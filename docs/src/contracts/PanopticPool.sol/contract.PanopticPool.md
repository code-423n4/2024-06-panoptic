# PanopticPool
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/PanopticPool.sol)

**Inherits:**
ERC1155Holder, [Multicall](/contracts/base/Multicall.sol/abstract.Multicall.md)

**Author:**
Axicon Labs Limited

Manages positions, collateral, liquidations and forced exercises.


## State Variables
### MIN_SWAP_TICK
Lower price bound used when no slippage check is required.


```solidity
int24 internal constant MIN_SWAP_TICK = Constants.MIN_V3POOL_TICK - 1;
```


### MAX_SWAP_TICK
Upper price bound used when no slippage check is required.


```solidity
int24 internal constant MAX_SWAP_TICK = Constants.MAX_V3POOL_TICK + 1;
```


### COMPUTE_ALL_PREMIA
Flag that signals to compute premia for both the short and long legs of a position.


```solidity
bool internal constant COMPUTE_ALL_PREMIA = true;
```


### COMPUTE_LONG_PREMIA
Flag that signals to compute premia only for the long legs of a position.


```solidity
bool internal constant COMPUTE_LONG_PREMIA = false;
```


### ONLY_AVAILABLE_PREMIUM
Flag that indicates only to include the share of (settled) premium that is available to collect when calling `_calculateAccumulatedPremia`.


```solidity
bool internal constant ONLY_AVAILABLE_PREMIUM = false;
```


### COMMIT_LONG_SETTLED
Flag that signals to commit both collected Uniswap fees and settled long premium to `s_settledTokens`.


```solidity
bool internal constant COMMIT_LONG_SETTLED = true;
```


### DONOT_COMMIT_LONG_SETTLED
Flag that signals to only commit collected Uniswap fees to `s_settledTokens`.


```solidity
bool internal constant DONOT_COMMIT_LONG_SETTLED = false;
```


### ADD
Flag that signals to add a new position to the user's positions hash (as opposed to removing an existing position).


```solidity
bool internal constant ADD = true;
```


### TWAP_WINDOW
The minimum window (in seconds) used to calculate the TWAP price for solvency checks during liquidations.


```solidity
uint32 internal constant TWAP_WINDOW = 600;
```


### SLOW_ORACLE_UNISWAP_MODE
Parameter that determines which oracle type to use for the "slow" oracle price on non-liquidation solvency checks.

*If false, an 8-slot internal median array is used to compute the "slow" oracle price.*

*This oracle is updated with the last Uniswap observation during `mintOptions` if MEDIAN_PERIOD has elapsed past the last observation.*

*If true, the "slow" oracle price is instead computed on-the-fly from 8 Uniswap observations (spaced 5 observations apart) irrespective of the frequency of `mintOptions` calls.*


```solidity
bool internal constant SLOW_ORACLE_UNISWAP_MODE = false;
```


### MEDIAN_PERIOD
The minimum amount of time, in seconds, permitted between internal TWAP updates.


```solidity
uint256 internal constant MEDIAN_PERIOD = 60;
```


### FAST_ORACLE_CARDINALITY
Amount of Uniswap observations to include in the "fast" oracle price.


```solidity
uint256 internal constant FAST_ORACLE_CARDINALITY = 3;
```


### FAST_ORACLE_PERIOD
*Amount of observation indices to skip in between each observation for the "fast" oracle price.*

*Note that the *minimum* total observation time is determined by the blocktime and may need to be adjusted by chain.*

*Uniswap observations snapshot the last block's closing price at the first interaction with the pool in a block.*

*In this case, if there is an interaction every block, the "fast" oracle can consider 3 consecutive block end prices (min=36 seconds on Ethereum).*


```solidity
uint256 internal constant FAST_ORACLE_PERIOD = 1;
```


### SLOW_ORACLE_CARDINALITY
Amount of Uniswap observations to include in the "slow" oracle price (in Uniswap mode).


```solidity
uint256 internal constant SLOW_ORACLE_CARDINALITY = 8;
```


### SLOW_ORACLE_PERIOD
Amount of observation indices to skip in between each observation for the "slow" oracle price.

*Structured such that the minimum total observation time is 8 minutes on Ethereum (similar to internal median mode).*


```solidity
uint256 internal constant SLOW_ORACLE_PERIOD = 5;
```


### MAX_TWAP_DELTA_LIQUIDATION
The maximum allowed delta between the currentTick and the Uniswap TWAP tick during a liquidation (~5% down, ~5.26% up).

*Mitigates manipulation of the currentTick that causes positions to be liquidated at a less favorable price.*


