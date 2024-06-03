// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.18;

// Interfaces
import {CollateralTracker} from "@contracts/CollateralTracker.sol";
import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";
import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";
// Inherited implementations
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import {Multicall} from "@base/Multicall.sol";
// Libraries
import {Constants} from "@libraries/Constants.sol";
import {Errors} from "@libraries/Errors.sol";
import {FeesCalc} from "@libraries/FeesCalc.sol";
import {InteractionHelper} from "@libraries/InteractionHelper.sol";
import {Math} from "@libraries/Math.sol";
import {PanopticMath} from "@libraries/PanopticMath.sol";
// Custom types
import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";
import {LiquidityChunk} from "@types/LiquidityChunk.sol";
import {TokenId} from "@types/TokenId.sol";

/// @title The Panoptic Pool: Create permissionless options on a CLAMM.
/// @author Axicon Labs Limited
/// @notice Manages positions, collateral, liquidations and forced exercises.
contract PanopticPool is ERC1155Holder, Multicall {
    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when an account is liquidated.
    /// @dev Need to unpack bonusAmounts to get raw numbers, which are always positive.
    /// @param liquidator Address of the caller liquidating the distressed account
    /// @param liquidatee Address of the distressed/liquidatable account
    /// @param bonusAmounts LeftRight encoding for the the bonus paid for token 0 (right slot) and 1 (left slot) from the Panoptic Pool to the liquidator
    event AccountLiquidated(
        address indexed liquidator,
        address indexed liquidatee,
        LeftRightSigned bonusAmounts
    );

    /// @notice Emitted when a position is force exercised.
    /// @param exercisor Address of the account that forces the exercise of the position
    /// @param user Address of the owner of the liquidated position
    /// @param tokenId TokenId of the liquidated position
    /// @param exerciseFee LeftRight encoding for the cost paid by the exercisor to force the exercise of the token;
    /// the cost for token 0 (right slot) and 1 (left slot) is represented as negative
    event ForcedExercised(
        address indexed exercisor,
        address indexed user,
        TokenId indexed tokenId,
        LeftRightSigned exerciseFee
    );

    /// @notice Emitted when premium is settled independent of a mint/burn (e.g. during `settleLongPremium`).
    /// @param user Address of the owner of the settled position
    /// @param tokenId TokenId of the settled position
    /// @param settledAmounts LeftRight encoding for the amount of premium settled for token0 (right slot) and token1 (left slot)
    event PremiumSettled(
        address indexed user,
        TokenId indexed tokenId,
        LeftRightSigned settledAmounts
    );

    /// @notice Emitted when an option is burned.
    /// @param recipient User that burnt the option
    /// @param positionSize The number of contracts burnt, expressed in terms of the asset
    /// @param tokenId TokenId of the burnt option
    /// @param premia LeftRight packing for the amount of premia collected for token0 (right) and token1 (left)
    event OptionBurnt(
        address indexed recipient,
        uint128 positionSize,
        TokenId indexed tokenId,
        LeftRightSigned premia
    );

    /// @notice Emitted when an option is minted.
    /// @param recipient User that minted the option
    /// @param positionSize The number of contracts minted, expressed in terms of the asset
    /// @param tokenId TokenId of the created option
    /// @param poolUtilizations Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool at the time of minting),
    /// right 64bits for token0 and left 64bits for token1, defined as (inAMM * 10_000) / totalAssets()
    /// where totalAssets is the total tracked assets in the AMM and PanopticPool minus fees and donations to the Panoptic pool
    event OptionMinted(
        address indexed recipient,
        uint128 positionSize,
        TokenId indexed tokenId,
        uint128 poolUtilizations
    );

    /*//////////////////////////////////////////////////////////////
                         IMMUTABLES & CONSTANTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Lower price bound used when no slippage check is required.
    int24 internal constant MIN_SWAP_TICK = Constants.MIN_V3POOL_TICK - 1;

    /// @notice Upper price bound used when no slippage check is required.
    int24 internal constant MAX_SWAP_TICK = Constants.MAX_V3POOL_TICK + 1;

    /// @notice Flag that signals to compute premia for both the short and long legs of a position.
    bool internal constant COMPUTE_ALL_PREMIA = true;
    /// @notice Flag that signals to compute premia only for the long legs of a position.
    bool internal constant COMPUTE_LONG_PREMIA = false;

    /// @notice Flag that indicates only to include the share of (settled) premium that is available to collect when calling `_calculateAccumulatedPremia`.
    bool internal constant ONLY_AVAILABLE_PREMIUM = false;

    /// @notice Flag that signals to commit both collected Uniswap fees and settled long premium to `s_settledTokens`.
    bool internal constant COMMIT_LONG_SETTLED = true;
    /// @notice Flag that signals to only commit collected Uniswap fees to `s_settledTokens`.
    bool internal constant DONOT_COMMIT_LONG_SETTLED = false;

    /// @notice Flag that signals to add a new position to the user's positions hash (as opposed to removing an existing position).
    bool internal constant ADD = true;

    /// @notice The minimum window (in seconds) used to calculate the TWAP price for solvency checks during liquidations.
    uint32 internal constant TWAP_WINDOW = 600;

    /// @notice Parameter that determines which oracle type to use for the "slow" oracle price on non-liquidation solvency checks.
    /// @dev If false, an 8-slot internal median array is used to compute the "slow" oracle price.
    /// @dev This oracle is updated with the last Uniswap observation during `mintOptions` if MEDIAN_PERIOD has elapsed past the last observation.
    /// @dev If true, the "slow" oracle price is instead computed on-the-fly from 8 Uniswap observations (spaced 5 observations apart) irrespective of the frequency of `mintOptions` calls.
    bool internal constant SLOW_ORACLE_UNISWAP_MODE = false;

    /// @notice The minimum amount of time, in seconds, permitted between internal TWAP updates.
    uint256 internal constant MEDIAN_PERIOD = 60;

    /// @notice Amount of Uniswap observations to include in the "fast" oracle price.
    uint256 internal constant FAST_ORACLE_CARDINALITY = 3;

    /// @dev Amount of observation indices to skip in between each observation for the "fast" oracle price.
    /// @dev Note that the *minimum* total observation time is determined by the blocktime and may need to be adjusted by chain.
    /// @dev Uniswap observations snapshot the last block's closing price at the first interaction with the pool in a block.
    /// @dev In this case, if there is an interaction every block, the "fast" oracle can consider 3 consecutive block end prices (min=36 seconds on Ethereum).
    uint256 internal constant FAST_ORACLE_PERIOD = 1;

    /// @notice Amount of Uniswap observations to include in the "slow" oracle price (in Uniswap mode).
    uint256 internal constant SLOW_ORACLE_CARDINALITY = 8;

    /// @notice Amount of observation indices to skip in between each observation for the "slow" oracle price.
    /// @dev Structured such that the minimum total observation time is 8 minutes on Ethereum (similar to internal median mode).
    uint256 internal constant SLOW_ORACLE_PERIOD = 5;

    /// @notice The maximum allowed delta between the currentTick and the Uniswap TWAP tick during a liquidation (~5% down, ~5.26% up).
    /// @dev Mitigates manipulation of the currentTick that causes positions to be liquidated at a less favorable price.
    int256 internal constant MAX_TWAP_DELTA_LIQUIDATION = 513;

    /// @notice The maximum allowed delta between the fast and slow oracle ticks before solvency is evaluated at the slow oracle tick.
    /// @dev Falls back on the more conservative (less solvent) tick during times of extreme volatility.
    int256 internal constant MAX_SLOW_FAST_DELTA = 1800;

    /// @notice The maximum allowed ratio for a single chunk, defined as: removedLiquidity / netLiquidity.
    /// @dev The long premium spread multiplier that corresponds with the MAX_SPREAD value depends on VEGOID,
    /// which can be explored in this calculator: https://www.desmos.com/calculator/mdeqob2m04.
    uint64 internal constant MAX_SPREAD = 9 * (2 ** 32);

    /// @notice The maximum allowed number of opened positions for a user.
    uint64 internal constant MAX_POSITIONS = 32;

    /// @notice Multiplier in basis points for the collateral requirement in the event of a buying power decrease, such as minting or force exercising another user.
    uint256 internal constant BP_DECREASE_BUFFER = 13_333;

    /// @notice Multiplier for the collateral requirement in the general case.
    uint256 internal constant NO_BUFFER = 10_000;

    /// @notice The "engine" of Panoptic - manages AMM liquidity and executes all mints/burns/exercises.
    SemiFungiblePositionManager internal immutable SFPM;

    /*//////////////////////////////////////////////////////////////
                                STORAGE 
    //////////////////////////////////////////////////////////////*/

    /// @notice The Uniswap v3 pool that this instance of Panoptic is deployed on.
    IUniswapV3Pool internal s_univ3pool;

    /// @notice Stores a sorted set of 8 price observations used to compute the internal median oracle price.
    // The data for the last 8 interactions is stored as such:
    // LAST UPDATED BLOCK TIMESTAMP (40 bits)
    // [BLOCK.TIMESTAMP]
    // (00000000000000000000000000000000) // dynamic
    //
    // ORDERING of tick indices least --> greatest (24 bits)
    // The value of the bit codon ([#]) is a pointer to a tick index in the tick array.
    // The position of the bit codon from most to least significant is the ordering of the
    // tick index it points to from least to greatest.
    //
    // [7] [5] [3] [1] [0] [2] [4] [6]
    // 111 101 011 001 000 010 100 110
    //
    // [Constants.MIN_V3POOL_TICK-1] [7]
    // 111100100111011000010111
    //
    // [Constants.MAX_V3POOL_TICK+1] [0]
    // 000011011000100111101001
    //
    // [Constants.MIN_V3POOL_TICK-1] [6]
    // 111100100111011000010111
    //
    // [Constants.MAX_V3POOL_TICK+1] [1]
    // 000011011000100111101001
    //
    // [Constants.MIN_V3POOL_TICK-1] [5]
    // 111100100111011000010111
    //
    // [Constants.MAX_V3POOL_TICK+1] [2]
    // 000011011000100111101001
    //
    // [CURRENT TICK] [4]
    // (000000000000000000000000) // dynamic
    //
    // [CURRENT TICK] [3]
    // (000000000000000000000000) // dynamic
    uint256 internal s_miniMedian;

    // ERC4626 vaults that users collateralize their positions with
    // Each token has its own vault, listed in the same order as the tokens in the pool
    // In addition to collateral deposits, these vaults also handle various collateral/bonus/exercise computations

    /// @notice Collateral vault for token0 in the Uniswap pool.
    CollateralTracker internal s_collateralToken0;
    /// @notice Collateral vault for token1 in the Uniswap pool.
    CollateralTracker internal s_collateralToken1;

    /// @notice Nested mapping that tracks the option formation: address => tokenId => leg => premiaGrowth.
    /// @dev Premia growth is taking a snapshot of the chunk premium in SFPM, which is measuring the amount of fees
    /// collected for every chunk per unit of liquidity (net or short, depending on the isLong value of the specific leg index).
    mapping(address account => mapping(TokenId tokenId => mapping(uint256 leg => LeftRightUnsigned premiaGrowth)))
        internal s_options;

    /// @notice Per-chunk `last` value that gives the aggregate amount of premium owed to all sellers when multiplied by the total amount of liquidity `totalLiquidity`.
    /// @dev totalGrossPremium = totalLiquidity * (grossPremium(perLiquidityX64) - lastGrossPremium(perLiquidityX64)) / 2**64.
    /// @dev Used to compute the denominator for the fraction of premium available to sellers to collect.
    /// @dev LeftRight - right slot is token0, left slot is token1.
    mapping(bytes32 chunkKey => LeftRightUnsigned lastGrossPremium) internal s_grossPremiumLast;

    /// @notice Per-chunk accumulator for tokens owed to sellers that have been settled and are now available.
    /// @dev This number increases when buyers pay long premium and when tokens are collected from Uniswap.
    /// @dev It decreases when sellers close positions and collect the premium they are owed.
    /// @dev LeftRight - right slot is token0, left slot is token1.
    mapping(bytes32 chunkKey => LeftRightUnsigned settledTokens) internal s_settledTokens;

    /// @notice Tracks the amount of liquidity for a user+tokenId (right slot) and the initial pool utilizations when that position was minted (left slot).
    //    poolUtilizations when minted (left)    liquidity=ERC1155 balance (right)
    //        token0          token1
    //  |<-- 64 bits -->|<-- 64 bits -->|<---------- 128 bits ---------->|
    //  |<-------------------------- 256 bits -------------------------->|
    mapping(address account => mapping(TokenId tokenId => LeftRightUnsigned balanceAndUtilizations))
        internal s_positionBalance;

    //    numPositions (32 positions max)    user positions hash
    //  |<-- 8 bits -->|<------------------ 248 bits ------------------->|
    //  |<---------------------- 256 bits ------------------------------>|
    /// @notice Tracks the position list hash i.e keccak256(XORs of abi.encodePacked(positionIdList)).
    /// @dev The order and content of this list (the preimage for the hash) is emitted in an event every time it is changed.
    /// @dev A component of this hash also tracks the total number of positions (i.e. makes sure the length of the provided positionIdList matches).
    /// @dev The purpose of this system is to reduce storage usage when a user has more than one active position.
    /// @dev Instead of having to manage an unwieldy storage array and do lots of loads, we just store a hash of the array.
    /// @dev This hash can be cheaply verified on every operation with a user provided positionIdList - which can then be used for operations
    /// without having to every load any other data from storage.
    //    numPositions (32 positions max)    user positions hash
    //  |<-- 8 bits -->|<------------------ 248 bits ------------------->|
    //  |<---------------------- 256 bits ------------------------------>|
    mapping(address account => uint256 positionsHash) internal s_positionsHash;

    /*//////////////////////////////////////////////////////////////
                             INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Store the address of the canonical SemiFungiblePositionManager (SFPM) contract.
    /// @param _sfpm The address of the SFPM
    constructor(SemiFungiblePositionManager _sfpm) {
        SFPM = _sfpm;
    }

    /// @notice Initializes a Panoptic Pool on top of an existing Uniswap v3 + collateral vault pair.
    /// @dev Must be called first (by a factory contract) before any transaction can occur.
    /// @param _univ3pool Address of the target Uniswap v3 pool
    /// @param token0 Address of the pool's token0
    /// @param token1 Address of the pool's token1
    /// @param collateralTracker0 Address of the collateral vault for token0
    /// @param collateralTracker1 Address of the collateral vault for token1
    function startPool(
        IUniswapV3Pool _univ3pool,
        address token0,
        address token1,
        CollateralTracker collateralTracker0,
        CollateralTracker collateralTracker1
    ) external {
        // reverts if the Uniswap pool has already been initialized
        if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

        // Store the univ3Pool variable
        s_univ3pool = IUniswapV3Pool(_univ3pool);

        (, int24 currentTick, , , , , ) = IUniswapV3Pool(_univ3pool).slot0();

        // Store the median data
        unchecked {
            s_miniMedian =
                (uint256(block.timestamp) << 216) +
                // magic number which adds (7,5,3,1,0,2,4,6) order and minTick in positions 7, 5, 3 and maxTick in 6, 4, 2
                // see comment on s_miniMedian initialization for format of this magic number
                (uint256(0xF590A6F276170D89E9F276170D89E9F276170D89E9000000000000)) +
                (uint256(uint24(currentTick)) << 24) + // add to slot 4
                (uint256(uint24(currentTick))); // add to slot 3
        }

        // Store the collateral token0
        s_collateralToken0 = collateralTracker0;
        s_collateralToken1 = collateralTracker1;

        // consolidate all 4 approval calls to one library delegatecall in order to reduce bytecode size
        // approves:
        // SFPM: token0, token1
        // CollateralTracker0 - token0
        // CollateralTracker1 - token1
        InteractionHelper.doApprovals(SFPM, collateralTracker0, collateralTracker1, token0, token1);
    }

    /*//////////////////////////////////////////////////////////////
                             QUERY HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Reverts if the caller has a lower collateral balance than required to meet the provided `minValue0` and `minValue1`.
    /// @dev Can be used for composable slippage checks with `multicall` (such as for a force exercise or liquidation).
    /// @param minValue0 The minimum acceptable `token0` value of collateral
    /// @param minValue1 The minimum acceptable `token1` value of collateral
    function assertMinCollateralValues(uint256 minValue0, uint256 minValue1) external view {
        CollateralTracker ct0 = s_collateralToken0;
        CollateralTracker ct1 = s_collateralToken1;
        if (
            ct0.convertToAssets(ct0.balanceOf(msg.sender)) < minValue0 ||
            ct1.convertToAssets(ct1.balanceOf(msg.sender)) < minValue1
        ) revert Errors.NotEnoughCollateral();
    }

    /// @notice Determines if account is eligible to withdraw or transfer collateral.
    /// @dev Checks whether account is solvent with `BP_DECREASE_BUFFER` according to `_validateSolvency`.
    /// @dev Prevents insolvent and near-insolvent accounts from withdrawing collateral before they are liquidated.
    /// @dev Reverts if account is not solvent with `BP_DECREASE_BUFFER`.
    /// @param user The account to check for collateral withdrawal eligibility
    /// @param positionIdList The list of all option positions held by `user`
    function validateCollateralWithdrawable(
        address user,
        TokenId[] calldata positionIdList
    ) external view {
        _validateSolvency(user, positionIdList, BP_DECREASE_BUFFER);
    }

    /// @notice Returns the total number of contracts owned by user for a specified position.
    /// @param user Address of the account to be checked
    /// @param tokenId TokenId of the option position to be checked
    /// @return balance Number of contracts of tokenId owned by the user
    /// @return poolUtilization0 The utilization of token0 in the Panoptic pool at mint
    /// @return poolUtilization1 The utilization of token1 in the Panoptic pool at mint
    function optionPositionBalance(
        address user,
        TokenId tokenId
    ) external view returns (uint128 balance, uint64 poolUtilization0, uint64 poolUtilization1) {
        // Extract the data stored in s_positionBalance for the provided user + tokenId
        LeftRightUnsigned balanceData = s_positionBalance[user][tokenId];

        // Return the unpacked data: balanceOf(user, tokenId) and packed pool utilizations at the time of minting
        balance = balanceData.rightSlot();

        // pool utilizations are packed into a single uint128

        // the 64 least significant bits are the utilization of token0, so we can simply cast to uint64 to extract it
        // (cutting off the 64 most significant bits)
        poolUtilization0 = uint64(balanceData.leftSlot());

        // the 64 most significant bits are the utilization of token1, so we can shift the number to the right by 64 to extract it
        // (shifting away the 64 least significant bits)
        poolUtilization1 = uint64(balanceData.leftSlot() >> 64);
    }

    /// @notice Compute the total amount of premium accumulated for a list of positions.
    /// @param user Address of the user that owns the positions
    /// @param positionIdList List of positions. Written as [tokenId1, tokenId2, ...]
    /// @param includePendingPremium If true, include premium that is owed to the user but has not yet settled; if false, only include premium that is available to collect
    /// @return premium0 Premium for token0 (negative = amount is owed)
    /// @return premium1 Premium for token1 (negative = amount is owed)
    /// @return A list of balances and pool utilization for each position, of the form [[tokenId0, balances0], [tokenId1, balances1], ...]
    function calculateAccumulatedFeesBatch(
        address user,
        bool includePendingPremium,
        TokenId[] calldata positionIdList
    ) external view returns (int128 premium0, int128 premium1, uint256[2][] memory) {
        // Get the current tick of the Uniswap pool
        (, int24 currentTick, , , , , ) = s_univ3pool.slot0();

        // Compute the accumulated premia for all tokenId in positionIdList (includes short+long premium)
        (LeftRightSigned premia, uint256[2][] memory balances) = _calculateAccumulatedPremia(
            user,
            positionIdList,
            COMPUTE_ALL_PREMIA,
            includePendingPremium,
            currentTick
        );

        // Return the premia as (token0, token1)
        return (premia.rightSlot(), premia.leftSlot(), balances);
    }

    /// @notice Compute the net token amounts owned by a given positionIdList in the Uniswap pool at the given price tick.
    /// @param user Address of the user that owns the positions.
    /// @param atTick Tick at which the portfolio value is evaluated
    /// @param positionIdList List of positions. Written as [tokenId1, tokenId2, ...]
    /// @return value0 Net amount of token0 in the Uniswap pool owned by the positionIdList (negative = borrowed liquidity owed to sellers)
    /// @return value1 Net amount of token1 in the Uniswap pool owned by the positionIdList (negative = borrowed liquidity owed to sellers)
    function calculatePortfolioValue(
        address user,
        int24 atTick,
        TokenId[] calldata positionIdList
    ) external view returns (int256 value0, int256 value1) {
        (value0, value1) = FeesCalc.getPortfolioValue(
            atTick,
            s_positionBalance[user],
            positionIdList
        );
    }

    /// @notice Calculate the accumulated premia owed from the option buyer to the option seller.
    /// @param user The holder of options
    /// @param positionIdList The list of all option positions held by user
    /// @param computeAllPremia Whether to compute accumulated premia for all legs held by the user (true), or just owed premia for long legs (false)
    /// @param includePendingPremium If true, include premium that is owed to the user but has not yet settled; if false, only include premium that is available to collect
    /// @return portfolioPremium The computed premia of the user's positions, where premia contains the accumulated premia for token0 in the right slot and for token1 in the left slot
    /// @return balances A list of balances and pool utilization for each position, of the form [[tokenId0, balances0], [tokenId1, balances1], ...]
    function _calculateAccumulatedPremia(
        address user,
        TokenId[] calldata positionIdList,
        bool computeAllPremia,
        bool includePendingPremium,
        int24 atTick
    ) internal view returns (LeftRightSigned portfolioPremium, uint256[2][] memory balances) {
        uint256 pLength = positionIdList.length;
        balances = new uint256[2][](pLength);

        address c_user = user;
        // loop through each option position/tokenId
        for (uint256 k = 0; k < pLength; ) {
            TokenId tokenId = positionIdList[k];

            balances[k][0] = TokenId.unwrap(tokenId);
            balances[k][1] = LeftRightUnsigned.unwrap(s_positionBalance[c_user][tokenId]);

            (
                LeftRightSigned[4] memory premiaByLeg,
                uint256[2][4] memory premiumAccumulatorsByLeg
            ) = _getPremia(
                    tokenId,
                    LeftRightUnsigned.wrap(balances[k][1]).rightSlot(),
                    c_user,
                    computeAllPremia,
                    atTick
                );

            uint256 numLegs = tokenId.countLegs();
            for (uint256 leg = 0; leg < numLegs; ) {
                if (tokenId.isLong(leg) == 0 && !includePendingPremium) {
                    bytes32 chunkKey = keccak256(
                        abi.encodePacked(
                            tokenId.strike(leg),
                            tokenId.width(leg),
                            tokenId.tokenType(leg)
                        )
                    );

                    LeftRightUnsigned availablePremium = _getAvailablePremium(
                        _getTotalLiquidity(tokenId, leg),
                        s_settledTokens[chunkKey],
                        s_grossPremiumLast[chunkKey],
                        LeftRightUnsigned.wrap(uint256(LeftRightSigned.unwrap(premiaByLeg[leg]))),
                        premiumAccumulatorsByLeg[leg]
                    );
                    portfolioPremium = portfolioPremium.add(
                        LeftRightSigned.wrap(int256(LeftRightUnsigned.unwrap(availablePremium)))
                    );
                } else {
                    portfolioPremium = portfolioPremium.add(premiaByLeg[leg]);
                }
                unchecked {
                    ++leg;
                }
            }

            unchecked {
                ++k;
            }
        }
        return (portfolioPremium, balances);
    }

    /*//////////////////////////////////////////////////////////////
                          ONBOARD MEDIAN TWAP
    //////////////////////////////////////////////////////////////*/

    /// @notice Updates the internal median with the last Uniswap observation if the MEDIAN_PERIOD has elapsed.
    function pokeMedian() external {
        (, , uint16 observationIndex, uint16 observationCardinality, , , ) = s_univ3pool.slot0();

        (, uint256 medianData) = PanopticMath.computeInternalMedian(
            observationIndex,
            observationCardinality,
            MEDIAN_PERIOD,
            s_miniMedian,
            s_univ3pool
        );

        if (medianData != 0) s_miniMedian = medianData;
    }

    /*//////////////////////////////////////////////////////////////
                          MINT/BURN INTERFACE
    //////////////////////////////////////////////////////////////*/

    /// @notice Validates the current options of the user, and mints a new position.
    /// @param positionIdList The list of currently held positions by the user, where the newly minted position(token) will be the last element in 'positionIdList'
    /// @param positionSize The size of the position to be minted, expressed in terms of the asset
    /// @param effectiveLiquidityLimitX32 Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position and
    /// denominated as X32 = (ratioLimit * 2**32)
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    function mintOptions(
        TokenId[] calldata positionIdList,
        uint128 positionSize,
        uint64 effectiveLiquidityLimitX32,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) external {
        _mintOptions(
            positionIdList,
            positionSize,
            effectiveLiquidityLimitX32,
            tickLimitLow,
            tickLimitHigh
        );
    }

    /// @notice Closes and burns the caller's entire balance of `tokenId`.
    /// @param tokenId The tokenId of the option position to be burnt
    /// @param newPositionIdList The new positionIdList without the token being burnt
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    function burnOptions(
        TokenId tokenId,
        TokenId[] calldata newPositionIdList,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) external {
        _burnOptions(COMMIT_LONG_SETTLED, tokenId, msg.sender, tickLimitLow, tickLimitHigh);

        _validateSolvency(msg.sender, newPositionIdList, NO_BUFFER);
    }

    /// @notice Closes and burns the caller's entire balance of each `tokenId` in `positionIdList.
    /// @param positionIdList The list of tokenIds for the option positions to be burnt
    /// @param newPositionIdList The new positionIdList without the token(s) being burnt
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    function burnOptions(
        TokenId[] calldata positionIdList,
        TokenId[] calldata newPositionIdList,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) external {
        _burnAllOptionsFrom(
            msg.sender,
            tickLimitLow,
            tickLimitHigh,
            COMMIT_LONG_SETTLED,
            positionIdList
        );

        _validateSolvency(msg.sender, newPositionIdList, NO_BUFFER);
    }

    /*//////////////////////////////////////////////////////////////
                         POSITION MINTING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Validates the current options of the user, and mints a new position.
    /// @param positionIdList The list of currently held positions by the user, where the newly minted position(token) will be the last element in 'positionIdList'
    /// @param positionSize The size of the position to be minted, expressed in terms of the asset
    /// @param effectiveLiquidityLimitX32 Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position and
    /// denominated as X32 = (ratioLimit * 2**32)
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    function _mintOptions(
        TokenId[] calldata positionIdList,
        uint128 positionSize,
        uint64 effectiveLiquidityLimitX32,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) internal {
        // the new tokenId will be the last element in 'positionIdList'
        TokenId tokenId;
        unchecked {
            tokenId = positionIdList[positionIdList.length - 1];
        }

        // do duplicate checks and the checks related to minting and positions
        _validatePositionList(msg.sender, positionIdList, 1);

        // make sure the tokenId is for this Panoptic pool
        if (tokenId.poolId() != SFPM.getPoolId(address(s_univ3pool)))
            revert Errors.InvalidTokenIdParameter(0);

        // disallow user to mint exact same position
        // in order to do it, user should burn it first and then mint
        if (LeftRightUnsigned.unwrap(s_positionBalance[msg.sender][tokenId]) != 0)
            revert Errors.PositionAlreadyMinted();

        // Mint in the SFPM and update state of collateral
        uint128 poolUtilizations = _mintInSFPMAndUpdateCollateral(
            tokenId,
            positionSize,
            tickLimitLow,
            tickLimitHigh
        );

        // calculate and write position data
        _addUserOption(tokenId, effectiveLiquidityLimitX32);

        // update the users options balance of position 'tokenId'
        // NOTE: user can't mint same position multiple times, so set the positionSize instead of adding
        s_positionBalance[msg.sender][tokenId] = LeftRightUnsigned
            .wrap(0)
            .toLeftSlot(poolUtilizations)
            .toRightSlot(positionSize);

        // Perform solvency check on user's account to ensure they had enough buying power to mint the option
        // Add an initial buffer to the collateral requirement to prevent users from minting their account close to insolvency
        uint256 medianData = _validateSolvency(msg.sender, positionIdList, BP_DECREASE_BUFFER);

        // Update `s_miniMedian` with a new observation if the last observation is old enough (returned medianData is nonzero)
        if (medianData != 0) s_miniMedian = medianData;

        emit OptionMinted(msg.sender, positionSize, tokenId, poolUtilizations);
    }

    /// @notice Move all the required liquidity to/from the AMM and settle any required collateral deltas.
    /// @param tokenId The option position to be minted
    /// @param positionSize The size of the position, expressed in terms of the asset
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    /// @return Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool) at the time of minting,
    /// right 64bits for token0 and left 64bits for token1
    function _mintInSFPMAndUpdateCollateral(
        TokenId tokenId,
        uint128 positionSize,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) internal returns (uint128) {
        (LeftRightUnsigned[4] memory collectedByLeg, LeftRightSigned totalSwapped) = SFPM
            .mintTokenizedPosition(tokenId, positionSize, tickLimitLow, tickLimitHigh);

        _updateSettlementPostMint(tokenId, collectedByLeg, positionSize);

        uint128 poolUtilizations = _payCommissionAndWriteData(tokenId, positionSize, totalSwapped);

        return poolUtilizations;
    }

    /// @notice Take the commission fees for minting `tokenId` and settle any other required collateral deltas.
    /// @param tokenId The option position
    /// @param positionSize The size of the position, expressed in terms of the asset
    /// @param totalSwapped The amount of tokens moved during creation of the option position
    /// @return Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool at the time of minting),
    /// right 64bits for token0 and left 64bits for token1, defined as (inAMM * 10_000) / totalAssets()
    /// where totalAssets is the total tracked assets in the AMM and PanopticPool minus fees and donations to the Panoptic pool
    function _payCommissionAndWriteData(
        TokenId tokenId,
        uint128 positionSize,
        LeftRightSigned totalSwapped
    ) internal returns (uint128) {
        // compute how much of tokenId is long and short positions
        (LeftRightSigned longAmounts, LeftRightSigned shortAmounts) = PanopticMath
            .computeExercisedAmounts(tokenId, positionSize);

        int256 utilization0 = s_collateralToken0.takeCommissionAddData(
            msg.sender,
            longAmounts.rightSlot(),
            shortAmounts.rightSlot(),
            totalSwapped.rightSlot()
        );
        int256 utilization1 = s_collateralToken1.takeCommissionAddData(
            msg.sender,
            longAmounts.leftSlot(),
            shortAmounts.leftSlot(),
            totalSwapped.leftSlot()
        );

        // return pool utilizations as a uint128 (pool Utilization is always < 10000)
        unchecked {
            return uint128(uint256(utilization0) + uint128(uint256(utilization1) << 64));
        }
    }

    /// @notice Add a new option to the user's position hash, perform required checks, and initialize the premium accumulators.
    /// @param tokenId The minted option position
    /// @param effectiveLiquidityLimitX32 Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position
    /// denominated as X32 = (ratioLimit * 2**32)
    function _addUserOption(TokenId tokenId, uint64 effectiveLiquidityLimitX32) internal {
        // Update the position list hash (hash = XOR of all keccak256(tokenId)). Remove hash by XOR'ing again
        _updatePositionsHash(msg.sender, tokenId, ADD);

        uint256 numLegs = tokenId.countLegs();
        // compute upper and lower tick and liquidity
        for (uint256 leg = 0; leg < numLegs; ) {
            // Extract base fee (AMM swap/trading fees) for the position and add it to s_options
            // (ie. the (feeGrowth * liquidity) / 2**128 for each token)
            (int24 tickLower, int24 tickUpper) = tokenId.asTicks(leg);
            uint256 isLong = tokenId.isLong(leg);
            {
                (uint128 premiumAccumulator0, uint128 premiumAccumulator1) = SFPM.getAccountPremium(
                    address(s_univ3pool),
                    address(this),
                    tokenId.tokenType(leg),
                    tickLower,
                    tickUpper,
                    type(int24).max,
                    isLong
                );

                // update the premium accumulators
                s_options[msg.sender][tokenId][leg] = LeftRightUnsigned
                    .wrap(0)
                    .toRightSlot(premiumAccumulator0)
                    .toLeftSlot(premiumAccumulator1);
            }
            // verify base Liquidity limit only if new position is long
            if (isLong == 1) {
                // Move this into a new function
                _checkLiquiditySpread(
                    tokenId,
                    leg,
                    tickLower,
                    tickUpper,
                    uint64(Math.min(effectiveLiquidityLimitX32, MAX_SPREAD))
                );
            }
            unchecked {
                ++leg;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                         POSITION BURNING LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Close all options in `positionIdList.
    /// @param owner The owner of the option position to be closed
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price on each option close
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price on each option close
    /// @param commitLongSettled Whether to commit the long premium that will be settled to storage (disabled during liquidations)
    /// @param positionIdList The list of option positions to close
    /// @return netPaid The net amount of tokens paid after closing the positions
    /// @return premiasByLeg The amount of premia owed to the user for each leg of the position
    function _burnAllOptionsFrom(
        address owner,
        int24 tickLimitLow,
        int24 tickLimitHigh,
        bool commitLongSettled,
        TokenId[] calldata positionIdList
    ) internal returns (LeftRightSigned netPaid, LeftRightSigned[4][] memory premiasByLeg) {
        premiasByLeg = new LeftRightSigned[4][](positionIdList.length);
        for (uint256 i = 0; i < positionIdList.length; ) {
            LeftRightSigned paidAmounts;
            (paidAmounts, premiasByLeg[i]) = _burnOptions(
                commitLongSettled,
                positionIdList[i],
                owner,
                tickLimitLow,
                tickLimitHigh
            );
            netPaid = netPaid.add(paidAmounts);
            unchecked {
                ++i;
            }
        }
    }

    /// @notice Close a single option position.
    /// @param tokenId The option position to burn
    /// @param owner The owner of the option position to be burned
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price on each option close
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price on each option close
    /// @param commitLongSettled Whether to commit the long premium that will be settled to storage (disabled during liquidations)
    /// @return paidAmounts The net amount of tokens paid after closing the position
    /// @return premiaByLeg The amount of premia owed to the user for each leg of the position
    function _burnOptions(
        bool commitLongSettled,
        TokenId tokenId,
        address owner,
        int24 tickLimitLow,
        int24 tickLimitHigh
    ) internal returns (LeftRightSigned paidAmounts, LeftRightSigned[4] memory premiaByLeg) {
        uint128 positionSize = s_positionBalance[owner][tokenId].rightSlot();

        LeftRightSigned premiaOwed;
        // burn position and do exercise checks
        (premiaOwed, premiaByLeg, paidAmounts) = _burnAndHandleExercise(
            commitLongSettled,
            tickLimitLow,
            tickLimitHigh,
            tokenId,
            positionSize,
            owner
        );

        // erase position data
        _updatePositionDataBurn(owner, tokenId);

        emit OptionBurnt(owner, positionSize, tokenId, premiaOwed);
    }

    /// @notice Remove an option position from a user's position hash and reset its premium accumulators on close.
    /// @param owner The owner of the option position
    /// @param tokenId The option position being closed
    function _updatePositionDataBurn(address owner, TokenId tokenId) internal {
        // reset balances and delete stored option data
        s_positionBalance[owner][tokenId] = LeftRightUnsigned.wrap(0);

        uint256 numLegs = tokenId.countLegs();
        for (uint256 leg = 0; leg < numLegs; ) {
            if (tokenId.isLong(leg) == 0) {
                // Check the liquidity spread, make sure that closing the option does not exceed the MAX_SPREAD allowed
                (int24 tickLower, int24 tickUpper) = tokenId.asTicks(leg);
                _checkLiquiditySpread(tokenId, leg, tickLower, tickUpper, MAX_SPREAD);
            }
            s_options[owner][tokenId][leg] = LeftRightUnsigned.wrap(0);
            unchecked {
                ++leg;
            }
        }

        // Update the position list hash (hash = XOR of all keccak256(tokenId)). Remove hash by XOR'ing again
        _updatePositionsHash(owner, tokenId, !ADD);
    }

    /// @notice Validates the solvency of `user`.
    /// @dev Falls back to the more conservative tick if the delta between the fast and slow oracle exceeds `MAX_SLOW_FAST_DELTA`.
    /// @dev Effectively, this means that the users must be solvent at both the fast and slow oracle ticks if one of them is stale to mint or burn options.
    /// @param user The account to validate
    /// @param positionIdList The list of positions to validate solvency for
    /// @param buffer The buffer to apply to the collateral requirement for `user`
    /// @return medianData If nonzero (enough time has passed since last observation), the updated value for `s_miniMedian` with a new observation
    function _validateSolvency(
        address user,
        TokenId[] calldata positionIdList,
        uint256 buffer
    ) internal view returns (uint256 medianData) {
        // check that the provided positionIdList matches the positions in memory
        _validatePositionList(user, positionIdList, 0);

        IUniswapV3Pool _univ3pool = s_univ3pool;
        (
            ,
            int24 currentTick,
            uint16 observationIndex,
            uint16 observationCardinality,
            ,
            ,

        ) = _univ3pool.slot0();
        int24 fastOracleTick = PanopticMath.computeMedianObservedPrice(
            _univ3pool,
            observationIndex,
            observationCardinality,
            FAST_ORACLE_CARDINALITY,
            FAST_ORACLE_PERIOD
        );

        int24 slowOracleTick;
        if (SLOW_ORACLE_UNISWAP_MODE) {
            slowOracleTick = PanopticMath.computeMedianObservedPrice(
                _univ3pool,
                observationIndex,
                observationCardinality,
                SLOW_ORACLE_CARDINALITY,
                SLOW_ORACLE_PERIOD
            );
        } else {
            (slowOracleTick, medianData) = PanopticMath.computeInternalMedian(
                observationIndex,
                observationCardinality,
                MEDIAN_PERIOD,
                s_miniMedian,
                _univ3pool
            );
        }

        // Check the user's solvency at the fast tick; revert if not solvent
        bool solventAtFast = _checkSolvencyAtTick(
            user,
            positionIdList,
            currentTick,
            fastOracleTick,
            buffer
        );
        if (!solventAtFast) revert Errors.NotEnoughCollateral();

        // If one of the ticks is too stale, we fall back to the more conservative tick, i.e, the user must be solvent at both the fast and slow oracle ticks.
        if (Math.abs(int256(fastOracleTick) - slowOracleTick) > MAX_SLOW_FAST_DELTA)
            if (!_checkSolvencyAtTick(user, positionIdList, currentTick, slowOracleTick, buffer))
                revert Errors.NotEnoughCollateral();
    }

    /// @notice Burns and handles the exercise of options.
    /// @param commitLongSettled Whether to commit the long premium that will be settled to storage (disabled during liquidations)
    /// @param tickLimitLow The lower bound of an acceptable open interval for the ending price
    /// @param tickLimitHigh The upper bound of an acceptable open interval for the ending price
    /// @param tokenId The option position to burn
    /// @param positionSize The size of the option position, expressed in terms of the asset
    /// @param owner The owner of the option position
    /// @return realizedPremia The net premia paid/received from the option position
    /// @return premiaByLeg The premia owed to the user for each leg of the option position
    /// @return paidAmounts The net amount of tokens paid after closing the position
    function _burnAndHandleExercise(
        bool commitLongSettled,
        int24 tickLimitLow,
        int24 tickLimitHigh,
        TokenId tokenId,
        uint128 positionSize,
        address owner
    )
        internal
        returns (
            LeftRightSigned realizedPremia,
            LeftRightSigned[4] memory premiaByLeg,
            LeftRightSigned paidAmounts
        )
    {
        (LeftRightUnsigned[4] memory collectedByLeg, LeftRightSigned totalSwapped) = SFPM
            .burnTokenizedPosition(tokenId, positionSize, tickLimitLow, tickLimitHigh);

        (realizedPremia, premiaByLeg) = _updateSettlementPostBurn(
            owner,
            tokenId,
            collectedByLeg,
            positionSize,
            commitLongSettled
        );

        (LeftRightSigned longAmounts, LeftRightSigned shortAmounts) = PanopticMath
            .computeExercisedAmounts(tokenId, positionSize);

        {
            int128 paid0 = s_collateralToken0.exercise(
                owner,
                longAmounts.rightSlot(),
                shortAmounts.rightSlot(),
                totalSwapped.rightSlot(),
                realizedPremia.rightSlot()
            );
            paidAmounts = paidAmounts.toRightSlot(paid0);
        }

        {
            int128 paid1 = s_collateralToken1.exercise(
                owner,
                longAmounts.leftSlot(),
                shortAmounts.leftSlot(),
                totalSwapped.leftSlot(),
                realizedPremia.leftSlot()
            );
            paidAmounts = paidAmounts.toLeftSlot(paid1);
        }
    }

    /*//////////////////////////////////////////////////////////////
                    LIQUIDATIONS & FORCED EXERCISES
    //////////////////////////////////////////////////////////////*/

    /// @notice Liquidates a distressed account. Will burn all positions and issue a bonus to the liquidator.
    /// @dev Will revert if liquidated account is solvent at the TWAP tick or if TWAP tick is too far away from the current tick.
    /// @param positionIdListLiquidator List of positions owned by the liquidator
    /// @param liquidatee Address of the distressed account
    /// @param delegations LeftRight amounts of token0 and token1 (token0:token1 right:left) delegated to the liquidatee by the liquidator so the option can be smoothly exercised
    /// @param positionIdList List of positions owned by the user. Written as [tokenId1, tokenId2, ...]
    function liquidate(
        TokenId[] calldata positionIdListLiquidator,
        address liquidatee,
        LeftRightUnsigned delegations,
        TokenId[] calldata positionIdList
    ) external {
        _validatePositionList(liquidatee, positionIdList, 0);

        // Assert the account we are liquidating is actually insolvent
        int24 twapTick = getUniV3TWAP();

        LeftRightUnsigned tokenData0;
        LeftRightUnsigned tokenData1;
        LeftRightSigned premia;
        {
            (, int24 currentTick, , , , , ) = s_univ3pool.slot0();

            // Enforce maximum delta between TWAP and currentTick to prevent extreme price manipulation
            if (Math.abs(currentTick - twapTick) > MAX_TWAP_DELTA_LIQUIDATION)
                revert Errors.StaleTWAP();

            uint256[2][] memory positionBalanceArray = new uint256[2][](positionIdList.length);
            (premia, positionBalanceArray) = _calculateAccumulatedPremia(
                liquidatee,
                positionIdList,
                COMPUTE_ALL_PREMIA,
                ONLY_AVAILABLE_PREMIUM,
                currentTick
            );
            tokenData0 = s_collateralToken0.getAccountMarginDetails(
                liquidatee,
                twapTick,
                positionBalanceArray,
                premia.rightSlot()
            );

            tokenData1 = s_collateralToken1.getAccountMarginDetails(
                liquidatee,
                twapTick,
                positionBalanceArray,
                premia.leftSlot()
            );

            (uint256 balanceCross, uint256 thresholdCross) = _getSolvencyBalances(
                tokenData0,
                tokenData1,
                Math.getSqrtRatioAtTick(twapTick)
            );

            if (balanceCross >= thresholdCross) revert Errors.NotMarginCalled();
        }

        // Perform the specified delegation from `msg.sender` to `liquidatee`
        // Works like a transfer, so the liquidator must possess all the tokens they are delegating, resulting in no net supply change
        // If not enough tokens are delegated for the positions of `liquidatee` to be closed, the liquidation will fail
        s_collateralToken0.delegate(msg.sender, liquidatee, delegations.rightSlot());
        s_collateralToken1.delegate(msg.sender, liquidatee, delegations.leftSlot());

        int256 liquidationBonus0;
        int256 liquidationBonus1;
        int24 finalTick;
        {
            LeftRightSigned netExchanged;
            LeftRightSigned[4][] memory premiasByLeg;
            // burn all options from the liquidatee

            // Do not commit any settled long premium to storage - we will do this after we determine if any long premium must be revoked
            // This is to prevent any short positions the liquidatee has being settled with tokens that will later be revoked
            // NOTE: tick limits are not applied here since it is not the liquidator's position being liquidated
            (netExchanged, premiasByLeg) = _burnAllOptionsFrom(
                liquidatee,
                MIN_SWAP_TICK,
                MAX_SWAP_TICK,
                DONOT_COMMIT_LONG_SETTLED,
                positionIdList
            );

            (, finalTick, , , , , ) = s_univ3pool.slot0();

            LeftRightSigned collateralRemaining;
            // compute bonus amounts using latest tick data
            (liquidationBonus0, liquidationBonus1, collateralRemaining) = PanopticMath
                .getLiquidationBonus(
                    tokenData0,
                    tokenData1,
                    Math.getSqrtRatioAtTick(twapTick),
                    Math.getSqrtRatioAtTick(finalTick),
                    netExchanged,
                    premia
                );

            // premia cannot be paid if there is protocol loss associated with the liquidatee
            // otherwise, an economic exploit could occur if the liquidator and liquidatee collude to
            // manipulate the fees in a liquidity area they control past the protocol loss threshold
            // such that the PLPs are forced to pay out premia to the liquidator
            // thus, we haircut any premium paid by the liquidatee (converting tokens as necessary) until the protocol loss is covered or the premium is exhausted
            // note that the haircutPremia function also commits the settled amounts (adjusted for the haircut) to storage, so it will be called even if there is no haircut

            // if premium is haircut from a token that is not in protocol loss, some of the liquidation bonus will be converted into that token
            // reusing variables to save stack space; netExchanged = deltaBonus0, premia = deltaBonus1
            address _liquidatee = liquidatee;
            TokenId[] memory _positionIdList = positionIdList;
            int24 _finalTick = finalTick;
            int256 deltaBonus0;
            int256 deltaBonus1;
            (deltaBonus0, deltaBonus1) = PanopticMath.haircutPremia(
                _liquidatee,
                _positionIdList,
                premiasByLeg,
                collateralRemaining,
                s_collateralToken0,
                s_collateralToken1,
                Math.getSqrtRatioAtTick(_finalTick),
                s_settledTokens
            );

            unchecked {
                liquidationBonus0 += deltaBonus0;
                liquidationBonus1 += deltaBonus1;
            }
        }

        LeftRightUnsigned _delegations = delegations;
        // revoke the delegated amount plus the bonus amount.
        s_collateralToken0.revoke(
            msg.sender,
            liquidatee,
            uint256(int256(uint256(_delegations.rightSlot())) + liquidationBonus0)
        );
        s_collateralToken1.revoke(
            msg.sender,
            liquidatee,
            uint256(int256(uint256(_delegations.leftSlot())) + liquidationBonus1)
        );

        // check that the provided positionIdList matches the positions in memory
        _validatePositionList(msg.sender, positionIdListLiquidator, 0);

        if (
            !_checkSolvencyAtTick(
                msg.sender,
                positionIdListLiquidator,
                finalTick,
                finalTick,
                BP_DECREASE_BUFFER
            )
        ) revert Errors.NotEnoughCollateral();

        LeftRightSigned bonusAmounts = LeftRightSigned
            .wrap(0)
            .toRightSlot(int128(liquidationBonus0))
            .toLeftSlot(int128(liquidationBonus1));

        emit AccountLiquidated(msg.sender, liquidatee, bonusAmounts);
    }

    /// @notice Force the exercise of a single position. Exercisor will have to pay a fee to the force exercisee.
    /// @param account Address of the distressed account
    /// @param touchedId List of position to be force exercised. Can only contain one tokenId, written as [tokenId]
    /// @param positionIdListExercisee Post-burn list of open positions in the exercisee's (account) account
    /// @param positionIdListExercisor List of open positions in the exercisor's (msg.sender) account
    function forceExercise(
        address account,
        TokenId[] calldata touchedId,
        TokenId[] calldata positionIdListExercisee,
        TokenId[] calldata positionIdListExercisor
    ) external {
        // revert if multiple positions are specified
        // the reason why the singular touchedId is an array is so it composes well with the rest of the system
        // '_calculateAccumulatedPremia' expects a list of positions to be touched, and this is the only way to pass a single position
        if (touchedId.length != 1) revert Errors.InputListFail();

        // validate the exercisor's position list (the exercisee's list will be evaluated after their position is force exercised)
        _validatePositionList(msg.sender, positionIdListExercisor, 0);

        uint128 positionBalance = s_positionBalance[account][touchedId[0]].rightSlot();

        // compute the notional value of the short legs (the maximum amount of tokens required to exercise - premia)
        // and the long legs (from which the exercise cost is computed)
        (LeftRightSigned longAmounts, LeftRightSigned delegatedAmounts) = PanopticMath
            .computeExercisedAmounts(touchedId[0], positionBalance);

        int24 twapTick = getUniV3TWAP();

        (, int24 currentTick, , , , , ) = s_univ3pool.slot0();

        {
            // add the premia to the delegated amounts to ensure the user has enough collateral to exercise
            (LeftRightSigned positionPremia, ) = _calculateAccumulatedPremia(
                account,
                touchedId,
                COMPUTE_LONG_PREMIA,
                ONLY_AVAILABLE_PREMIUM,
                currentTick
            );

            // long premia is represented as negative so subtract it to increase it for the delegated amounts
            delegatedAmounts = delegatedAmounts.sub(positionPremia);
        }

        // on forced exercise, the price *must* be outside the position's range for at least 1 leg
        touchedId[0].validateIsExercisable(twapTick);

        // The protocol delegates some virtual shares to ensure the burn can be settled.
        s_collateralToken0.delegate(account, uint128(delegatedAmounts.rightSlot()));
        s_collateralToken1.delegate(account, uint128(delegatedAmounts.leftSlot()));

        // Exercise the option
        // Turn off ITM swapping to prevent swap at potentially unfavorable price
        _burnAllOptionsFrom(account, MIN_SWAP_TICK, MAX_SWAP_TICK, COMMIT_LONG_SETTLED, touchedId);

        // Compute the exerciseFee, this will decrease the further away the price is from the forcedExercised position
        // Use an oracle tick to prevent price manipulations based on swaps.
        LeftRightSigned exerciseFees = s_collateralToken0.exerciseCost(
            currentTick,
            twapTick,
            touchedId[0],
            positionBalance,
            longAmounts
        );

        LeftRightSigned refundAmounts = delegatedAmounts.add(exerciseFees);

        // redistribute token composition of refund amounts if user doesn't have enough of one token to pay
        refundAmounts = PanopticMath.getRefundAmounts(
            account,
            refundAmounts,
            twapTick,
            s_collateralToken0,
            s_collateralToken1
        );

        unchecked {
            // settle difference between delegated amounts (from the protocol) and exercise fees/substituted tokens
            s_collateralToken0.refund(
                account,
                msg.sender,
                refundAmounts.rightSlot() - delegatedAmounts.rightSlot()
            );
            s_collateralToken1.refund(
                account,
                msg.sender,
                refundAmounts.leftSlot() - delegatedAmounts.leftSlot()
            );
        }

        // refund the protocol any virtual shares after settling the difference with the exercisor
        s_collateralToken0.refund(account, uint128(delegatedAmounts.rightSlot()));
        s_collateralToken1.refund(account, uint128(delegatedAmounts.leftSlot()));

        _validateSolvency(account, positionIdListExercisee, NO_BUFFER);

        // the exercisor's position list is validated above
        // we need to assert their solvency against their collateral requirement plus a buffer
        // force exercises involve a collateral decrease with open positions, so there is a higher standard for solvency
        // a similar buffer is also invoked when minting options, which also decreases the available collateral
        if (positionIdListExercisor.length > 0)
            _validateSolvency(msg.sender, positionIdListExercisor, BP_DECREASE_BUFFER);

        emit ForcedExercised(msg.sender, account, touchedId[0], exerciseFees);
    }

    /*//////////////////////////////////////////////////////////////
                            SOLVENCY CHECKS
    //////////////////////////////////////////////////////////////*/

    /// @notice Check whether an account is solvent at a given `atTick` with a collateral requirement of `buffer`/10_000 multiplied by the requirement of `positionIdList`.
    /// @param account The account to check solvency for
    /// @param positionIdList The list of positions to check solvency for
    /// @param currentTick The current tick of the Uniswap pool (needed for fee calculations)
    /// @param atTick The tick to check solvency at
    /// @param buffer The buffer to apply to the collateral requirement
    /// @return Whether the account is solvent at the given tick
    function _checkSolvencyAtTick(
        address account,
        TokenId[] calldata positionIdList,
        int24 currentTick,
        int24 atTick,
        uint256 buffer
    ) internal view returns (bool) {
        (
            LeftRightSigned portfolioPremium,
            uint256[2][] memory positionBalanceArray
        ) = _calculateAccumulatedPremia(
                account,
                positionIdList,
                COMPUTE_ALL_PREMIA,
                ONLY_AVAILABLE_PREMIUM,
                currentTick
            );

        LeftRightUnsigned tokenData0 = s_collateralToken0.getAccountMarginDetails(
            account,
            atTick,
            positionBalanceArray,
            portfolioPremium.rightSlot()
        );
        LeftRightUnsigned tokenData1 = s_collateralToken1.getAccountMarginDetails(
            account,
            atTick,
            positionBalanceArray,
            portfolioPremium.leftSlot()
        );

        (uint256 balanceCross, uint256 thresholdCross) = _getSolvencyBalances(
            tokenData0,
            tokenData1,
            Math.getSqrtRatioAtTick(atTick)
        );

        // compare balance and required tokens, can use unsafe div because denominator is always nonzero
        unchecked {
            return balanceCross >= Math.unsafeDivRoundingUp(thresholdCross * buffer, 10_000);
        }
    }

    /// @notice Get a cross-collateral balance and required threshold for a given set of token balances and collateral requirements.
    /// @param tokenData0 LeftRight encoded word with balance of token0 in the right slot, and required balance in left slot
    /// @param tokenData1 LeftRight encoded word with balance of token1 in the right slot, and required balance in left slot
    /// @param sqrtPriceX96 The price at which to compute the collateral value and requirements
    /// @return balanceCross The current cross-collateral balance of the option positions
    /// @return thresholdCross The cross-collateral threshold balance under which the account is insolvent
    function _getSolvencyBalances(
        LeftRightUnsigned tokenData0,
        LeftRightUnsigned tokenData1,
        uint160 sqrtPriceX96
    ) internal pure returns (uint256 balanceCross, uint256 thresholdCross) {
        unchecked {
            // the cross-collateral balance, computed in terms of liquidity X*√P + Y/√P
            // We use mulDiv to compute Y/√P + X*√P while correctly handling overflows, round down
            balanceCross =
                Math.mulDiv(uint256(tokenData1.rightSlot()), 2 ** 96, sqrtPriceX96) +
                Math.mulDiv96(tokenData0.rightSlot(), sqrtPriceX96);
            // the amount of cross-collateral balance needed for the account to be solvent, computed in terms of liquidity
            // overstimate by rounding up
            thresholdCross =
                Math.mulDivRoundingUp(uint256(tokenData1.leftSlot()), 2 ** 96, sqrtPriceX96) +
                Math.mulDiv96RoundingUp(tokenData0.leftSlot(), sqrtPriceX96);
        }
    }

    /*//////////////////////////////////////////////////////////////
                 POSITIONS HASH GENERATION & VALIDATION
    //////////////////////////////////////////////////////////////*/

    /// @notice Makes sure that the positions in the incoming user's list match the existing active option positions.
    /// @param account The owner of the incoming list of positions
    /// @param positionIdList The existing list of active options for the owner
    /// @param offset The amount of positions from the end of the list to exclude from validation
    function _validatePositionList(
        address account,
        TokenId[] calldata positionIdList,
        uint256 offset
    ) internal view {
        uint256 pLength;
        uint256 currentHash = s_positionsHash[account];

        unchecked {
            pLength = positionIdList.length - offset;
        }

        uint256 fingerprintIncomingList;

        for (uint256 i = 0; i < pLength; ) {
            fingerprintIncomingList = PanopticMath.updatePositionsHash(
                fingerprintIncomingList,
                positionIdList[i],
                ADD
            );
            unchecked {
                ++i;
            }
        }

        // revert if fingerprint for provided '_positionIdList' does not match the one stored for the '_account'
        if (fingerprintIncomingList != currentHash) revert Errors.InputListFail();
    }

    /// @notice Updates the hash for all positions owned by an account. This fingerprints the list of all incoming options with a single hash.
    /// @dev The outcome of this function will be to update the hash of positions.
    /// This is done as a duplicate/validation check of the incoming list O(N).
    /// @dev The positions hash is stored as the XOR of the keccak256 of each tokenId. Updating will XOR the existing hash with the new tokenId.
    /// The same update can either add a new tokenId (when minting an option), or remove an existing one (when burning it).
    /// @param account The owner of `tokenId`
    /// @param tokenId The option position
    /// @param addFlag Whether to add `tokenId` to the hash (true) or remove it (false)
    function _updatePositionsHash(address account, TokenId tokenId, bool addFlag) internal {
        // Get the current position hash value (fingerprint of all pre-existing positions created by '_account')
        // Add the current tokenId to the positionsHash as XOR'd
        // since 0 ^ x = x, no problem on first mint
        // Store values back into the user option details with the updated hash (leaves the other parameters unchanged)
        uint256 newHash = PanopticMath.updatePositionsHash(
            s_positionsHash[account],
            tokenId,
            addFlag
        );
        if ((newHash >> 248) > MAX_POSITIONS) revert Errors.TooManyPositionsOpen();
        s_positionsHash[account] = newHash;
    }

    /*//////////////////////////////////////////////////////////////
                                QUERIES
    //////////////////////////////////////////////////////////////*/

    /// @notice Get the address of the AMM pool connected to this Panoptic pool.
    /// @return AMM pool corresponding to this Panoptic pool
    function univ3pool() external view returns (IUniswapV3Pool) {
        return s_univ3pool;
    }

    /// @notice Get the collateral token corresponding to token0 of the AMM pool.
    /// @return collateralToken Collateral token corresponding to token0 in the AMM
    function collateralToken0() external view returns (CollateralTracker collateralToken) {
        return s_collateralToken0;
    }

    /// @notice Get the collateral token corresponding to token1 of the AMM pool.
    /// @return Collateral token corresponding to token1 in the AMM
    function collateralToken1() external view returns (CollateralTracker) {
        return s_collateralToken1;
    }

    /// @notice Get the current number of open positions for an account
    /// @param user The account to query
    /// @return _numberOfPositions Number of open positions for `user`
    function numberOfPositions(address user) public view returns (uint256 _numberOfPositions) {
        _numberOfPositions = (s_positionsHash[user] >> 248);
    }

    /// @notice Get the oracle price used to check solvency in liquidations.
    /// @return twapTick The current oracle price used to check solvency in liquidations
    function getUniV3TWAP() internal view returns (int24 twapTick) {
        twapTick = PanopticMath.twapFilter(s_univ3pool, TWAP_WINDOW);
    }

    /*//////////////////////////////////////////////////////////////
                  PREMIA & PREMIA SPREAD CALCULATIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Ensure the effective liquidity in a given chunk is above a certain threshold.
    /// @param tokenId An option position
    /// @param leg A leg index of `tokenId` corresponding to a tickLower-tickUpper chunk
    /// @param tickLower The lower tick of the chunk
    /// @param tickUpper The upper tick of the chunk
    /// @param effectiveLiquidityLimitX32 Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position
    /// denominated as X32 = (ratioLimit * 2**32)
    function _checkLiquiditySpread(
        TokenId tokenId,
        uint256 leg,
        int24 tickLower,
        int24 tickUpper,
        uint64 effectiveLiquidityLimitX32
    ) internal view {
        LeftRightUnsigned accountLiquidities = SFPM.getAccountLiquidity(
            address(s_univ3pool),
            address(this),
            tokenId.tokenType(leg),
            tickLower,
            tickUpper
        );

        uint128 netLiquidity = accountLiquidities.rightSlot();
        uint128 removedLiquidity = accountLiquidities.leftSlot();
        // compute and return effective liquidity. Return if short=net=0, which is closing short position
        if (netLiquidity == 0 && removedLiquidity == 0) return;

        uint256 effectiveLiquidityFactorX32;
        unchecked {
            effectiveLiquidityFactorX32 = (uint256(removedLiquidity) * 2 ** 32) / netLiquidity;
        }

        // put a limit on how much new liquidity in one transaction can be deployed into this leg
        // the effective liquidity measures how many times more the newly added liquidity is compared to the existing/base liquidity
        if (effectiveLiquidityFactorX32 > uint256(effectiveLiquidityLimitX32))
            revert Errors.EffectiveLiquidityAboveThreshold();
    }

    /// @notice Compute the premia collected for a single option position 'tokenId'.
    /// @param tokenId The option position
    /// @param positionSize The number of contracts (size) of the option position
    /// @param owner The holder of the tokenId option
    /// @param computeAllPremia Whether to compute accumulated premia for all legs held by the user (true), or just owed premia for long legs (false)
    /// @param atTick The tick at which the premia is calculated -> use (atTick < type(int24).max) to compute it
    /// up to current block. atTick = type(int24).max will only consider fees as of the last on-chain transaction
    /// @return premiaByLeg The amount of premia owed to the user for each leg of the position
    /// @return premiumAccumulatorsByLeg The amount of premia accumulated for each leg of the position
    function _getPremia(
        TokenId tokenId,
        uint128 positionSize,
        address owner,
        bool computeAllPremia,
        int24 atTick
    )
        internal
        view
        returns (
            LeftRightSigned[4] memory premiaByLeg,
            uint256[2][4] memory premiumAccumulatorsByLeg
        )
    {
        uint256 numLegs = tokenId.countLegs();
        for (uint256 leg = 0; leg < numLegs; ) {
            uint256 isLong = tokenId.isLong(leg);
            if ((isLong == 1) || computeAllPremia) {
                LiquidityChunk liquidityChunk = PanopticMath.getLiquidityChunk(
                    tokenId,
                    leg,
                    positionSize
                );
                uint256 tokenType = tokenId.tokenType(leg);

                (premiumAccumulatorsByLeg[leg][0], premiumAccumulatorsByLeg[leg][1]) = SFPM
                    .getAccountPremium(
                        address(s_univ3pool),
                        address(this),
                        tokenType,
                        liquidityChunk.tickLower(),
                        liquidityChunk.tickUpper(),
                        atTick,
                        isLong
                    );

                unchecked {
                    LeftRightUnsigned premiumAccumulatorLast = s_options[owner][tokenId][leg];

                    premiaByLeg[leg] = LeftRightSigned
                        .wrap(0)
                        .toRightSlot(
                            int128(
                                int256(
                                    ((premiumAccumulatorsByLeg[leg][0] -
                                        premiumAccumulatorLast.rightSlot()) *
                                        (liquidityChunk.liquidity())) / 2 ** 64
                                )
                            )
                        )
                        .toLeftSlot(
                            int128(
                                int256(
                                    ((premiumAccumulatorsByLeg[leg][1] -
                                        premiumAccumulatorLast.leftSlot()) *
                                        (liquidityChunk.liquidity())) / 2 ** 64
                                )
                            )
                        );

                    if (isLong == 1) {
                        premiaByLeg[leg] = LeftRightSigned.wrap(0).sub(premiaByLeg[leg]);
                    }
                }
            }
            unchecked {
                ++leg;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                        AVAILABLE PREMIUM LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @notice Settle unpaid premium for one `legIndex` on a position owned by `owner`.
    /// @dev Called by sellers on buyers of their chunk to increase the available premium for withdrawal (before closing their position).
    /// @dev This feature is only available when `owner` is solvent and has the requisite tokens to settle the premium.
    /// @param positionIdList Exhaustive list of open positions for `owner` used for solvency checks where the tokenId to settle is placed at the last index
    /// @param owner The owner of the option position to make premium payments on
    /// @param legIndex the index of the leg in tokenId that is to be collected on (must be isLong=1)
    function settleLongPremium(
        TokenId[] calldata positionIdList,
        address owner,
        uint256 legIndex
    ) external {
        _validatePositionList(owner, positionIdList, 0);

        TokenId tokenId = positionIdList[positionIdList.length - 1];

        if (tokenId.isLong(legIndex) == 0 || legIndex > 3) revert Errors.NotALongLeg();

        (, int24 currentTick, , , , , ) = s_univ3pool.slot0();

        LeftRightUnsigned accumulatedPremium;
        {
            (int24 tickLower, int24 tickUpper) = tokenId.asTicks(legIndex);

            uint256 tokenType = tokenId.tokenType(legIndex);
            (uint128 premiumAccumulator0, uint128 premiumAccumulator1) = SFPM.getAccountPremium(
                address(s_univ3pool),
                address(this),
                tokenType,
                tickLower,
                tickUpper,
                currentTick,
                1
            );
            accumulatedPremium = LeftRightUnsigned
                .wrap(0)
                .toRightSlot(premiumAccumulator0)
                .toLeftSlot(premiumAccumulator1);

            // update the premium accumulator for the long position to the latest value
            // (the entire premia delta will be settled)
            LeftRightUnsigned premiumAccumulatorsLast = s_options[owner][tokenId][legIndex];
            s_options[owner][tokenId][legIndex] = accumulatedPremium;

            accumulatedPremium = accumulatedPremium.sub(premiumAccumulatorsLast);
        }

        uint256 liquidity = PanopticMath
            .getLiquidityChunk(tokenId, legIndex, s_positionBalance[owner][tokenId].rightSlot())
            .liquidity();

        unchecked {
            // update the realized premia
            LeftRightSigned realizedPremia = LeftRightSigned
                .wrap(0)
                .toRightSlot(int128(int256((accumulatedPremium.rightSlot() * liquidity) / 2 ** 64)))
                .toLeftSlot(int128(int256((accumulatedPremium.leftSlot() * liquidity) / 2 ** 64)));

            // deduct the paid premium tokens from the owner's balance and add them to the cumulative settled token delta
            s_collateralToken0.exercise(owner, 0, 0, 0, -realizedPremia.rightSlot());
            s_collateralToken1.exercise(owner, 0, 0, 0, -realizedPremia.leftSlot());

            bytes32 chunkKey = keccak256(
                abi.encodePacked(
                    tokenId.strike(legIndex),
                    tokenId.width(legIndex),
                    tokenId.tokenType(legIndex)
                )
            );
            // commit the delta in settled tokens (all of the premium paid by long chunks in the tokenIds list) to storage
            s_settledTokens[chunkKey] = s_settledTokens[chunkKey].add(
                LeftRightUnsigned.wrap(uint256(LeftRightSigned.unwrap(realizedPremia)))
            );

            emit PremiumSettled(owner, tokenId, realizedPremia);
        }

        // ensure the owner is solvent (insolvent accounts are not permitted to pay premium unless they are being liquidated)
        _validateSolvency(owner, positionIdList, NO_BUFFER);
    }

    /// @notice Adds collected tokens to settled accumulator and adjusts grossPremiumLast for any liquidity added.
    /// @param tokenId The option position that was minted
    /// @param collectedByLeg The amount of tokens collected in the corresponding chunk for each leg of the position
    /// @param positionSize The size of the position, expressed in terms of the asset
    function _updateSettlementPostMint(
        TokenId tokenId,
        LeftRightUnsigned[4] memory collectedByLeg,
        uint128 positionSize
    ) internal {
        uint256 numLegs = tokenId.countLegs();
        for (uint256 leg = 0; leg < numLegs; ++leg) {
            bytes32 chunkKey = keccak256(
                abi.encodePacked(tokenId.strike(leg), tokenId.width(leg), tokenId.tokenType(leg))
            );
            // add any tokens collected from Uniswap in a given chunk to the settled tokens available for withdrawal by sellers
            s_settledTokens[chunkKey] = s_settledTokens[chunkKey].add(collectedByLeg[leg]);

            if (tokenId.isLong(leg) == 0) {
                LiquidityChunk liquidityChunk = PanopticMath.getLiquidityChunk(
                    tokenId,
                    leg,
                    positionSize
                );

                // new totalLiquidity (total sold) = removedLiquidity + netLiquidity (R + N)
                uint256 totalLiquidity = _getTotalLiquidity(tokenId, leg);

                // We need to adjust the grossPremiumLast value such that the result of
                // (grossPremium - adjustedGrossPremiumLast)*updatedTotalLiquidityPostMint/2**64 is equal to (grossPremium - grossPremiumLast)*totalLiquidityBeforeMint/2**64
                // G: total gross premium
                // T: totalLiquidityBeforeMint
                // R: positionLiquidity
                // C: current grossPremium value
                // L: current grossPremiumLast value
                // Ln: updated grossPremiumLast value
                // T * (C - L) = G
                // (T + R) * (C - Ln) = G
                //
                // T * (C - L) = (T + R) * (C - Ln)
                // (TC - TL) / (T + R) = C - Ln
                // Ln = C - (TC - TL)/(T + R)
                // Ln = (CT + CR - TC + TL)/(T+R)
                // Ln = (CR + TL)/(T+R)

                uint256[2] memory grossCurrent;
                (grossCurrent[0], grossCurrent[1]) = SFPM.getAccountPremium(
                    address(s_univ3pool),
                    address(this),
                    tokenId.tokenType(leg),
                    liquidityChunk.tickLower(),
                    liquidityChunk.tickUpper(),
                    type(int24).max,
                    0
                );

                unchecked {
                    // L
                    LeftRightUnsigned grossPremiumLast = s_grossPremiumLast[chunkKey];
                    // R
                    uint256 positionLiquidity = liquidityChunk.liquidity();
                    // T (totalLiquidity is (T + R) after minting)
                    uint256 totalLiquidityBefore = totalLiquidity - positionLiquidity;

                    s_grossPremiumLast[chunkKey] = LeftRightUnsigned
                        .wrap(0)
                        .toRightSlot(
                            uint128(
                                (grossCurrent[0] *
                                    positionLiquidity +
                                    grossPremiumLast.rightSlot() *
                                    totalLiquidityBefore) / (totalLiquidity)
                            )
                        )
                        .toLeftSlot(
                            uint128(
                                (grossCurrent[1] *
                                    positionLiquidity +
                                    grossPremiumLast.leftSlot() *
                                    totalLiquidityBefore) / (totalLiquidity)
                            )
                        );
                }
            }
        }
    }

    /// @notice Query the amount of premium available for withdrawal given a certain `premiumOwed` for a chunk.
    /// @dev Based on the ratio between `settledTokens` and the total premium owed to sellers in a chunk.
    /// @dev The ratio is capped at 1 (as the base ratio can be greater than one if some seller forfeits enough premium).
    /// @param totalLiquidity The updated total liquidity amount for the chunk
    /// @param settledTokens LeftRight accumulator for the amount of tokens that have been settled (collected or paid)
    /// @param grossPremiumLast The `last` values used with `premiumAccumulators` to compute the total premium owed to sellers
    /// @param premiumOwed The amount of premium owed to sellers in the chunk
    /// @param premiumAccumulators The current values of the premium accumulators for the chunk
    /// @return The amount of token0/token1 premium available for withdrawal
    function _getAvailablePremium(
        uint256 totalLiquidity,
        LeftRightUnsigned settledTokens,
        LeftRightUnsigned grossPremiumLast,
        LeftRightUnsigned premiumOwed,
        uint256[2] memory premiumAccumulators
    ) internal pure returns (LeftRightUnsigned) {
        unchecked {
            // long premium only accumulates as it is settled, so compute the ratio
            // of total settled tokens in a chunk to total premium owed to sellers and multiply
            // cap the ratio at 1 (it can be greater than one if some seller forfeits enough premium)
            uint256 accumulated0 = ((premiumAccumulators[0] - grossPremiumLast.rightSlot()) *
                totalLiquidity) / 2 ** 64;
            uint256 accumulated1 = ((premiumAccumulators[1] - grossPremiumLast.leftSlot()) *
                totalLiquidity) / 2 ** 64;

            return (
                LeftRightUnsigned
                    .wrap(0)
                    .toRightSlot(
                        uint128(
                            Math.min(
                                (uint256(premiumOwed.rightSlot()) * settledTokens.rightSlot()) /
                                    (accumulated0 == 0 ? type(uint256).max : accumulated0),
                                premiumOwed.rightSlot()
                            )
                        )
                    )
                    .toLeftSlot(
                        uint128(
                            Math.min(
                                (uint256(premiumOwed.leftSlot()) * settledTokens.leftSlot()) /
                                    (accumulated1 == 0 ? type(uint256).max : accumulated1),
                                premiumOwed.leftSlot()
                            )
                        )
                    )
            );
        }
    }

    /// @notice Query the total amount of liquidity sold in the corresponding chunk for a position leg.
    /// @dev totalLiquidity (total sold) = removedLiquidity + netLiquidity (in AMM).
    /// @param tokenId The option position
    /// @param leg The leg of the option position to get `totalLiquidity` for
    /// @return totalLiquidity The total amount of liquidity sold in the corresponding chunk for a position leg
    function _getTotalLiquidity(
        TokenId tokenId,
        uint256 leg
    ) internal view returns (uint256 totalLiquidity) {
        unchecked {
            // totalLiquidity (total sold) = removedLiquidity + netLiquidity

            (int24 tickLower, int24 tickUpper) = tokenId.asTicks(leg);
            uint256 tokenType = tokenId.tokenType(leg);
            LeftRightUnsigned accountLiquidities = SFPM.getAccountLiquidity(
                address(s_univ3pool),
                address(this),
                tokenType,
                tickLower,
                tickUpper
            );

            // removed + net
            totalLiquidity = accountLiquidities.rightSlot() + accountLiquidities.leftSlot();
        }
    }

    /// @notice Updates settled tokens and grossPremiumLast for a chunk after a burn and returns premium info.
    /// @param owner The owner of the option position that was burnt
    /// @param tokenId The option position that was burnt
    /// @param collectedByLeg The amount of tokens collected in the corresponding chunk for each leg of the position
    /// @param positionSize The size of the position, expressed in terms of the asset
    /// @param commitLongSettled Whether to commit the long premium that will be settled to storage
    /// @return realizedPremia The amount of premia owed to the user
    /// @return premiaByLeg The amount of premia owed to the user for each leg of the position
    function _updateSettlementPostBurn(
        address owner,
        TokenId tokenId,
        LeftRightUnsigned[4] memory collectedByLeg,
        uint128 positionSize,
        bool commitLongSettled
    ) internal returns (LeftRightSigned realizedPremia, LeftRightSigned[4] memory premiaByLeg) {
        uint256 numLegs = tokenId.countLegs();
        uint256[2][4] memory premiumAccumulatorsByLeg;

        // compute accumulated fees
        (premiaByLeg, premiumAccumulatorsByLeg) = _getPremia(
            tokenId,
            positionSize,
            owner,
            COMPUTE_ALL_PREMIA,
            type(int24).max
        );

        for (uint256 leg = 0; leg < numLegs; ) {
            LeftRightSigned legPremia = premiaByLeg[leg];

            bytes32 chunkKey = keccak256(
                abi.encodePacked(tokenId.strike(leg), tokenId.width(leg), tokenId.tokenType(leg))
            );

            // collected from Uniswap
            LeftRightUnsigned settledTokens = s_settledTokens[chunkKey].add(collectedByLeg[leg]);

            // (will be) paid by long legs
            if (tokenId.isLong(leg) == 1) {
                if (commitLongSettled)
                    settledTokens = LeftRightUnsigned.wrap(
                        uint256(
                            LeftRightSigned.unwrap(
                                LeftRightSigned
                                    .wrap(int256(LeftRightUnsigned.unwrap(settledTokens)))
                                    .sub(legPremia)
                            )
                        )
                    );
                realizedPremia = realizedPremia.add(legPremia);
            } else {
                uint256 positionLiquidity = PanopticMath
                    .getLiquidityChunk(tokenId, leg, positionSize)
                    .liquidity();

                // new totalLiquidity (total sold) = removedLiquidity + netLiquidity (T - R)
                uint256 totalLiquidity = _getTotalLiquidity(tokenId, leg);
                // T (totalLiquidity is (T - R) after burning)
                uint256 totalLiquidityBefore = totalLiquidity + positionLiquidity;

                LeftRightUnsigned grossPremiumLast = s_grossPremiumLast[chunkKey];

                LeftRightUnsigned availablePremium = _getAvailablePremium(
                    totalLiquidity + positionLiquidity,
                    settledTokens,
                    grossPremiumLast,
                    LeftRightUnsigned.wrap(uint256(LeftRightSigned.unwrap(legPremia))),
                    premiumAccumulatorsByLeg[leg]
                );

                // subtract settled tokens sent to seller
                settledTokens = settledTokens.sub(availablePremium);

                // add available premium to amount that should be settled
                realizedPremia = realizedPremia.add(
                    LeftRightSigned.wrap(int256(LeftRightUnsigned.unwrap(availablePremium)))
                );

                // We need to adjust the grossPremiumLast value such that the result of
                // (grossPremium - adjustedGrossPremiumLast)*updatedTotalLiquidityPostBurn/2**64 is equal to
                // (grossPremium - grossPremiumLast)*totalLiquidityBeforeBurn/2**64 - premiumOwedToPosition
                // G: total gross premium (- premiumOwedToPosition)
                // T: totalLiquidityBeforeMint
                // R: positionLiquidity
                // C: current grossPremium value
                // L: current grossPremiumLast value
                // Ln: updated grossPremiumLast value
                // T * (C - L) = G
                // (T - R) * (C - Ln) = G - P
                //
                // T * (C - L) = (T - R) * (C - Ln) + P
                // (TC - TL - P) / (T - R) = C - Ln
                // Ln = C - (TC - TL - P) / (T - R)
                // Ln = (TC - CR - TC + LT + P) / (T-R)
                // Ln = (LT - CR + P) / (T-R)

                unchecked {
                    uint256[2][4] memory _premiumAccumulatorsByLeg = premiumAccumulatorsByLeg;
                    uint256 _leg = leg;

                    // if there's still liquidity, compute the new grossPremiumLast
                    // otherwise, we just reset grossPremiumLast to the current grossPremium
                    s_grossPremiumLast[chunkKey] = totalLiquidity != 0
                        ? LeftRightUnsigned
                            .wrap(0)
                            .toRightSlot(
                                uint128(
                                    uint256(
                                        Math.max(
                                            (int256(
                                                grossPremiumLast.rightSlot() * totalLiquidityBefore
                                            ) -
                                                int256(
                                                    _premiumAccumulatorsByLeg[_leg][0] *
                                                        positionLiquidity
                                                )) + int256(legPremia.rightSlot() * 2 ** 64),
                                            0
                                        )
                                    ) / totalLiquidity
                                )
                            )
                            .toLeftSlot(
                                uint128(
                                    uint256(
                                        Math.max(
                                            (int256(
                                                grossPremiumLast.leftSlot() * totalLiquidityBefore
                                            ) -
                                                int256(
                                                    _premiumAccumulatorsByLeg[_leg][1] *
                                                        positionLiquidity
                                                )) + int256(legPremia.leftSlot()) * 2 ** 64,
                                            0
                                        )
                                    ) / totalLiquidity
                                )
                            )
                        : LeftRightUnsigned
                            .wrap(0)
                            .toRightSlot(uint128(premiumAccumulatorsByLeg[_leg][0]))
                            .toLeftSlot(uint128(premiumAccumulatorsByLeg[_leg][1]));
                }
            }
            // update settled tokens in storage with all local deltas
            s_settledTokens[chunkKey] = settledTokens;

            unchecked {
                ++leg;
            }
        }
    }
}