```solidity
int256 internal constant MAX_TWAP_DELTA_LIQUIDATION = 513;
```


### MAX_SLOW_FAST_DELTA
The maximum allowed delta between the fast and slow oracle ticks before solvency is evaluated at the slow oracle tick.

*Falls back on the more conservative (less solvent) tick during times of extreme volatility.*


```solidity
int256 internal constant MAX_SLOW_FAST_DELTA = 1800;
```


### MAX_SPREAD
The maximum allowed ratio for a single chunk, defined as: removedLiquidity / netLiquidity.

*The long premium spread multiplier that corresponds with the MAX_SPREAD value depends on VEGOID,
which can be explored in this calculator: https://www.desmos.com/calculator/mdeqob2m04.*


```solidity
uint64 internal constant MAX_SPREAD = 9 * (2 ** 32);
```


### MAX_POSITIONS
The maximum allowed number of opened positions for a user.


```solidity
uint64 internal constant MAX_POSITIONS = 32;
```


### BP_DECREASE_BUFFER
Multiplier in basis points for the collateral requirement in the event of a buying power decrease, such as minting or force exercising another user.


```solidity
uint256 internal constant BP_DECREASE_BUFFER = 13_333;
```


### NO_BUFFER
Multiplier for the collateral requirement in the general case.


```solidity
uint256 internal constant NO_BUFFER = 10_000;
```


### SFPM
The "engine" of Panoptic - manages AMM liquidity and executes all mints/burns/exercises.


```solidity
SemiFungiblePositionManager internal immutable SFPM;
```


### s_univ3pool
The Uniswap v3 pool that this instance of Panoptic is deployed on.


```solidity
IUniswapV3Pool internal s_univ3pool;
```


### s_miniMedian
Stores a sorted set of 8 price observations used to compute the internal median oracle price.


```solidity
uint256 internal s_miniMedian;
```


### s_collateralToken0
Collateral vault for token0 in the Uniswap pool.


```solidity
CollateralTracker internal s_collateralToken0;
```


### s_collateralToken1
Collateral vault for token1 in the Uniswap pool.


```solidity
CollateralTracker internal s_collateralToken1;
```


### s_options
Nested mapping that tracks the option formation: address => tokenId => leg => premiaGrowth.

*Premia growth is taking a snapshot of the chunk premium in SFPM, which is measuring the amount of fees
collected for every chunk per unit of liquidity (net or short, depending on the isLong value of the specific leg index).*


```solidity
mapping(address account => mapping(TokenId tokenId => mapping(uint256 leg => LeftRightUnsigned premiaGrowth))) internal
    s_options;
```


### s_grossPremiumLast
Per-chunk `last` value that gives the aggregate amount of premium owed to all sellers when multiplied by the total amount of liquidity `totalLiquidity`.

*totalGrossPremium = totalLiquidity * (grossPremium(perLiquidityX64) - lastGrossPremium(perLiquidityX64)) / 2**64.*

*Used to compute the denominator for the fraction of premium available to sellers to collect.*

*LeftRight - right slot is token0, left slot is token1.*


```solidity
mapping(bytes32 chunkKey => LeftRightUnsigned lastGrossPremium) internal s_grossPremiumLast;
```


### s_settledTokens
Per-chunk accumulator for tokens owed to sellers that have been settled and are now available.

*This number increases when buyers pay long premium and when tokens are collected from Uniswap.*

*It decreases when sellers close positions and collect the premium they are owed.*

*LeftRight - right slot is token0, left slot is token1.*


```solidity
mapping(bytes32 chunkKey => LeftRightUnsigned settledTokens) internal s_settledTokens;
```


### s_positionBalance
Tracks the amount of liquidity for a user+tokenId (right slot) and the initial pool utilizations when that position was minted (left slot).


```solidity
mapping(address account => mapping(TokenId tokenId => LeftRightUnsigned balanceAndUtilizations)) internal
    s_positionBalance;
```


### s_positionsHash
Tracks the position list hash i.e keccak256(XORs of abi.encodePacked(positionIdList)).

*The order and content of this list (the preimage for the hash) is emitted in an event every time it is changed.*

*A component of this hash also tracks the total number of positions (i.e. makes sure the length of the provided positionIdList matches).*

*The purpose of this system is to reduce storage usage when a user has more than one active position.*

*Instead of having to manage an unwieldy storage array and do lots of loads, we just store a hash of the array.*

*This hash can be cheaply verified on every operation with a user provided positionIdList - which can then be used for operations
without having to every load any other data from storage.*


```solidity
mapping(address account => uint256 positionsHash) internal s_positionsHash;
```


## Functions
### constructor

Store the address of the canonical SemiFungiblePositionManager (SFPM) contract.


```solidity
constructor(SemiFungiblePositionManager _sfpm);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_sfpm`|`SemiFungiblePositionManager`|The address of the SFPM|


### startPool

Initializes a Panoptic Pool on top of an existing Uniswap v3 + collateral vault pair.

*Must be called first (by a factory contract) before any transaction can occur.*


```solidity
function startPool(
    IUniswapV3Pool _univ3pool,
    address token0,
    address token1,
    CollateralTracker collateralTracker0,
    CollateralTracker collateralTracker1
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_univ3pool`|`IUniswapV3Pool`|Address of the target Uniswap v3 pool|
|`token0`|`address`|Address of the pool's token0|
|`token1`|`address`|Address of the pool's token1|
|`collateralTracker0`|`CollateralTracker`|Address of the collateral vault for token0|
|`collateralTracker1`|`CollateralTracker`|Address of the collateral vault for token1|


### assertMinCollateralValues

Reverts if the caller has a lower collateral balance than required to meet the provided `minValue0` and `minValue1`.

*Can be used for composable slippage checks with `multicall` (such as for a force exercise or liquidation).*


```solidity
function assertMinCollateralValues(uint256 minValue0, uint256 minValue1) external view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minValue0`|`uint256`|The minimum acceptable `token0` value of collateral|
|`minValue1`|`uint256`|The minimum acceptable `token1` value of collateral|


### validateCollateralWithdrawable

Determines if account is eligible to withdraw or transfer collateral.

*Checks whether account is solvent with `BP_DECREASE_BUFFER` according to `_validateSolvency`.*

*Prevents insolvent and near-insolvent accounts from withdrawing collateral before they are liquidated.*

*Reverts if account is not solvent with `BP_DECREASE_BUFFER`.*


```solidity
function validateCollateralWithdrawable(address user, TokenId[] calldata positionIdList) external view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The account to check for collateral withdrawal eligibility|
|`positionIdList`|`TokenId[]`|The list of all option positions held by `user`|


### optionPositionBalance

Returns the total number of contracts owned by user for a specified position.


```solidity
function optionPositionBalance(address user, TokenId tokenId)
    external
    view
    returns (uint128 balance, uint64 poolUtilization0, uint64 poolUtilization1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address of the account to be checked|
|`tokenId`|`TokenId`|TokenId of the option position to be checked|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`balance`|`uint128`|Number of contracts of tokenId owned by the user|
|`poolUtilization0`|`uint64`|The utilization of token0 in the Panoptic pool at mint|
|`poolUtilization1`|`uint64`|The utilization of token1 in the Panoptic pool at mint|


### calculateAccumulatedFeesBatch

Compute the total amount of premium accumulated for a list of positions.


```solidity
function calculateAccumulatedFeesBatch(address user, bool includePendingPremium, TokenId[] calldata positionIdList)
    external
    view
    returns (int128 premium0, int128 premium1, uint256[2][] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address of the user that owns the positions|
|`includePendingPremium`|`bool`|If true, include premium that is owed to the user but has not yet settled; if false, only include premium that is available to collect|
|`positionIdList`|`TokenId[]`|List of positions. Written as [tokenId1, tokenId2, ...]|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`premium0`|`int128`|Premium for token0 (negative = amount is owed)|
|`premium1`|`int128`|Premium for token1 (negative = amount is owed)|
|`<none>`|`uint256[2][]`|A list of balances and pool utilization for each position, of the form [[tokenId0, balances0], [tokenId1, balances1], ...]|


### calculatePortfolioValue

Compute the net token amounts owned by a given positionIdList in the Uniswap pool at the given price tick.


```solidity
function calculatePortfolioValue(address user, int24 atTick, TokenId[] calldata positionIdList)
    external
    view
    returns (int256 value0, int256 value1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address of the user that owns the positions.|
|`atTick`|`int24`|Tick at which the portfolio value is evaluated|
|`positionIdList`|`TokenId[]`|List of positions. Written as [tokenId1, tokenId2, ...]|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`value0`|`int256`|Net amount of token0 in the Uniswap pool owned by the positionIdList (negative = borrowed liquidity owed to sellers)|
|`value1`|`int256`|Net amount of token1 in the Uniswap pool owned by the positionIdList (negative = borrowed liquidity owed to sellers)|


### _calculateAccumulatedPremia

Calculate the accumulated premia owed from the option buyer to the option seller.


```solidity
function _calculateAccumulatedPremia(
    address user,
    TokenId[] calldata positionIdList,
    bool computeAllPremia,
    bool includePendingPremium,
    int24 atTick
) internal view returns (LeftRightSigned portfolioPremium, uint256[2][] memory balances);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The holder of options|
|`positionIdList`|`TokenId[]`|The list of all option positions held by user|
|`computeAllPremia`|`bool`|Whether to compute accumulated premia for all legs held by the user (true), or just owed premia for long legs (false)|
|`includePendingPremium`|`bool`|If true, include premium that is owed to the user but has not yet settled; if false, only include premium that is available to collect|
|`atTick`|`int24`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`portfolioPremium`|`LeftRightSigned`|The computed premia of the user's positions, where premia contains the accumulated premia for token0 in the right slot and for token1 in the left slot|
|`balances`|`uint256[2][]`|A list of balances and pool utilization for each position, of the form [[tokenId0, balances0], [tokenId1, balances1], ...]|


### pokeMedian

Updates the internal median with the last Uniswap observation if the MEDIAN_PERIOD has elapsed.


```solidity
function pokeMedian() external;
```

### mintOptions

Validates the current options of the user, and mints a new position.


```solidity
function mintOptions(
    TokenId[] calldata positionIdList,
    uint128 positionSize,
    uint64 effectiveLiquidityLimitX32,
    int24 tickLimitLow,
    int24 tickLimitHigh
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionIdList`|`TokenId[]`|The list of currently held positions by the user, where the newly minted position(token) will be the last element in 'positionIdList'|
|`positionSize`|`uint128`|The size of the position to be minted, expressed in terms of the asset|
|`effectiveLiquidityLimitX32`|`uint64`|Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position and denominated as X32 = (ratioLimit * 2**32)|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|


### burnOptions

Closes and burns the caller's entire balance of `tokenId`.


```solidity
function burnOptions(TokenId tokenId, TokenId[] calldata newPositionIdList, int24 tickLimitLow, int24 tickLimitHigh)
    external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The tokenId of the option position to be burnt|
|`newPositionIdList`|`TokenId[]`|The new positionIdList without the token being burnt|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|


### burnOptions

Closes and burns the caller's entire balance of each `tokenId` in `positionIdList.


```solidity
function burnOptions(
    TokenId[] calldata positionIdList,
    TokenId[] calldata newPositionIdList,
    int24 tickLimitLow,
    int24 tickLimitHigh
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionIdList`|`TokenId[]`|The list of tokenIds for the option positions to be burnt|
|`newPositionIdList`|`TokenId[]`|The new positionIdList without the token(s) being burnt|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|


### _mintOptions

Validates the current options of the user, and mints a new position.


```solidity
function _mintOptions(
    TokenId[] calldata positionIdList,
    uint128 positionSize,
    uint64 effectiveLiquidityLimitX32,
    int24 tickLimitLow,
    int24 tickLimitHigh
) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionIdList`|`TokenId[]`|The list of currently held positions by the user, where the newly minted position(token) will be the last element in 'positionIdList'|
|`positionSize`|`uint128`|The size of the position to be minted, expressed in terms of the asset|
|`effectiveLiquidityLimitX32`|`uint64`|Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position and denominated as X32 = (ratioLimit * 2**32)|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|


### _mintInSFPMAndUpdateCollateral

Move all the required liquidity to/from the AMM and settle any required collateral deltas.


```solidity
function _mintInSFPMAndUpdateCollateral(TokenId tokenId, uint128 positionSize, int24 tickLimitLow, int24 tickLimitHigh)
    internal
    returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The option position to be minted|
|`positionSize`|`uint128`|The size of the position, expressed in terms of the asset|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool) at the time of minting, right 64bits for token0 and left 64bits for token1|


### _payCommissionAndWriteData

Take the commission fees for minting `tokenId` and settle any other required collateral deltas.


```solidity
function _payCommissionAndWriteData(TokenId tokenId, uint128 positionSize, LeftRightSigned totalSwapped)
    internal
    returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The option position|
|`positionSize`|`uint128`|The size of the position, expressed in terms of the asset|
|`totalSwapped`|`LeftRightSigned`|The amount of tokens moved during creation of the option position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool at the time of minting), right 64bits for token0 and left 64bits for token1, defined as (inAMM * 10_000) / totalAssets() where totalAssets is the total tracked assets in the AMM and PanopticPool minus fees and donations to the Panoptic pool|


### _addUserOption

Add a new option to the user's position hash, perform required checks, and initialize the premium accumulators.


```solidity
function _addUserOption(TokenId tokenId, uint64 effectiveLiquidityLimitX32) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The minted option position|
|`effectiveLiquidityLimitX32`|`uint64`|Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position denominated as X32 = (ratioLimit * 2**32)|


### _burnAllOptionsFrom

Close all options in `positionIdList.


```solidity
function _burnAllOptionsFrom(
    address owner,
    int24 tickLimitLow,
    int24 tickLimitHigh,
    bool commitLongSettled,
    TokenId[] calldata positionIdList
) internal returns (LeftRightSigned netPaid, LeftRightSigned[4][] memory premiasByLeg);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|The owner of the option position to be closed|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price on each option close|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price on each option close|
|`commitLongSettled`|`bool`|Whether to commit the long premium that will be settled to storage (disabled during liquidations)|
|`positionIdList`|`TokenId[]`|The list of option positions to close|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`netPaid`|`LeftRightSigned`|The net amount of tokens paid after closing the positions|
|`premiasByLeg`|`LeftRightSigned[4][]`|The amount of premia owed to the user for each leg of the position|


### _burnOptions

Close a single option position.


```solidity
function _burnOptions(bool commitLongSettled, TokenId tokenId, address owner, int24 tickLimitLow, int24 tickLimitHigh)
    internal
    returns (LeftRightSigned paidAmounts, LeftRightSigned[4] memory premiaByLeg);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`commitLongSettled`|`bool`|Whether to commit the long premium that will be settled to storage (disabled during liquidations)|
|`tokenId`|`TokenId`|The option position to burn|
|`owner`|`address`|The owner of the option position to be burned|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price on each option close|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price on each option close|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`paidAmounts`|`LeftRightSigned`|The net amount of tokens paid after closing the position|
|`premiaByLeg`|`LeftRightSigned[4]`|The amount of premia owed to the user for each leg of the position|


### _updatePositionDataBurn

Remove an option position from a user's position hash and reset its premium accumulators on close.


```solidity
function _updatePositionDataBurn(address owner, TokenId tokenId) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|The owner of the option position|
|`tokenId`|`TokenId`|The option position being closed|


### _validateSolvency

Validates the solvency of `user`.

*Falls back to the more conservative tick if the delta between the fast and slow oracle exceeds `MAX_SLOW_FAST_DELTA`.*

*Effectively, this means that the users must be solvent at both the fast and slow oracle ticks if one of them is stale to mint or burn options.*


```solidity
function _validateSolvency(address user, TokenId[] calldata positionIdList, uint256 buffer)
    internal
    view
    returns (uint256 medianData);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The account to validate|
|`positionIdList`|`TokenId[]`|The list of positions to validate solvency for|
|`buffer`|`uint256`|The buffer to apply to the collateral requirement for `user`|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`medianData`|`uint256`|If nonzero (enough time has passed since last observation), the updated value for `s_miniMedian` with a new observation|


### _burnAndHandleExercise

Burns and handles the exercise of options.


```solidity
function _burnAndHandleExercise(
    bool commitLongSettled,
    int24 tickLimitLow,
    int24 tickLimitHigh,
    TokenId tokenId,
    uint128 positionSize,
    address owner
)
    internal
    returns (LeftRightSigned realizedPremia, LeftRightSigned[4] memory premiaByLeg, LeftRightSigned paidAmounts);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`commitLongSettled`|`bool`|Whether to commit the long premium that will be settled to storage (disabled during liquidations)|
|`tickLimitLow`|`int24`|The lower bound of an acceptable open interval for the ending price|
|`tickLimitHigh`|`int24`|The upper bound of an acceptable open interval for the ending price|
|`tokenId`|`TokenId`|The option position to burn|
|`positionSize`|`uint128`|The size of the option position, expressed in terms of the asset|
|`owner`|`address`|The owner of the option position|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`realizedPremia`|`LeftRightSigned`|The net premia paid/received from the option position|
|`premiaByLeg`|`LeftRightSigned[4]`|The premia owed to the user for each leg of the option position|
|`paidAmounts`|`LeftRightSigned`|The net amount of tokens paid after closing the position|


### liquidate

Liquidates a distressed account. Will burn all positions and issue a bonus to the liquidator.

*Will revert if liquidated account is solvent at the TWAP tick or if TWAP tick is too far away from the current tick.*


```solidity
function liquidate(
    TokenId[] calldata positionIdListLiquidator,
    address liquidatee,
    LeftRightUnsigned delegations,
    TokenId[] calldata positionIdList
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionIdListLiquidator`|`TokenId[]`|List of positions owned by the liquidator|
|`liquidatee`|`address`|Address of the distressed account|
|`delegations`|`LeftRightUnsigned`|LeftRight amounts of token0 and token1 (token0:token1 right:left) delegated to the liquidatee by the liquidator so the option can be smoothly exercised|
|`positionIdList`|`TokenId[]`|List of positions owned by the user. Written as [tokenId1, tokenId2, ...]|


### forceExercise

Force the exercise of a single position. Exercisor will have to pay a fee to the force exercisee.


```solidity
function forceExercise(
    address account,
    TokenId[] calldata touchedId,
    TokenId[] calldata positionIdListExercisee,
    TokenId[] calldata positionIdListExercisor
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|Address of the distressed account|
|`touchedId`|`TokenId[]`|List of position to be force exercised. Can only contain one tokenId, written as [tokenId]|
|`positionIdListExercisee`|`TokenId[]`|Post-burn list of open positions in the exercisee's (account) account|
|`positionIdListExercisor`|`TokenId[]`|List of open positions in the exercisor's (msg.sender) account|


### _checkSolvencyAtTick

Check whether an account is solvent at a given `atTick` with a collateral requirement of `buffer`/10_000 multiplied by the requirement of `positionIdList`.


```solidity
function _checkSolvencyAtTick(
    address account,
    TokenId[] calldata positionIdList,
    int24 currentTick,
    int24 atTick,
    uint256 buffer
) internal view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The account to check solvency for|
|`positionIdList`|`TokenId[]`|The list of positions to check solvency for|
|`currentTick`|`int24`|The current tick of the Uniswap pool (needed for fee calculations)|
|`atTick`|`int24`|The tick to check solvency at|
|`buffer`|`uint256`|The buffer to apply to the collateral requirement|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Whether the account is solvent at the given tick|


### _getSolvencyBalances

Get a cross-collateral balance and required threshold for a given set of token balances and collateral requirements.


```solidity
function _getSolvencyBalances(LeftRightUnsigned tokenData0, LeftRightUnsigned tokenData1, uint160 sqrtPriceX96)
    internal
    pure
    returns (uint256 balanceCross, uint256 thresholdCross);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenData0`|`LeftRightUnsigned`|LeftRight encoded word with balance of token0 in the right slot, and required balance in left slot|
|`tokenData1`|`LeftRightUnsigned`|LeftRight encoded word with balance of token1 in the right slot, and required balance in left slot|
|`sqrtPriceX96`|`uint160`|The price at which to compute the collateral value and requirements|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`balanceCross`|`uint256`|The current cross-collateral balance of the option positions|
|`thresholdCross`|`uint256`|The cross-collateral threshold balance under which the account is insolvent|


### _validatePositionList

Makes sure that the positions in the incoming user's list match the existing active option positions.


```solidity
function _validatePositionList(address account, TokenId[] calldata positionIdList, uint256 offset) internal view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The owner of the incoming list of positions|
|`positionIdList`|`TokenId[]`|The existing list of active options for the owner|
|`offset`|`uint256`|The amount of positions from the end of the list to exclude from validation|


### _updatePositionsHash

Updates the hash for all positions owned by an account. This fingerprints the list of all incoming options with a single hash.

*The outcome of this function will be to update the hash of positions.
This is done as a duplicate/validation check of the incoming list O(N).*

*The positions hash is stored as the XOR of the keccak256 of each tokenId. Updating will XOR the existing hash with the new tokenId.
The same update can either add a new tokenId (when minting an option), or remove an existing one (when burning it).*


```solidity
function _updatePositionsHash(address account, TokenId tokenId, bool addFlag) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The owner of `tokenId`|
|`tokenId`|`TokenId`|The option position|
|`addFlag`|`bool`|Whether to add `tokenId` to the hash (true) or remove it (false)|


### univ3pool

Get the address of the AMM pool connected to this Panoptic pool.


```solidity
function univ3pool() external view returns (IUniswapV3Pool);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`IUniswapV3Pool`|AMM pool corresponding to this Panoptic pool|


### collateralToken0

Get the collateral token corresponding to token0 of the AMM pool.


```solidity
function collateralToken0() external view returns (CollateralTracker collateralToken);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`collateralToken`|`CollateralTracker`|Collateral token corresponding to token0 in the AMM|


### collateralToken1

Get the collateral token corresponding to token1 of the AMM pool.


```solidity
function collateralToken1() external view returns (CollateralTracker);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`CollateralTracker`|Collateral token corresponding to token1 in the AMM|


### numberOfPositions

Get the current number of open positions for an account


```solidity
function numberOfPositions(address user) public view returns (uint256 _numberOfPositions);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|The account to query|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_numberOfPositions`|`uint256`|Number of open positions for `user`|


### getUniV3TWAP

Get the oracle price used to check solvency in liquidations.


```solidity
function getUniV3TWAP() internal view returns (int24 twapTick);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`twapTick`|`int24`|The current oracle price used to check solvency in liquidations|


### _checkLiquiditySpread

Ensure the effective liquidity in a given chunk is above a certain threshold.


```solidity
function _checkLiquiditySpread(
    TokenId tokenId,
    uint256 leg,
    int24 tickLower,
    int24 tickUpper,
    uint64 effectiveLiquidityLimitX32
) internal view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|An option position|
|`leg`|`uint256`|A leg index of `tokenId` corresponding to a tickLower-tickUpper chunk|
|`tickLower`|`int24`|The lower tick of the chunk|
|`tickUpper`|`int24`|The upper tick of the chunk|
|`effectiveLiquidityLimitX32`|`uint64`|Maximum amount of "spread" defined as removedLiquidity/netLiquidity for a new position denominated as X32 = (ratioLimit * 2**32)|


### _getPremia

Compute the premia collected for a single option position 'tokenId'.


```solidity
function _getPremia(TokenId tokenId, uint128 positionSize, address owner, bool computeAllPremia, int24 atTick)
    internal
    view
    returns (LeftRightSigned[4] memory premiaByLeg, uint256[2][4] memory premiumAccumulatorsByLeg);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The option position|
|`positionSize`|`uint128`|The number of contracts (size) of the option position|
|`owner`|`address`|The holder of the tokenId option|
|`computeAllPremia`|`bool`|Whether to compute accumulated premia for all legs held by the user (true), or just owed premia for long legs (false)|
|`atTick`|`int24`|The tick at which the premia is calculated -> use (atTick < type(int24).max) to compute it up to current block. atTick = type(int24).max will only consider fees as of the last on-chain transaction|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`premiaByLeg`|`LeftRightSigned[4]`|The amount of premia owed to the user for each leg of the position|
|`premiumAccumulatorsByLeg`|`uint256[2][4]`|The amount of premia accumulated for each leg of the position|


### settleLongPremium

Settle unpaid premium for one `legIndex` on a position owned by `owner`.

*Called by sellers on buyers of their chunk to increase the available premium for withdrawal (before closing their position).*

*This feature is only available when `owner` is solvent and has the requisite tokens to settle the premium.*


```solidity
function settleLongPremium(TokenId[] calldata positionIdList, address owner, uint256 legIndex) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`positionIdList`|`TokenId[]`|Exhaustive list of open positions for `owner` used for solvency checks where the tokenId to settle is placed at the last index|
|`owner`|`address`|The owner of the option position to make premium payments on|
|`legIndex`|`uint256`|the index of the leg in tokenId that is to be collected on (must be isLong=1)|


### _updateSettlementPostMint

Adds collected tokens to settled accumulator and adjusts grossPremiumLast for any liquidity added.


```solidity
function _updateSettlementPostMint(TokenId tokenId, LeftRightUnsigned[4] memory collectedByLeg, uint128 positionSize)
    internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The option position that was minted|
|`collectedByLeg`|`LeftRightUnsigned[4]`|The amount of tokens collected in the corresponding chunk for each leg of the position|
|`positionSize`|`uint128`|The size of the position, expressed in terms of the asset|


### _getAvailablePremium

Query the amount of premium available for withdrawal given a certain `premiumOwed` for a chunk.

*Based on the ratio between `settledTokens` and the total premium owed to sellers in a chunk.*

*The ratio is capped at 1 (as the base ratio can be greater than one if some seller forfeits enough premium).*


```solidity
function _getAvailablePremium(
    uint256 totalLiquidity,
    LeftRightUnsigned settledTokens,
    LeftRightUnsigned grossPremiumLast,
    LeftRightUnsigned premiumOwed,
    uint256[2] memory premiumAccumulators
) internal pure returns (LeftRightUnsigned);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`totalLiquidity`|`uint256`|The updated total liquidity amount for the chunk|
|`settledTokens`|`LeftRightUnsigned`|LeftRight accumulator for the amount of tokens that have been settled (collected or paid)|
|`grossPremiumLast`|`LeftRightUnsigned`|The `last` values used with `premiumAccumulators` to compute the total premium owed to sellers|
|`premiumOwed`|`LeftRightUnsigned`|The amount of premium owed to sellers in the chunk|
|`premiumAccumulators`|`uint256[2]`|The current values of the premium accumulators for the chunk|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`LeftRightUnsigned`|The amount of token0/token1 premium available for withdrawal|


### _getTotalLiquidity

Query the total amount of liquidity sold in the corresponding chunk for a position leg.

*totalLiquidity (total sold) = removedLiquidity + netLiquidity (in AMM).*


```solidity
function _getTotalLiquidity(TokenId tokenId, uint256 leg) internal view returns (uint256 totalLiquidity);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The option position|
|`leg`|`uint256`|The leg of the option position to get `totalLiquidity` for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`totalLiquidity`|`uint256`|The total amount of liquidity sold in the corresponding chunk for a position leg|


### _updateSettlementPostBurn

Updates settled tokens and grossPremiumLast for a chunk after a burn and returns premium info.


```solidity
function _updateSettlementPostBurn(
    address owner,
    TokenId tokenId,
    LeftRightUnsigned[4] memory collectedByLeg,
    uint128 positionSize,
    bool commitLongSettled
) internal returns (LeftRightSigned realizedPremia, LeftRightSigned[4] memory premiaByLeg);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`owner`|`address`|The owner of the option position that was burnt|
|`tokenId`|`TokenId`|The option position that was burnt|
|`collectedByLeg`|`LeftRightUnsigned[4]`|The amount of tokens collected in the corresponding chunk for each leg of the position|
|`positionSize`|`uint128`|The size of the position, expressed in terms of the asset|
|`commitLongSettled`|`bool`|Whether to commit the long premium that will be settled to storage|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`realizedPremia`|`LeftRightSigned`|The amount of premia owed to the user|
|`premiaByLeg`|`LeftRightSigned[4]`|The amount of premia owed to the user for each leg of the position|


## Events
### AccountLiquidated
Emitted when an account is liquidated.

*Need to unpack bonusAmounts to get raw numbers, which are always positive.*


```solidity
event AccountLiquidated(address indexed liquidator, address indexed liquidatee, LeftRightSigned bonusAmounts);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`liquidator`|`address`|Address of the caller liquidating the distressed account|
|`liquidatee`|`address`|Address of the distressed/liquidatable account|
|`bonusAmounts`|`LeftRightSigned`|LeftRight encoding for the the bonus paid for token 0 (right slot) and 1 (left slot) from the Panoptic Pool to the liquidator|

### ForcedExercised
Emitted when a position is force exercised.


```solidity
event ForcedExercised(
    address indexed exercisor, address indexed user, TokenId indexed tokenId, LeftRightSigned exerciseFee
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`exercisor`|`address`|Address of the account that forces the exercise of the position|
|`user`|`address`|Address of the owner of the liquidated position|
|`tokenId`|`TokenId`|TokenId of the liquidated position|
|`exerciseFee`|`LeftRightSigned`|LeftRight encoding for the cost paid by the exercisor to force the exercise of the token; the cost for token 0 (right slot) and 1 (left slot) is represented as negative|

### PremiumSettled
Emitted when premium is settled independent of a mint/burn (e.g. during `settleLongPremium`).


```solidity
event PremiumSettled(address indexed user, TokenId indexed tokenId, LeftRightSigned settledAmounts);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`user`|`address`|Address of the owner of the settled position|
|`tokenId`|`TokenId`|TokenId of the settled position|
|`settledAmounts`|`LeftRightSigned`|LeftRight encoding for the amount of premium settled for token0 (right slot) and token1 (left slot)|

### OptionBurnt
Emitted when an option is burned.


```solidity
event OptionBurnt(address indexed recipient, uint128 positionSize, TokenId indexed tokenId, LeftRightSigned premia);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|User that burnt the option|
|`positionSize`|`uint128`|The number of contracts burnt, expressed in terms of the asset|
|`tokenId`|`TokenId`|TokenId of the burnt option|
|`premia`|`LeftRightSigned`|LeftRight packing for the amount of premia collected for token0 (right) and token1 (left)|

### OptionMinted
Emitted when an option is minted.


```solidity
event OptionMinted(address indexed recipient, uint128 positionSize, TokenId indexed tokenId, uint128 poolUtilizations);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`recipient`|`address`|User that minted the option|
|`positionSize`|`uint128`|The number of contracts minted, expressed in terms of the asset|
|`tokenId`|`TokenId`|TokenId of the created option|
|`poolUtilizations`|`uint128`|Packing of the pool utilization (how much funds are in the Panoptic pool versus the AMM pool at the time of minting), right 64bits for token0 and left 64bits for token1, defined as (inAMM * 10_000) / totalAssets() where totalAssets is the total tracked assets in the AMM and PanopticPool minus fees and donations to the Panoptic pool|

