# Report

- [Report](#report)
  - [Gas Optimizations](#gas-optimizations)
    - [\[GAS-1\] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)](#gas-1-a--a--b-is-more-gas-effective-than-a--b-for-state-variables-excluding-arrays-and-mappings)
    - [\[GAS-2\] Use assembly to check for `address(0)`](#gas-2-use-assembly-to-check-for-address0)
    - [\[GAS-3\] Using bools for storage incurs overhead](#gas-3-using-bools-for-storage-incurs-overhead)
    - [\[GAS-4\] Cache array length outside of loop](#gas-4-cache-array-length-outside-of-loop)
    - [\[GAS-5\] State variables should be cached in stack variables rather than re-reading them from storage](#gas-5-state-variables-should-be-cached-in-stack-variables-rather-than-re-reading-them-from-storage)
    - [\[GAS-6\] Use calldata instead of memory for function arguments that do not get mutated](#gas-6-use-calldata-instead-of-memory-for-function-arguments-that-do-not-get-mutated)
    - [\[GAS-7\] For Operations that will not overflow, you could use unchecked](#gas-7-for-operations-that-will-not-overflow-you-could-use-unchecked)
    - [\[GAS-8\] Avoid contract existence checks by using low level calls](#gas-8-avoid-contract-existence-checks-by-using-low-level-calls)
    - [\[GAS-9\] Stack variable used as a cheaper cache for a state variable is only used once](#gas-9-stack-variable-used-as-a-cheaper-cache-for-a-state-variable-is-only-used-once)
    - [\[GAS-10\] State variables only set in the constructor should be declared `immutable`](#gas-10-state-variables-only-set-in-the-constructor-should-be-declared-immutable)
    - [\[GAS-11\] Functions guaranteed to revert when called by normal users can be marked `payable`](#gas-11-functions-guaranteed-to-revert-when-called-by-normal-users-can-be-marked-payable)
    - [\[GAS-12\] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)](#gas-12-i-costs-less-gas-compared-to-i-or-i--1-same-for---i-vs-i---or-i---1)
    - [\[GAS-13\] Use shift right/left instead of division/multiplication if possible](#gas-13-use-shift-rightleft-instead-of-divisionmultiplication-if-possible)
    - [\[GAS-14\] Increments/decrements can be unchecked in for-loops](#gas-14-incrementsdecrements-can-be-unchecked-in-for-loops)
    - [\[GAS-15\] Use != 0 instead of \> 0 for unsigned integer comparison](#gas-15-use--0-instead-of--0-for-unsigned-integer-comparison)
    - [\[GAS-16\] `internal` functions not called by the contract should be removed](#gas-16-internal-functions-not-called-by-the-contract-should-be-removed)
    - [\[GAS-17\] WETH address definition can be use directly](#gas-17-weth-address-definition-can-be-use-directly)
  - [Non Critical Issues](#non-critical-issues)
    - [\[NC-1\] Missing checks for `address(0)` when assigning values to address state variables](#nc-1-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[NC-2\] Array indices should be referenced via `enum`s rather than via numeric literals](#nc-2-array-indices-should-be-referenced-via-enums-rather-than-via-numeric-literals)
    - [\[NC-3\] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`](#nc-3-use-stringconcat-or-bytesconcat-instead-of-abiencodepacked)
    - [\[NC-4\] `constant`s should be defined rather than using magic numbers](#nc-4-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-5\] Control structures do not follow the Solidity Style Guide](#nc-5-control-structures-do-not-follow-the-solidity-style-guide)
    - [\[NC-6\] Unused `error` definition](#nc-6-unused-error-definition)
    - [\[NC-7\] Events that mark critical parameter changes should contain both the old and the new value](#nc-7-events-that-mark-critical-parameter-changes-should-contain-both-the-old-and-the-new-value)
    - [\[NC-8\] Function ordering does not follow the Solidity style guide](#nc-8-function-ordering-does-not-follow-the-solidity-style-guide)
    - [\[NC-9\] Functions should not be longer than 50 lines](#nc-9-functions-should-not-be-longer-than-50-lines)
    - [\[NC-10\] Change int to int256](#nc-10-change-int-to-int256)
    - [\[NC-11\] Lack of checks in setters](#nc-11-lack-of-checks-in-setters)
    - [\[NC-12\] Lines are too long](#nc-12-lines-are-too-long)
    - [\[NC-13\] `type(uint256).max` should be used instead of `2 ** 256 - 1`](#nc-13-typeuint256max-should-be-used-instead-of-2--256---1)
    - [\[NC-14\] Incomplete NatSpec: `@param` is missing on actually documented functions](#nc-14-incomplete-natspec-param-is-missing-on-actually-documented-functions)
    - [\[NC-15\] Incomplete NatSpec: `@return` is missing on actually documented functions](#nc-15-incomplete-natspec-return-is-missing-on-actually-documented-functions)
    - [\[NC-16\] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor](#nc-16-use-a-modifier-instead-of-a-requireif-statement-for-a-special-msgsender-actor)
    - [\[NC-17\] Constant state variables defined more than once](#nc-17-constant-state-variables-defined-more-than-once)
    - [\[NC-18\] Adding a `return` statement when the function defines a named return variable, is redundant](#nc-18-adding-a-return-statement-when-the-function-defines-a-named-return-variable-is-redundant)
    - [\[NC-19\] `require()` / `revert()` statements should have descriptive reason strings](#nc-19-requirerevertstatements-should-have-descriptive-reason-strings)
    - [\[NC-20\] Take advantage of Custom Error's return value property](#nc-20-take-advantage-of-custom-errors-return-value-property)
    - [\[NC-21\] Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`)](#nc-21-use-scientific-notation-eg-1e18-rather-than-exponentiation-eg-1018)
    - [\[NC-22\] Strings should use double quotes rather than single quotes](#nc-22-strings-should-use-double-quotes-rather-than-single-quotes)
    - [\[NC-23\] Contract does not follow the Solidity style guide's suggested layout ordering](#nc-23-contract-does-not-follow-the-solidity-style-guides-suggested-layout-ordering)
    - [\[NC-24\] Use Underscores for Number Literals (add an underscore every 3 digits)](#nc-24-use-underscores-for-number-literals-add-an-underscore-every-3-digits)
    - [\[NC-25\] Internal and private variables and functions names should begin with an underscore](#nc-25-internal-and-private-variables-and-functions-names-should-begin-with-an-underscore)
    - [\[NC-26\] Event is missing `indexed` fields](#nc-26-event-is-missing-indexed-fields)
    - [\[NC-27\] Constants should be defined rather than using magic numbers](#nc-27-constants-should-be-defined-rather-than-using-magic-numbers)
    - [\[NC-28\] `public` functions not called by the contract should be declared `external` instead](#nc-28-public-functions-not-called-by-the-contract-should-be-declared-external-instead)
    - [\[NC-29\] Variables need not be initialized to zero](#nc-29-variables-need-not-be-initialized-to-zero)
  - [Low Issues](#low-issues)
    - [\[L-1\] `approve()`/`safeApprove()` may revert if the current approval is not zero](#l-1-approvesafeapprove-may-revert-if-the-current-approval-is-not-zero)
    - [\[L-2\] Some tokens may revert when zero value transfers are made](#l-2-some-tokens-may-revert-when-zero-value-transfers-are-made)
    - [\[L-3\] Missing checks for `address(0)` when assigning values to address state variables](#l-3-missing-checks-for-address0-when-assigning-values-to-address-state-variables)
    - [\[L-4\] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`](#l-4-abiencodepacked-should-not-be-used-with-dynamic-types-when-passing-the-result-to-a-hash-function-such-as-keccak256)
    - [\[L-5\] `decimals()` is not a part of the ERC-20 standard](#l-5-decimals-is-not-a-part-of-the-erc-20-standard)
    - [\[L-6\] Deprecated approve() function](#l-6-deprecated-approve-function)
    - [\[L-7\] Division by zero not prevented](#l-7-division-by-zero-not-prevented)
    - [\[L-8\] External calls in an un-bounded `for-`loop may result in a DOS](#l-8-external-calls-in-an-un-bounded-for-loop-may-result-in-a-dos)
    - [\[L-9\] Prevent accidentally burning tokens](#l-9-prevent-accidentally-burning-tokens)
    - [\[L-10\] NFT ownership doesn't support hard forks](#l-10-nft-ownership-doesnt-support-hard-forks)
    - [\[L-11\] Possible rounding issue](#l-11-possible-rounding-issue)
    - [\[L-12\] Loss of precision](#l-12-loss-of-precision)
    - [\[L-13\] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`](#l-13-solidity-version-0820-may-not-work-on-other-chains-due-to-push0)
    - [\[L-14\] File allows a version of solidity that is susceptible to an assembly optimizer bug](#l-14-file-allows-a-version-of-solidity-that-is-susceptible-to-an-assembly-optimizer-bug)
    - [\[L-15\] `symbol()` is not a part of the ERC-20 standard](#l-15-symbol-is-not-a-part-of-the-erc-20-standard)
    - [\[L-16\] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting](#l-16-consider-using-openzeppelins-safecast-library-to-prevent-unexpected-overflows-when-downcasting)
    - [\[L-17\] Unsafe ERC20 operation(s)](#l-17-unsafe-erc20-operations)
    - [\[L-18\] Upgradeable contract not initialized](#l-18-upgradeable-contract-not-initialized)
  - [Medium Issues](#medium-issues)
    - [\[M-1\] `_safeMint()` should be used rather than `_mint()` wherever possible](#m-1-_safemint-should-be-used-rather-than-_mint-wherever-possible)
    - [\[M-2\] Library function isn't `internal` or `private`](#m-2-library-function-isnt-internal-or-private)
    - [\[M-3\] Return values of `transfer()`/`transferFrom()` not checked](#m-3-return-values-of-transfertransferfrom-not-checked)
    - [\[M-4\] Unsafe use of `transfer()`/`transferFrom()` with `IERC20`](#m-4-unsafe-use-of-transfertransferfrom-with-ierc20)

## Gas Optimizations

| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 42 |
| [GAS-2](#GAS-2) | Use assembly to check for `address(0)` | 6 |
| [GAS-3](#GAS-3) | Using bools for storage incurs overhead | 12 |
| [GAS-4](#GAS-4) | Cache array length outside of loop | 9 |
| [GAS-5](#GAS-5) | State variables should be cached in stack variables rather than re-reading them from storage | 1 |
| [GAS-6](#GAS-6) | Use calldata instead of memory for function arguments that do not get mutated | 7 |
| [GAS-7](#GAS-7) | For Operations that will not overflow, you could use unchecked | 719 |
| [GAS-8](#GAS-8) | Avoid contract existence checks by using low level calls | 5 |
| [GAS-9](#GAS-9) | Stack variable used as a cheaper cache for a state variable is only used once | 2 |
| [GAS-10](#GAS-10) | State variables only set in the constructor should be declared `immutable` | 14 |
| [GAS-11](#GAS-11) | Functions guaranteed to revert when called by normal users can be marked `payable` | 3 |
| [GAS-12](#GAS-12) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 33 |
| [GAS-13](#GAS-13) | Use shift right/left instead of division/multiplication if possible | 29 |
| [GAS-14](#GAS-14) | Increments/decrements can be unchecked in for-loops | 17 |
| [GAS-15](#GAS-15) | Use != 0 instead of > 0 for unsigned integer comparison | 27 |
| [GAS-16](#GAS-16) | `internal` functions not called by the contract should be removed | 82 |
| [GAS-17](#GAS-17) | WETH address definition can be use directly | 2 |

### <a name="GAS-1"></a>[GAS-1] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)

This saves **16 gas per instance.**

*Instances (42)*:

```solidity
File: contracts/CollateralTracker.sol

420:             s_poolAssets += uint128(assets);

478:             s_poolAssets += uint128(assets);

914:         balanceOf[delegatee] += convertToShares(assets);

1128:             exchangedAmount += int256(

1184:                     tokenRequired += uint128(-premiumAllPositions);

1193:                 netBalance += uint256(uint128(premiumAllPositions));

1237:                 tokenRequired += _tokenRequired;

1268:                 tokenRequired += _getRequiredCollateralSingleLeg(

1408:                         required += Math.mulDiv96RoundingUp(amountMoved, c2);

1424:                         required += c3;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

303:                 salt += 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

1102:                 liquidationBonus0 += deltaBonus0;

1103:                 liquidationBonus1 += deltaBonus1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

229:               s_accountPremiumOwed += feeGrowthX128 * R * (1 + ν*R/N) / R

230:                                    += feeGrowthX128 * (T - R + ν*R)/N

231:                                    += feeGrowthX128 * T/N * (1 - R/T + ν*R/T)

245:              s_accountPremiumOwed += feesCollected * T/N^2 * (1 - R/T + ν*R/T)          (Eqn 3)     

265:             s_accountPremiumGross += feesCollected * T/N^2 * (1 - R/T + ν*R^2/T^2)       (Eqn 4) 

919:                     amount0 += Math.getAmount0ForLiquidity(liquidityChunk);

921:                     amount1 += Math.getAmount1ForLiquidity(liquidityChunk);

1027:                     removedLiquidity += chunkLiquidity;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

228:             offset += charOffset;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

69:                         value0 += int256(amount0);

70:                         value1 += int256(amount1);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/Math.sol

95:                 r += 32;

99:                 r += 16;

103:                 r += 8;

107:                 r += 4;

111:                 r += 2;

114:                 r += 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

53:             poolId += uint64(uint24(tickSpacing)) << 48;

254:                         shift += 1;

721:                     bonus1 += Math.min(

739:                     bonus0 += Math.min(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

107:             balanceOf[to][id] += amount;

151:                 balanceOf[to][id] += amount;

217:             balanceOf[to][id] += amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

67:             balanceOf[to] += amount;

91:             balanceOf[to] += amount;

109:             balanceOf[to] += amount;

126:             balanceOf[to] += amount;

128:         totalSupply += amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

### <a name="GAS-2"></a>[GAS-2] Use assembly to check for `address(0)`

*Saves 6 gas per instance*

*Instances (6)*:

```solidity
File: contracts/PanopticFactory.sol

183:         if (address(v3Pool) == address(0)) revert Errors.UniswapPoolNotInitialized();

185:         if (address(s_getPanopticPool[v3Pool]) != address(0))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

291:         if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

370:         // There are 281,474,976,710,655 possible pool patterns.

387:         // (this is for the case that poolId == 0, so we can make a distinction between zero and uninitialized)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

78:             return addr == address(0) ? 40 : 39 - Math.mostSignificantNibble(uint160(addr));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-3"></a>[GAS-3] Using bools for storage incurs overhead

Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (12)*:

```solidity
File: contracts/CollateralTracker.sol

92:     bool internal s_initialized;

101:     bool internal s_underlyingIsToken0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

102:     bool internal constant COMPUTE_ALL_PREMIA = true;

104:     bool internal constant COMPUTE_LONG_PREMIA = false;

107:     bool internal constant ONLY_AVAILABLE_PREMIUM = false;

110:     bool internal constant COMMIT_LONG_SETTLED = true;

112:     bool internal constant DONOT_COMMIT_LONG_SETTLED = false;

115:     bool internal constant ADD = true;

124:     bool internal constant SLOW_ORACLE_UNISWAP_MODE = false;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

123:     bool internal constant MINT = false;

126:     bool internal constant BURN = true;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

71:     mapping(address owner => mapping(address operator => bool approvedForAll))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

### <a name="GAS-4"></a>[GAS-4] Cache array length outside of loop

If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (9)*:

```solidity
File: contracts/PanopticPool.sol

771:         for (uint256 i = 0; i < positionIdList.length; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

577:         for (uint256 i = 0; i < ids.length; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

223:         for (uint256 i = 0; i < bytes(chars).length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/base/Multicall.sol

14:         for (uint256 i = 0; i < data.length; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

51:         for (uint256 k = 0; k < positionIdList.length; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

787:             for (uint256 i = 0; i < positionIdList.length; ++i) {

867:             for (uint256 i = 0; i < positionIdList.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

143:         for (uint256 i = 0; i < ids.length; ) {

187:             for (uint256 i = 0; i < owners.length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

### <a name="GAS-5"></a>[GAS-5] State variables should be cached in stack variables rather than re-reading them from storage

The instances below point to the second+ access of a state variable within a function. Caching of a state variable replaces each Gwarmaccess (100 gas) with a much cheaper stack read. Other less obvious fixes/optimizations include having local memory caches of state variable structs, or having local caches of state variable contracts/addresses.

*Saves 100 gas per instance*

*Instances (1)*:

```solidity
File: contracts/PanopticFactory.sol

209:             Clones.clone(COLLATERAL_REFERENCE)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

### <a name="GAS-6"></a>[GAS-6] Use calldata instead of memory for function arguments that do not get mutated

When a function with a `memory` array is called externally, the `abi.decode()` step has to use a for-loop to copy each index of the `calldata` to the `memory` index. Each iteration of this for-loop costs at least 60 gas (i.e. `60 * <mem_array>.length`). Using `calldata` directly bypasses this loop.

If the array is passed to an `internal` function which passes the array to another internal function where the array is modified and therefore `memory` is used in the `external` call, it's still more gas-efficient to use `calldata` when the `external` function uses modifiers, since the modifiers may prevent the internal functions from being called. Structs have the same overhead as an array of length one.

 *Saves 60 gas per instance*

*Instances (7)*:

```solidity
File: contracts/CollateralTracker.sol

1160:     /// @dev NOTE: It's up to the caller to confirm from the returned result that the account has enough collateral.

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/base/FactoryNFT.sol

60:         string memory symbol0,

61:         string memory symbol1,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

53:         string memory prefix

80:         string memory prefix

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

778:         LeftRightSigned collateralRemaining,

779:         CollateralTracker collateral0,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-7"></a>[GAS-7] For Operations that will not overflow, you could use unchecked

*Instances (719)*:

```solidity
File: contracts/CollateralTracker.sol

5: import {PanopticPool} from "./PanopticPool.sol";

7: import {ERC20Minimal} from "@tokens/ERC20Minimal.sol";

8: import {Multicall} from "@base/Multicall.sol";

10: import {Constants} from "@libraries/Constants.sol";

11: import {Errors} from "@libraries/Errors.sol";

12: import {InteractionHelper} from "@libraries/InteractionHelper.sol";

13: import {Math} from "@libraries/Math.sol";

14: import {PanopticMath} from "@libraries/PanopticMath.sol";

15: import {SafeTransferLib} from "@libraries/SafeTransferLib.sol";

17: import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";

18: import {LiquidityChunk} from "@types/LiquidityChunk.sol";

19: import {TokenId} from "@types/TokenId.sol";

72:     string internal constant NAME_PREFIX = "POPT-V1";

223:         totalSupply = 10 ** 6;

247:             s_ITMSpreadFee = uint128((ITM_SPREAD_MULTIPLIER * fee) / DECIMALS);

356:             return s_poolAssets + s_inAMM;

387:                 assets * (DECIMALS - COMMISSION_FEE),

389:                 totalAssets() * DECIMALS

420:             s_poolAssets += uint128(assets);

430:             return (convertToShares(type(uint104).max) * (DECIMALS - COMMISSION_FEE)) / DECIMALS;

446:             shares * DECIMALS,

448:             totalSupply * (DECIMALS - COMMISSION_FEE)

478:             s_poolAssets += uint128(assets);

501:         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

524:             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.

526:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

534:             s_poolAssets -= uint128(assets);

568:             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.

570:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

578:             s_poolAssets -= uint128(assets);

629:             uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.

631:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

641:             s_poolAssets -= uint128(assets);

688:         uint256 maxNumRangesFromStrike = 1; // technically "maxNum(Half)RangesFromStrike" but the name is long

691:             for (uint256 leg = 0; leg < positionId.countLegs(); ++leg) {

699:                                 uint24(positionId.width(leg) * positionId.tickSpacing()),

706:                         uint256(Math.abs(currentTick - positionId.strike(leg)) / range)

738:                         .toRightSlot(int128(uint128(oracleValue0)) - int128(uint128(currentValue0)))

739:                         .toLeftSlot(int128(uint128(oracleValue1)) - int128(uint128(currentValue1)))

747:             int256 fee = (FORCE_EXERCISE_COST >> (maxNumRangesFromStrike - 1)); // exponential decay of fee based on number of half ranges away from the price

751:                 .toRightSlot(int128((longAmounts.rightSlot() * fee) / DECIMALS_128))

752:                 .toLeftSlot(int128((longAmounts.leftSlot() * fee) / DECIMALS_128));

762:             return int256((s_inAMM * DECIMALS) / totalAssets());

783:                    100% - |                _------

784:                           |             _-¯

785:                           |          _-¯

786:                     20% - |---------¯

788:                           +---------+-------+-+--->   POOL_

797:                 min_sell_ratio /= 2;

798:                 utilization = -utilization;

815:                 min_sell_ratio +

816:                 ((DECIMALS - min_sell_ratio) * (uint256(utilization) - TARGET_POOL_UTIL)) /

817:                 (SATURATED_POOL_UTIL - TARGET_POOL_UTIL);

846:            10% - |----------__       min_ratio = 5%

847:            5%  - | . . . . .  ¯¯¯--______

849:                  +---------+-------+-+--->   POOL_

862:                 return BUYER_COLLATERAL_RATIO / 2;

868:                 (BUYER_COLLATERAL_RATIO +

869:                     (BUYER_COLLATERAL_RATIO * (SATURATED_POOL_UTIL - utilization)) /

870:                     (SATURATED_POOL_UTIL - TARGET_POOL_UTIL)) / 2; // do the division by 2 at the end after all addition and multiplication; b/c y1 = buyCollateralRatio / 2

875:           LIFECYCLE OF A COLLATERAL TOKEN AND DELEGATE/REVOKE LOGIC

914:         balanceOf[delegatee] += convertToShares(assets);

923:         balanceOf[delegatee] -= convertToShares(assets);

977:                     totalSupply - delegateeBalance,

978:                     uint256(Math.max(1, int256(totalAssets()) - int256(assets)))

979:                 ) - delegateeBalance

999:                 _transferFrom(refundee, refunder, convertToShares(uint256(-assets)));

1022:             int256 updatedAssets = int256(uint256(s_poolAssets)) - swappedAmount;

1039:                 uint256 sharesToMint = convertToShares(uint256(-tokenToPay));

1048:             s_inAMM = uint128(uint256(int256(uint256(s_inAMM)) + (shortAmount - longAmount)));

1071:             int256 updatedAssets = int256(uint256(s_poolAssets)) - swappedAmount;

1074:             int256 tokenToPay = swappedAmount - (longAmount - shortAmount) - realizedPremium;

1086:                 uint256 sharesToMint = convertToShares(uint256(-tokenToPay));

1093:             s_poolAssets = uint128(uint256(updatedAssets + realizedPremium));

1094:             s_inAMM = uint128(uint256(int256(uint256(s_inAMM)) - (shortAmount - longAmount)));

1114:             int256 intrinsicValue = swappedAmount - (shortAmount - longAmount);

1119:                     s_ITMSpreadFee * uint256(Math.abs(intrinsicValue)),

1120:                     DECIMALS * 100

1124:                 exchangedAmount = intrinsicValue + int256(swapCommission);

1128:             exchangedAmount += int256(

1130:                     uint256(uint128(shortAmount + longAmount)) * COMMISSION_FEE,

1184:                     tokenRequired += uint128(-premiumAllPositions);

1193:                 netBalance += uint256(uint128(premiumAllPositions));

1237:                 tokenRequired += _tokenRequired;

1240:                 ++i;

1264:             for (uint256 index = 0; index < numLegs; ++index) {

1268:                 tokenRequired += _getRequiredCollateralSingleLeg(

1294:             tokenId.riskPartner(index) == index // does this leg have a risk partner? Affects required collateral

1353:                     ((atTick >= tickUpper) && (tokenType == 1)) || // strike OTM when price >= upperTick for tokenType=1

1354:                     ((atTick < tickLower) && (tokenType == 0)) // strike OTM when price < lowerTick for tokenType=0

1369:                     uint160 ratio = tokenType == 1 // tokenType

1371:                             Math.max24(2 * (atTick - strike), Constants.MIN_V3POOL_TICK)

1372:                         ) // puts ->  price/strike

1374:                             Math.max24(2 * (strike - atTick), Constants.MIN_V3POOL_TICK)

1375:                         ); // calls -> strike/price

1381:                         ((atTick < tickLower) && (tokenType == 1)) || // strike ITM but out of range price < lowerTick for tokenType=1

1382:                         ((atTick >= tickUpper) && (tokenType == 0)) // strike ITM but out of range when price >= upperTick for tokenType=0

1385:                                     Short put BPR = 100% - (price/strike) + SCR

1392:                                          |        <- ITM . <-ATM-> . OTM ->

1393:                            100% + SCR% - |--__           .    .    .

1394:                                   100% - | . .¯¯--__     .    .    .

1395:                                          |    .     ¯¯--__    .    .

1396:                                    SCR - |    .          .¯¯--__________

1398:                                          +----+----------+----+----+--->   current

1399:                                          0   Liqui-     Pa  strike Pb       price

1401:                                              price = SCR*strike                                         

1404:                         uint256 c2 = Constants.FP96 - ratio;

1408:                         required += Math.mulDiv96RoundingUp(amountMoved, c2);

1416:                             (tickUpper - strike) + (strike - tickLower)

1420:                             scaleFactor - ratio,

1421:                             scaleFactor + Constants.FP96

1424:                         required += c3;

1492:                 required = Math.unsafeDivRoundingUp(amount * sellCollateral, DECIMALS);

1502:                 required = Math.unsafeDivRoundingUp(amount * buyCollateral, DECIMALS);

1552:                         ? movedPartnerRight - movedRight

1553:                         : movedRight - movedPartnerRight;

1556:                         ? movedPartnerLeft - movedLeft

1557:                         : movedLeft - movedPartnerLeft;

1577:                     ? Math.unsafeDivRoundingUp((notionalP - notional) * contracts, notional)

1578:                     : Math.unsafeDivRoundingUp((notional - notionalP) * contracts, notionalP);

1620:                     Put side of a short strangle, BPR = 100% - (100% - SCR/2)*(price/strike)

1625:                          |           <- ITM   .  OTM ->

1626:                   100% - |--__                .

1627:                          |    ¯¯--__          .

1628:                          |          ¯¯--__    .

1629:                  SCR/2 - |                ¯¯--______ <------ base collateral is half that of a single-leg

1630:                          +--------------------+--->   current

1643:                 uint128(uint64(-int64(poolUtilization0 == 0 ? 1 : poolUtilization0))) +

1644:                 (uint128(uint64(-int64(poolUtilization1 == 0 ? 1 : poolUtilization1))) << 64);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

5: import {CollateralTracker} from "@contracts/CollateralTracker.sol";

6: import {PanopticPool} from "@contracts/PanopticPool.sol";

7: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

8: import {IUniswapV3Factory} from "univ3-core/interfaces/IUniswapV3Factory.sol";

9: import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";

11: import {Multicall} from "@base/Multicall.sol";

12: import {FactoryNFT} from "@base/FactoryNFT.sol";

14: import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

16: import {CallbackLib} from "@libraries/CallbackLib.sol";

17: import {Constants} from "@libraries/Constants.sol";

18: import {Errors} from "@libraries/Errors.sol";

19: import {Math} from "@libraries/Math.sol";

20: import {PanopticMath} from "@libraries/PanopticMath.sol";

21: import {SafeTransferLib} from "@libraries/SafeTransferLib.sol";

23: import {Pointer} from "@types/Pointer.sol";

272:             maxSalt = uint256(salt) + loops;

303:                 salt += 1;

372:             tickLower = (Constants.MIN_V3POOL_TICK / tickSpacing) * tickSpacing;

373:             tickUpper = -tickLower;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

5: import {CollateralTracker} from "@contracts/CollateralTracker.sol";

6: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

7: import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";

9: import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

10: import {Multicall} from "@base/Multicall.sol";

12: import {Constants} from "@libraries/Constants.sol";

13: import {Errors} from "@libraries/Errors.sol";

14: import {FeesCalc} from "@libraries/FeesCalc.sol";

15: import {InteractionHelper} from "@libraries/InteractionHelper.sol";

16: import {Math} from "@libraries/Math.sol";

17: import {PanopticMath} from "@libraries/PanopticMath.sol";

19: import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";

20: import {LiquidityChunk} from "@types/LiquidityChunk.sol";

21: import {TokenId} from "@types/TokenId.sol";

96:     int24 internal constant MIN_SWAP_TICK = Constants.MIN_V3POOL_TICK - 1;

99:     int24 internal constant MAX_SWAP_TICK = Constants.MAX_V3POOL_TICK + 1;

156:     uint64 internal constant MAX_SPREAD = 9 * (2 ** 32);

301:                 (uint256(block.timestamp) << 216) +

304:                 (uint256(0xF590A6F276170D89E9F276170D89E9F276170D89E9000000000000)) +

305:                 (uint256(uint24(currentTick)) << 24) + // add to slot 4

306:                 (uint256(uint24(currentTick))); // add to slot 3

485:                     ++leg;

490:                 ++k;

516:                           MINT/BURN INTERFACE

601:             tokenId = positionIdList[positionIdList.length - 1];

698:             return uint128(uint256(utilization0) + uint128(uint256(utilization1) << 64));

746:                 ++leg;

782:                 ++i;

837:                 ++leg;

908:         if (Math.abs(int256(fastOracleTick) - slowOracleTick) > MAX_SLOW_FAST_DELTA)

1003:             if (Math.abs(currentTick - twapTick) > MAX_TWAP_DELTA_LIQUIDATION)

1102:                 liquidationBonus0 += deltaBonus0;

1103:                 liquidationBonus1 += deltaBonus1;

1112:             uint256(int256(uint256(_delegations.rightSlot())) + liquidationBonus0)

1117:             uint256(int256(uint256(_delegations.leftSlot())) + liquidationBonus1)

1222:                 refundAmounts.rightSlot() - delegatedAmounts.rightSlot()

1227:                 refundAmounts.leftSlot() - delegatedAmounts.leftSlot()

1297:             return balanceCross >= Math.unsafeDivRoundingUp(thresholdCross * buffer, 10_000);

1316:                 Math.mulDiv(uint256(tokenData1.rightSlot()), 2 ** 96, sqrtPriceX96) +

1321:                 Math.mulDivRoundingUp(uint256(tokenData1.leftSlot()), 2 ** 96, sqrtPriceX96) +

1343:             pLength = positionIdList.length - offset;

1355:                 ++i;

1453:             effectiveLiquidityFactorX32 = (uint256(removedLiquidity) * 2 ** 32) / netLiquidity;

1515:                                     ((premiumAccumulatorsByLeg[leg][0] -

1516:                                         premiumAccumulatorLast.rightSlot()) *

1517:                                         (liquidityChunk.liquidity())) / 2 ** 64

1524:                                     ((premiumAccumulatorsByLeg[leg][1] -

1525:                                         premiumAccumulatorLast.leftSlot()) *

1526:                                         (liquidityChunk.liquidity())) / 2 ** 64

1537:                 ++leg;

1559:         TokenId tokenId = positionIdList[positionIdList.length - 1];

1600:                 .toRightSlot(int128(int256((accumulatedPremium.rightSlot() * liquidity) / 2 ** 64)))

1601:                 .toLeftSlot(int128(int256((accumulatedPremium.leftSlot() * liquidity) / 2 ** 64)));

1604:             s_collateralToken0.exercise(owner, 0, 0, 0, -realizedPremia.rightSlot());

1605:             s_collateralToken1.exercise(owner, 0, 0, 0, -realizedPremia.leftSlot());

1636:         for (uint256 leg = 0; leg < numLegs; ++leg) {

1687:                     uint256 totalLiquidityBefore = totalLiquidity - positionLiquidity;

1693:                                 (grossCurrent[0] *

1694:                                     positionLiquidity +

1695:                                     grossPremiumLast.rightSlot() *

1696:                                     totalLiquidityBefore) / (totalLiquidity)

1701:                                 (grossCurrent[1] *

1702:                                     positionLiquidity +

1703:                                     grossPremiumLast.leftSlot() *

1704:                                     totalLiquidityBefore) / (totalLiquidity)

1732:             uint256 accumulated0 = ((premiumAccumulators[0] - grossPremiumLast.rightSlot()) *

1733:                 totalLiquidity) / 2 ** 64;

1734:             uint256 accumulated1 = ((premiumAccumulators[1] - grossPremiumLast.leftSlot()) *

1735:                 totalLiquidity) / 2 ** 64;

1743:                                 (uint256(premiumOwed.rightSlot()) * settledTokens.rightSlot()) /

1752:                                 (uint256(premiumOwed.leftSlot()) * settledTokens.leftSlot()) /

1785:             totalLiquidity = accountLiquidities.rightSlot() + accountLiquidities.leftSlot();

1847:                 uint256 totalLiquidityBefore = totalLiquidity + positionLiquidity;

1852:                     totalLiquidity + positionLiquidity,

1899:                                                 grossPremiumLast.rightSlot() * totalLiquidityBefore

1900:                                             ) -

1902:                                                     _premiumAccumulatorsByLeg[_leg][0] *

1904:                                                 )) + int256(legPremia.rightSlot() * 2 ** 64),

1907:                                     ) / totalLiquidity

1915:                                                 grossPremiumLast.leftSlot() * totalLiquidityBefore

1916:                                             ) -

1918:                                                     _premiumAccumulatorsByLeg[_leg][1] *

1920:                                                 )) + int256(legPremia.leftSlot()) * 2 ** 64,

1923:                                     ) / totalLiquidity

1936:                 ++leg;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

5: import {IUniswapV3Factory} from "univ3-core/interfaces/IUniswapV3Factory.sol";

6: import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";

8: import {ERC1155} from "@tokens/ERC1155Minimal.sol";

9: import {Multicall} from "@base/Multicall.sol";

11: import {CallbackLib} from "@libraries/CallbackLib.sol";

12: import {Constants} from "@libraries/Constants.sol";

13: import {Errors} from "@libraries/Errors.sol";

14: import {FeesCalc} from "@libraries/FeesCalc.sol";

15: import {Math} from "@libraries/Math.sol";

16: import {PanopticMath} from "@libraries/PanopticMath.sol";

17: import {SafeTransferLib} from "@libraries/SafeTransferLib.sol";

19: import {LeftRightUnsigned, LeftRightSigned, LeftRightLibrary} from "@types/LeftRight.sol";

20: import {LiquidityChunk} from "@types/LiquidityChunk.sol";

21: import {TokenId} from "@types/TokenId.sol";

160:           │  ┌────┐-T      due isLong=1   in the UniswapV3Pool 

162:           │  │    │                        ┌────┐-(T-R)  

163:           │  │    │         ┌────┐-R       │    │          

166:              total=T       removed=R      net=(T-R)

184:         keep track of the amount of fees that *would have been collected*, we call this the owed

192:         same tick using a tokenId with a isLong=1 parameter. Because the netLiquidity is only (T-R),

195:               net_feesCollectedX128 = feeGrowthX128 * (T - R)

196:                                     = feeGrowthX128 * N                                     

198:         where N = netLiquidity = T-R. Had that liquidity never been removed, we want the gross

201:               gross_feesCollectedX128 = feeGrowthX128 * T

209:               gross_feesCollectedX128 = net_feesCollectedX128 + owed_feesCollectedX128

213:               owed_feesCollectedX128 = feeGrowthX128 * R * (1 + spread)                      (Eqn 1)

217:               spread = ν*(liquidity removed from that strike)/(netLiquidity remaining at that strike)

218:                      = ν*R/N

220:         For an arbitrary parameter 0 <= ν <= 1 (ν = 1/2^VEGOID). This way, the gross_feesCollectedX128 will be given by: 

222:               gross_feesCollectedX128 = feeGrowthX128 * N + feeGrowthX128*R*(1 + ν*R/N) 

223:                                       = feeGrowthX128 * T + feesGrowthX128*ν*R^2/N         

224:                                       = feeGrowthX128 * T * (1 + ν*R^2/(N*T))                (Eqn 2)

226:         The s_accountPremiumOwed accumulator tracks the feeGrowthX128 * R * (1 + spread) term

229:               s_accountPremiumOwed += feeGrowthX128 * R * (1 + ν*R/N) / R

230:                                    += feeGrowthX128 * (T - R + ν*R)/N

231:                                    += feeGrowthX128 * T/N * (1 - R/T + ν*R/T)

237:              feesCollected = feesGrowthX128 * (T-R)

241:              feesGrowthX128 = feesCollected/N

245:              s_accountPremiumOwed += feesCollected * T/N^2 * (1 - R/T + ν*R/T)          (Eqn 3)     

250:              owedPremia(t1, t2) = (s_accountPremiumOwed_t2-s_accountPremiumOwed_t1) * r

251:                                 = ∆feesGrowthX128 * r * T/N * (1 - R/T + ν*R/T)

252:                                 = ∆feesGrowthX128 * r * (T - R + ν*R)/N

253:                                 = ∆feesGrowthX128 * r * (N + ν*R)/N

254:                                 = ∆feesGrowthX128 * r * (1 + ν*R/N)             (same as Eqn 1)

261:         However, since we require that Eqn 2 holds up-- ie. the gross fees collected should be equal

265:             s_accountPremiumGross += feesCollected * T/N^2 * (1 - R/T + ν*R^2/T^2)       (Eqn 4) 

270:             grossPremia(t1, t2) = ∆(s_accountPremiumGross) * t

271:                                 = ∆feeGrowthX128 * t * T/N * (1 - R/T + ν*R^2/T^2) 

272:                                 = ∆feeGrowthX128 * t * (T - R + ν*R^2/T) / N 

273:                                 = ∆feeGrowthX128 * t * (N + ν*R^2/T) / N

274:                                 = ∆feeGrowthX128 * t * (1  + ν*R^2/(N*T))   (same as Eqn 2)

279:         long+short liquidity to guarantee that liquidity deposited always receives the correct

389:             s_AddrToPoolIdData[univ3pool] = uint256(poolId) + 2 ** 255;

462:                        PUBLIC MINT/BURN FUNCTIONS

581:                 ++i;

650:                 ++leg;

760:         bool zeroForOne; // The direction of the swap, true for token0 to token1, false for token1 to token0

761:         int256 swapAmount; // The amount of token0 or token1 to swap

816:                 int256 net0 = itm0 - PanopticMath.convert1to0(itm1, sqrtPriceX96);

821:                 swapAmount = -net0;

824:                 swapAmount = -itm0;

827:                 swapAmount = -itm1;

841:                     ? Constants.MIN_V3POOL_SQRT_RATIO + 1

842:                     : Constants.MAX_V3POOL_SQRT_RATIO - 1,

898:                     _leg = _isBurn ? numLegs - leg - 1 : leg;

919:                     amount0 += Math.getAmount0ForLiquidity(liquidityChunk);

921:                     amount1 += Math.getAmount1ForLiquidity(liquidityChunk);

929:                 ++leg;

985:         LeftRightUnsigned currentLiquidity = s_accountLiquidity[positionKey]; //cache

999:                 updatedLiquidity = startingLiquidity + chunkLiquidity;

1004:                     removedLiquidity -= chunkLiquidity;

1020:                         updatedLiquidity = startingLiquidity - chunkLiquidity;

1027:                     removedLiquidity += chunkLiquidity;

1062:                 : _burnLiquidity(liquidityChunk, univ3pool); // from msg.sender to Uniswap

1182:             CallbackLib.CallbackData({ // compute by reading values from univ3pool every time

1232:             movedAmounts = LeftRightSigned.wrap(0).toRightSlot(-int128(int256(amount0))).toLeftSlot(

1233:                 -int128(int256(amount1))

1288:                     ? receivedAmount0 - uint128(-movedInLeg.rightSlot())

1291:                     ? receivedAmount1 - uint128(-movedInLeg.leftSlot())

1331:             uint256 totalLiquidity = netLiquidity + removedLiquidity;

1343:                     totalLiquidity * 2 ** 64,

1344:                     netLiquidity ** 2

1348:                     totalLiquidity * 2 ** 64,

1349:                     netLiquidity ** 2

1358:                     uint256 numerator = netLiquidity + (removedLiquidity / 2 ** VEGOID);

1379:                     uint256 numerator = totalLiquidity ** 2 -

1380:                         totalLiquidity *

1381:                         removedLiquidity +

1382:                         ((removedLiquidity ** 2) / 2 ** (VEGOID));

1385:                         .mulDiv(premium0X64_base, numerator, totalLiquidity ** 2)

1388:                         .mulDiv(premium1X64_base, numerator, totalLiquidity ** 2)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

5: import {PanopticMath} from "@libraries/PanopticMath.sol";

6: import {PanopticPool} from "@contracts/PanopticPool.sol";

8: import {ERC721} from "solmate/tokens/ERC721.sol";

9: import {MetadataStore} from "@base/MetadataStore.sol";

11: import {Pointer} from "@types/Pointer.sol";

13: import {LibString} from "solady/utils/LibString.sol";

14: import {Base64} from "solady/utils/Base64.sol";

32:         ERC721("Panoptic Factory Deployer NFTs", "PANOPTIC-NFT")

73:                     "data:application/json;base64,",

80:                                     "-",

83:                                         "-",

91:                                     "-",

93:                                     "-",

101:                                     " - ",

110:                                 "data:image/svg+xml;base64,",

129:             rarity < 18 ? rarity / 3 : rarity < 23 ? 23 - rarity : 0

132:             "<!-- LABEL -->",

141:                 "<!-- TEXT -->",

142:                 metadata[bytes32("descriptions")][lastCharVal + 16 * (rarity / 8)]

145:             .replace("<!-- ART -->", metadata[bytes32("art")][lastCharVal].decompressedDataStr())

146:             .replace("<!-- FILTER -->", metadata[bytes32("filters")][rarity].decompressedDataStr());

164:             .replace("<!-- POOLADDRESS -->", LibString.toHexString(uint160(panopticPool), 20))

165:             .replace("<!-- CHAINID -->", getChainName());

168:             "<!-- RARITY_NAME -->",

174:                 .replace("<!-- RARITY -->", write(LibString.toString(rarity)))

175:                 .replace("<!-- SYMBOL0 -->", write(symbol0, maxSymbolWidth(rarity)))

176:                 .replace("<!-- SYMBOL1 -->", write(symbol1, maxSymbolWidth(rarity)));

191:             return "Avalanche C-Chain";

223:         for (uint256 i = 0; i < bytes(chars).length; ++i) {

228:             offset += charOffset;

231:                 '<g transform="translate(-',

236:                 "</g>"

243:             uint256 _scale = (3400 * maxWidth) / offset;

257:             LibString.toString(offset / 2),

260:             "</g>"

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/base/Multicall.sol

25:                 assembly ("memory-safe") {

33:                 ++i;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

5: import {IUniswapV3Factory} from "univ3-core/interfaces/IUniswapV3Factory.sol";

7: import {Errors} from "@libraries/Errors.sol";

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Constants.sol

12:     int24 internal constant MIN_V3POOL_TICK = -887272;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Constants.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

5: import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";

7: import {Math} from "@libraries/Math.sol";

8: import {PanopticMath} from "@libraries/PanopticMath.sol";

10: import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";

11: import {LiquidityChunk} from "@types/LiquidityChunk.sol";

12: import {TokenId} from "@types/TokenId.sol";

69:                         value0 += int256(amount0);

70:                         value1 += int256(amount1);

74:                         value0 -= int256(amount0);

75:                         value1 -= int256(amount1);

80:                     ++leg;

84:                 ++k;

166:                 feeGrowthInside0X128 = lowerOut0 - upperOut0; // fee growth inside the chunk

167:                 feeGrowthInside1X128 = lowerOut1 - upperOut1;

183:                 feeGrowthInside0X128 = upperOut0 - lowerOut0;

184:                 feeGrowthInside1X128 = upperOut1 - lowerOut1;

204:                 feeGrowthInside0X128 = univ3pool.feeGrowthGlobal0X128() - lowerOut0 - upperOut0;

205:                 feeGrowthInside1X128 = univ3pool.feeGrowthGlobal1X128() - lowerOut1 - upperOut1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

5: import {CollateralTracker} from "@contracts/CollateralTracker.sol";

6: import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import {IERC20Partial} from "@tokens/interfaces/IERC20Partial.sol";

8: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

10: import {PanopticMath} from "@libraries/PanopticMath.sol";

66:                     "/",

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/Math.sol

5: import {Errors} from "@libraries/Errors.sol";

6: import {Constants} from "@libraries/Constants.sol";

8: import {LiquidityChunk, LiquidityChunkLibrary} from "@types/LiquidityChunk.sol";

15:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

74:         return x > 0 ? x : -x;

83:             return x > 0 ? uint256(x) : uint256(-x);

95:                 r += 32;

99:                 r += 16;

103:                 r += 8;

107:                 r += 4;

111:                 r += 2;

114:                 r += 1;

130:             uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));

137:             if (absTick & 0x2 != 0) sqrtR = (sqrtR * 0xfff97272373d413259a46990580e213a) >> 128;

139:             if (absTick & 0x4 != 0) sqrtR = (sqrtR * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

141:             if (absTick & 0x8 != 0) sqrtR = (sqrtR * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

143:             if (absTick & 0x10 != 0) sqrtR = (sqrtR * 0xffcb9843d60f6159c9db58835c926644) >> 128;

145:             if (absTick & 0x20 != 0) sqrtR = (sqrtR * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

147:             if (absTick & 0x40 != 0) sqrtR = (sqrtR * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

149:             if (absTick & 0x80 != 0) sqrtR = (sqrtR * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

151:             if (absTick & 0x100 != 0) sqrtR = (sqrtR * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

153:             if (absTick & 0x200 != 0) sqrtR = (sqrtR * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

155:             if (absTick & 0x400 != 0) sqrtR = (sqrtR * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

157:             if (absTick & 0x800 != 0) sqrtR = (sqrtR * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

159:             if (absTick & 0x1000 != 0) sqrtR = (sqrtR * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

161:             if (absTick & 0x2000 != 0) sqrtR = (sqrtR * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

163:             if (absTick & 0x4000 != 0) sqrtR = (sqrtR * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

165:             if (absTick & 0x8000 != 0) sqrtR = (sqrtR * 0x31be135f97d08fd981231505542fcfa6) >> 128;

167:             if (absTick & 0x10000 != 0) sqrtR = (sqrtR * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

169:             if (absTick & 0x20000 != 0) sqrtR = (sqrtR * 0x5d6af8dedb81196699c329225ee604) >> 128;

171:             if (absTick & 0x40000 != 0) sqrtR = (sqrtR * 0x2216e584f5fa1ea926041bedfe98) >> 128;

173:             if (absTick & 0x80000 != 0) sqrtR = (sqrtR * 0x48a170391f7dc42444e8fa2) >> 128;

176:             if (tick > 0) sqrtR = type(uint256).max / sqrtR;

179:             return uint160((sqrtR >> 32) + (sqrtR % (1 << 32) == 0 ? 0 : 1));

184:                     LIQUIDITY AMOUNTS (STRIKE+WIDTH)

198:                     highPriceX96 - lowPriceX96,

200:                 ) / lowPriceX96;

212:             return mulDiv96(liquidityChunk.liquidity(), highPriceX96 - lowPriceX96);

258:                             highPriceX96 - lowPriceX96

284:                     toUint128(mulDiv(amount1, Constants.FP96, highPriceX96 - lowPriceX96))

351:             uint256 prod0; // Least significant 256 bits of the product

352:             uint256 prod1; // Most significant 256 bits of the product

353:             assembly ("memory-safe") {

362:                 assembly ("memory-safe") {

379:             assembly ("memory-safe") {

383:             assembly ("memory-safe") {

391:             uint256 twos = (0 - denominator) & denominator;

393:             assembly ("memory-safe") {

398:             assembly ("memory-safe") {

404:             assembly ("memory-safe") {

407:             prod0 |= prod1 * twos;

414:             uint256 inv = (3 * denominator) ^ 2;

418:             inv *= 2 - denominator * inv; // inverse mod 2**8

419:             inv *= 2 - denominator * inv; // inverse mod 2**16

420:             inv *= 2 - denominator * inv; // inverse mod 2**32

421:             inv *= 2 - denominator * inv; // inverse mod 2**64

422:             inv *= 2 - denominator * inv; // inverse mod 2**128

423:             inv *= 2 - denominator * inv; // inverse mod 2**256

431:             result = prod0 * inv;

449:                 result++;

465:             uint256 prod0; // Least significant 256 bits of the product

466:             uint256 prod1; // Most significant 256 bits of the product

467:             assembly ("memory-safe") {

476:                 assembly ("memory-safe") {

484:             require(2 ** 64 > prod1);

493:             assembly ("memory-safe") {

497:             assembly ("memory-safe") {

503:             assembly ("memory-safe") {

511:             prod0 |= prod1 * 2 ** 192;

528:             uint256 prod0; // Least significant 256 bits of the product

529:             uint256 prod1; // Most significant 256 bits of the product

530:             assembly ("memory-safe") {

539:                 assembly ("memory-safe") {

547:             require(2 ** 96 > prod1);

556:             assembly ("memory-safe") {

560:             assembly ("memory-safe") {

566:             assembly ("memory-safe") {

574:             prod0 |= prod1 * 2 ** 160;

587:             if (mulmod(a, b, 2 ** 96) > 0) {

589:                 result++;

605:             uint256 prod0; // Least significant 256 bits of the product

606:             uint256 prod1; // Most significant 256 bits of the product

607:             assembly ("memory-safe") {

616:                 assembly ("memory-safe") {

624:             require(2 ** 128 > prod1);

633:             assembly ("memory-safe") {

637:             assembly ("memory-safe") {

643:             assembly ("memory-safe") {

651:             prod0 |= prod1 * 2 ** 128;

664:             if (mulmod(a, b, 2 ** 128) > 0) {

666:                 result++;

682:             uint256 prod0; // Least significant 256 bits of the product

683:             uint256 prod1; // Most significant 256 bits of the product

684:             assembly ("memory-safe") {

693:                 assembly ("memory-safe") {

701:             require(2 ** 192 > prod1);

710:             assembly ("memory-safe") {

714:             assembly ("memory-safe") {

720:             assembly ("memory-safe") {

728:             prod0 |= prod1 * 2 ** 64;

739:         assembly ("memory-safe") {

758:             int256 pivot = arr[uint256(left + (right - left) / 2)];

760:                 while (arr[uint256(i)] < pivot) i++;

761:                 while (pivot < arr[uint256(j)]) j--;

764:                     i++;

765:                     j--;

778:             quickSort(data, int256(0), int256(data.length - 1));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

5: import {CollateralTracker} from "@contracts/CollateralTracker.sol";

6: import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

7: import {IUniswapV3Pool} from "univ3-core/interfaces/IUniswapV3Pool.sol";

9: import {Constants} from "@libraries/Constants.sol";

10: import {Errors} from "@libraries/Errors.sol";

11: import {Math} from "@libraries/Math.sol";

13: import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

15: import {LeftRightUnsigned, LeftRightSigned} from "@types/LeftRight.sol";

16: import {LiquidityChunk} from "@types/LiquidityChunk.sol";

17: import {TokenId} from "@types/TokenId.sol";

25:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

53:             poolId += uint64(uint24(tickSpacing)) << 48;

63:             return (poolId & TICKSPACING_MASK) + (uint48(poolId) + 1);

78:             return addr == address(0) ? 40 : 39 - Math.mostSignificantNibble(uint160(addr));

102:                 Strings.toString(fee / 100),

107:                         Strings.toString((fee / 10) % 10),

139:             ? uint8(existingHash >> 248) + 1

140:             : uint8(existingHash >> 248) - 1;

143:             return uint256(updatedHash) + (newPositionCount << 248);

168:             int256[] memory tickCumulatives = new int256[](cardinality + 1);

170:             uint256[] memory timestamps = new uint256[](cardinality + 1);

172:             for (uint256 i = 0; i < cardinality + 1; ++i) {

175:                         (int256(observationIndex) - int256(i * period)) +

183:             for (uint256 i = 0; i < cardinality; ++i) {

185:                     (tickCumulatives[i] - tickCumulatives[i + 1]) /

186:                     int256(timestamps[i] - timestamps[i + 1]);

190:             return int24(Math.sort(ticks)[cardinality / 2]);

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

218:             if (block.timestamp >= uint256(uint40(medianData >> 216)) + period) {

223:                             int256(observationIndex) - int256(1) + int256(observationCardinality)

230:                         (tickCumulative_last - tickCumulative_old) /

231:                             int256(timestamp_last - timestamp_old)

242:                 for (uint8 i; i < 8; ++i) {

244:                     rank = (orderMap >> (3 * i)) % 8;

247:                         shift -= 1;

252:                     entry = int24(uint24(medianData >> (rank * 24)));

254:                         shift += 1;

258:                     newOrderMap = newOrderMap + ((rank + 1) << (3 * (i + shift - 1)));

262:                     (block.timestamp << 216) +

263:                     (uint256(newOrderMap) << 192) +

264:                     uint256(uint192(medianData << 24)) +

283:             for (uint256 i = 0; i < 20; ++i) {

284:                 secondsAgos[i] = uint32(((i + 1) * twapWindow) / 20);

291:             for (uint256 i = 0; i < 19; ++i) {

293:                     (tickCumulatives[i] - tickCumulatives[i + 1]) / int56(uint56(twapWindow / 20))

359:         uint256 amount = uint256(positionSize) * tokenId.optionRatio(legIndex);

381:             int24 minTick = (Constants.MIN_V3POOL_TICK / tickSpacing) * tickSpacing;

382:             int24 maxTick = (Constants.MAX_V3POOL_TICK / tickSpacing) * tickSpacing;

386:             (tickLower, tickUpper) = (strike - rangeDown, strike + rangeUp);

411:             (width * tickSpacing) / 2,

412:             int24(int256(Math.unsafeDivRoundingUp(uint24(width) * uint24(tickSpacing), 2)))

442:                 ++leg;

462:                 tokenData0.rightSlot() + convert1to0(tokenData1.rightSlot(), sqrtPriceX96),

463:                 tokenData0.leftSlot() + convert1to0(tokenData1.leftSlot(), sqrtPriceX96)

467:                 tokenData1.rightSlot() + convert0to1(tokenData0.rightSlot(), sqrtPriceX96),

468:                 tokenData1.leftSlot() + convert0to1(tokenData0.leftSlot(), sqrtPriceX96)

500:                 return Math.mulDiv192(amount, uint256(sqrtPriceX96) ** 2);

517:                 return Math.mulDiv(amount, 2 ** 192, uint256(sqrtPriceX96) ** 2);

519:                 return Math.mulDiv(amount, 2 ** 128, Math.mulDiv64(sqrtPriceX96, sqrtPriceX96));

535:                     .mulDiv192(Math.absUint(amount), uint256(sqrtPriceX96) ** 2)

537:                 return amount < 0 ? -absResult : absResult;

542:                 return amount < 0 ? -absResult : absResult;

558:                     .mulDiv(Math.absUint(amount), 2 ** 192, uint256(sqrtPriceX96) ** 2)

560:                 return amount < 0 ? -absResult : absResult;

565:                         2 ** 128,

569:                 return amount < 0 ? -absResult : absResult;

590:             amount0 = positionSize * uint128(tokenId.optionRatio(legIndex));

596:             amount1 = positionSize * uint128(tokenId.optionRatio(legIndex));

643:                        REVOKE/REFUND COMPUTATIONS

675:                 uint256 requiredRatioX128 = Math.mulDiv(required0, 2 ** 128, required0 + required1);

684:                 uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);

691:                         Math.mulDiv128(bonusCross, 2 ** 128 - requiredRatioX128),

699:             int256 balance0 = int256(uint256(tokenData0.rightSlot())) -

701:             int256 balance1 = int256(uint256(tokenData1.rightSlot())) -

704:             int256 paid0 = bonus0 + int256(netExchanged.rightSlot());

705:             int256 paid1 = bonus1 + int256(netExchanged.leftSlot());

721:                     bonus1 += Math.min(

722:                         balance1 - paid1,

723:                         PanopticMath.convert0to1(paid0 - balance0, sqrtPriceX96Final)

725:                     bonus0 -= Math.min(

726:                         PanopticMath.convert1to0(balance1 - paid1, sqrtPriceX96Final),

727:                         paid0 - balance0

739:                     bonus0 += Math.min(

740:                         balance0 - paid0,

741:                         PanopticMath.convert1to0(paid1 - balance1, sqrtPriceX96Final)

743:                     bonus1 -= Math.min(

744:                         PanopticMath.convert0to1(balance0 - paid0, sqrtPriceX96Final),

745:                         paid1 - balance1

750:             paid0 = bonus0 + int256(netExchanged.rightSlot());

751:             paid1 = bonus1 + int256(netExchanged.leftSlot());

755:                 LeftRightSigned.wrap(0).toRightSlot(int128(balance0 - paid0)).toLeftSlot(

756:                     int128(balance1 - paid1)

787:             for (uint256 i = 0; i < positionIdList.length; ++i) {

790:                 for (uint256 leg = 0; leg < numLegs; ++leg) {

797:             int256 collateralDelta0 = -Math.min(collateralRemaining.rightSlot(), 0);

798:             int256 collateralDelta1 = -Math.min(collateralRemaining.leftSlot(), 0);

810:                     -Math.min(

811:                         collateralDelta0 - longPremium.rightSlot(),

813:                             longPremium.leftSlot() - collateralDelta1,

818:                         longPremium.leftSlot() - collateralDelta1,

820:                             collateralDelta0 - longPremium.rightSlot(),

827:                 haircut1 = protocolLoss1 + collateralDelta1;

835:                         longPremium.rightSlot() - collateralDelta0,

837:                             collateralDelta1 - longPremium.leftSlot(),

841:                     -Math.min(

842:                         collateralDelta1 - longPremium.leftSlot(),

844:                             longPremium.rightSlot() - collateralDelta0,

850:                 haircut0 = collateralDelta0 + protocolLoss0;

867:             for (uint256 i = 0; i < positionIdList.length; i++) {

870:                 for (uint256 leg = 0; leg < tokenId.countLegs(); ++leg) {

877:                             uint128(-_premiasByLeg[i][leg].rightSlot()) * uint256(haircut0),

881:                             uint128(-_premiasByLeg[i][leg].leftSlot()) * uint256(haircut1),

897:                             uint128(-_premiasByLeg[i][leg].rightSlot()) - settled0

901:                             uint128(-_premiasByLeg[i][leg].leftSlot()) - settled1

935:             int256 balanceShortage = refundValues.rightSlot() -

942:                         .toRightSlot(int128(refundValues.rightSlot() - balanceShortage))

947:                                 ) + refundValues.leftSlot()

953:                 refundValues.leftSlot() -

960:                         .toLeftSlot(int128(refundValues.leftSlot() - balanceShortage))

965:                                 ) + refundValues.rightSlot()

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

5: import {Errors} from "@libraries/Errors.sol";

24:         assembly ("memory-safe") {

30:             mstore(add(4, p), from) // Append the "from" argument.

31:             mstore(add(36, p), to) // Append the "to" argument.

32:             mstore(add(68, p), amount) // Append the "amount" argument.

55:         assembly ("memory-safe") {

61:             mstore(add(4, p), to) // Append the "to" argument.

62:             mstore(add(36, p), amount) // Append the "amount" argument.

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

5: import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

103:         balanceOf[from][id] -= amount;

107:             balanceOf[to][id] += amount;

147:             balanceOf[from][id] -= amount;

151:                 balanceOf[to][id] += amount;

157:                 ++i;

187:             for (uint256 i = 0; i < owners.length; ++i) {

202:             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165

203:             interfaceId == 0xd9b67a26; // ERC165 Interface ID for ERC1155

207:                         INTERNAL MINT/BURN LOGIC

217:             balanceOf[to][id] += amount;

237:         balanceOf[from][id] -= amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

62:         balanceOf[msg.sender] -= amount;

67:             balanceOf[to] += amount;

82:         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

84:         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

86:         balanceOf[from] -= amount;

91:             balanceOf[to] += amount;

104:         balanceOf[from] -= amount;

109:             balanceOf[to] += amount;

116:                         INTERNAL MINT/BURN LOGIC

126:             balanceOf[to] += amount;

128:         totalSupply += amount;

137:         balanceOf[from] -= amount;

142:             totalSupply -= amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

```solidity
File: contracts/types/LeftRight.sol

5: import {Errors} from "@libraries/Errors.sol";

6: import {Math} from "@libraries/Math.sol";

67:                     (LeftRightUnsigned.unwrap(self) & LEFT_HALF_BIT_MASK) +

68:                         uint256(uint128(LeftRightUnsigned.unwrap(self)) + right)

87:                     (LeftRightSigned.unwrap(self) & LEFT_HALF_BIT_MASK_INT) +

88:                         (int256(int128(LeftRightSigned.unwrap(self)) + right) & RIGHT_HALF_BIT_MASK)

125:             return LeftRightUnsigned.wrap(LeftRightUnsigned.unwrap(self) + (uint256(left) << 128));

135:             return LeftRightSigned.wrap(LeftRightSigned.unwrap(self) + (int256(left) << 128));

154:             z = LeftRightUnsigned.wrap(LeftRightUnsigned.unwrap(x) + LeftRightUnsigned.unwrap(y));

177:             z = LeftRightUnsigned.wrap(LeftRightUnsigned.unwrap(x) - LeftRightUnsigned.unwrap(y));

195:             int256 left = int256(uint256(x.leftSlot())) + y.leftSlot();

200:             int256 right = int256(uint256(x.rightSlot())) + y.rightSlot();

215:             int256 left256 = int256(x.leftSlot()) + y.leftSlot();

218:             int256 right256 = int256(x.rightSlot()) + y.rightSlot();

233:             int256 left256 = int256(x.leftSlot()) - y.leftSlot();

236:             int256 right256 = int256(x.rightSlot()) - y.rightSlot();

255:             int256 left256 = int256(x.leftSlot()) - y.leftSlot();

258:             int256 right256 = int256(x.rightSlot()) - y.rightSlot();

284:         uint128 z_xR = (uint256(x.rightSlot()) + dx.rightSlot()).toUint128Capped();

285:         uint128 z_xL = (uint256(x.leftSlot()) + dx.leftSlot()).toUint128Capped();

286:         uint128 z_yR = (uint256(y.rightSlot()) + dy.rightSlot()).toUint128Capped();

287:         uint128 z_yL = (uint256(y.leftSlot()) + dy.leftSlot()).toUint128Capped();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

5: import {TokenId} from "@types/TokenId.sol";

78:                     (uint256(uint24(_tickLower)) << 232) +

79:                         (uint256(uint24(_tickUpper)) << 208) +

94:             return LiquidityChunk.wrap(LiquidityChunk.unwrap(self) + amount);

109:                     LiquidityChunk.unwrap(self) + (uint256(uint24(_tickLower)) << 232)

126:                     LiquidityChunk.unwrap(self) + ((uint256(uint24(_tickUpper))) << 208)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

5: import {Constants} from "@libraries/Constants.sol";

6: import {Errors} from "@libraries/Errors.sol";

7: import {PanopticMath} from "@libraries/PanopticMath.sol";

98:             return int24(uint24((TokenId.unwrap(self) >> 48) % 2 ** 16));

110:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48)) % 2);

120:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 1)) % 128);

130:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 8)) % 2);

140:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 9)) % 2);

150:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 10)) % 4);

160:             return int24(int256(TokenId.unwrap(self) >> (64 + legIndex * 48 + 12)));

171:             return int24(int256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 36)) % 4096));

172:         } // "% 4096" = take last (2 ** 12 = 4096) 12 bits

185:             return TokenId.wrap(TokenId.unwrap(self) + _poolId);

195:             return TokenId.wrap(TokenId.unwrap(self) + (uint256(uint24(_tickSpacing)) << 48));

212:                 TokenId.wrap(TokenId.unwrap(self) + (uint256(_asset % 2) << (64 + legIndex * 48)));

229:                     TokenId.unwrap(self) + (uint256(_optionRatio % 128) << (64 + legIndex * 48 + 1))

246:             return TokenId.wrap(TokenId.unwrap(self) + ((_isLong % 2) << (64 + legIndex * 48 + 8)));

263:                     TokenId.unwrap(self) + (uint256(_tokenType % 2) << (64 + legIndex * 48 + 9))

281:                     TokenId.unwrap(self) + (uint256(_riskPartner % 4) << (64 + legIndex * 48 + 10))

299:                     TokenId.unwrap(self) +

300:                         uint256((int256(_strike) & BITMASK_INT24) << (64 + legIndex * 48 + 12))

319:                     TokenId.unwrap(self) +

320:                         (uint256(uint24(_width) % 4096) << (64 + legIndex * 48 + 36))

376:             if (optionRatios < 2 ** 64) {

378:             } else if (optionRatios < 2 ** 112) {

380:             } else if (optionRatios < 2 ** 160) {

382:             } else if (optionRatios < 2 ** 208) {

395:                         ((LONG_MASK >> (48 * (4 - optionRatios))) & CLEAR_POOLID_MASK)

406:             return self.isLong(0) + self.isLong(1) + self.isLong(2) + self.isLong(3);

439:         if (optionRatios < 2 ** 64) {

441:         } else if (optionRatios < 2 ** 112) {

443:         } else if (optionRatios < 2 ** 160) {

445:         } else if (optionRatios < 2 ** 208) {

507:             for (uint256 i = 0; i < 4; ++i) {

512:                     if ((TokenId.unwrap(self) >> (64 + 48 * i)) != 0)

515:                     break; // we are done iterating over potential legs

520:                 for (uint256 j = i + 1; j < numLegs; ++j) {

521:                     if (uint48(chunkData >> (48 * i)) == uint48(chunkData >> (48 * j))) {

569:             } // end for loop over legs

581:             for (uint256 i = 0; i < numLegs; ++i) {

589:                 if ((currentTick >= _strike + rangeUp) || (currentTick < _strike - rangeDown)) {

592:                     if (self.isLong(i) == 1) return; // validated

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="GAS-8"></a>[GAS-8] Avoid contract existence checks by using low level calls

Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (5)*:

```solidity
File: contracts/PanopticPool.sol

333:             ct0.convertToAssets(ct0.balanceOf(msg.sender)) < minValue0 ||

334:             ct1.convertToAssets(ct1.balanceOf(msg.sender)) < minValue1

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/Multicall.sol

15:             (bool success, bytes memory result) = address(this).delegatecall(data[i]);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

936:                 int256(collateral0.convertToAssets(collateral0.balanceOf(refunder)));

954:                 int256(collateral1.convertToAssets(collateral1.balanceOf(refunder)));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-9"></a>[GAS-9] Stack variable used as a cheaper cache for a state variable is only used once

If the variable is only accessed once, it's cheaper to use the state variable directly that one time, and save the **3 gas** the extra stack assignment would spend

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

492:         uint256 available = s_poolAssets;

1266:                 if (tokenId.tokenType(index) != (underlyingIsToken0 ? 0 : 1)) continue;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="GAS-10"></a>[GAS-10] State variables only set in the constructor should be declared `immutable`

Variables only set in the constructor and never edited afterwards should be marked as immutable, as it would avoid the expensive storage-writing operation in the constructor (around **20 000 gas** per variable) and replace the expensive storage-reading operations (around **2100 gas** per reading) to a less expensive value reading (**3 gas**)

*Instances (14)*:

```solidity
File: contracts/CollateralTracker.sol

193:         COMMISSION_FEE = _commissionFee;

194:         SELLER_COLLATERAL_RATIO = _sellerCollateralRatio;

195:         BUYER_COLLATERAL_RATIO = _buyerCollateralRatio;

196:         FORCE_EXERCISE_COST = _forceExerciseCost;

197:         TARGET_POOL_UTIL = _targetPoolUtilization;

198:         SATURATED_POOL_UTIL = _saturatedPoolUtilization;

199:         ITM_SPREAD_MULTIPLIER = _ITMSpreadMultiplier;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

115:         WETH = _WETH9;

116:         SFPM = _SFPM;

117:         UNIV3_FACTORY = _univ3Factory;

118:         POOL_REFERENCE = _poolReference;

119:         COLLATERAL_REFERENCE = _collateralReference;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

273:         SFPM = _sfpm;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

359:         // return if the pool has already been initialized in SFPM

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

### <a name="GAS-11"></a>[GAS-11] Functions guaranteed to revert when called by normal users can be marked `payable`

If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (3)*:

```solidity
File: contracts/CollateralTracker.sol

913:     function delegate(address delegatee, uint256 assets) external onlyPanopticPool {

922:     function refund(address delegatee, uint256 assets) external onlyPanopticPool {

994:     function refund(address refunder, address refundee, int256 assets) external onlyPanopticPool {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="GAS-12"></a>[GAS-12] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)

Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (33)*:

```solidity
File: contracts/CollateralTracker.sol

783:                    100% - |                _------

786:                     20% - |---------¯

788:                           +---------+-------+-+--->   POOL_

846:            10% - |----------__       min_ratio = 5%

847:            5%  - | . . . . .  ¯¯¯--______

849:                  +---------+-------+-+--->   POOL_

1393:                            100% + SCR% - |--__           .    .    .

1394:                                   100% - | . .¯¯--__     .    .    .

1395:                                          |    .     ¯¯--__    .    .

1396:                                    SCR - |    .          .¯¯--__________

1398:                                          +----+----------+----+----+--->   current

1626:                   100% - |--__                .

1627:                          |    ¯¯--__          .

1628:                          |          ¯¯--__    .

1629:                  SCR/2 - |                ¯¯--______ <------ base collateral is half that of a single-leg

1630:                          +--------------------+--->   current

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

261:         However, since we require that Eqn 2 holds up-- ie. the gross fees collected should be equal

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

132:             "<!-- LABEL -->",

141:                 "<!-- TEXT -->",

145:             .replace("<!-- ART -->", metadata[bytes32("art")][lastCharVal].decompressedDataStr())

146:             .replace("<!-- FILTER -->", metadata[bytes32("filters")][rarity].decompressedDataStr());

164:             .replace("<!-- POOLADDRESS -->", LibString.toHexString(uint160(panopticPool), 20))

165:             .replace("<!-- CHAINID -->", getChainName());

168:             "<!-- RARITY_NAME -->",

174:                 .replace("<!-- RARITY -->", write(LibString.toString(rarity)))

175:                 .replace("<!-- SYMBOL0 -->", write(symbol0, maxSymbolWidth(rarity)))

176:                 .replace("<!-- SYMBOL1 -->", write(symbol1, maxSymbolWidth(rarity)));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Math.sol

449:                 result++;

589:                 result++;

666:                 result++;

764:                     i++;

765:                     j--;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

867:             for (uint256 i = 0; i < positionIdList.length; i++) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-13"></a>[GAS-13] Use shift right/left instead of division/multiplication if possible

While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`

- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:

- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (29)*:

```solidity
File: contracts/CollateralTracker.sol

862:                 return BUYER_COLLATERAL_RATIO / 2;

870:                     (SATURATED_POOL_UTIL - TARGET_POOL_UTIL)) / 2; // do the division by 2 at the end after all addition and multiplication; b/c y1 = buyCollateralRatio / 2

1620:                     Put side of a short strangle, BPR = 100% - (100% - SCR/2)*(price/strike)

1629:                  SCR/2 - |                ¯¯--______ <------ base collateral is half that of a single-leg

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

1453:             effectiveLiquidityFactorX32 = (uint256(removedLiquidity) * 2 ** 32) / netLiquidity;

1517:                                         (liquidityChunk.liquidity())) / 2 ** 64

1526:                                         (liquidityChunk.liquidity())) / 2 ** 64

1600:                 .toRightSlot(int128(int256((accumulatedPremium.rightSlot() * liquidity) / 2 ** 64)))

1601:                 .toLeftSlot(int128(int256((accumulatedPremium.leftSlot() * liquidity) / 2 ** 64)));

1733:                 totalLiquidity) / 2 ** 64;

1735:                 totalLiquidity) / 2 ** 64;

1904:                                                 )) + int256(legPremia.rightSlot() * 2 ** 64),

1920:                                                 )) + int256(legPremia.leftSlot()) * 2 ** 64,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

220:         For an arbitrary parameter 0 <= ν <= 1 (ν = 1/2^VEGOID). This way, the gross_feesCollectedX128 will be given by: 

1343:                     totalLiquidity * 2 ** 64,

1348:                     totalLiquidity * 2 ** 64,

1358:                     uint256 numerator = netLiquidity + (removedLiquidity / 2 ** VEGOID);

1382:                         ((removedLiquidity ** 2) / 2 ** (VEGOID));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

142:                 metadata[bytes32("descriptions")][lastCharVal + 16 * (rarity / 8)]

257:             LibString.toString(offset / 2),

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Math.sol

511:             prod0 |= prod1 * 2 ** 192;

574:             prod0 |= prod1 * 2 ** 160;

651:             prod0 |= prod1 * 2 ** 128;

728:             prod0 |= prod1 * 2 ** 64;

758:             int256 pivot = arr[uint256(left + (right - left) / 2)];

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

190:             return int24(Math.sort(ticks)[cardinality / 2]);

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

411:             (width * tickSpacing) / 2,

684:                 uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-14"></a>[GAS-14] Increments/decrements can be unchecked in for-loops

In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (17)*:

```solidity
File: contracts/CollateralTracker.sol

691:             for (uint256 leg = 0; leg < positionId.countLegs(); ++leg) {

1264:             for (uint256 index = 0; index < numLegs; ++index) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

1636:         for (uint256 leg = 0; leg < numLegs; ++leg) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/FactoryNFT.sol

223:         for (uint256 i = 0; i < bytes(chars).length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

172:             for (uint256 i = 0; i < cardinality + 1; ++i) {

183:             for (uint256 i = 0; i < cardinality; ++i) {

242:                 for (uint8 i; i < 8; ++i) {

283:             for (uint256 i = 0; i < 20; ++i) {

291:             for (uint256 i = 0; i < 19; ++i) {

787:             for (uint256 i = 0; i < positionIdList.length; ++i) {

790:                 for (uint256 leg = 0; leg < numLegs; ++leg) {

867:             for (uint256 i = 0; i < positionIdList.length; i++) {

870:                 for (uint256 leg = 0; leg < tokenId.countLegs(); ++leg) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

187:             for (uint256 i = 0; i < owners.length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/types/TokenId.sol

507:             for (uint256 i = 0; i < 4; ++i) {

520:                 for (uint256 j = i + 1; j < numLegs; ++j) {

581:             for (uint256 i = 0; i < numLegs; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="GAS-15"></a>[GAS-15] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (27)*:

```solidity
File: contracts/CollateralTracker.sol

995:         if (assets > 0) {

1029:             if (tokenToPay > 0) {

1076:             if (tokenToPay > 0) {

1177:         if (positionBalanceArray.length > 0) {

1191:         if (premiumAllPositions > 0) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

140:         if (amount0Owed > 0)

147:         if (amount1Owed > 0)

180:         (token0, token1) = token0 < token1 ? (token0, token1) : (token1, token0);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

1241:         if (positionIdListExercisor.length > 0)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

220:         For an arbitrary parameter 0 <= ν <= 1 (ν = 1/2^VEGOID). This way, the gross_feesCollectedX128 will be given by: 

414:         if (amount0Owed > 0)

421:         if (amount1Owed > 0)

448:         address token = amount0Delta > 0

455:         uint256 amountToPay = amount0Delta > 0 ? uint256(amount0Delta) : uint256(amount1Delta);

818:                 zeroForOne = net0 < 0;

823:                 zeroForOne = itm0 < 0;

826:                 zeroForOne = itm1 > 0;

1079:         if (currentLiquidity.rightSlot() > 0) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/Math.sol

74:         return x > 0 ? x : -x;

83:             return x > 0 ? uint256(x) : uint256(-x);

176:             if (tick > 0) sqrtR = type(uint256).max / sqrtR;

361:                 require(denominator > 0);

447:             if (mulmod(a, b, denominator) > 0) {

587:             if (mulmod(a, b, 2 ** 96) > 0) {

664:             if (mulmod(a, b, 2 ** 128) > 0) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

938:             if (balanceShortage > 0) {

956:             if (balanceShortage > 0) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="GAS-16"></a>[GAS-16] `internal` functions not called by the contract should be removed

If the functions are required by an interface, the contract should inherit from that interface and use the `override` keyword

*Instances (82)*:

```solidity
File: contracts/libraries/CallbackLib.sol

30:     function validateCallback(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Math.sol

25:     function min24(int24 a, int24 b) internal pure returns (int24) {

33:     function max24(int24 a, int24 b) internal pure returns (int24) {

41:     function min(uint256 a, uint256 b) internal pure returns (uint256) {

49:     function min(int256 a, int256 b) internal pure returns (int256) {

57:     function max(uint256 a, uint256 b) internal pure returns (uint256) {

65:     function max(int256 a, int256 b) internal pure returns (int256) {

73:     function abs(int256 x) internal pure returns (int256) {

81:     function absUint(int256 x) internal pure returns (uint256) {

91:     function mostSignificantNibble(uint160 x) internal pure returns (uint256 r) {

221:     function getAmountsForLiquidity(

241:     function getLiquidityForAmount0(

271:     function getLiquidityForAmount1(

302:     function toUint128Capped(uint256 toDowncast) internal pure returns (uint128 downcastedInt) {

311:     function toInt128(uint128 toCast) internal pure returns (int128 downcastedInt) {

318:     function toInt128(int256 toCast) internal pure returns (int128 downcastedInt) {

325:     function toInt256(uint256 toCast) internal pure returns (int256) {

440:     function mulDivRoundingUp(

458:     function mulDiv64(uint256 a, uint256 b) internal pure returns (uint256) {

584:     function mulDiv96RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

661:     function mulDiv128RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

675:     function mulDiv192(uint256 a, uint256 b) internal pure returns (uint256) {

738:     function unsafeDivRoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

776:     function sort(int256[] memory data) internal pure returns (int256[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

49:     function getPoolId(address univ3pool) internal view returns (uint64) {

61:     function incrementPoolPattern(uint64 poolId) internal pure returns (uint64) {

99:     function uniswapFeeToString(uint24 fee) internal pure returns (string memory) {

125:     function updatePositionsHash(

327:         uint128 positionSize

377:     ) internal pure returns (int24 tickLower, int24 tickUpper) {

409:     ) internal pure returns (int24, int24) {

428:     ) internal pure returns (LeftRightSigned longAmounts, LeftRightSigned shortAmounts) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

21:     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {

52:     function safeTransfer(address token, address to, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

214:     function _mint(address to, uint256 id, uint256 amount) internal {

236:     function _burn(address from, uint256 id, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

103:     function _transferFrom(address from, address to, uint256 amount) internal {

122:     function _mint(address to, uint256 amount) internal {

136:     function _burn(address from, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

```solidity
File: contracts/types/LeftRight.sol

38:     function rightSlot(LeftRightUnsigned self) internal pure returns (uint128) {

45:     function rightSlot(LeftRightSigned self) internal pure returns (int128) {

58:     function toRightSlot(

77:     function toRightSlot(

100:     function leftSlot(LeftRightUnsigned self) internal pure returns (uint128) {

107:     function leftSlot(LeftRightSigned self) internal pure returns (int128) {

120:     function toLeftSlot(

133:     function toLeftSlot(LeftRightSigned self, int128 left) internal pure returns (LeftRightSigned) {

147:     function add(

170:     function sub(

193:     function add(LeftRightUnsigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

213:     function add(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

231:     function sub(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

250:     function subRect(

278:     function addCapped(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

75:         unchecked {

94:             return LiquidityChunk.wrap(LiquidityChunk.unwrap(self) + amount);

107:             return

123:             // convert tick upper to uint24 as explicit conversion from int24 to uint256 is not allowed

139:         unchecked {

155:         unchecked {

173:             return int24(int256(LiquidityChunk.unwrap(self) >> 232));

182:             return int24(int256(LiquidityChunk.unwrap(self) >> 208));

191:             return uint128(LiquidityChunk.unwrap(self));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

87:     function poolId(TokenId self) internal pure returns (uint64) {

96:     function tickSpacing(TokenId self) internal pure returns (int24) {

108:     function asset(TokenId self, uint256 legIndex) internal pure returns (uint256) {

118:     function optionRatio(TokenId self, uint256 legIndex) internal pure returns (uint256) {

128:     function isLong(TokenId self, uint256 legIndex) internal pure returns (uint256) {

138:     function tokenType(TokenId self, uint256 legIndex) internal pure returns (uint256) {

148:     function riskPartner(TokenId self, uint256 legIndex) internal pure returns (uint256) {

158:     function strike(TokenId self, uint256 legIndex) internal pure returns (int24) {

169:     function width(TokenId self, uint256 legIndex) internal pure returns (int24) {

183:     function addPoolId(TokenId self, uint64 _poolId) internal pure returns (TokenId) {

193:     function addTickSpacing(TokenId self, int24 _tickSpacing) internal pure returns (TokenId) {

336:     function addLeg(

366:     function flipToBurnToken(TokenId self) internal pure returns (TokenId) {

404:     function countLongs(TokenId self) internal pure returns (uint256) {

416:     function asTicks(

432:     function countLegs(TokenId self) internal pure returns (uint256) {

464:     function clearLeg(TokenId self, uint256 i) internal pure returns (TokenId) {

500:     function validate(TokenId self) internal pure {

578:     function validateIsExercisable(TokenId self, int24 currentTick) internal pure {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="GAS-17"></a>[GAS-17] WETH address definition can be use directly

WETH is a wrap Ether contract with a specific address in the Ethereum network, giving the option to define it may cause false recognition, it is healthier to define it directly.

    Advantages of defining a specific contract directly:
    
    It saves gas,
    Prevents incorrect argument definition,
    Prevents execution on a different chain and re-signature issues,
    WETH Address : 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2

*Instances (2)*:

```solidity
File: contracts/PanopticFactory.sol

72:     address internal immutable WETH;

76:     uint256 internal constant FULL_RANGE_LIQUIDITY_AMOUNT_WETH = 0.1 ether;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

## Non Critical Issues

| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Missing checks for `address(0)` when assigning values to address state variables | 5 |
| [NC-2](#NC-2) | Array indices should be referenced via `enum`s rather than via numeric literals | 24 |
| [NC-3](#NC-3) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 17 |
| [NC-4](#NC-4) | `constant`s should be defined rather than using magic numbers | 260 |
| [NC-5](#NC-5) | Control structures do not follow the Solidity Style Guide | 144 |
| [NC-6](#NC-6) | Unused `error` definition | 32 |
| [NC-7](#NC-7) | Events that mark critical parameter changes should contain both the old and the new value | 2 |
| [NC-8](#NC-8) | Function ordering does not follow the Solidity style guide | 5 |
| [NC-9](#NC-9) | Functions should not be longer than 50 lines | 124 |
| [NC-10](#NC-10) | Change int to int256 | 10 |
| [NC-11](#NC-11) | Lack of checks in setters | 2 |
| [NC-12](#NC-12) | Lines are too long | 1 |
| [NC-13](#NC-13) | `type(uint256).max` should be used instead of `2 ** 256 - 1` | 2 |
| [NC-14](#NC-14) | Incomplete NatSpec: `@param` is missing on actually documented functions | 2 |
| [NC-15](#NC-15) | Incomplete NatSpec: `@return` is missing on actually documented functions | 2 |
| [NC-16](#NC-16) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 12 |
| [NC-17](#NC-17) | Constant state variables defined more than once | 2 |
| [NC-18](#NC-18) | Adding a `return` statement when the function defines a named return variable, is redundant | 35 |
| [NC-19](#NC-19) | `require()` / `revert()` statements should have descriptive reason strings | 71 |
| [NC-20](#NC-20) | Take advantage of Custom Error's return value property | 57 |
| [NC-21](#NC-21) | Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`) | 1 |
| [NC-22](#NC-22) | Strings should use double quotes rather than single quotes | 15 |
| [NC-23](#NC-23) | Contract does not follow the Solidity style guide's suggested layout ordering | 6 |
| [NC-24](#NC-24) | Use Underscores for Number Literals (add an underscore every 3 digits) | 23 |
| [NC-25](#NC-25) | Internal and private variables and functions names should begin with an underscore | 138 |
| [NC-26](#NC-26) | Event is missing `indexed` fields | 12 |
| [NC-27](#NC-27) | Constants should be defined rather than using magic numbers | 31 |
| [NC-28](#NC-28) | `public` functions not called by the contract should be declared `external` instead | 8 |
| [NC-29](#NC-29) | Variables need not be initialized to zero | 32 |

### <a name="NC-1"></a>[NC-1] Missing checks for `address(0)` when assigning values to address state variables

*Instances (5)*:

```solidity
File: contracts/CollateralTracker.sol

239:         s_univ3token0 = token0;

240:         s_univ3token1 = token1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

115:         WETH = _WETH9;

118:         POOL_REFERENCE = _poolReference;

119:         COLLATERAL_REFERENCE = _collateralReference;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

### <a name="NC-2"></a>[NC-2] Array indices should be referenced via `enum`s rather than via numeric literals

*Instances (24)*:

```solidity
File: contracts/CollateralTracker.sol

1225:             uint128 poolUtilization = LeftRightUnsigned.wrap(positionBalanceArray[i][1]).leftSlot();

1228:             uint256 _tokenRequired = _getRequiredCollateralAtTickSinglePosition(

1233:             );

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

446:             balances[k][0] = TokenId.unwrap(tokenId);

447:             balances[k][1] = LeftRightUnsigned.unwrap(s_positionBalance[c_user][tokenId]);

454:                     LeftRightUnsigned.wrap(balances[k][1]).rightSlot(),

1160:         uint128 positionBalance = s_positionBalance[account][touchedId[0]].rightSlot();

1165:             .computeExercisedAmounts(touchedId[0], positionBalance);

1186:         touchedId[0].validateIsExercisable(twapTick);

1201:             touchedId[0],

1244:         emit ForcedExercised(msg.sender, account, touchedId[0], exerciseFees);

1496:                 (premiumAccumulatorsByLeg[leg][0], premiumAccumulatorsByLeg[leg][1]) = SFPM

1515:                                     ((premiumAccumulatorsByLeg[leg][0] -

1524:                                     ((premiumAccumulatorsByLeg[leg][1] -

1671:                 (grossCurrent[0], grossCurrent[1]) = SFPM.getAccountPremium(

1693:                                 (grossCurrent[0] *

1701:                                 (grossCurrent[1] *

1732:             uint256 accumulated0 = ((premiumAccumulators[0] - grossPremiumLast.rightSlot()) *

1734:             uint256 accumulated1 = ((premiumAccumulators[1] - grossPremiumLast.leftSlot()) *

1902:                                                     _premiumAccumulatorsByLeg[_leg][0] *

1918:                                                     _premiumAccumulatorsByLeg[_leg][1] *

1928:                             .toRightSlot(uint128(premiumAccumulatorsByLeg[_leg][0]))

1929:                             .toLeftSlot(uint128(premiumAccumulatorsByLeg[_leg][1]));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

301:             return int24(sortedTicks[9]);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="NC-3"></a>[NC-3] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`

Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a`bytes`data mixed in the concatenation)`)

*Instances (17)*:

```solidity
File: contracts/PanopticFactory.sol

194:             abi.encodePacked(

277:                 abi.encodePacked(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

464:                         abi.encodePacked(

1608:                 abi.encodePacked(

1638:                 abi.encodePacked(tokenId.strike(leg), tokenId.width(leg), tokenId.tokenType(leg))

1820:                 abi.encodePacked(tokenId.strike(leg), tokenId.width(leg), tokenId.tokenType(leg))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

611:                 abi.encodePacked(

620:                 abi.encodePacked(

972:             abi.encodePacked(

1142:                     abi.encodePacked(

1422:             keccak256(abi.encodePacked(univ3pool, owner, tokenType, tickLower, tickUpper))

1450:             abi.encodePacked(univ3pool, owner, tokenType, tickLower, tickUpper)

1534:             keccak256(abi.encodePacked(univ3pool, owner, tokenType, tickLower, tickUpper))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

72:                 abi.encodePacked(

76:                             abi.encodePacked(

78:                                 abi.encodePacked(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

886:                             abi.encodePacked(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="NC-4"></a>[NC-4] `constant`s should be defined rather than using magic numbers

Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (260)*:

```solidity
File: contracts/CollateralTracker.sol

223:         totalSupply = 10 ** 6;

700:                                 2

782:                           |                  max ratio = 100%

783:                    100% - |                _------

786:                     20% - |---------¯

789:                                    50%    90% 100%     UTILIZATION

797:                 min_sell_ratio /= 2;

845:                  |   buy_ratio = 10%

846:            10% - |----------__       min_ratio = 5%

847:            5%  - | . . . . .  ¯¯¯--______

850:                           50%    90% 100%      UTILIZATION

862:                 return BUYER_COLLATERAL_RATIO / 2;

870:                     (SATURATED_POOL_UTIL - TARGET_POOL_UTIL)) / 2; // do the division by 2 at the end after all addition and multiplication; b/c y1 = buyCollateralRatio / 2

1120:                     DECIMALS * 100

1337:             : int64(uint64(poolUtilization >> 64));

1385:                                     Short put BPR = 100% - (price/strike) + SCR

1393:                            100% + SCR% - |--__           .    .    .

1394:                                   100% - | . .¯¯--__     .    .    .

1592:                     : int64(uint64(poolUtilization >> 64))

1620:                     Put side of a short strangle, BPR = 100% - (100% - SCR/2)*(price/strike)

1626:                   100% - |--__                .

1638:             uint64 poolUtilization1 = uint64(poolUtilization >> 64);

1644:                 (uint128(uint64(-int64(poolUtilization1 == 0 ? 1 : poolUtilization1))) << 64);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

195:                 uint80(uint160(msg.sender) >> 80),

196:                 uint80(uint160(address(v3Pool)) >> 80),

278:                     uint80(uint160(deployerAddress) >> 80),

279:                     uint80(uint160(v3Pool) >> 80),

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

301:                 (uint256(block.timestamp) << 216) +

305:                 (uint256(uint24(currentTick)) << 24) + // add to slot 4

375:         poolUtilization1 = uint64(balanceData.leftSlot() >> 64);

698:             return uint128(uint256(utilization0) + uint128(uint256(utilization1) << 64));

1297:             return balanceCross >= Math.unsafeDivRoundingUp(thresholdCross * buffer, 10_000);

1316:                 Math.mulDiv(uint256(tokenData1.rightSlot()), 2 ** 96, sqrtPriceX96) +

1321:                 Math.mulDivRoundingUp(uint256(tokenData1.leftSlot()), 2 ** 96, sqrtPriceX96) +

1381:         if ((newHash >> 248) > MAX_POSITIONS) revert Errors.TooManyPositionsOpen();

1411:         _numberOfPositions = (s_positionsHash[user] >> 248);

1453:             effectiveLiquidityFactorX32 = (uint256(removedLiquidity) * 2 ** 32) / netLiquidity;

1517:                                         (liquidityChunk.liquidity())) / 2 ** 64

1526:                                         (liquidityChunk.liquidity())) / 2 ** 64

1561:         if (tokenId.isLong(legIndex) == 0 || legIndex > 3) revert Errors.NotALongLeg();

1600:                 .toRightSlot(int128(int256((accumulatedPremium.rightSlot() * liquidity) / 2 ** 64)))

1601:                 .toLeftSlot(int128(int256((accumulatedPremium.leftSlot() * liquidity) / 2 ** 64)));

1733:                 totalLiquidity) / 2 ** 64;

1735:                 totalLiquidity) / 2 ** 64;

1904:                                                 )) + int256(legPremia.rightSlot() * 2 ** 64),

1920:                                                 )) + int256(legPremia.leftSlot()) * 2 ** 64,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

224:                                       = feeGrowthX128 * T * (1 + ν*R^2/(N*T))                (Eqn 2)

245:              s_accountPremiumOwed += feesCollected * T/N^2 * (1 - R/T + ν*R/T)          (Eqn 3)     

261:         However, since we require that Eqn 2 holds up-- ie. the gross fees collected should be equal

265:             s_accountPremiumGross += feesCollected * T/N^2 * (1 - R/T + ν*R^2/T^2)       (Eqn 4) 

274:                                 = ∆feeGrowthX128 * t * (1  + ν*R^2/(N*T))   (same as Eqn 2)

276:         where the last expression matches Eqn 2 exactly.

389:             s_AddrToPoolIdData[univ3pool] = uint256(poolId) + 2 ** 255;

1343:                     totalLiquidity * 2 ** 64,

1344:                     netLiquidity ** 2

1348:                     totalLiquidity * 2 ** 64,

1349:                     netLiquidity ** 2

1358:                     uint256 numerator = netLiquidity + (removedLiquidity / 2 ** VEGOID);

1379:                     uint256 numerator = totalLiquidity ** 2 -

1382:                         ((removedLiquidity ** 2) / 2 ** (VEGOID));

1385:                         .mulDiv(premium0X64_base, numerator, totalLiquidity ** 2)

1388:                         .mulDiv(premium1X64_base, numerator, totalLiquidity ** 2)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

79:                                     LibString.toHexString(uint256(uint160(panopticPool)), 20),

129:             rarity < 18 ? rarity / 3 : rarity < 23 ? 23 - rarity : 0

142:                 metadata[bytes32("descriptions")][lastCharVal + 16 * (rarity / 8)]

164:             .replace("<!-- POOLADDRESS -->", LibString.toHexString(uint160(panopticPool), 20))

184:         } else if (block.chainid == 56) {

186:         } else if (block.chainid == 42161) {

188:         } else if (block.chainid == 8453) {

190:         } else if (block.chainid == 43114) {

192:         } else if (block.chainid == 137) {

194:         } else if (block.chainid == 10) {

196:         } else if (block.chainid == 42220) {

198:         } else if (block.chainid == 238) {

244:             if (_scale > 99) {

257:             LibString.toString(offset / 2),

269:         if (rarity < 3) {

270:             width = 1600;

271:         } else if (rarity < 9) {

272:             width = 1350;

273:         } else if (rarity < 12) {

274:             width = 1450;

275:         } else if (rarity < 15) {

276:             width = 1350;

277:         } else if (rarity < 19) {

278:             width = 1250;

279:         } else if (rarity < 20) {

280:             width = 1350;

281:         } else if (rarity < 21) {

282:             width = 1450;

283:         } else if (rarity < 23) {

284:             width = 1350;

285:         } else if (rarity >= 23) {

286:             width = 1600;

295:         if (rarity < 3) {

296:             width = 210;

297:         } else if (rarity < 6) {

298:             width = 220;

299:         } else if (rarity < 9) {

300:             width = 210;

301:         } else if (rarity < 12) {

302:             width = 220;

303:         } else if (rarity < 15) {

304:             width = 260;

305:         } else if (rarity < 19) {

306:             width = 225;

307:         } else if (rarity < 20) {

308:             width = 260;

309:         } else if (rarity < 21) {

310:             width = 220;

311:         } else if (rarity < 22) {

312:             width = 210;

313:         } else if (rarity < 23) {

314:             width = 220;

315:         } else if (rarity >= 23) {

316:             width = 210;

325:         if (rarity < 6) {

326:             width = 9000;

327:         } else if (rarity <= 22) {

328:             width = 3900;

329:         } else if (rarity > 22) {

330:             width = 9000;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/base/Multicall.sol

26:                     revert(add(result, 32), mload(result))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/Constants.sol

22:         1461446703485210103287273052203988822378723970342;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Constants.sol)

```solidity
File: contracts/libraries/Math.sol

94:                 x >>= 128;

95:                 r += 32;

98:                 x >>= 64;

99:                 r += 16;

102:                 x >>= 32;

103:                 r += 8;

106:                 x >>= 16;

107:                 r += 4;

110:                 x >>= 8;

111:                 r += 2;

137:             if (absTick & 0x2 != 0) sqrtR = (sqrtR * 0xfff97272373d413259a46990580e213a) >> 128;

139:             if (absTick & 0x4 != 0) sqrtR = (sqrtR * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

141:             if (absTick & 0x8 != 0) sqrtR = (sqrtR * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

143:             if (absTick & 0x10 != 0) sqrtR = (sqrtR * 0xffcb9843d60f6159c9db58835c926644) >> 128;

145:             if (absTick & 0x20 != 0) sqrtR = (sqrtR * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

147:             if (absTick & 0x40 != 0) sqrtR = (sqrtR * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

149:             if (absTick & 0x80 != 0) sqrtR = (sqrtR * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

151:             if (absTick & 0x100 != 0) sqrtR = (sqrtR * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

153:             if (absTick & 0x200 != 0) sqrtR = (sqrtR * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

155:             if (absTick & 0x400 != 0) sqrtR = (sqrtR * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

157:             if (absTick & 0x800 != 0) sqrtR = (sqrtR * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

159:             if (absTick & 0x1000 != 0) sqrtR = (sqrtR * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

161:             if (absTick & 0x2000 != 0) sqrtR = (sqrtR * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

163:             if (absTick & 0x4000 != 0) sqrtR = (sqrtR * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

165:             if (absTick & 0x8000 != 0) sqrtR = (sqrtR * 0x31be135f97d08fd981231505542fcfa6) >> 128;

167:             if (absTick & 0x10000 != 0) sqrtR = (sqrtR * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

169:             if (absTick & 0x20000 != 0) sqrtR = (sqrtR * 0x5d6af8dedb81196699c329225ee604) >> 128;

171:             if (absTick & 0x40000 != 0) sqrtR = (sqrtR * 0x2216e584f5fa1ea926041bedfe98) >> 128;

173:             if (absTick & 0x80000 != 0) sqrtR = (sqrtR * 0x48a170391f7dc42444e8fa2) >> 128;

179:             return uint160((sqrtR >> 32) + (sqrtR % (1 << 32) == 0 ? 0 : 1));

197:                     uint256(liquidityChunk.liquidity()) << 96,

414:             uint256 inv = (3 * denominator) ^ 2;

418:             inv *= 2 - denominator * inv; // inverse mod 2**8

419:             inv *= 2 - denominator * inv; // inverse mod 2**16

420:             inv *= 2 - denominator * inv; // inverse mod 2**32

421:             inv *= 2 - denominator * inv; // inverse mod 2**64

422:             inv *= 2 - denominator * inv; // inverse mod 2**128

423:             inv *= 2 - denominator * inv; // inverse mod 2**256

484:             require(2 ** 64 > prod1);

511:             prod0 |= prod1 * 2 ** 192;

547:             require(2 ** 96 > prod1);

574:             prod0 |= prod1 * 2 ** 160;

587:             if (mulmod(a, b, 2 ** 96) > 0) {

624:             require(2 ** 128 > prod1);

651:             prod0 |= prod1 * 2 ** 128;

664:             if (mulmod(a, b, 2 ** 128) > 0) {

701:             require(2 ** 192 > prod1);

728:             prod0 |= prod1 * 2 ** 64;

758:             int256 pivot = arr[uint256(left + (right - left) / 2)];

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

52:             uint64 poolId = uint64(uint160(univ3pool) >> 112);

53:             poolId += uint64(uint24(tickSpacing)) << 48;

78:             return addr == address(0) ? 40 : 39 - Math.mostSignificantNibble(uint160(addr));

102:                 Strings.toString(fee / 100),

103:                 fee % 100 == 0

107:                         Strings.toString((fee / 10) % 10),

108:                         Strings.toString(fee % 10)

139:             ? uint8(existingHash >> 248) + 1

140:             : uint8(existingHash >> 248) - 1;

143:             return uint256(updatedHash) + (newPositionCount << 248);

190:             return int24(Math.sort(ticks)[cardinality / 2]);

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

215:                 2;

218:             if (block.timestamp >= uint256(uint40(medianData >> 216)) + period) {

235:                 uint24 orderMap = uint24(medianData >> 192);

242:                 for (uint8 i; i < 8; ++i) {

244:                     rank = (orderMap >> (3 * i)) % 8;

246:                     if (rank == 7) {

252:                     entry = int24(uint24(medianData >> (rank * 24)));

262:                     (block.timestamp << 216) +

263:                     (uint256(newOrderMap) << 192) +

264:                     uint256(uint192(medianData << 24)) +

283:             for (uint256 i = 0; i < 20; ++i) {

284:                 secondsAgos[i] = uint32(((i + 1) * twapWindow) / 20);

291:             for (uint256 i = 0; i < 19; ++i) {

293:                     (tickCumulatives[i] - tickCumulatives[i + 1]) / int56(uint56(twapWindow / 20))

411:             (width * tickSpacing) / 2,

412:             int24(int256(Math.unsafeDivRoundingUp(uint24(width) * uint24(tickSpacing), 2)))

500:                 return Math.mulDiv192(amount, uint256(sqrtPriceX96) ** 2);

517:                 return Math.mulDiv(amount, 2 ** 192, uint256(sqrtPriceX96) ** 2);

519:                 return Math.mulDiv(amount, 2 ** 128, Math.mulDiv64(sqrtPriceX96, sqrtPriceX96));

535:                     .mulDiv192(Math.absUint(amount), uint256(sqrtPriceX96) ** 2)

558:                     .mulDiv(Math.absUint(amount), 2 ** 192, uint256(sqrtPriceX96) ** 2)

565:                         2 ** 128,

675:                 uint256 requiredRatioX128 = Math.mulDiv(required0, 2 ** 128, required0 + required1);

684:                 uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);

691:                         Math.mulDiv128(bonusCross, 2 ** 128 - requiredRatioX128),

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

37:                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),

41:                 call(gas(), token, 0, p, 100, 0, 32)

67:                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),

71:                 call(gas(), token, 0, p, 68, 0, 32)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/LeftRight.sol

101:         return uint128(LeftRightUnsigned.unwrap(self) >> 128);

108:         return int128(LeftRightSigned.unwrap(self) >> 128);

125:             return LeftRightUnsigned.wrap(LeftRightUnsigned.unwrap(self) + (uint256(left) << 128));

135:             return LeftRightSigned.wrap(LeftRightSigned.unwrap(self) + (int256(left) << 128));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

78:                     (uint256(uint24(_tickLower)) << 232) +

79:                         (uint256(uint24(_tickUpper)) << 208) +

109:                     LiquidityChunk.unwrap(self) + (uint256(uint24(_tickLower)) << 232)

126:                     LiquidityChunk.unwrap(self) + ((uint256(uint24(_tickUpper))) << 208)

173:             return int24(int256(LiquidityChunk.unwrap(self) >> 232));

182:             return int24(int256(LiquidityChunk.unwrap(self) >> 208));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

98:             return int24(uint24((TokenId.unwrap(self) >> 48) % 2 ** 16));

110:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48)) % 2);

120:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 1)) % 128);

130:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 8)) % 2);

140:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 9)) % 2);

150:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 10)) % 4);

160:             return int24(int256(TokenId.unwrap(self) >> (64 + legIndex * 48 + 12)));

171:             return int24(int256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 36)) % 4096));

195:             return TokenId.wrap(TokenId.unwrap(self) + (uint256(uint24(_tickSpacing)) << 48));

212:                 TokenId.wrap(TokenId.unwrap(self) + (uint256(_asset % 2) << (64 + legIndex * 48)));

229:                     TokenId.unwrap(self) + (uint256(_optionRatio % 128) << (64 + legIndex * 48 + 1))

246:             return TokenId.wrap(TokenId.unwrap(self) + ((_isLong % 2) << (64 + legIndex * 48 + 8)));

263:                     TokenId.unwrap(self) + (uint256(_tokenType % 2) << (64 + legIndex * 48 + 9))

281:                     TokenId.unwrap(self) + (uint256(_riskPartner % 4) << (64 + legIndex * 48 + 10))

300:                         uint256((int256(_strike) & BITMASK_INT24) << (64 + legIndex * 48 + 12))

320:                         (uint256(uint24(_width) % 4096) << (64 + legIndex * 48 + 36))

376:             if (optionRatios < 2 ** 64) {

378:             } else if (optionRatios < 2 ** 112) {

380:             } else if (optionRatios < 2 ** 160) {

381:                 optionRatios = 2;

382:             } else if (optionRatios < 2 ** 208) {

383:                 optionRatios = 3;

385:                 optionRatios = 4;

439:         if (optionRatios < 2 ** 64) {

441:         } else if (optionRatios < 2 ** 112) {

443:         } else if (optionRatios < 2 ** 160) {

444:             return 2;

445:         } else if (optionRatios < 2 ** 208) {

446:             return 3;

448:         return 4;

477:         if (i == 2)

483:         if (i == 3)

506:             uint256 chunkData = (TokenId.unwrap(self) & CHUNK_MASK) >> 64;

507:             for (uint256 i = 0; i < 4; ++i) {

512:                     if ((TokenId.unwrap(self) >> (64 + 48 * i)) != 0)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-5"></a>[NC-5] Control structures do not follow the Solidity Style Guide

See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (144)*:

```solidity
File: contracts/CollateralTracker.sol

168:         if (msg.sender != address(s_panopticPool)) revert Errors.NotPanopticPool();

218:         if (s_initialized) revert Errors.CollateralTokenAlreadyInitialized();

315:         if (s_panopticPool.numberOfPositions(msg.sender) != 0) revert Errors.PositionCountNotZero();

334:         if (s_panopticPool.numberOfPositions(from) != 0) revert Errors.PositionCountNotZero();

402:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

462:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

501:         uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.

518:         if (assets > maxWithdraw(owner)) revert Errors.ExceedsMaximumRedemption();

526:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

570:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

625:         if (shares > maxRedeem(owner)) revert Errors.ExceedsMaximumRedemption();

631:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

693:                 if (positionId.isLong(leg) == 0) continue;

875:           LIFECYCLE OF A COLLATERAL TOKEN AND DELEGATE/REVOKE LOGIC

1266:                 if (tokenId.tokenType(index) != (underlyingIsToken0 ? 0 : 1)) continue;

1352:                 if (

1380:                     if (

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

7: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

63:     SemiFungiblePositionManager internal immutable SFPM;

107:         SemiFungiblePositionManager _SFPM,

140:         if (amount0Owed > 0)

147:         if (amount1Owed > 0)

183:         if (address(v3Pool) == address(0)) revert Errors.UniswapPoolNotInitialized();

185:         if (address(s_getPanopticPool[v3Pool]) != address(0))

230:         if (amount0 > amount0Max || amount1 > amount1Max) revert Errors.PriceBoundFail();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

6: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

168:     SemiFungiblePositionManager internal immutable SFPM;

291:         if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

332:         if (

512:         if (medianData != 0) s_miniMedian = medianData;

608:         if (tokenId.poolId() != SFPM.getPoolId(address(s_univ3pool)))

613:         if (LeftRightUnsigned.unwrap(s_positionBalance[msg.sender][tokenId]) != 0)

639:         if (medianData != 0) s_miniMedian = medianData;

905:         if (!solventAtFast) revert Errors.NotEnoughCollateral();

908:         if (Math.abs(int256(fastOracleTick) - slowOracleTick) > MAX_SLOW_FAST_DELTA)

909:             if (!_checkSolvencyAtTick(user, positionIdList, currentTick, slowOracleTick, buffer))

1003:             if (Math.abs(currentTick - twapTick) > MAX_TWAP_DELTA_LIQUIDATION)

1034:             if (balanceCross >= thresholdCross) revert Errors.NotMarginCalled();

1123:         if (

1155:         if (touchedId.length != 1) revert Errors.InputListFail();

1241:         if (positionIdListExercisor.length > 0)

1360:         if (fingerprintIncomingList != currentHash) revert Errors.InputListFail();

1381:         if ((newHash >> 248) > MAX_POSITIONS) revert Errors.TooManyPositionsOpen();

1449:         if (netLiquidity == 0 && removedLiquidity == 0) return;

1458:         if (effectiveLiquidityFactorX32 > uint256(effectiveLiquidityLimitX32))

1561:         if (tokenId.isLong(legIndex) == 0 || legIndex > 3) revert Errors.NotALongLeg();

1828:                 if (commitLongSettled)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

154:         We're tracking the amount of net and removed liquidity for the specific region:

183:         time, we call this the gross premia. If that liquidity has been removed, we also need to

206:         In addition to tracking, we also want to track those fees plus a small spread. Specifically,

283:         specific risk management profile of every smart contract. And simply setting the ν parameter

324:         if (s_poolContext[poolId].locked) revert Errors.ReentrantCall();

357:         if (univ3pool == address(0)) revert Errors.UniswapPoolNotInitialized();

363:         if (s_AddrToPoolIdData[univ3pool] != 0) return;

414:         if (amount0Owed > 0)

421:         if (amount1Owed > 0)

551:         if (s_poolContext[TokenId.wrap(id).poolId()].locked) revert Errors.ReentrantCall();

578:             if (s_poolContext[TokenId.wrap(ids[i]).poolId()].locked) revert Errors.ReentrantCall();

630:             if (

637:             if (LeftRightUnsigned.unwrap(fromLiq) != liquidityChunk.liquidity())

687:         if (positionSize == 0) revert Errors.OptionsBalanceZero();

701:         if (univ3pool == IUniswapV3Pool(address(0))) revert Errors.UniswapPoolNotInitialized();

726:         if ((currentTick >= tickLimitHigh) || (currentTick <= tickLimitLow))

832:             if (swapAmount == 0) return LeftRightSigned.wrap(0);

936:         if (amount0 > uint128(type(int128).max) || amount1 > uint128(type(int128).max))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

36:         if (factory.getPool(features.token0, features.token1, features.fee) != sender)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

8: import {SemiFungiblePositionManager} from "@contracts/SemiFungiblePositionManager.sol";

25:         SemiFungiblePositionManager sfpm,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/Math.sol

131:             if (absTick > uint256(int256(Constants.MAX_V3POOL_TICK))) revert Errors.InvalidTick();

137:             if (absTick & 0x2 != 0) sqrtR = (sqrtR * 0xfff97272373d413259a46990580e213a) >> 128;

139:             if (absTick & 0x4 != 0) sqrtR = (sqrtR * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;

141:             if (absTick & 0x8 != 0) sqrtR = (sqrtR * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;

143:             if (absTick & 0x10 != 0) sqrtR = (sqrtR * 0xffcb9843d60f6159c9db58835c926644) >> 128;

145:             if (absTick & 0x20 != 0) sqrtR = (sqrtR * 0xff973b41fa98c081472e6896dfb254c0) >> 128;

147:             if (absTick & 0x40 != 0) sqrtR = (sqrtR * 0xff2ea16466c96a3843ec78b326b52861) >> 128;

149:             if (absTick & 0x80 != 0) sqrtR = (sqrtR * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;

151:             if (absTick & 0x100 != 0) sqrtR = (sqrtR * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;

153:             if (absTick & 0x200 != 0) sqrtR = (sqrtR * 0xf987a7253ac413176f2b074cf7815e54) >> 128;

155:             if (absTick & 0x400 != 0) sqrtR = (sqrtR * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;

157:             if (absTick & 0x800 != 0) sqrtR = (sqrtR * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;

159:             if (absTick & 0x1000 != 0) sqrtR = (sqrtR * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;

161:             if (absTick & 0x2000 != 0) sqrtR = (sqrtR * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;

163:             if (absTick & 0x4000 != 0) sqrtR = (sqrtR * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;

165:             if (absTick & 0x8000 != 0) sqrtR = (sqrtR * 0x31be135f97d08fd981231505542fcfa6) >> 128;

167:             if (absTick & 0x10000 != 0) sqrtR = (sqrtR * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;

169:             if (absTick & 0x20000 != 0) sqrtR = (sqrtR * 0x5d6af8dedb81196699c329225ee604) >> 128;

171:             if (absTick & 0x40000 != 0) sqrtR = (sqrtR * 0x2216e584f5fa1ea926041bedfe98) >> 128;

173:             if (absTick & 0x80000 != 0) sqrtR = (sqrtR * 0x48a170391f7dc42444e8fa2) >> 128;

176:             if (tick > 0) sqrtR = type(uint256).max / sqrtR;

297:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) revert Errors.CastingError();

312:         if ((downcastedInt = int128(toCast)) < 0) revert Errors.CastingError();

319:         if (!((downcastedInt = int128(toCast)) == toCast)) revert Errors.CastingError();

326:         if (toCast > uint256(type(int256).max)) revert Errors.CastingError();

351:             uint256 prod0; // Least significant 256 bits of the product

352:             uint256 prod1; // Most significant 256 bits of the product

465:             uint256 prod0; // Least significant 256 bits of the product

466:             uint256 prod1; // Most significant 256 bits of the product

528:             uint256 prod0; // Least significant 256 bits of the product

529:             uint256 prod1; // Most significant 256 bits of the product

605:             uint256 prod0; // Least significant 256 bits of the product

606:             uint256 prod1; // Most significant 256 bits of the product

682:             uint256 prod0; // Least significant 256 bits of the product

683:             uint256 prod1; // Most significant 256 bits of the product

757:             if (i == j) return;

768:             if (left < j) quickSort(arr, left, j);

769:             if (i < right) quickSort(arr, i, right);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

78:             return addr == address(0) ? 40 : 39 - Math.mostSignificantNibble(uint160(addr));

238:                 uint24 shift = 1;

247:                         shift -= 1;

254:                         shift += 1;

258:                     newOrderMap = newOrderMap + ((rank + 1) << (3 * (i + shift - 1)));

391:             if (

804:             if (

828:             } else if (

863:                 if (haircut0 != 0) collateral0.exercise(_liquidatee, 0, 0, 0, int128(haircut0));

864:                 if (haircut1 != 0) collateral1.exercise(_liquidatee, 0, 0, 0, int128(haircut1));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

45:         if (!success) revert Errors.TransferFailed();

75:         if (!success) revert Errors.TransferFailed();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

101:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

113:             if (

137:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

164:             if (

223:             if (

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

84:         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

```solidity
File: contracts/types/LeftRight.sol

159:             if (

182:             if (

198:             if (left128 != left) revert Errors.UnderOverFlow();

203:             if (right128 != right) revert Errors.UnderOverFlow();

221:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

239:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

261:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/TokenId.sol

465:         if (i == 0)

471:         if (i == 1)

477:         if (i == 2)

483:         if (i == 3)

501:         if (self.optionRatio(0) == 0) revert Errors.InvalidTokenIdParameter(1);

512:                     if ((TokenId.unwrap(self) >> (64 + 48 * i)) != 0)

528:                 if ((self.width(i) == 0)) revert Errors.InvalidTokenIdParameter(5);

530:                 if (

541:                     if (self.riskPartner(riskPartnerIndex) != i)

545:                     if (

560:                     if ((_isLong == isLongP) && (_tokenType == tokenTypeP))

566:                     if (((_isLong != isLongP) || _isLong == 1) && (_tokenType != tokenTypeP))

592:                     if (self.isLong(i) == 1) return; // validated

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-6"></a>[NC-6] Unused `error` definition

Note that there may be cases where an error superficially appears to be used, but this is only because there are multiple definitions of the error in different files. In such cases, the error definition should be moved into a separate file. The instances below are the unused definitions.

*Instances (32)*:

```solidity
File: contracts/libraries/Errors.sol

10:     error CastingError();

13:     error CollateralTokenAlreadyInitialized();

16:     error DepositTooLarge();

20:     error EffectiveLiquidityAboveThreshold();

23:     error ExceedsMaximumRedemption();

26:     error ExerciseeNotSolvent();

29:     error InputListFail();

32:     error InvalidSalt();

35:     error InvalidTick();

38:     error InvalidNotionalValue();

42:     error InvalidTokenIdParameter(uint256 parameterType);

45:     error InvalidUniswapCallback();

48:     error LeftRightInputError();

51:     error NoLegsExercisable();

54:     error NotEnoughCollateral();

57:     error PositionTooLarge();

60:     error NotALongLeg();

63:     error NotEnoughLiquidity();

66:     error NotMarginCalled();

69:     error NotPanopticPool();

72:     error OptionsBalanceZero();

75:     error PoolAlreadyInitialized();

78:     error PositionAlreadyMinted();

81:     error PositionCountNotZero();

84:     error PriceBoundFail();

87:     error ReentrantCall();

91:     error StaleTWAP();

94:     error TooManyPositionsOpen();

97:     error TransferFailed();

101:     error TicksNotInitializable();

104:     error UnderOverFlow();

107:     error UniswapPoolNotInitialized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Errors.sol)

### <a name="NC-7"></a>[NC-7] Events that mark critical parameter changes should contain both the old and the new value

This should especially be done if the new value is not required to be different from the old value

*Instances (2)*:

```solidity
File: contracts/PanopticPool.sol

1552:     function settleLongPremium(
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

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

81:     function setApprovalForAll(address operator, bool approved) public {
            isApprovedForAll[msg.sender][operator] = approved;
    
            emit ApprovalForAll(msg.sender, operator, approved);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

### <a name="NC-8"></a>[NC-8] Function ordering does not follow the Solidity style guide

According to the [Solidity style guide](https://docs.soliditylang.org/en/v0.8.17/style-guide.html#order-of-functions), functions should be laid out in the following order :`constructor()`, `receive()`, `fallback()`, `external`, `public`, `internal`, `private`, but the cases below do not follow this pattern

*Instances (5)*:

```solidity
File: contracts/CollateralTracker.sol

1: 
   Current order:
   external startToken
   external getPoolData
   external name
   external symbol
   external decimals
   public transfer
   public transferFrom
   external asset
   public totalAssets
   public convertToShares
   public convertToAssets
   external maxDeposit
   public previewDeposit
   external deposit
   external maxMint
   public previewMint
   external mint
   public maxWithdraw
   public previewWithdraw
   external withdraw
   external withdraw
   public maxRedeem
   public previewRedeem
   external redeem
   external exerciseCost
   internal _poolUtilization
   internal _sellCollateralRatio
   internal _buyCollateralRatio
   external delegate
   external delegate
   external refund
   external revoke
   external refund
   external takeCommissionAddData
   external exercise
   internal _getExchangedAmount
   public getAccountMarginDetails
   internal _getAccountMargin
   internal _getTotalRequiredCollateral
   internal _getRequiredCollateralAtTickSinglePosition
   internal _getRequiredCollateralSingleLeg
   internal _getRequiredCollateralSingleLegNoPartner
   internal _getRequiredCollateralSingleLegPartner
   internal _getRequiredCollateralAtUtilization
   internal _computeSpread
   internal _computeStrangle
   
   Suggested order:
   external startToken
   external getPoolData
   external name
   external symbol
   external decimals
   external asset
   external maxDeposit
   external deposit
   external maxMint
   external mint
   external withdraw
   external withdraw
   external redeem
   external exerciseCost
   external delegate
   external delegate
   external refund
   external revoke
   external refund
   external takeCommissionAddData
   external exercise
   public transfer
   public transferFrom
   public totalAssets
   public convertToShares
   public convertToAssets
   public previewDeposit
   public previewMint
   public maxWithdraw
   public previewWithdraw
   public maxRedeem
   public previewRedeem
   public getAccountMarginDetails
   internal _poolUtilization
   internal _sellCollateralRatio
   internal _buyCollateralRatio
   internal _getExchangedAmount
   internal _getAccountMargin
   internal _getTotalRequiredCollateral
   internal _getRequiredCollateralAtTickSinglePosition
   internal _getRequiredCollateralSingleLeg
   internal _getRequiredCollateralSingleLegNoPartner
   internal _getRequiredCollateralSingleLegPartner
   internal _getRequiredCollateralAtUtilization
   internal _computeSpread
   internal _computeStrangle

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

1: 
   Current order:
   external uniswapV3MintCallback
   external deployNewPool
   external minePoolAddress
   internal _mintFullRange
   external getPanopticPool
   
   Suggested order:
   external uniswapV3MintCallback
   external deployNewPool
   external minePoolAddress
   external getPanopticPool
   internal _mintFullRange

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

1: 
   Current order:
   external startPool
   external assertMinCollateralValues
   external validateCollateralWithdrawable
   external optionPositionBalance
   external calculateAccumulatedFeesBatch
   external calculatePortfolioValue
   internal _calculateAccumulatedPremia
   external pokeMedian
   external mintOptions
   external burnOptions
   external burnOptions
   internal _mintOptions
   internal _mintInSFPMAndUpdateCollateral
   internal _payCommissionAndWriteData
   internal _addUserOption
   internal _burnAllOptionsFrom
   internal _burnOptions
   internal _updatePositionDataBurn
   internal _validateSolvency
   internal _burnAndHandleExercise
   external liquidate
   external forceExercise
   internal _checkSolvencyAtTick
   internal _getSolvencyBalances
   internal _validatePositionList
   internal _updatePositionsHash
   external univ3pool
   external collateralToken0
   external collateralToken1
   public numberOfPositions
   internal getUniV3TWAP
   internal _checkLiquiditySpread
   internal _getPremia
   external settleLongPremium
   internal _updateSettlementPostMint
   internal _getAvailablePremium
   internal _getTotalLiquidity
   internal _updateSettlementPostBurn
   
   Suggested order:
   external startPool
   external assertMinCollateralValues
   external validateCollateralWithdrawable
   external optionPositionBalance
   external calculateAccumulatedFeesBatch
   external calculatePortfolioValue
   external pokeMedian
   external mintOptions
   external burnOptions
   external burnOptions
   external liquidate
   external forceExercise
   external univ3pool
   external collateralToken0
   external collateralToken1
   external settleLongPremium
   public numberOfPositions
   internal _calculateAccumulatedPremia
   internal _mintOptions
   internal _mintInSFPMAndUpdateCollateral
   internal _payCommissionAndWriteData
   internal _addUserOption
   internal _burnAllOptionsFrom
   internal _burnOptions
   internal _updatePositionDataBurn
   internal _validateSolvency
   internal _burnAndHandleExercise
   internal _checkSolvencyAtTick
   internal _getSolvencyBalances
   internal _validatePositionList
   internal _updatePositionsHash
   internal getUniV3TWAP
   internal _checkLiquiditySpread
   internal _getPremia
   internal _updateSettlementPostMint
   internal _getAvailablePremium
   internal _getTotalLiquidity
   internal _updateSettlementPostBurn

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

1: 
   Current order:
   internal beginReentrancyLock
   internal endReentrancyLock
   external initializeAMMPool
   external uniswapV3MintCallback
   external uniswapV3SwapCallback
   external burnTokenizedPosition
   external mintTokenizedPosition
   public safeTransferFrom
   public safeBatchTransferFrom
   internal registerTokenTransfer
   internal _validateAndForwardToAMM
   internal swapInAMM
   internal _createPositionInAMM
   internal _createLegInAMM
   private _updateStoredPremia
   private _getFeesBase
   internal _mintLiquidity
   internal _burnLiquidity
   internal _collectAndWritePositionData
   private _getPremiaDeltas
   external getAccountLiquidity
   external getAccountPremium
   external getAccountFeesBase
   external getUniswapV3PoolFromId
   external getPoolId
   
   Suggested order:
   external initializeAMMPool
   external uniswapV3MintCallback
   external uniswapV3SwapCallback
   external burnTokenizedPosition
   external mintTokenizedPosition
   external getAccountLiquidity
   external getAccountPremium
   external getAccountFeesBase
   external getUniswapV3PoolFromId
   external getPoolId
   public safeTransferFrom
   public safeBatchTransferFrom
   internal beginReentrancyLock
   internal endReentrancyLock
   internal registerTokenTransfer
   internal _validateAndForwardToAMM
   internal swapInAMM
   internal _createPositionInAMM
   internal _createLegInAMM
   internal _mintLiquidity
   internal _burnLiquidity
   internal _collectAndWritePositionData
   private _updateStoredPremia
   private _getFeesBase
   private _getPremiaDeltas

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

1: 
   Current order:
   internal getPoolId
   internal incrementPoolPattern
   external numberOfLeadingHexZeros
   external safeERC20Symbol
   internal uniswapFeeToString
   internal updatePositionsHash
   external computeMedianObservedPrice
   external computeInternalMedian
   external twapFilter
   internal getLiquidityChunk
   internal getTicks
   internal getRangesFromStrike
   internal computeExercisedAmounts
   internal convertCollateralData
   internal convertCollateralData
   internal convert0to1
   internal convert1to0
   internal convert0to1
   internal convert1to0
   internal getAmountsMoved
   internal _calculateIOAmounts
   external getLiquidationBonus
   external haircutPremia
   external getRefundAmounts
   
   Suggested order:
   external numberOfLeadingHexZeros
   external safeERC20Symbol
   external computeMedianObservedPrice
   external computeInternalMedian
   external twapFilter
   external getLiquidationBonus
   external haircutPremia
   external getRefundAmounts
   internal getPoolId
   internal incrementPoolPattern
   internal uniswapFeeToString
   internal updatePositionsHash
   internal getLiquidityChunk
   internal getTicks
   internal getRangesFromStrike
   internal computeExercisedAmounts
   internal convertCollateralData
   internal convertCollateralData
   internal convert0to1
   internal convert1to0
   internal convert0to1
   internal convert1to0
   internal getAmountsMoved
   internal _calculateIOAmounts

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="NC-9"></a>[NC-9] Functions should not be longer than 50 lines

Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability

*Instances (124)*:

```solidity
File: contracts/CollateralTracker.sol

273:     function name() external view returns (string memory) {

287:     function symbol() external view returns (string memory) {

294:     function decimals() external view returns (uint8) {

345:     function asset() external view returns (address assetTokenAddress) {

354:     function totalAssets() public view returns (uint256 totalManagedAssets) {

363:     function convertToShares(uint256 assets) public view returns (uint256 shares) {

370:     function convertToAssets(uint256 shares) public view returns (uint256 assets) {

376:     function maxDeposit(address) external pure returns (uint256 maxAssets) {

383:     function previewDeposit(uint256 assets) public view returns (uint256 shares) {

401:     function deposit(uint256 assets, address receiver) external returns (uint256 shares) {

428:     function maxMint(address) external view returns (uint256 maxShares) {

437:     function previewMint(uint256 shares) public view returns (uint256 assets) {

459:     function mint(uint256 shares, address receiver) external returns (uint256 assets) {

489:     function maxWithdraw(address owner) public view returns (uint256 maxAssets) {

500:     function previewWithdraw(uint256 assets) public view returns (uint256 shares) {

601:     function maxRedeem(address owner) public view returns (uint256 maxShares) {

610:     function previewRedeem(uint256 shares) public view returns (uint256 assets) {

760:     function _poolUtilization() internal view returns (int256 poolUtilization) {

913:     function delegate(address delegatee, uint256 assets) external onlyPanopticPool {

922:     function refund(address delegatee, uint256 assets) external onlyPanopticPool {

994:     function refund(address refunder, address refundee, int256 assets) external onlyPanopticPool {

1254:     function _getRequiredCollateralAtTickSinglePosition(

1318:     function _getRequiredCollateralSingleLegNoPartner(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

400:     function getPanopticPool(IUniswapV3Pool univ3pool) external view returns (PanopticPool) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

329:     function assertMinCollateralValues(uint256 minValue0, uint256 minValue1) external view {

706:     function _addUserOption(TokenId tokenId, uint64 effectiveLiquidityLimitX32) internal {

824:     function _updatePositionDataBurn(address owner, TokenId tokenId) internal {

1371:     function _updatePositionsHash(address account, TokenId tokenId, bool addFlag) internal {

1391:     function univ3pool() external view returns (IUniswapV3Pool) {

1397:     function collateralToken0() external view returns (CollateralTracker collateralToken) {

1403:     function collateralToken1() external view returns (CollateralTracker) {

1410:     function numberOfPositions(address user) public view returns (uint256 _numberOfPositions) {

1416:     function getUniV3TWAP() internal view returns (int24 twapTick) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

322:     function beginReentrancyLock(uint64 poolId) internal {

332:     function endReentrancyLock(uint64 poolId) internal {

352:     function initializeAMMPool(address token0, address token1, uint24 fee) external {

595:     function registerTokenTransfer(address from, address to, TokenId id, uint256 amount) internal {

1552:     function getPoolId(address univ3pool) external view returns (uint64 poolId) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

40:     function tokenURI(uint256 tokenId) public view override returns (string memory) {

181:     function getChainName() internal view returns (string memory) {

208:     function write(string memory chars) internal view returns (string memory) {

268:     function maxSymbolWidth(uint256 rarity) internal pure returns (uint256 width) {

294:     function maxRarityLabelWidth(uint256 rarity) internal pure returns (uint256 width) {

324:     function maxStrategyLabelWidth(uint256 rarity) internal pure returns (uint256 width) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/base/Multicall.sol

12:     function multicall(bytes[] calldata data) public payable returns (bytes[] memory results) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

88:     function computeDecimals(address token) external view returns (uint8) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/Math.sol

25:     function min24(int24 a, int24 b) internal pure returns (int24) {

33:     function max24(int24 a, int24 b) internal pure returns (int24) {

41:     function min(uint256 a, uint256 b) internal pure returns (uint256) {

49:     function min(int256 a, int256 b) internal pure returns (int256) {

57:     function max(uint256 a, uint256 b) internal pure returns (uint256) {

65:     function max(int256 a, int256 b) internal pure returns (int256) {

73:     function abs(int256 x) internal pure returns (int256) {

81:     function absUint(int256 x) internal pure returns (uint256) {

91:     function mostSignificantNibble(uint160 x) internal pure returns (uint256 r) {

128:     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160) {

191:     function getAmount0ForLiquidity(LiquidityChunk liquidityChunk) internal pure returns (uint256) {

207:     function getAmount1ForLiquidity(LiquidityChunk liquidityChunk) internal pure returns (uint256) {

296:     function toUint128(uint256 toDowncast) internal pure returns (uint128 downcastedInt) {

302:     function toUint128Capped(uint256 toDowncast) internal pure returns (uint128 downcastedInt) {

311:     function toInt128(uint128 toCast) internal pure returns (int128 downcastedInt) {

318:     function toInt128(int256 toCast) internal pure returns (int128 downcastedInt) {

325:     function toInt256(uint256 toCast) internal pure returns (int256) {

458:     function mulDiv64(uint256 a, uint256 b) internal pure returns (uint256) {

521:     function mulDiv96(uint256 a, uint256 b) internal pure returns (uint256) {

584:     function mulDiv96RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

598:     function mulDiv128(uint256 a, uint256 b) internal pure returns (uint256) {

661:     function mulDiv128RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

675:     function mulDiv192(uint256 a, uint256 b) internal pure returns (uint256) {

738:     function unsafeDivRoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

753:     function quickSort(int256[] memory arr, int256 left, int256 right) internal pure {

776:     function sort(int256[] memory data) internal pure returns (int256[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

49:     function getPoolId(address univ3pool) internal view returns (uint64) {

61:     function incrementPoolPattern(uint64 poolId) internal pure returns (uint64) {

76:     function numberOfLeadingHexZeros(address addr) external pure returns (uint256) {

85:     function safeERC20Symbol(address token) external view returns (string memory) {

99:     function uniswapFeeToString(uint24 fee) internal pure returns (string memory) {

276:     function twapFilter(IUniswapV3Pool univ3pool, uint32 twapWindow) external view returns (int24) {

495:     function convert0to1(uint256 amount, uint160 sqrtPriceX96) internal pure returns (uint256) {

512:     function convert1to0(uint256 amount, uint160 sqrtPriceX96) internal pure returns (uint256) {

529:     function convert0to1(int256 amount, uint160 sqrtPriceX96) internal pure returns (int256) {

552:     function convert1to0(int256 amount, uint160 sqrtPriceX96) internal pure returns (int256) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

21:     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {

52:     function safeTransfer(address token, address to, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

81:     function setApprovalForAll(address operator, bool approved) public {

200:     function supportsInterface(bytes4 interfaceId) public pure returns (bool) {

214:     function _mint(address to, uint256 id, uint256 amount) internal {

236:     function _burn(address from, uint256 id, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

49:     function approve(address spender, uint256 amount) public returns (bool) {

61:     function transfer(address to, uint256 amount) public virtual returns (bool) {

81:     function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {

103:     function _transferFrom(address from, address to, uint256 amount) internal {

122:     function _mint(address to, uint256 amount) internal {

136:     function _burn(address from, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

```solidity
File: contracts/tokens/interfaces/IERC20Partial.sol

16:     function balanceOf(address account) external view returns (uint256);

22:     function approve(address spender, uint256 amount) external;

27:     function transfer(address to, uint256 amount) external;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/interfaces/IERC20Partial.sol)

```solidity
File: contracts/types/LeftRight.sol

38:     function rightSlot(LeftRightUnsigned self) internal pure returns (uint128) {

45:     function rightSlot(LeftRightSigned self) internal pure returns (int128) {

100:     function leftSlot(LeftRightUnsigned self) internal pure returns (uint128) {

107:     function leftSlot(LeftRightSigned self) internal pure returns (int128) {

133:     function toLeftSlot(LeftRightSigned self, int128 left) internal pure returns (LeftRightSigned) {

193:     function add(LeftRightUnsigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

213:     function add(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

231:     function sub(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

171:     function tickLower(LiquidityChunk self) internal pure returns (int24) {

180:     function tickUpper(LiquidityChunk self) internal pure returns (int24) {

189:     function liquidity(LiquidityChunk self) internal pure returns (uint128) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

87:     function poolId(TokenId self) internal pure returns (uint64) {

96:     function tickSpacing(TokenId self) internal pure returns (int24) {

108:     function asset(TokenId self, uint256 legIndex) internal pure returns (uint256) {

118:     function optionRatio(TokenId self, uint256 legIndex) internal pure returns (uint256) {

128:     function isLong(TokenId self, uint256 legIndex) internal pure returns (uint256) {

138:     function tokenType(TokenId self, uint256 legIndex) internal pure returns (uint256) {

148:     function riskPartner(TokenId self, uint256 legIndex) internal pure returns (uint256) {

158:     function strike(TokenId self, uint256 legIndex) internal pure returns (int24) {

169:     function width(TokenId self, uint256 legIndex) internal pure returns (int24) {

183:     function addPoolId(TokenId self, uint64 _poolId) internal pure returns (TokenId) {

193:     function addTickSpacing(TokenId self, int24 _tickSpacing) internal pure returns (TokenId) {

366:     function flipToBurnToken(TokenId self) internal pure returns (TokenId) {

404:     function countLongs(TokenId self) internal pure returns (uint256) {

432:     function countLegs(TokenId self) internal pure returns (uint256) {

464:     function clearLeg(TokenId self, uint256 i) internal pure returns (TokenId) {

578:     function validateIsExercisable(TokenId self, int24 currentTick) internal pure {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-10"></a>[NC-10] Change int to int256

Throughout the code base, some variables are declared as `int`. To favor explicitness, consider changing all instances of `int` to `int256`

*Instances (10)*:

```solidity
File: contracts/CollateralTracker.sol

1039:                 uint256 sharesToMint = convertToShares(uint256(-tokenToPay));

1086:                 uint256 sharesToMint = convertToShares(uint256(-tokenToPay));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

123:     bool internal constant MINT = false;

1043:                 Selling(isLong=0): Mint chunk of liquidity in Uniswap (defined by upper tick, lower tick, and amount)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/Math.sol

297:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) revert Errors.CastingError();

303:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) {

304:             downcastedInt = type(uint128).max;

312:         if ((downcastedInt = int128(toCast)) < 0) revert Errors.CastingError();

319:         if (!((downcastedInt = int128(toCast)) == toCast)) revert Errors.CastingError();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/types/LeftRight.sol

25:     int256 internal constant LEFT_HALF_BIT_MASK_INT =

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

### <a name="NC-11"></a>[NC-11] Lack of checks in setters

Be it sanity checks (like checks against `0`-values) or initial setting checks: it's best for Setter functions to have them

*Instances (2)*:

```solidity
File: contracts/SemiFungiblePositionManager.sol

1133:         IUniswapV3Pool univ3pool,
              uint128 liquidity,
              LiquidityChunk liquidityChunk,
              bool roundUp
          ) private view returns (LeftRightSigned feesBase) {
              // read the latest feeGrowth directly from the Uniswap pool
              (, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, , ) = univ3pool
                  .positions(
                      keccak256(
                          abi.encodePacked(
                              address(this),
                              liquidityChunk.tickLower(),
                              liquidityChunk.tickUpper()
                          )
                      )
                  );
      
              // (feegrowth * liquidity) / 2 ** 128
              // here we're converting the value to an int128 even though all values (feeGrowth, liquidity, Q128) are strictly positive.

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

81:     function setApprovalForAll(address operator, bool approved) public {
            isApprovedForAll[msg.sender][operator] = approved;
    
            emit ApprovalForAll(msg.sender, operator, approved);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

### <a name="NC-12"></a>[NC-12] Lines are too long

Usually lines in source code are limited to [80](https://softwareengineering.stackexchange.com/questions/148677/why-is-80-characters-the-standard-limit-for-code-width) characters. Today's screens are much larger so it's reasonable to stretch this in some cases. Since the files will most likely reside in GitHub, and GitHub starts using a scroll bar in all cases when the length is over [164](https://github.com/aizatto/character-length) characters, the lines below should be split when they reach that length

*Instances (1)*:

```solidity
File: contracts/CollateralTracker.sol

870:                     (SATURATED_POOL_UTIL - TARGET_POOL_UTIL)) / 2; // do the division by 2 at the end after all addition and multiplication; b/c y1 = buyCollateralRatio / 2

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="NC-13"></a>[NC-13] `type(uint256).max` should be used instead of `2 ** 256 - 1`

*Instances (2)*:

```solidity
File: contracts/libraries/Math.sol

15:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

25:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="NC-14"></a>[NC-14] Incomplete NatSpec: `@param` is missing on actually documented functions

The following functions are missing `@param` NatSpec comments.

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

303:     /// @dev See {IERC20-transfer}.
         /// Requirements:
         /// - the caller must have a balance of at least 'amount'.
         /// - the msg.sender must not have any position on the panoptic pool
         function transfer(
             address recipient,
             uint256 amount

320:     /// @dev See {IERC20-transferFrom}.
         /// Requirements:
         /// - the 'from' must have a balance of at least 'amount'.
         /// - the caller must have allowance for 'from' of at least 'amount' tokens.
         /// - 'from' must not have any open positions on the panoptic pool.
         function transferFrom(
             address from,
             address to,
             uint256 amount

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="NC-15"></a>[NC-15] Incomplete NatSpec: `@return` is missing on actually documented functions

The following functions are missing `@return` NatSpec comments.

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

303:     /// @dev See {IERC20-transfer}.
         /// Requirements:
         /// - the caller must have a balance of at least 'amount'.
         /// - the msg.sender must not have any position on the panoptic pool
         function transfer(
             address recipient,
             uint256 amount
         ) public override(ERC20Minimal) returns (bool) {

320:     /// @dev See {IERC20-transferFrom}.
         /// Requirements:
         /// - the 'from' must have a balance of at least 'amount'.
         /// - the caller must have allowance for 'from' of at least 'amount' tokens.
         /// - 'from' must not have any open positions on the panoptic pool.
         function transferFrom(
             address from,
             address to,
             uint256 amount
         ) public override(ERC20Minimal) returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="NC-16"></a>[NC-16] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor

If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (12)*:

```solidity
File: contracts/CollateralTracker.sol

168:         if (msg.sender != address(s_panopticPool)) revert Errors.NotPanopticPool();

315:         if (s_panopticPool.numberOfPositions(msg.sender) != 0) revert Errors.PositionCountNotZero();

523:         if (msg.sender != owner) {

526:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

567:         if (msg.sender != owner) {

570:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

628:         if (msg.sender != owner) {

631:             if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

613:         if (LeftRightUnsigned.unwrap(s_positionBalance[msg.sender][tokenId]) != 0)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

101:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

137:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

84:         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

### <a name="NC-17"></a>[NC-17] Constant state variables defined more than once

Rather than redefining state variable constant, consider using a library to store all constants as this will prevent data redundancy

*Instances (2)*:

```solidity
File: contracts/libraries/Math.sol

15:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

25:     uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="NC-18"></a>[NC-18] Adding a `return` statement when the function defines a named return variable, is redundant

*Instances (35)*:

```solidity
File: contracts/CollateralTracker.sol

343:     /// @notice Get the token contract address of the underlying asset being managed.
         /// @return assetTokenAddress The address of the underlying asset
         function asset() external view returns (address assetTokenAddress) {
             return s_underlyingToken;

349:     /// @notice Get the total amount of assets managed by the CollateralTracker vault.
         /// @dev This returns the total tracked assets in the AMM and PanopticPool,
         /// @dev - EXCLUDING the amount of collected fees (because they are reserved for short options)
         /// @dev - EXCLUDING any donations that have been made to the pool
         /// @return totalManagedAssets The total amount of assets managed
         function totalAssets() public view returns (uint256 totalManagedAssets) {
             unchecked {
                 return s_poolAssets + s_inAMM;

360:     /// @notice Returns the amount of shares that can be minted for the given amount of assets.
         /// @param assets The amount of assets to be deposited
         /// @return shares The amount of shares that can be minted
         function convertToShares(uint256 assets) public view returns (uint256 shares) {
             return Math.mulDiv(assets, totalSupply, totalAssets());

367:     /// @notice Returns the amount of assets that can be redeemed for the given amount of shares.
         /// @param shares The amount of shares to be redeemed
         /// @return assets The amount of assets that can be redeemed
         function convertToAssets(uint256 shares) public view returns (uint256 assets) {
             return Math.mulDiv(shares, totalAssets(), totalSupply);

374:     /// @notice Returns the maximum deposit amount.
         /// @return maxAssets The maximum amount of assets that can be deposited
         function maxDeposit(address) external pure returns (uint256 maxAssets) {
             return type(uint104).max;

426:     /// @notice Returns the maximum shares received for a deposit.
         /// @return maxShares The maximum amount of shares that can be minted.
         function maxMint(address) external view returns (uint256 maxShares) {
             unchecked {
                 return (convertToShares(type(uint104).max) * (DECIMALS - COMMISSION_FEE)) / DECIMALS;

484:     /// @notice Returns The maximum amount of assets that can be withdrawn for a given user.
         /// If the user has any open positions, the max withdrawable balance is zero.
         /// @dev Calculated from the balance of the user; limited by the assets the pool has available.
         /// @param owner The address being withdrawn for.
         /// @return maxAssets The maximum amount of assets that can be withdrawn.
         function maxWithdraw(address owner) public view returns (uint256 maxAssets) {
             // We can only use the standard 4626 withdraw function if the user has no open positions
             // For the sake of simplicity assets can only be withdrawn through the redeem function
             uint256 available = s_poolAssets;
             uint256 balance = convertToAssets(balanceOf[owner]);
             return s_panopticPool.numberOfPositions(owner) == 0 ? Math.min(available, balance) : 0;

497:     /// @notice Returns the amount of shares that would be burned to withdraw a given amount of assets.
         /// @param assets The amount of assets to be withdrawn.
         /// @return shares The amount of shares that would be burned.
         function previewWithdraw(uint256 assets) public view returns (uint256 shares) {
             uint256 supply = totalSupply; // Saves an extra SLOAD if totalSupply is non-zero.
     
             return Math.mulDivRoundingUp(assets, supply, totalAssets());

506:     /// @notice Redeem the amount of shares required to withdraw the specified amount of assets.
         /// We can only use this standard 4626 withdraw function if the user has no open positions.
         /// @dev Shares are burned and assets are sent to the LP ('receiver').
         /// @param assets Amount of assets to be withdrawn.
         /// @param receiver User to receive the assets.
         /// @param owner User to burn the shares from.
         /// @return shares The amount of shares burned to withdraw the desired amount of assets.
         function withdraw(
             uint256 assets,
             address receiver,
             address owner
         ) external returns (uint256 shares) {
             if (assets > maxWithdraw(owner)) revert Errors.ExceedsMaximumRedemption();
     
             shares = previewWithdraw(assets);
     
             // check/update allowance for approved withdraw
             if (msg.sender != owner) {
                 uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
     
                 if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
             }
     
             // burn collateral shares of the Panoptic Pool funds (this ERC20 token)
             _burn(owner, shares);
     
             // update tracked asset balance
             unchecked {
                 s_poolAssets -= uint128(assets);
             }
     
             // transfer assets (underlying token funds) from the PanopticPool to the LP
             SafeTransferLib.safeTransferFrom(
                 s_underlyingToken,
                 address(s_panopticPool),
                 receiver,
                 assets
             );
     
             emit Withdraw(msg.sender, receiver, owner, assets, shares);
     
             return shares;

550:     /// @notice Redeem the amount of shares required to withdraw the specified amount of assets.
         /// @dev Reverts if the account is not solvent with the given `positionIdList`.
         /// @dev Shares are burned and assets are sent to the LP ('receiver').
         /// @param assets Amount of assets to be withdrawn
         /// @param receiver User to receive the assets
         /// @param owner User to burn the shares from
         /// @param positionIdList The list of all option positions held by `owner`
         /// @return shares The amount of shares burned to withdraw the desired amount of assets
         function withdraw(
             uint256 assets,
             address receiver,
             address owner,
             TokenId[] calldata positionIdList
         ) external returns (uint256 shares) {
             shares = previewWithdraw(assets);
     
             // check/update allowance for approved withdraw
             if (msg.sender != owner) {
                 uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
     
                 if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
             }
     
             // burn collateral shares of the Panoptic Pool funds (this ERC20 token)
             _burn(owner, shares);
     
             // update tracked asset balance
             unchecked {
                 s_poolAssets -= uint128(assets);
             }
     
             // reverts if account is not solvent/eligible to withdraw
             s_panopticPool.validateCollateralWithdrawable(owner, positionIdList);
     
             // transfer assets (underlying token funds) from the PanopticPool to the LP
             SafeTransferLib.safeTransferFrom(
                 s_underlyingToken,
                 address(s_panopticPool),
                 receiver,
                 assets
             );
     
             emit Withdraw(msg.sender, receiver, owner, assets, shares);
     
             return shares;

597:     /// @notice Returns the maximum amount of shares that can be redeemed for a given user.
         /// If the user has any open positions, the max redeemable balance is zero.
         /// @param owner The redeeming address.
         /// @return maxShares The maximum amount of shares that can be redeemed.
         function maxRedeem(address owner) public view returns (uint256 maxShares) {
             uint256 available = convertToShares(s_poolAssets);
             uint256 balance = balanceOf[owner];
             return s_panopticPool.numberOfPositions(owner) == 0 ? Math.min(available, balance) : 0;

607:     /// @notice returns the amount of assets resulting from a given amount of shares being redeemed
         /// @param shares the amount of shares to be redeemed
         /// @return assets the amount of assets resulting from the redemption
         function previewRedeem(uint256 shares) public view returns (uint256 assets) {
             return convertToAssets(shares);

614:     /// @notice Redeem exact shares for underlying assets
         /// We can only use this standard 4626 redeem function if the user has no open positions.
         /// @param shares Amount of shares to be redeemed
         /// @param receiver User to receive the assets
         /// @param owner User to burn the shares from
         /// @return assets the amount of assets resulting from the redemption
         function redeem(
             uint256 shares,
             address receiver,
             address owner
         ) external returns (uint256 assets) {
             if (shares > maxRedeem(owner)) revert Errors.ExceedsMaximumRedemption();
     
             // check/update allowance for approved redeem
             if (msg.sender != owner) {
                 uint256 allowed = allowance[owner][msg.sender]; // Saves gas for limited approvals.
     
                 if (allowed != type(uint256).max) allowance[owner][msg.sender] = allowed - shares;
             }
     
             assets = previewRedeem(shares);
     
             // burn collateral shares of the Panoptic Pool funds (this ERC20 token)
             _burn(owner, shares);
     
             // update tracked asset balance
             unchecked {
                 s_poolAssets -= uint128(assets);
             }
     
             // transfer assets (underlying token funds) from the PanopticPool to the LP
             SafeTransferLib.safeTransferFrom(
                 s_underlyingToken,
                 address(s_panopticPool),
                 receiver,
                 assets
             );
     
             emit Withdraw(msg.sender, receiver, owner, assets, shares);
     
             return assets;

758:     /// @dev compute: inAMM/totalAssets().
         /// @return poolUtilization The pool utilization in basis points
         function _poolUtilization() internal view returns (int256 poolUtilization) {
             unchecked {
                 return int256((s_inAMM * DECIMALS) / totalAssets());

766:     /// @notice Get the (sell) collateral ratio that is paid when a short option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalAssets() that belongs to the Uniswap Pool
         /// @return sellCollateralRatio The sell collateral ratio at `utilization`
         function _sellCollateralRatio(
             int256 utilization
         ) internal view returns (uint256 sellCollateralRatio) {
             // the sell ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,min_sell_ratio) and
             //   (x1,y1) = (saturatedPoolUtilization,max_sell_ratio)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             /**
                 SELL
                 COLLATERAL
                 RATIO
                               ^
                               |                  max ratio = 100%
                        100% - |                _------
                               |             _-¯
                               |          _-¯
                         20% - |---------¯
                               |         .       . .
                               +---------+-------+-+--->   POOL_
                                        50%    90% 100%     UTILIZATION
             */
     
             uint256 min_sell_ratio = SELLER_COLLATERAL_RATIO;
             /// if utilization is less than zero, this is the calculation for a strangle, which gets 2x the capital efficiency at low pool utilization
             /// at 0% utilization, strangle legs do not compound efficiency
             if (utilization < 0) {
                 unchecked {
                     min_sell_ratio /= 2;
                     utilization = -utilization;
                 }
             }
     
             // return the basal sell ratio if pool utilization is lower than target
             if (uint256(utilization) < TARGET_POOL_UTIL) {
                 return min_sell_ratio;
             }
     
             // return 100% collateral ratio if utilization is above saturated pool utilization
             // this means all new positions are fully collateralized, which reduces risks of insolvency at high pool utilization
             if (uint256(utilization) > SATURATED_POOL_UTIL) {
                 return DECIMALS;
             }
     
             unchecked {
                 return

766:     /// @notice Get the (sell) collateral ratio that is paid when a short option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalAssets() that belongs to the Uniswap Pool
         /// @return sellCollateralRatio The sell collateral ratio at `utilization`
         function _sellCollateralRatio(
             int256 utilization
         ) internal view returns (uint256 sellCollateralRatio) {
             // the sell ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,min_sell_ratio) and
             //   (x1,y1) = (saturatedPoolUtilization,max_sell_ratio)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             /**
                 SELL
                 COLLATERAL
                 RATIO
                               ^
                               |                  max ratio = 100%
                        100% - |                _------
                               |             _-¯
                               |          _-¯
                         20% - |---------¯
                               |         .       . .
                               +---------+-------+-+--->   POOL_
                                        50%    90% 100%     UTILIZATION
             */
     
             uint256 min_sell_ratio = SELLER_COLLATERAL_RATIO;
             /// if utilization is less than zero, this is the calculation for a strangle, which gets 2x the capital efficiency at low pool utilization
             /// at 0% utilization, strangle legs do not compound efficiency
             if (utilization < 0) {
                 unchecked {
                     min_sell_ratio /= 2;
                     utilization = -utilization;
                 }
             }
     
             // return the basal sell ratio if pool utilization is lower than target
             if (uint256(utilization) < TARGET_POOL_UTIL) {
                 return min_sell_ratio;

766:     /// @notice Get the (sell) collateral ratio that is paid when a short option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalAssets() that belongs to the Uniswap Pool
         /// @return sellCollateralRatio The sell collateral ratio at `utilization`
         function _sellCollateralRatio(
             int256 utilization
         ) internal view returns (uint256 sellCollateralRatio) {
             // the sell ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,min_sell_ratio) and
             //   (x1,y1) = (saturatedPoolUtilization,max_sell_ratio)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             /**
                 SELL
                 COLLATERAL
                 RATIO
                               ^
                               |                  max ratio = 100%
                        100% - |                _------
                               |             _-¯
                               |          _-¯
                         20% - |---------¯
                               |         .       . .
                               +---------+-------+-+--->   POOL_
                                        50%    90% 100%     UTILIZATION
             */
     
             uint256 min_sell_ratio = SELLER_COLLATERAL_RATIO;
             /// if utilization is less than zero, this is the calculation for a strangle, which gets 2x the capital efficiency at low pool utilization
             /// at 0% utilization, strangle legs do not compound efficiency
             if (utilization < 0) {
                 unchecked {
                     min_sell_ratio /= 2;
                     utilization = -utilization;
                 }
             }
     
             // return the basal sell ratio if pool utilization is lower than target
             if (uint256(utilization) < TARGET_POOL_UTIL) {
                 return min_sell_ratio;
             }
     
             // return 100% collateral ratio if utilization is above saturated pool utilization
             // this means all new positions are fully collateralized, which reduces risks of insolvency at high pool utilization
             if (uint256(utilization) > SATURATED_POOL_UTIL) {
                 return DECIMALS;

821:     /// @notice Get the (buy) collateral ratio that is paid when a long option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalBalance() that belongs to the Uniswap Pool
         /// @return buyCollateralRatio The buy collateral ratio at `utilization`
         function _buyCollateralRatio(
             uint256 utilization
         ) internal view returns (uint256 buyCollateralRatio) {
             // linear from BUY to BUY/2 between 50% and 90%
             // the buy ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,buyCollateralRatio) and
             //   (x1,y1) = (saturatedPoolUtilization,buyCollateralRatio / 2)
             // note that y1<y0 so the slope is negative:
             // aka the buy ratio starts high and drops to a lower value with increased utilization; the sell ratio does the opposite (slope is positive)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             // but since a<0, we rewrite as:
             // y = a' * (x0 - x) + y0, where a' = (y0 - y1) / (x1 - x0)
     
             // HOWEVER, if the utilization is larger than 10_000, then default to 100% buying power requirement.
             // this denotes a situation where the median is too far away from the current price, so we need to require fully collateralized positions for safety
             /**
               BUY
               COLLATERAL
               RATIO
                      ^
                      |   buy_ratio = 10%
                10% - |----------__       min_ratio = 5%
                5%  - | . . . . .  ¯¯¯--______
                      |         .       . .
                      +---------+-------+-+--->   POOL_
                               50%    90% 100%      UTILIZATION
              */
     
             // return the basal buy ratio if pool utilization is lower than target
             if (utilization < TARGET_POOL_UTIL) {
                 return BUYER_COLLATERAL_RATIO;
             }
     
             // return the basal ratio divided by 2 if pool utilization is above saturated pool utilization
             /// this is incentivized buying, which returns funds to the panoptic pool
             if (utilization > SATURATED_POOL_UTIL) {
                 unchecked {
                     return BUYER_COLLATERAL_RATIO / 2;
                 }
             }
     
             unchecked {
                 return
                     (BUYER_COLLATERAL_RATIO +

821:     /// @notice Get the (buy) collateral ratio that is paid when a long option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalBalance() that belongs to the Uniswap Pool
         /// @return buyCollateralRatio The buy collateral ratio at `utilization`
         function _buyCollateralRatio(
             uint256 utilization
         ) internal view returns (uint256 buyCollateralRatio) {
             // linear from BUY to BUY/2 between 50% and 90%
             // the buy ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,buyCollateralRatio) and
             //   (x1,y1) = (saturatedPoolUtilization,buyCollateralRatio / 2)
             // note that y1<y0 so the slope is negative:
             // aka the buy ratio starts high and drops to a lower value with increased utilization; the sell ratio does the opposite (slope is positive)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             // but since a<0, we rewrite as:
             // y = a' * (x0 - x) + y0, where a' = (y0 - y1) / (x1 - x0)
     
             // HOWEVER, if the utilization is larger than 10_000, then default to 100% buying power requirement.
             // this denotes a situation where the median is too far away from the current price, so we need to require fully collateralized positions for safety
             /**
               BUY
               COLLATERAL
               RATIO
                      ^
                      |   buy_ratio = 10%
                10% - |----------__       min_ratio = 5%
                5%  - | . . . . .  ¯¯¯--______
                      |         .       . .
                      +---------+-------+-+--->   POOL_
                               50%    90% 100%      UTILIZATION
              */
     
             // return the basal buy ratio if pool utilization is lower than target
             if (utilization < TARGET_POOL_UTIL) {
                 return BUYER_COLLATERAL_RATIO;

821:     /// @notice Get the (buy) collateral ratio that is paid when a long option is minted at a specific pool utilization.
         /// @dev This is computed at the time the position is minted.
         /// @param utilization The fraction of totalBalance() that belongs to the Uniswap Pool
         /// @return buyCollateralRatio The buy collateral ratio at `utilization`
         function _buyCollateralRatio(
             uint256 utilization
         ) internal view returns (uint256 buyCollateralRatio) {
             // linear from BUY to BUY/2 between 50% and 90%
             // the buy ratio is on a straight line defined between two points (x0,y0) and (x1,y1):
             //   (x0,y0) = (targetPoolUtilization,buyCollateralRatio) and
             //   (x1,y1) = (saturatedPoolUtilization,buyCollateralRatio / 2)
             // note that y1<y0 so the slope is negative:
             // aka the buy ratio starts high and drops to a lower value with increased utilization; the sell ratio does the opposite (slope is positive)
             // the line's formula: y = a * (x - x0) + y0, where a = (y1 - y0) / (x1 - x0)
             // but since a<0, we rewrite as:
             // y = a' * (x0 - x) + y0, where a' = (y0 - y1) / (x1 - x0)
     
             // HOWEVER, if the utilization is larger than 10_000, then default to 100% buying power requirement.
             // this denotes a situation where the median is too far away from the current price, so we need to require fully collateralized positions for safety
             /**
               BUY
               COLLATERAL
               RATIO
                      ^
                      |   buy_ratio = 10%
                10% - |----------__       min_ratio = 5%
                5%  - | . . . . .  ¯¯¯--______
                      |         .       . .
                      +---------+-------+-+--->   POOL_
                               50%    90% 100%      UTILIZATION
              */
     
             // return the basal buy ratio if pool utilization is lower than target
             if (utilization < TARGET_POOL_UTIL) {
                 return BUYER_COLLATERAL_RATIO;
             }
     
             // return the basal ratio divided by 2 if pool utilization is above saturated pool utilization
             /// this is incentivized buying, which returns funds to the panoptic pool
             if (utilization > SATURATED_POOL_UTIL) {
                 unchecked {
                     return BUYER_COLLATERAL_RATIO / 2;

1162:     /// @param user The account to check collateral/margin health for.
          /// @param atTick The tick at which to evaluate the account's positions
          /// @param positionBalanceArray The list of all historical positions held by the 'optionOwner', stored as [[tokenId, balance/poolUtilizationAtMint], ...]
          /// @param premiumAllPositions The premium collected thus far across all positions
          /// @return tokenData Information collected for the tokens about the health of the account;
          /// the collateral balance of the user is in the right slot and the threshold for margin call is in the left slot
          function _getAccountMargin(
              address user,
              int24 atTick,
              uint256[2][] memory positionBalanceArray,
              int128 premiumAllPositions
          ) internal view returns (LeftRightUnsigned tokenData) {
              uint256 tokenRequired;
      
              // if the account has active options, compute the required collateral to keep account in good health
              if (positionBalanceArray.length > 0) {
                  // get all collateral required for the incoming list of positions
                  tokenRequired = _getTotalRequiredCollateral(atTick, positionBalanceArray);
      
                  // If premium is negative (ie. user has to pay for their purchased options), add this long premium to the token requirement
                  if (premiumAllPositions < 0) {
                      unchecked {
                          tokenRequired += uint128(-premiumAllPositions);
                      }
                  }
              }
      
              // if premium is positive (ie. user will receive funds due to selling options), add this premum to the user's balance
              uint256 netBalance = convertToAssets(balanceOf[user]);
              if (premiumAllPositions > 0) {
                  unchecked {
                      netBalance += uint256(uint128(premiumAllPositions));
                  }
              }
      
              // store assetBalance and tokens required in tokenData variable
              tokenData = tokenData.toRightSlot(netBalance.toUint128()).toLeftSlot(
                  tokenRequired.toUint128()
              );
              return tokenData;
          }
      
          /// @notice Get the total required amount of collateral tokens of a user/account across all active positions to stay above the margin requirement.
          /// @dev Returns the token amounts required for the entire account with active positions in 'positionIdList' (list of tokenIds).
          /// @param atTick The tick at which to evaluate the account's positions

1206:     /// @param atTick The tick at which to evaluate the account's positions
          /// @param positionBalanceArray The list of all historical positions held by the 'optionOwner', stored as [[tokenId, balance/poolUtilizationAtMint], ...]
          /// @return tokenRequired The amount of tokens required to stay above the margin threshold for all active positions of user
          function _getTotalRequiredCollateral(
              int24 atTick,
              uint256[2][] memory positionBalanceArray
          ) internal view returns (uint256 tokenRequired) {
              // loop through each active position.
              // Offset determined whether to consider the last tokenId from the list
              // (a potentially newly minted position)
              uint256 totalIterations = positionBalanceArray.length;
              for (uint256 i = 0; i < totalIterations; ) {
                  // read the ith tokenId from the account
                  TokenId tokenId = TokenId.wrap(positionBalanceArray[i][0]);
      
                  // read the position size and the pool utilization at mint
                  uint128 positionSize = LeftRightUnsigned.wrap(positionBalanceArray[i][1]).rightSlot();
      
                  // read the pool utilization at mint
                  uint128 poolUtilization = LeftRightUnsigned.wrap(positionBalanceArray[i][1]).leftSlot();
      
                  // Get tokens required for the current tokenId (a single active position)
                  uint256 _tokenRequired = _getRequiredCollateralAtTickSinglePosition(
                      tokenId,
                      positionSize,
                      atTick,
                      poolUtilization
                  );
      
                  // add to the tokenRequired accumulator
                  unchecked {
                      tokenRequired += _tokenRequired;
                  }
                  unchecked {
                      ++i;
                  }
              }
      
              return tokenRequired;
          }
      
          /// @notice Get the required amount of collateral tokens corresponding to a specific single position 'tokenId' at a price 'tick'.
          /// The required collateral of an account depends on the price ('tick') in the AMM pool: if in the position's favor less collateral needed, etc.
          /// @param tokenId The option position

1283:     /// @param atTick The tick at which to evaluate the account's positions
          /// @param poolUtilization The pool utilization: how much funds are in the Panoptic pool versus the AMM pool
          /// @return required The required amount collateral needed for this leg 'index'
          function _getRequiredCollateralSingleLeg(
              TokenId tokenId,
              uint256 index,
              uint128 positionSize,
              int24 atTick,
              uint128 poolUtilization
          ) internal view returns (uint256 required) {
              return
                  tokenId.riskPartner(index) == index // does this leg have a risk partner? Affects required collateral
                      ? _getRequiredCollateralSingleLegNoPartner(
                          tokenId,
                          index,
                          positionSize,
                          atTick,
                          poolUtilization

1600:     /// @param tokenId The option position
          /// @param positionSize The size of the position
          /// @param index The leg index (associated with a liquidity chunk) to consider a partner for
          /// @param atTick The tick at which to evaluate the account's positions
          /// @param poolUtilization The pool utilization: how much funds are in the Panoptic pool versus the AMM pool
          /// @return strangleRequired The required amount of collateral needed for the strangle leg
          function _computeStrangle(
              TokenId tokenId,
              uint256 index,
              uint128 positionSize,
              int24 atTick,
              uint128 poolUtilization
          ) internal view returns (uint256 strangleRequired) {
              // If both tokenTypes are the same, then this is a long or short strangle.
              // A strangle is an options strategy in which the investor holds a position
              // in both a call and a put option with different strike prices,
              // but with the same expiration date and underlying asset.
      
              /// collateral requirement is for short strangles depicted:
              /**
                          Put side of a short strangle, BPR = 100% - (100% - SCR/2)*(price/strike)
                 BUYING
                 POWER
                 REQUIREMENT
                               ^                    .
                               |           <- ITM   .  OTM ->
                        100% - |--__                .
                               |    ¯¯--__          .
                               |          ¯¯--__    .
                       SCR/2 - |                ¯¯--______ <------ base collateral is half that of a single-leg
                               +--------------------+--->   current
                               0                  strike     price
               */
              unchecked {
                  // A negative pool utilization is used to denote a position which is a strangle
                  // at low pool utilization's strangle legs are evaluated at 2x capital efficiency
      
                  uint64 poolUtilization0 = uint64(poolUtilization);
                  uint64 poolUtilization1 = uint64(poolUtilization >> 64);
      
                  // add 1 to handle poolUtilization = 0
      
                  poolUtilization =
                      uint128(uint64(-int64(poolUtilization0 == 0 ? 1 : poolUtilization0))) +
                      (uint128(uint64(-int64(poolUtilization1 == 0 ? 1 : poolUtilization1))) << 64);
      
                  return
                      strangleRequired = _getRequiredCollateralSingleLegNoPartner(
                          tokenId,
                          index,
                          positionSize,
                          atTick,
                          poolUtilization
                      );
              }
          }
      }
      

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

378:     /// @notice Compute the total amount of premium accumulated for a list of positions.
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

424:     /// @notice Calculate the accumulated premia owed from the option buyer to the option seller.
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

1395:     /// @notice Get the collateral token corresponding to token0 of the AMM pool.
          /// @return collateralToken Collateral token corresponding to token0 in the AMM
          function collateralToken0() external view returns (CollateralTracker collateralToken) {
              return s_collateralToken0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

783:             // NOTE: upstream users of this function such as the Panoptic Pool should ensure users always compensate for the ITM amount delta
                 // the netting swap is not perfectly accurate, and it is possible for swaps to run out of liquidity, so we do not want to rely on it
                 // this is simply a convenience feature, and should be treated as such
                 if ((itm0 != 0) && (itm1 != 0)) {
                     (uint160 sqrtPriceX96, , , , , , ) = _univ3pool.slot0();
     
                     // implement a single "netting" swap. Thank you @danrobinson for this puzzle/idea
                     // NOTE: negative ITM amounts denote a surplus of tokens (burning liquidity), while positive amounts denote a shortage of tokens (minting liquidity)
                     // compute the approximate delta of token0 that should be resolved in the swap at the current tick
                     // we do this by flipping the signs on the token1 ITM amount converting+deducting it against the token0 ITM amount
                     // couple examples (price = 2 1/0):
                     //  - 100 surplus 0, 100 surplus 1 (itm0 = -100, itm1 = -100)
                     //    normal swap 0: 100 0 => 200 1
                     //    normal swap 1: 100 1 => 50 0
                     //    final swap amounts: 50 0 => 100 1
                     //    netting swap: net0 = -100 - (-100/2) = -50, ZF1 = true, 50 0 => 100 1
                     // - 100 surplus 0, 100 shortage 1 (itm0 = -100, itm1 = 100)
                     //    normal swap 0: 100 0 => 200 1
                     //    normal swap 1: 50 0 => 100 1
                     //    final swap amounts: 150 0 => 300 1
                     //    netting swap: net0 = -100 - (100/2) = -150, ZF1 = true, 150 0 => 300 1
                     // - 100 shortage 0, 100 surplus 1 (itm0 = 100, itm1 = -100)
                     //    normal swap 0: 200 1 => 100 0
                     //    normal swap 1: 100 1 => 50 0
                     //    final swap amounts: 300 1 => 150 0
                     //    netting swap: net0 = 100 - (-100/2) = 150, ZF1 = false, 300 1 => 150 0
                     // - 100 shortage 0, 100 shortage 1 (itm0 = 100, itm1 = 100)
                     //    normal swap 0: 200 1 => 100 0
                     //    normal swap 1: 50 0 => 100 1
                     //    final swap amounts: 100 1 => 50 0
                     //    netting swap: net0 = 100 - (100/2) = 50, ZF1 = false, 100 1 => 50 0
                     // - = Net surplus of token0
                     // + = Net shortage of token0
                     int256 net0 = itm0 - PanopticMath.convert1to0(itm1, sqrtPriceX96);
     
                     zeroForOne = net0 < 0;
     
                     //compute the swap amount, set as positive (exact input)
                     swapAmount = -net0;
                 } else if (itm0 != 0) {
                     zeroForOne = itm0 < 0;
                     swapAmount = -itm0;
                 } else {
                     zeroForOne = itm1 > 0;
                     swapAmount = -itm1;
                 }
     
                 // NOTE: can occur if itm0 and itm1 have the same value
                 // in that case, swapping would be pointless so skip
                 if (swapAmount == 0) return LeftRightSigned.wrap(0);
     
                 // swap tokens in the Uniswap pool
                 // NOTE: this triggers our swap callback function
                 (int256 swap0, int256 swap1) = _univ3pool.swap(
                     msg.sender,
                     zeroForOne,
                     swapAmount,
                     zeroForOne
                         ? Constants.MIN_V3POOL_SQRT_RATIO + 1
                         : Constants.MAX_V3POOL_SQRT_RATIO - 1,
                     data
                 );
     
                 // Add amounts swapped to totalSwapped variable
                 totalSwapped = LeftRightSigned.wrap(0).toRightSlot(swap0.toInt128()).toLeftSlot(
                     swap1.toInt128()
                 );
             }
         }
     
         /// @notice Create the position in the AMM given in the tokenId.
         /// @dev Loops over each leg in the tokenId and calls _createLegInAMM for each, which does the mint/burn in the AMM.
         /// @param univ3pool The Uniswap pool
         /// @param tokenId The option position
         /// @param positionSize The size of the option position
         /// @param isBurn Whether a position is being minted (true) or burned (false)
         /// @return totalMoved The net amount of funds moved to/from Uniswap
         /// @return collectedByLeg An array of LeftRight encoded words containing the amount of token0 and token1 collected as fees for each leg
         /// @return itmAmounts The amount of tokens swapped due to legs being in-the-money

1556: 

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/Math.sol

334:     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0.
         /// @param a The multiplicand
         /// @param b The multiplier
         /// @param denominator The divisor
         /// @return result The 256-bit result
         /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
         function mulDiv(
             uint256 a,
             uint256 b,
             uint256 denominator
         ) internal pure returns (uint256 result) {
             unchecked {
                 // 512-bit multiply [prod1 prod0] = a * b
                 // Compute the product mod 2**256 and mod 2**256 - 1
                 // then use the Chinese Remainder Theorem to reconstruct
                 // the 512 bit result. The result is stored in two 256
                 // variables such that product = prod1 * 2**256 + prod0
                 uint256 prod0; // Least significant 256 bits of the product
                 uint256 prod1; // Most significant 256 bits of the product
                 assembly ("memory-safe") {
                     let mm := mulmod(a, b, not(0))
                     prod0 := mul(a, b)
                     prod1 := sub(sub(mm, prod0), lt(mm, prod0))
                 }
     
                 // Handle non-overflow cases, 256 by 256 division
                 if (prod1 == 0) {
                     require(denominator > 0);
                     assembly ("memory-safe") {
                         result := div(prod0, denominator)
                     }
                     return result;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

646:     /// @notice Check that the account is liquidatable, get the split of bonus0 and bonus1 amounts.
         /// @param tokenData0 Leftright encoded word with balance of token0 in the right slot, and required balance in left slot
         /// @param tokenData1 Leftright encoded word with balance of token1 in the right slot, and required balance in left slot
         /// @param sqrtPriceX96Twap The sqrt(price) of the TWAP tick before liquidation used to evaluate solvency
         /// @param sqrtPriceX96Final The current sqrt(price) of the AMM after liquidating a user
         /// @param netExchanged The net exchanged value of the closed portfolio
         /// @param premia Premium across all positions being liquidated present in tokenData
         /// @return bonus0 Bonus amount for token0
         /// @return bonus1 Bonus amount for token1
         /// @return The LeftRight-packed protocol loss for both tokens, i.e., the delta between the user's balance and expended tokens
         function getLiquidationBonus(
             LeftRightUnsigned tokenData0,
             LeftRightUnsigned tokenData1,
             uint160 sqrtPriceX96Twap,
             uint160 sqrtPriceX96Final,
             LeftRightSigned netExchanged,
             LeftRightSigned premia
         ) external pure returns (int256 bonus0, int256 bonus1, LeftRightSigned) {
             unchecked {
                 // compute bonus as min(collateralBalance/2, required-collateralBalance)
                 {
                     // compute the ratio of token0 to total collateral requirements
                     // evaluate at TWAP price to keep consistentcy with solvency calculations
                     uint256 required0 = PanopticMath.convert0to1(
                         tokenData0.leftSlot(),
                         sqrtPriceX96Twap
                     );
                     uint256 required1 = tokenData1.leftSlot();
     
                     uint256 requiredRatioX128 = Math.mulDiv(required0, 2 ** 128, required0 + required1);
     
                     (uint256 balanceCross, uint256 thresholdCross) = PanopticMath.convertCollateralData(
                         tokenData0,
                         tokenData1,
                         0,
                         sqrtPriceX96Twap
                     );
     
                     uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);
     
                     // convert that bonus to tokens 0 and 1
                     bonus0 = int256(Math.mulDiv128(bonusCross, requiredRatioX128));
     
                     bonus1 = int256(
                         PanopticMath.convert0to1(
                             Math.mulDiv128(bonusCross, 2 ** 128 - requiredRatioX128),
                             sqrtPriceX96Final
                         )
                     );
                 }
     
                 // negative premium (owed to the liquidatee) is credited to the collateral balance
                 // this is already present in the netExchanged amount, so to avoid double-counting we remove it from the balance
                 int256 balance0 = int256(uint256(tokenData0.rightSlot())) -
                     Math.max(premia.rightSlot(), 0);
                 int256 balance1 = int256(uint256(tokenData1.rightSlot())) -
                     Math.max(premia.leftSlot(), 0);
     
                 int256 paid0 = bonus0 + int256(netExchanged.rightSlot());
                 int256 paid1 = bonus1 + int256(netExchanged.leftSlot());
     
                 // note that "balance0" and "balance1" are the liquidatee's original balances before token delegation by a liquidator
                 // their actual balances at the time of computation may be higher, but these are a buffer representing the amount of tokens we
                 // have to work with before cutting into the liquidator's funds
                 if (!(paid0 > balance0 && paid1 > balance1)) {
                     // liquidatee cannot pay back the liquidator fully in either token, so no protocol loss can be avoided
                     if ((paid0 > balance0)) {
                         // liquidatee has insufficient token0 but some token1 left over, so we use what they have left to mitigate token0 losses
                         // we do this by substituting an equivalent value of token1 in our refund to the liquidator, plus a bonus, for the token0 we convert
                         // we want to convert the minimum amount of tokens required to achieve the lowest possible protocol loss (to avoid overpaying on the conversion bonus)
                         // the maximum level of protocol loss mitigation that can be achieved is the liquidatee's excess token1 balance: balance1 - paid1
                         // and paid0 - balance0 is the amount of token0 that the liquidatee is missing, i.e the protocol loss
                         // if the protocol loss is lower than the excess token1 balance, then we can fully mitigate the loss and we should only convert the loss amount
                         // if the protocol loss is higher than the excess token1 balance, we can only mitigate part of the loss, so we should convert only the excess token1 balance
                         // thus, the value converted should be min(balance1 - paid1, paid0 - balance0)
                         bonus1 += Math.min(
                             balance1 - paid1,
                             PanopticMath.convert0to1(paid0 - balance0, sqrtPriceX96Final)
                         );
                         bonus0 -= Math.min(
                             PanopticMath.convert1to0(balance1 - paid1, sqrtPriceX96Final),
                             paid0 - balance0
                         );
                     }
                     if ((paid1 > balance1)) {
                         // liquidatee has insufficient token1 but some token0 left over, so we use what they have left to mitigate token1 losses
                         // we do this by substituting an equivalent value of token0 in our refund to the liquidator, plus a bonus, for the token1 we convert
                         // we want to convert the minimum amount of tokens required to achieve the lowest possible protocol loss (to avoid overpaying on the conversion bonus)
                         // the maximum level of protocol loss mitigation that can be achieved is the liquidatee's excess token0 balance: balance0 - paid0
                         // and paid1 - balance1 is the amount of token1 that the liquidatee is missing, i.e the protocol loss
                         // if the protocol loss is lower than the excess token0 balance, then we can fully mitigate the loss and we should only convert the loss amount
                         // if the protocol loss is higher than the excess token0 balance, we can only mitigate part of the loss, so we should convert only the excess token0 balance
                         // thus, the value converted should be min(balance0 - paid0, paid1 - balance1)
                         bonus0 += Math.min(
                             balance0 - paid0,
                             PanopticMath.convert1to0(paid1 - balance1, sqrtPriceX96Final)
                         );
                         bonus1 -= Math.min(
                             PanopticMath.convert0to1(balance0 - paid0, sqrtPriceX96Final),
                             paid1 - balance1
                         );
                     }
                 }
     
                 paid0 = bonus0 + int256(netExchanged.rightSlot());
                 paid1 = bonus1 + int256(netExchanged.leftSlot());
                 return (
                     bonus0,
                     bonus1,
                     LeftRightSigned.wrap(0).toRightSlot(int128(balance0 - paid0)).toLeftSlot(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/types/LeftRight.sol

189:     /// @notice Add two LeftRight-encoded words; revert on overflow or underflow.
         /// @param x The augend
         /// @param y The addend
         /// @return z The sum `x + y`
         function add(LeftRightUnsigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {
             unchecked {
                 int256 left = int256(uint256(x.leftSlot())) + y.leftSlot();
                 int128 left128 = int128(left);
     
                 if (left128 != left) revert Errors.UnderOverFlow();
     
                 int256 right = int256(uint256(x.rightSlot())) + y.rightSlot();
                 int128 right128 = int128(right);
     
                 if (right128 != right) revert Errors.UnderOverFlow();
     
                 return z.toRightSlot(right128).toLeftSlot(left128);

209:     /// @notice Add two LeftRight-encoded words; revert on overflow or underflow.
         /// @param x The augend
         /// @param y The addend
         /// @return z The sum `x + y`
         function add(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {
             unchecked {
                 int256 left256 = int256(x.leftSlot()) + y.leftSlot();
                 int128 left128 = int128(left256);
     
                 int256 right256 = int256(x.rightSlot()) + y.rightSlot();
                 int128 right128 = int128(right256);
     
                 if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();
     
                 return z.toRightSlot(right128).toLeftSlot(left128);

227:     /// @notice Subtract two LeftRight-encoded words; revert on overflow or underflow.
         /// @param x The minuend
         /// @param y The subtrahend
         /// @return z The difference `x - y`
         function sub(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {
             unchecked {
                 int256 left256 = int256(x.leftSlot()) - y.leftSlot();
                 int128 left128 = int128(left256);
     
                 int256 right256 = int256(x.rightSlot()) - y.rightSlot();
                 int128 right128 = int128(right256);
     
                 if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();
     
                 return z.toRightSlot(right128).toLeftSlot(left128);

245:     /// @notice Subtract two LeftRight-encoded words; revert on overflow or underflow.
         /// @notice FOr each slot, rectify difference `x - y` to 0 if negative.
         /// @param x The minuend
         /// @param y The subtrahend
         /// @return z The difference `x - y`
         function subRect(
             LeftRightSigned x,
             LeftRightSigned y
         ) internal pure returns (LeftRightSigned z) {
             unchecked {
                 int256 left256 = int256(x.leftSlot()) - y.leftSlot();
                 int128 left128 = int128(left256);
     
                 int256 right256 = int256(x.rightSlot()) - y.rightSlot();
                 int128 right128 = int128(right256);
     
                 if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();
     
                 return

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

### <a name="NC-19"></a>[NC-19] `require()` / `revert()` statements should have descriptive reason strings

*Instances (71)*:

```solidity
File: contracts/CollateralTracker.sol

168:         if (msg.sender != address(s_panopticPool)) revert Errors.NotPanopticPool();

218:         if (s_initialized) revert Errors.CollateralTokenAlreadyInitialized();

315:         if (s_panopticPool.numberOfPositions(msg.sender) != 0) revert Errors.PositionCountNotZero();

334:         if (s_panopticPool.numberOfPositions(from) != 0) revert Errors.PositionCountNotZero();

402:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

462:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

518:         if (assets > maxWithdraw(owner)) revert Errors.ExceedsMaximumRedemption();

625:         if (shares > maxRedeem(owner)) revert Errors.ExceedsMaximumRedemption();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

183:         if (address(v3Pool) == address(0)) revert Errors.UniswapPoolNotInitialized();

186:             revert Errors.PoolAlreadyInitialized();

230:         if (amount0 > amount0Max || amount1 > amount1Max) revert Errors.PriceBoundFail();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

291:         if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

335:         ) revert Errors.NotEnoughCollateral();

609:             revert Errors.InvalidTokenIdParameter(0);

614:             revert Errors.PositionAlreadyMinted();

905:         if (!solventAtFast) revert Errors.NotEnoughCollateral();

910:                 revert Errors.NotEnoughCollateral();

1004:                 revert Errors.StaleTWAP();

1034:             if (balanceCross >= thresholdCross) revert Errors.NotMarginCalled();

1131:         ) revert Errors.NotEnoughCollateral();

1155:         if (touchedId.length != 1) revert Errors.InputListFail();

1360:         if (fingerprintIncomingList != currentHash) revert Errors.InputListFail();

1381:         if ((newHash >> 248) > MAX_POSITIONS) revert Errors.TooManyPositionsOpen();

1459:             revert Errors.EffectiveLiquidityAboveThreshold();

1561:         if (tokenId.isLong(legIndex) == 0 || legIndex > 3) revert Errors.NotALongLeg();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

344:         FACTORY = _factory;

370:         // There are 281,474,976,710,655 possible pool patterns.

568:     function safeBatchTransferFrom(

595:     function registerTokenTransfer(address from, address to, TokenId id, uint256 amount) internal {

650:                 ++leg;

659:     /// @notice Helper that checks the proposed option position and size and forwards the minting and potential swapping tasks.

716:             if ((LeftRightSigned.unwrap(itmAmounts) != 0)) {

730:     /// @notice Called to perform an ITM swap in the Uniswap pool to resolve any non-tokenType token deltas.

750:     //   If we take token0 as an example, we deploy it to the AMM pool and *then* swap to get the right mix of token0 and token1

961:     )

1043:                 Selling(isLong=0): Mint chunk of liquidity in Uniswap (defined by upper tick, lower tick, and amount)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

37:             revert Errors.InvalidUniswapCallback();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Math.sol

131:             if (absTick > uint256(int256(Constants.MAX_V3POOL_TICK))) revert Errors.InvalidTick();

297:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) revert Errors.CastingError();

312:         if ((downcastedInt = int128(toCast)) < 0) revert Errors.CastingError();

319:         if (!((downcastedInt = int128(toCast)) == toCast)) revert Errors.CastingError();

326:         if (toCast > uint256(type(int256).max)) revert Errors.CastingError();

361:                 require(denominator > 0);

370:             require(denominator > prod1);

448:                 require(result < type(uint256).max);

484:             require(2 ** 64 > prod1);

547:             require(2 ** 96 > prod1);

588:                 require(result < type(uint256).max);

624:             require(2 ** 128 > prod1);

665:                 require(result < type(uint256).max);

701:             require(2 ** 192 > prod1);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

400:     /// @notice Returns the distances of the upper and lower ticks from the strike for a position with the given width and tickSpacing.

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

45:         if (!success) revert Errors.TransferFailed();

75:         if (!success) revert Errors.TransferFailed();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/LeftRight.sol

162:             ) revert Errors.UnderOverFlow();

185:             ) revert Errors.UnderOverFlow();

198:             if (left128 != left) revert Errors.UnderOverFlow();

203:             if (right128 != right) revert Errors.UnderOverFlow();

221:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

239:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

261:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/TokenId.sol

501:         if (self.optionRatio(0) == 0) revert Errors.InvalidTokenIdParameter(1);

513:                         revert Errors.InvalidTokenIdParameter(1);

522:                         revert Errors.InvalidTokenIdParameter(6);

528:                 if ((self.width(i) == 0)) revert Errors.InvalidTokenIdParameter(5);

533:                 ) revert Errors.InvalidTokenIdParameter(4);

542:                         revert Errors.InvalidTokenIdParameter(3);

548:                     ) revert Errors.InvalidTokenIdParameter(3);

561:                         revert Errors.InvalidTokenIdParameter(4);

567:                         revert Errors.InvalidTokenIdParameter(5);

598:         revert Errors.NoLegsExercisable();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-20"></a>[NC-20] Take advantage of Custom Error's return value property

An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (57)*:

```solidity
File: contracts/CollateralTracker.sol

168:         if (msg.sender != address(s_panopticPool)) revert Errors.NotPanopticPool();

218:         if (s_initialized) revert Errors.CollateralTokenAlreadyInitialized();

315:         if (s_panopticPool.numberOfPositions(msg.sender) != 0) revert Errors.PositionCountNotZero();

334:         if (s_panopticPool.numberOfPositions(from) != 0) revert Errors.PositionCountNotZero();

402:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

462:         if (assets > type(uint104).max) revert Errors.DepositTooLarge();

518:         if (assets > maxWithdraw(owner)) revert Errors.ExceedsMaximumRedemption();

625:         if (shares > maxRedeem(owner)) revert Errors.ExceedsMaximumRedemption();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

183:         if (address(v3Pool) == address(0)) revert Errors.UniswapPoolNotInitialized();

186:             revert Errors.PoolAlreadyInitialized();

230:         if (amount0 > amount0Max || amount1 > amount1Max) revert Errors.PriceBoundFail();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

291:         if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

335:         ) revert Errors.NotEnoughCollateral();

614:             revert Errors.PositionAlreadyMinted();

905:         if (!solventAtFast) revert Errors.NotEnoughCollateral();

910:                 revert Errors.NotEnoughCollateral();

1004:                 revert Errors.StaleTWAP();

1034:             if (balanceCross >= thresholdCross) revert Errors.NotMarginCalled();

1131:         ) revert Errors.NotEnoughCollateral();

1155:         if (touchedId.length != 1) revert Errors.InputListFail();

1360:         if (fingerprintIncomingList != currentHash) revert Errors.InputListFail();

1381:         if ((newHash >> 248) > MAX_POSITIONS) revert Errors.TooManyPositionsOpen();

1459:             revert Errors.EffectiveLiquidityAboveThreshold();

1561:         if (tokenId.isLong(legIndex) == 0 || legIndex > 3) revert Errors.NotALongLeg();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

324:         if (s_poolContext[poolId].locked) revert Errors.ReentrantCall();

357:         if (univ3pool == address(0)) revert Errors.UniswapPoolNotInitialized();

551:         if (s_poolContext[TokenId.wrap(id).poolId()].locked) revert Errors.ReentrantCall();

578:             if (s_poolContext[TokenId.wrap(ids[i]).poolId()].locked) revert Errors.ReentrantCall();

633:             ) revert Errors.TransferFailed();

638:                 revert Errors.TransferFailed();

687:         if (positionSize == 0) revert Errors.OptionsBalanceZero();

701:         if (univ3pool == IUniswapV3Pool(address(0))) revert Errors.UniswapPoolNotInitialized();

727:             revert Errors.PriceBoundFail();

937:             revert Errors.PositionTooLarge();

1015:                     revert Errors.NotEnoughLiquidity();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

37:             revert Errors.InvalidUniswapCallback();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Math.sol

131:             if (absTick > uint256(int256(Constants.MAX_V3POOL_TICK))) revert Errors.InvalidTick();

297:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) revert Errors.CastingError();

312:         if ((downcastedInt = int128(toCast)) < 0) revert Errors.CastingError();

319:         if (!((downcastedInt = int128(toCast)) == toCast)) revert Errors.CastingError();

326:         if (toCast > uint256(type(int256).max)) revert Errors.CastingError();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

396:             ) revert Errors.TicksNotInitializable();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

45:         if (!success) revert Errors.TransferFailed();

75:         if (!success) revert Errors.TransferFailed();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

101:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

117:                 revert UnsafeRecipient();

137:         if (!(msg.sender == from || isApprovedForAll[from][msg.sender])) revert NotAuthorized();

168:                 revert UnsafeRecipient();

227:                 revert UnsafeRecipient();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/types/LeftRight.sol

162:             ) revert Errors.UnderOverFlow();

185:             ) revert Errors.UnderOverFlow();

198:             if (left128 != left) revert Errors.UnderOverFlow();

203:             if (right128 != right) revert Errors.UnderOverFlow();

221:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

239:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

261:             if (left128 != left256 || right128 != right256) revert Errors.UnderOverFlow();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/TokenId.sol

598:         revert Errors.NoLegsExercisable();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-21"></a>[NC-21] Use scientific notation (e.g. `1e18`) rather than exponentiation (e.g. `10**18`)

While this won't save gas in the recent solidity versions, this is shorter and more readable (this is especially true in calculations).

*Instances (1)*:

```solidity
File: contracts/CollateralTracker.sol

223:         totalSupply = 10 ** 6;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="NC-22"></a>[NC-22] Strings should use double quotes rather than single quotes

See the Solidity Style Guide: <https://docs.soliditylang.org/en/v0.8.20/style-guide.html#other-recommendations>

*Instances (15)*:

```solidity
File: contracts/CollateralTracker.sol

893:                      │(1) convert 'assets' to shares (this ERC20 contract)

940:                      │(1) convert 'assets' to shares (this ERC20 contract)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/base/FactoryNFT.sol

77:                                 '{"name":"',

87:                                 '", "description":"',

97:                                 '", "attributes": [{',

98:                                 '"trait_type": "Rarity", "value": "',

104:                                 '"}, {"trait_type": "Strategy", "value": "',

106:                                 '"}, {"trait_type": "ChainId", "value": "',

108:                                 '"}]',

109:                                 '", "image": "',

112:                                 '"}'

231:                 '<g transform="translate(-',

233:                 ', 0)">',

254:             '<g transform="scale(0.0',

258:             ', 0)">',

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

### <a name="NC-23"></a>[NC-23] Contract does not follow the Solidity style guide's suggested layout ordering

The [style guide](https://docs.soliditylang.org/en/v0.8.16/style-guide.html#order-of-layout) says that, within a contract, the ordering should be:

1) Type declarations
2) State variables
3) Events
4) Modifiers
5) Functions

However, the contract(s) below do not follow this ordering

*Instances (6)*:

```solidity
File: contracts/CollateralTracker.sol

1: 
   Current order:
   UsingForDirective.Math
   EventDefinition.Deposit
   EventDefinition.Withdraw
   VariableDeclaration.TICKER_PREFIX
   VariableDeclaration.NAME_PREFIX
   VariableDeclaration.DECIMALS
   VariableDeclaration.DECIMALS_128
   VariableDeclaration.s_underlyingToken
   VariableDeclaration.s_initialized
   VariableDeclaration.s_univ3token0
   VariableDeclaration.s_univ3token1
   VariableDeclaration.s_underlyingIsToken0
   VariableDeclaration.s_panopticPool
   VariableDeclaration.s_poolAssets
   VariableDeclaration.s_inAMM
   VariableDeclaration.s_ITMSpreadFee
   VariableDeclaration.s_poolFee
   VariableDeclaration.COMMISSION_FEE
   VariableDeclaration.SELLER_COLLATERAL_RATIO
   VariableDeclaration.BUYER_COLLATERAL_RATIO
   VariableDeclaration.FORCE_EXERCISE_COST
   VariableDeclaration.TARGET_POOL_UTIL
   VariableDeclaration.SATURATED_POOL_UTIL
   VariableDeclaration.ITM_SPREAD_MULTIPLIER
   ModifierDefinition.onlyPanopticPool
   FunctionDefinition.constructor
   FunctionDefinition.startToken
   FunctionDefinition.getPoolData
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.decimals
   FunctionDefinition.transfer
   FunctionDefinition.transferFrom
   FunctionDefinition.asset
   FunctionDefinition.totalAssets
   FunctionDefinition.convertToShares
   FunctionDefinition.convertToAssets
   FunctionDefinition.maxDeposit
   FunctionDefinition.previewDeposit
   FunctionDefinition.deposit
   FunctionDefinition.maxMint
   FunctionDefinition.previewMint
   FunctionDefinition.mint
   FunctionDefinition.maxWithdraw
   FunctionDefinition.previewWithdraw
   FunctionDefinition.withdraw
   FunctionDefinition.withdraw
   FunctionDefinition.maxRedeem
   FunctionDefinition.previewRedeem
   FunctionDefinition.redeem
   FunctionDefinition.exerciseCost
   FunctionDefinition._poolUtilization
   FunctionDefinition._sellCollateralRatio
   FunctionDefinition._buyCollateralRatio
   FunctionDefinition.delegate
   FunctionDefinition.delegate
   FunctionDefinition.refund
   FunctionDefinition.revoke
   FunctionDefinition.refund
   FunctionDefinition.takeCommissionAddData
   FunctionDefinition.exercise
   FunctionDefinition._getExchangedAmount
   FunctionDefinition.getAccountMarginDetails
   FunctionDefinition._getAccountMargin
   FunctionDefinition._getTotalRequiredCollateral
   FunctionDefinition._getRequiredCollateralAtTickSinglePosition
   FunctionDefinition._getRequiredCollateralSingleLeg
   FunctionDefinition._getRequiredCollateralSingleLegNoPartner
   FunctionDefinition._getRequiredCollateralSingleLegPartner
   FunctionDefinition._getRequiredCollateralAtUtilization
   FunctionDefinition._computeSpread
   FunctionDefinition._computeStrangle
   
   Suggested order:
   UsingForDirective.Math
   VariableDeclaration.TICKER_PREFIX
   VariableDeclaration.NAME_PREFIX
   VariableDeclaration.DECIMALS
   VariableDeclaration.DECIMALS_128
   VariableDeclaration.s_underlyingToken
   VariableDeclaration.s_initialized
   VariableDeclaration.s_univ3token0
   VariableDeclaration.s_univ3token1
   VariableDeclaration.s_underlyingIsToken0
   VariableDeclaration.s_panopticPool
   VariableDeclaration.s_poolAssets
   VariableDeclaration.s_inAMM
   VariableDeclaration.s_ITMSpreadFee
   VariableDeclaration.s_poolFee
   VariableDeclaration.COMMISSION_FEE
   VariableDeclaration.SELLER_COLLATERAL_RATIO
   VariableDeclaration.BUYER_COLLATERAL_RATIO
   VariableDeclaration.FORCE_EXERCISE_COST
   VariableDeclaration.TARGET_POOL_UTIL
   VariableDeclaration.SATURATED_POOL_UTIL
   VariableDeclaration.ITM_SPREAD_MULTIPLIER
   EventDefinition.Deposit
   EventDefinition.Withdraw
   ModifierDefinition.onlyPanopticPool
   FunctionDefinition.constructor
   FunctionDefinition.startToken
   FunctionDefinition.getPoolData
   FunctionDefinition.name
   FunctionDefinition.symbol
   FunctionDefinition.decimals
   FunctionDefinition.transfer
   FunctionDefinition.transferFrom
   FunctionDefinition.asset
   FunctionDefinition.totalAssets
   FunctionDefinition.convertToShares
   FunctionDefinition.convertToAssets
   FunctionDefinition.maxDeposit
   FunctionDefinition.previewDeposit
   FunctionDefinition.deposit
   FunctionDefinition.maxMint
   FunctionDefinition.previewMint
   FunctionDefinition.mint
   FunctionDefinition.maxWithdraw
   FunctionDefinition.previewWithdraw
   FunctionDefinition.withdraw
   FunctionDefinition.withdraw
   FunctionDefinition.maxRedeem
   FunctionDefinition.previewRedeem
   FunctionDefinition.redeem
   FunctionDefinition.exerciseCost
   FunctionDefinition._poolUtilization
   FunctionDefinition._sellCollateralRatio
   FunctionDefinition._buyCollateralRatio
   FunctionDefinition.delegate
   FunctionDefinition.delegate
   FunctionDefinition.refund
   FunctionDefinition.revoke
   FunctionDefinition.refund
   FunctionDefinition.takeCommissionAddData
   FunctionDefinition.exercise
   FunctionDefinition._getExchangedAmount
   FunctionDefinition.getAccountMarginDetails
   FunctionDefinition._getAccountMargin
   FunctionDefinition._getTotalRequiredCollateral
   FunctionDefinition._getRequiredCollateralAtTickSinglePosition
   FunctionDefinition._getRequiredCollateralSingleLeg
   FunctionDefinition._getRequiredCollateralSingleLegNoPartner
   FunctionDefinition._getRequiredCollateralSingleLegPartner
   FunctionDefinition._getRequiredCollateralAtUtilization
   FunctionDefinition._computeSpread
   FunctionDefinition._computeStrangle

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

1: 
   Current order:
   EventDefinition.PoolDeployed
   UsingForDirective.Clones
   VariableDeclaration.UNIV3_FACTORY
   VariableDeclaration.SFPM
   VariableDeclaration.POOL_REFERENCE
   VariableDeclaration.COLLATERAL_REFERENCE
   VariableDeclaration.WETH
   VariableDeclaration.FULL_RANGE_LIQUIDITY_AMOUNT_WETH
   VariableDeclaration.FULL_RANGE_LIQUIDITY_AMOUNT_TOKEN
   VariableDeclaration.CARDINALITY_INCREASE
   VariableDeclaration.s_getPanopticPool
   FunctionDefinition.constructor
   FunctionDefinition.uniswapV3MintCallback
   FunctionDefinition.deployNewPool
   FunctionDefinition.minePoolAddress
   FunctionDefinition._mintFullRange
   FunctionDefinition.getPanopticPool
   
   Suggested order:
   UsingForDirective.Clones
   VariableDeclaration.UNIV3_FACTORY
   VariableDeclaration.SFPM
   VariableDeclaration.POOL_REFERENCE
   VariableDeclaration.COLLATERAL_REFERENCE
   VariableDeclaration.WETH
   VariableDeclaration.FULL_RANGE_LIQUIDITY_AMOUNT_WETH
   VariableDeclaration.FULL_RANGE_LIQUIDITY_AMOUNT_TOKEN
   VariableDeclaration.CARDINALITY_INCREASE
   VariableDeclaration.s_getPanopticPool
   EventDefinition.PoolDeployed
   FunctionDefinition.constructor
   FunctionDefinition.uniswapV3MintCallback
   FunctionDefinition.deployNewPool
   FunctionDefinition.minePoolAddress
   FunctionDefinition._mintFullRange
   FunctionDefinition.getPanopticPool

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

1: 
   Current order:
   EventDefinition.AccountLiquidated
   EventDefinition.ForcedExercised
   EventDefinition.PremiumSettled
   EventDefinition.OptionBurnt
   EventDefinition.OptionMinted
   VariableDeclaration.MIN_SWAP_TICK
   VariableDeclaration.MAX_SWAP_TICK
   VariableDeclaration.COMPUTE_ALL_PREMIA
   VariableDeclaration.COMPUTE_LONG_PREMIA
   VariableDeclaration.ONLY_AVAILABLE_PREMIUM
   VariableDeclaration.COMMIT_LONG_SETTLED
   VariableDeclaration.DONOT_COMMIT_LONG_SETTLED
   VariableDeclaration.ADD
   VariableDeclaration.TWAP_WINDOW
   VariableDeclaration.SLOW_ORACLE_UNISWAP_MODE
   VariableDeclaration.MEDIAN_PERIOD
   VariableDeclaration.FAST_ORACLE_CARDINALITY
   VariableDeclaration.FAST_ORACLE_PERIOD
   VariableDeclaration.SLOW_ORACLE_CARDINALITY
   VariableDeclaration.SLOW_ORACLE_PERIOD
   VariableDeclaration.MAX_TWAP_DELTA_LIQUIDATION
   VariableDeclaration.MAX_SLOW_FAST_DELTA
   VariableDeclaration.MAX_SPREAD
   VariableDeclaration.MAX_POSITIONS
   VariableDeclaration.BP_DECREASE_BUFFER
   VariableDeclaration.NO_BUFFER
   VariableDeclaration.SFPM
   VariableDeclaration.s_univ3pool
   VariableDeclaration.s_miniMedian
   VariableDeclaration.s_collateralToken0
   VariableDeclaration.s_collateralToken1
   VariableDeclaration.s_options
   VariableDeclaration.s_grossPremiumLast
   VariableDeclaration.s_settledTokens
   VariableDeclaration.s_positionBalance
   VariableDeclaration.s_positionsHash
   FunctionDefinition.constructor
   FunctionDefinition.startPool
   FunctionDefinition.assertMinCollateralValues
   FunctionDefinition.validateCollateralWithdrawable
   FunctionDefinition.optionPositionBalance
   FunctionDefinition.calculateAccumulatedFeesBatch
   FunctionDefinition.calculatePortfolioValue
   FunctionDefinition._calculateAccumulatedPremia
   FunctionDefinition.pokeMedian
   FunctionDefinition.mintOptions
   FunctionDefinition.burnOptions
   FunctionDefinition.burnOptions
   FunctionDefinition._mintOptions
   FunctionDefinition._mintInSFPMAndUpdateCollateral
   FunctionDefinition._payCommissionAndWriteData
   FunctionDefinition._addUserOption
   FunctionDefinition._burnAllOptionsFrom
   FunctionDefinition._burnOptions
   FunctionDefinition._updatePositionDataBurn
   FunctionDefinition._validateSolvency
   FunctionDefinition._burnAndHandleExercise
   FunctionDefinition.liquidate
   FunctionDefinition.forceExercise
   FunctionDefinition._checkSolvencyAtTick
   FunctionDefinition._getSolvencyBalances
   FunctionDefinition._validatePositionList
   FunctionDefinition._updatePositionsHash
   FunctionDefinition.univ3pool
   FunctionDefinition.collateralToken0
   FunctionDefinition.collateralToken1
   FunctionDefinition.numberOfPositions
   FunctionDefinition.getUniV3TWAP
   FunctionDefinition._checkLiquiditySpread
   FunctionDefinition._getPremia
   FunctionDefinition.settleLongPremium
   FunctionDefinition._updateSettlementPostMint
   FunctionDefinition._getAvailablePremium
   FunctionDefinition._getTotalLiquidity
   FunctionDefinition._updateSettlementPostBurn
   
   Suggested order:
   VariableDeclaration.MIN_SWAP_TICK
   VariableDeclaration.MAX_SWAP_TICK
   VariableDeclaration.COMPUTE_ALL_PREMIA
   VariableDeclaration.COMPUTE_LONG_PREMIA
   VariableDeclaration.ONLY_AVAILABLE_PREMIUM
   VariableDeclaration.COMMIT_LONG_SETTLED
   VariableDeclaration.DONOT_COMMIT_LONG_SETTLED
   VariableDeclaration.ADD
   VariableDeclaration.TWAP_WINDOW
   VariableDeclaration.SLOW_ORACLE_UNISWAP_MODE
   VariableDeclaration.MEDIAN_PERIOD
   VariableDeclaration.FAST_ORACLE_CARDINALITY
   VariableDeclaration.FAST_ORACLE_PERIOD
   VariableDeclaration.SLOW_ORACLE_CARDINALITY
   VariableDeclaration.SLOW_ORACLE_PERIOD
   VariableDeclaration.MAX_TWAP_DELTA_LIQUIDATION
   VariableDeclaration.MAX_SLOW_FAST_DELTA
   VariableDeclaration.MAX_SPREAD
   VariableDeclaration.MAX_POSITIONS
   VariableDeclaration.BP_DECREASE_BUFFER
   VariableDeclaration.NO_BUFFER
   VariableDeclaration.SFPM
   VariableDeclaration.s_univ3pool
   VariableDeclaration.s_miniMedian
   VariableDeclaration.s_collateralToken0
   VariableDeclaration.s_collateralToken1
   VariableDeclaration.s_options
   VariableDeclaration.s_grossPremiumLast
   VariableDeclaration.s_settledTokens
   VariableDeclaration.s_positionBalance
   VariableDeclaration.s_positionsHash
   EventDefinition.AccountLiquidated
   EventDefinition.ForcedExercised
   EventDefinition.PremiumSettled
   EventDefinition.OptionBurnt
   EventDefinition.OptionMinted
   FunctionDefinition.constructor
   FunctionDefinition.startPool
   FunctionDefinition.assertMinCollateralValues
   FunctionDefinition.validateCollateralWithdrawable
   FunctionDefinition.optionPositionBalance
   FunctionDefinition.calculateAccumulatedFeesBatch
   FunctionDefinition.calculatePortfolioValue
   FunctionDefinition._calculateAccumulatedPremia
   FunctionDefinition.pokeMedian
   FunctionDefinition.mintOptions
   FunctionDefinition.burnOptions
   FunctionDefinition.burnOptions
   FunctionDefinition._mintOptions
   FunctionDefinition._mintInSFPMAndUpdateCollateral
   FunctionDefinition._payCommissionAndWriteData
   FunctionDefinition._addUserOption
   FunctionDefinition._burnAllOptionsFrom
   FunctionDefinition._burnOptions
   FunctionDefinition._updatePositionDataBurn
   FunctionDefinition._validateSolvency
   FunctionDefinition._burnAndHandleExercise
   FunctionDefinition.liquidate
   FunctionDefinition.forceExercise
   FunctionDefinition._checkSolvencyAtTick
   FunctionDefinition._getSolvencyBalances
   FunctionDefinition._validatePositionList
   FunctionDefinition._updatePositionsHash
   FunctionDefinition.univ3pool
   FunctionDefinition.collateralToken0
   FunctionDefinition.collateralToken1
   FunctionDefinition.numberOfPositions
   FunctionDefinition.getUniV3TWAP
   FunctionDefinition._checkLiquiditySpread
   FunctionDefinition._getPremia
   FunctionDefinition.settleLongPremium
   FunctionDefinition._updateSettlementPostMint
   FunctionDefinition._getAvailablePremium
   FunctionDefinition._getTotalLiquidity
   FunctionDefinition._updateSettlementPostBurn

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

1: 
   Current order:
   EventDefinition.PoolInitialized
   EventDefinition.TokenizedPositionBurnt
   EventDefinition.TokenizedPositionMinted
   UsingForDirective.Math
   UsingForDirective.Math
   StructDefinition.PoolAddressAndLock
   VariableDeclaration.MINT
   VariableDeclaration.BURN
   VariableDeclaration.VEGOID
   VariableDeclaration.FACTORY
   VariableDeclaration.s_AddrToPoolIdData
   VariableDeclaration.s_poolContext
   VariableDeclaration.s_accountLiquidity
   VariableDeclaration.s_accountPremiumOwed
   VariableDeclaration.s_accountPremiumGross
   VariableDeclaration.s_accountFeesBase
   ModifierDefinition.ReentrancyLock
   FunctionDefinition.beginReentrancyLock
   FunctionDefinition.endReentrancyLock
   FunctionDefinition.constructor
   FunctionDefinition.initializeAMMPool
   FunctionDefinition.uniswapV3MintCallback
   FunctionDefinition.uniswapV3SwapCallback
   FunctionDefinition.burnTokenizedPosition
   FunctionDefinition.mintTokenizedPosition
   FunctionDefinition.safeTransferFrom
   FunctionDefinition.safeBatchTransferFrom
   FunctionDefinition.registerTokenTransfer
   FunctionDefinition._validateAndForwardToAMM
   FunctionDefinition.swapInAMM
   FunctionDefinition._createPositionInAMM
   FunctionDefinition._createLegInAMM
   FunctionDefinition._updateStoredPremia
   FunctionDefinition._getFeesBase
   FunctionDefinition._mintLiquidity
   FunctionDefinition._burnLiquidity
   FunctionDefinition._collectAndWritePositionData
   FunctionDefinition._getPremiaDeltas
   FunctionDefinition.getAccountLiquidity
   FunctionDefinition.getAccountPremium
   FunctionDefinition.getAccountFeesBase
   FunctionDefinition.getUniswapV3PoolFromId
   FunctionDefinition.getPoolId
   
   Suggested order:
   UsingForDirective.Math
   UsingForDirective.Math
   VariableDeclaration.MINT
   VariableDeclaration.BURN
   VariableDeclaration.VEGOID
   VariableDeclaration.FACTORY
   VariableDeclaration.s_AddrToPoolIdData
   VariableDeclaration.s_poolContext
   VariableDeclaration.s_accountLiquidity
   VariableDeclaration.s_accountPremiumOwed
   VariableDeclaration.s_accountPremiumGross
   VariableDeclaration.s_accountFeesBase
   StructDefinition.PoolAddressAndLock
   EventDefinition.PoolInitialized
   EventDefinition.TokenizedPositionBurnt
   EventDefinition.TokenizedPositionMinted
   ModifierDefinition.ReentrancyLock
   FunctionDefinition.beginReentrancyLock
   FunctionDefinition.endReentrancyLock
   FunctionDefinition.constructor
   FunctionDefinition.initializeAMMPool
   FunctionDefinition.uniswapV3MintCallback
   FunctionDefinition.uniswapV3SwapCallback
   FunctionDefinition.burnTokenizedPosition
   FunctionDefinition.mintTokenizedPosition
   FunctionDefinition.safeTransferFrom
   FunctionDefinition.safeBatchTransferFrom
   FunctionDefinition.registerTokenTransfer
   FunctionDefinition._validateAndForwardToAMM
   FunctionDefinition.swapInAMM
   FunctionDefinition._createPositionInAMM
   FunctionDefinition._createLegInAMM
   FunctionDefinition._updateStoredPremia
   FunctionDefinition._getFeesBase
   FunctionDefinition._mintLiquidity
   FunctionDefinition._burnLiquidity
   FunctionDefinition._collectAndWritePositionData
   FunctionDefinition._getPremiaDeltas
   FunctionDefinition.getAccountLiquidity
   FunctionDefinition.getAccountPremium
   FunctionDefinition.getAccountFeesBase
   FunctionDefinition.getUniswapV3PoolFromId
   FunctionDefinition.getPoolId

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

1: 
   Current order:
   EventDefinition.TransferSingle
   EventDefinition.TransferBatch
   EventDefinition.ApprovalForAll
   ErrorDefinition.NotAuthorized
   ErrorDefinition.UnsafeRecipient
   VariableDeclaration.balanceOf
   VariableDeclaration.isApprovedForAll
   FunctionDefinition.setApprovalForAll
   FunctionDefinition.safeTransferFrom
   FunctionDefinition.safeBatchTransferFrom
   FunctionDefinition.balanceOfBatch
   FunctionDefinition.supportsInterface
   FunctionDefinition._mint
   FunctionDefinition._burn
   
   Suggested order:
   VariableDeclaration.balanceOf
   VariableDeclaration.isApprovedForAll
   ErrorDefinition.NotAuthorized
   ErrorDefinition.UnsafeRecipient
   EventDefinition.TransferSingle
   EventDefinition.TransferBatch
   EventDefinition.ApprovalForAll
   FunctionDefinition.setApprovalForAll
   FunctionDefinition.safeTransferFrom
   FunctionDefinition.safeBatchTransferFrom
   FunctionDefinition.balanceOfBatch
   FunctionDefinition.supportsInterface
   FunctionDefinition._mint
   FunctionDefinition._burn

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

1: 
   Current order:
   EventDefinition.Transfer
   EventDefinition.Approval
   VariableDeclaration.totalSupply
   VariableDeclaration.balanceOf
   VariableDeclaration.allowance
   FunctionDefinition.approve
   FunctionDefinition.transfer
   FunctionDefinition.transferFrom
   FunctionDefinition._transferFrom
   FunctionDefinition._mint
   FunctionDefinition._burn
   
   Suggested order:
   VariableDeclaration.totalSupply
   VariableDeclaration.balanceOf
   VariableDeclaration.allowance
   EventDefinition.Transfer
   EventDefinition.Approval
   FunctionDefinition.approve
   FunctionDefinition.transfer
   FunctionDefinition.transferFrom
   FunctionDefinition._transferFrom
   FunctionDefinition._mint
   FunctionDefinition._burn

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

### <a name="NC-24"></a>[NC-24] Use Underscores for Number Literals (add an underscore every 3 digits)

*Instances (23)*:

```solidity
File: contracts/PanopticPool.sol

151:     int256 internal constant MAX_SLOW_FAST_DELTA = 1800;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/FactoryNFT.sol

186:         } else if (block.chainid == 42161) {

188:         } else if (block.chainid == 8453) {

190:         } else if (block.chainid == 43114) {

196:         } else if (block.chainid == 42220) {

270:             width = 1600;

272:             width = 1350;

274:             width = 1450;

276:             width = 1350;

278:             width = 1250;

280:             width = 1350;

282:             width = 1450;

284:             width = 1350;

286:             width = 1600;

326:             width = 9000;

328:             width = 3900;

330:             width = 9000;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Constants.sol

15:     int24 internal constant MAX_V3POOL_TICK = 887272;

18:     uint160 internal constant MIN_V3POOL_SQRT_RATIO = 4295128739;

22:         1461446703485210103287273052203988822378723970342;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Constants.sol)

```solidity
File: contracts/types/TokenId.sol

171:             return int24(int256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 36)) % 4096));

172:         } // "% 4096" = take last (2 ** 12 = 4096) 12 bits

320:                         (uint256(uint24(_width) % 4096) << (64 + legIndex * 48 + 36))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-25"></a>[NC-25] Internal and private variables and functions names should begin with an underscore

According to the Solidity Style Guide, Non-`external` variable and function names should begin with an [underscore](https://docs.soliditylang.org/en/latest/style-guide.html#underscore-prefix-for-non-external-functions-and-variables)

*Instances (138)*:

```solidity
File: contracts/CollateralTracker.sol

88:     address internal s_underlyingToken;

92:     bool internal s_initialized;

95:     address internal s_univ3token0;

98:     address internal s_univ3token1;

101:     bool internal s_underlyingIsToken0;

108:     PanopticPool internal s_panopticPool;

111:     uint128 internal s_poolAssets;

114:     uint128 internal s_inAMM;

120:     uint128 internal s_ITMSpreadFee;

123:     uint24 internal s_poolFee;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

90:     mapping(IUniswapV3Pool univ3pool => PanopticPool panopticPool) internal s_getPanopticPool;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

175:     IUniswapV3Pool internal s_univ3pool;

214:     uint256 internal s_miniMedian;

221:     CollateralTracker internal s_collateralToken0;

223:     CollateralTracker internal s_collateralToken1;

228:     mapping(address account => mapping(TokenId tokenId => mapping(uint256 leg => LeftRightUnsigned premiaGrowth)))

235:     mapping(bytes32 chunkKey => LeftRightUnsigned lastGrossPremium) internal s_grossPremiumLast;

241:     mapping(bytes32 chunkKey => LeftRightUnsigned settledTokens) internal s_settledTokens;

248:     mapping(address account => mapping(TokenId tokenId => LeftRightUnsigned balanceAndUtilizations))

264:     mapping(address account => uint256 positionsHash) internal s_positionsHash;

1416:     function getUniV3TWAP() internal view returns (int24 twapTick) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

158:           ▲ for isLong=0     amount           

164:           │  │    │         │    │         │    │     

191:         Let`s say Charlie the smart contract deposited T into the AMM and later removed R from that

296:     /// @dev feesBase represents the baseline fees collected by the position last time it was updated - this is recalculated every time the position is collected from with the new value.

299:     /*//////////////////////////////////////////////////////////////

312:         // execute function

341:     /// @notice Set the canonical Uniswap V3 Factory address.

350:     /// @param token1 The contract address of token1 of the pool

615:                     liquidityChunk.tickLower(),

785:             // this is simply a convenience feature, and should be treated as such

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

124:     function generateSVGArt(

156:     function generateSVGInfo(

181:     function getChainName() internal view returns (string memory) {

208:     function write(string memory chars) internal view returns (string memory) {

216:     function write(

268:     function maxSymbolWidth(uint256 rarity) internal pure returns (uint256 width) {

294:     function maxRarityLabelWidth(uint256 rarity) internal pure returns (uint256 width) {

324:     function maxStrategyLabelWidth(uint256 rarity) internal pure returns (uint256 width) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

30:     function validateCallback(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Math.sol

25:     function min24(int24 a, int24 b) internal pure returns (int24) {

33:     function max24(int24 a, int24 b) internal pure returns (int24) {

41:     function min(uint256 a, uint256 b) internal pure returns (uint256) {

49:     function min(int256 a, int256 b) internal pure returns (int256) {

57:     function max(uint256 a, uint256 b) internal pure returns (uint256) {

65:     function max(int256 a, int256 b) internal pure returns (int256) {

73:     function abs(int256 x) internal pure returns (int256) {

81:     function absUint(int256 x) internal pure returns (uint256) {

91:     function mostSignificantNibble(uint160 x) internal pure returns (uint256 r) {

128:     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160) {

191:     function getAmount0ForLiquidity(LiquidityChunk liquidityChunk) internal pure returns (uint256) {

207:     function getAmount1ForLiquidity(LiquidityChunk liquidityChunk) internal pure returns (uint256) {

221:     function getAmountsForLiquidity(

241:     function getLiquidityForAmount0(

271:     function getLiquidityForAmount1(

296:     function toUint128(uint256 toDowncast) internal pure returns (uint128 downcastedInt) {

302:     function toUint128Capped(uint256 toDowncast) internal pure returns (uint128 downcastedInt) {

311:     function toInt128(uint128 toCast) internal pure returns (int128 downcastedInt) {

318:     function toInt128(int256 toCast) internal pure returns (int128 downcastedInt) {

325:     function toInt256(uint256 toCast) internal pure returns (int256) {

340:     function mulDiv(

440:     function mulDivRoundingUp(

458:     function mulDiv64(uint256 a, uint256 b) internal pure returns (uint256) {

521:     function mulDiv96(uint256 a, uint256 b) internal pure returns (uint256) {

584:     function mulDiv96RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

598:     function mulDiv128(uint256 a, uint256 b) internal pure returns (uint256) {

661:     function mulDiv128RoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

675:     function mulDiv192(uint256 a, uint256 b) internal pure returns (uint256) {

738:     function unsafeDivRoundingUp(uint256 a, uint256 b) internal pure returns (uint256 result) {

753:     function quickSort(int256[] memory arr, int256 left, int256 right) internal pure {

776:     function sort(int256[] memory data) internal pure returns (int256[] memory) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

49:     function getPoolId(address univ3pool) internal view returns (uint64) {

61:     function incrementPoolPattern(uint64 poolId) internal pure returns (uint64) {

99:     function uniswapFeeToString(uint24 fee) internal pure returns (string memory) {

125:     function updatePositionsHash(

327:         uint128 positionSize

377:     ) internal pure returns (int24 tickLower, int24 tickUpper) {

409:     ) internal pure returns (int24, int24) {

428:     ) internal pure returns (LeftRightSigned longAmounts, LeftRightSigned shortAmounts) {

456:         LeftRightUnsigned tokenData1,

482:         LeftRightUnsigned tokenData1,

495:     function convert0to1(uint256 amount, uint160 sqrtPriceX96) internal pure returns (uint256) {

512:     function convert1to0(uint256 amount, uint160 sqrtPriceX96) internal pure returns (uint256) {

529:     function convert0to1(int256 amount, uint160 sqrtPriceX96) internal pure returns (int256) {

552:     function convert1to0(int256 amount, uint160 sqrtPriceX96) internal pure returns (int256) {

582:         uint256 legIndex

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

21:     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {

52:     function safeTransfer(address token, address to, uint256 amount) internal {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/LeftRight.sol

38:     function rightSlot(LeftRightUnsigned self) internal pure returns (uint128) {

45:     function rightSlot(LeftRightSigned self) internal pure returns (int128) {

58:     function toRightSlot(

77:     function toRightSlot(

100:     function leftSlot(LeftRightUnsigned self) internal pure returns (uint128) {

107:     function leftSlot(LeftRightSigned self) internal pure returns (int128) {

120:     function toLeftSlot(

133:     function toLeftSlot(LeftRightSigned self, int128 left) internal pure returns (LeftRightSigned) {

147:     function add(

170:     function sub(

193:     function add(LeftRightUnsigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

213:     function add(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

231:     function sub(LeftRightSigned x, LeftRightSigned y) internal pure returns (LeftRightSigned z) {

250:     function subRect(

278:     function addCapped(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

75:         unchecked {

94:             return LiquidityChunk.wrap(LiquidityChunk.unwrap(self) + amount);

107:             return

123:             // convert tick upper to uint24 as explicit conversion from int24 to uint256 is not allowed

139:         unchecked {

155:         unchecked {

173:             return int24(int256(LiquidityChunk.unwrap(self) >> 232));

182:             return int24(int256(LiquidityChunk.unwrap(self) >> 208));

191:             return uint128(LiquidityChunk.unwrap(self));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

87:     function poolId(TokenId self) internal pure returns (uint64) {

96:     function tickSpacing(TokenId self) internal pure returns (int24) {

108:     function asset(TokenId self, uint256 legIndex) internal pure returns (uint256) {

118:     function optionRatio(TokenId self, uint256 legIndex) internal pure returns (uint256) {

128:     function isLong(TokenId self, uint256 legIndex) internal pure returns (uint256) {

138:     function tokenType(TokenId self, uint256 legIndex) internal pure returns (uint256) {

148:     function riskPartner(TokenId self, uint256 legIndex) internal pure returns (uint256) {

158:     function strike(TokenId self, uint256 legIndex) internal pure returns (int24) {

169:     function width(TokenId self, uint256 legIndex) internal pure returns (int24) {

183:     function addPoolId(TokenId self, uint64 _poolId) internal pure returns (TokenId) {

193:     function addTickSpacing(TokenId self, int24 _tickSpacing) internal pure returns (TokenId) {

205:     function addAsset(

221:     function addOptionRatio(

240:     function addIsLong(

255:     function addTokenType(

273:     function addRiskPartner(

291:     function addStrike(

310:     function addWidth(

336:     function addLeg(

366:     function flipToBurnToken(TokenId self) internal pure returns (TokenId) {

404:     function countLongs(TokenId self) internal pure returns (uint256) {

416:     function asTicks(

432:     function countLegs(TokenId self) internal pure returns (uint256) {

464:     function clearLeg(TokenId self, uint256 i) internal pure returns (TokenId) {

500:     function validate(TokenId self) internal pure {

578:     function validateIsExercisable(TokenId self, int24 currentTick) internal pure {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-26"></a>[NC-26] Event is missing `indexed` fields

Index event fields make the field more quickly accessible to off-chain tools that parse events. However, note that each index field costs extra gas during emission, so it's not necessarily best to index the maximum allowed per event (three fields). Each event should use three indexed fields if there are three or more fields, and gas usage is not particularly of concern for the events in question. If there are fewer than three fields, all of the fields should be indexed.

*Instances (12)*:

```solidity
File: contracts/CollateralTracker.sol

48:     event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

40:     event PoolDeployed(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

36:     event AccountLiquidated(

59:     event PremiumSettled(

70:     event OptionBurnt(

84:     event OptionMinted(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

93:     /// @dev `recipient` is used to track whether it was minted directly by the user or through an option contract.

98:         address indexed caller,

112:     /// @dev false = unlocked, true = locked

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

48:     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

18:     event Transfer(address indexed from, address indexed to, uint256 amount);

24:     event Approval(address indexed owner, address indexed spender, uint256 amount);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

### <a name="NC-27"></a>[NC-27] Constants should be defined rather than using magic numbers

*Instances (31)*:

```solidity
File: contracts/base/FactoryNFT.sol

243:             uint256 _scale = (3400 * maxWidth) / offset;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Math.sol

478:                     res := shr(64, prod0)

505:                 prod0 := shr(64, prod0)

541:                     res := shr(96, prod0)

568:                 prod0 := shr(96, prod0)

695:                     res := shr(192, prod0)

722:                 prod0 := shr(192, prod0)

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

277:         uint32[] memory secondsAgos = new uint32[](20);

279:         int256[] memory twapMeasurement = new int256[](19);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

31:             mstore(add(36, p), to) // Append the "to" argument.

32:             mstore(add(68, p), amount) // Append the "amount" argument.

62:             mstore(add(36, p), amount) // Append the "amount" argument.

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/TokenId.sol

110:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48)) % 2);

120:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 1)) % 128);

130:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 8)) % 2);

140:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 9)) % 2);

150:             return uint256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 10)) % 4);

160:             return int24(int256(TokenId.unwrap(self) >> (64 + legIndex * 48 + 12)));

171:             return int24(int256((TokenId.unwrap(self) >> (64 + legIndex * 48 + 36)) % 4096));

212:                 TokenId.wrap(TokenId.unwrap(self) + (uint256(_asset % 2) << (64 + legIndex * 48)));

229:                     TokenId.unwrap(self) + (uint256(_optionRatio % 128) << (64 + legIndex * 48 + 1))

246:             return TokenId.wrap(TokenId.unwrap(self) + ((_isLong % 2) << (64 + legIndex * 48 + 8)));

263:                     TokenId.unwrap(self) + (uint256(_tokenType % 2) << (64 + legIndex * 48 + 9))

281:                     TokenId.unwrap(self) + (uint256(_riskPartner % 4) << (64 + legIndex * 48 + 10))

300:                         uint256((int256(_strike) & BITMASK_INT24) << (64 + legIndex * 48 + 12))

320:                         (uint256(uint24(_width) % 4096) << (64 + legIndex * 48 + 36))

395:                         ((LONG_MASK >> (48 * (4 - optionRatios))) & CLEAR_POOLID_MASK)

512:                     if ((TokenId.unwrap(self) >> (64 + 48 * i)) != 0)

521:                     if (uint48(chunkData >> (48 * i)) == uint48(chunkData >> (48 * j))) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="NC-28"></a>[NC-28] `public` functions not called by the contract should be declared `external` instead

*Instances (8)*:

```solidity
File: contracts/CollateralTracker.sol

1156:         tokenData = _getAccountMargin(user, currentTick, positionBalanceArray, premiumAllPositions);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

1410:     function numberOfPositions(address user) public view returns (uint256 _numberOfPositions) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/Multicall.sol

12:     function multicall(bytes[] calldata data) public payable returns (bytes[] memory results) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

104:         // extract the amount of AMM fees collected within the liquidity chunk`

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

81:     function setApprovalForAll(address operator, bool approved) public {

178:     function balanceOfBatch(

200:     function supportsInterface(bytes4 interfaceId) public pure returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/tokens/ERC20Minimal.sol

49:     function approve(address spender, uint256 amount) public returns (bool) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC20Minimal.sol)

### <a name="NC-29"></a>[NC-29] Variables need not be initialized to zero

The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (32)*:

```solidity
File: contracts/CollateralTracker.sol

691:             for (uint256 leg = 0; leg < positionId.countLegs(); ++leg) {

1217:         for (uint256 i = 0; i < totalIterations; ) {

1264:             for (uint256 index = 0; index < numLegs; ++index) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

443:         for (uint256 k = 0; k < pLength; ) {

461:             for (uint256 leg = 0; leg < numLegs; ) {

712:         for (uint256 leg = 0; leg < numLegs; ) {

771:         for (uint256 i = 0; i < positionIdList.length; ) {

829:         for (uint256 leg = 0; leg < numLegs; ) {

1348:         for (uint256 i = 0; i < pLength; ) {

1486:         for (uint256 leg = 0; leg < numLegs; ) {

1636:         for (uint256 leg = 0; leg < numLegs; ++leg) {

1816:         for (uint256 leg = 0; leg < numLegs; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

577:         for (uint256 i = 0; i < ids.length; ) {

602:         for (uint256 leg = 0; leg < numLegs; ) {

881:         for (uint256 leg = 0; leg < numLegs; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

223:         for (uint256 i = 0; i < bytes(chars).length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/base/Multicall.sol

14:         for (uint256 i = 0; i < data.length; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/Multicall.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

51:         for (uint256 k = 0; k < positionIdList.length; ) {

55:             for (uint256 leg = 0; leg < numLegs; ) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

172:             for (uint256 i = 0; i < cardinality + 1; ++i) {

183:             for (uint256 i = 0; i < cardinality; ++i) {

283:             for (uint256 i = 0; i < 20; ++i) {

291:             for (uint256 i = 0; i < 19; ++i) {

430:         for (uint256 leg = 0; leg < numLegs; ) {

787:             for (uint256 i = 0; i < positionIdList.length; ++i) {

790:                 for (uint256 leg = 0; leg < numLegs; ++leg) {

867:             for (uint256 i = 0; i < positionIdList.length; i++) {

870:                 for (uint256 leg = 0; leg < tokenId.countLegs(); ++leg) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/tokens/ERC1155Minimal.sol

143:         for (uint256 i = 0; i < ids.length; ) {

187:             for (uint256 i = 0; i < owners.length; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/tokens/ERC1155Minimal.sol)

```solidity
File: contracts/types/TokenId.sol

507:             for (uint256 i = 0; i < 4; ++i) {

581:             for (uint256 i = 0; i < numLegs; ++i) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

## Low Issues

| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `approve()`/`safeApprove()` may revert if the current approval is not zero | 4 |
| [L-2](#L-2) | Some tokens may revert when zero value transfers are made | 2 |
| [L-3](#L-3) | Missing checks for `address(0)` when assigning values to address state variables | 5 |
| [L-4](#L-4) | `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 21 |
| [L-5](#L-5) | `decimals()` is not a part of the ERC-20 standard | 1 |
| [L-6](#L-6) | Deprecated approve() function | 4 |
| [L-7](#L-7) | Division by zero not prevented | 17 |
| [L-8](#L-8) | External calls in an un-bounded `for-`loop may result in a DOS | 15 |
| [L-9](#L-9) | Prevent accidentally burning tokens | 26 |
| [L-10](#L-10) | NFT ownership doesn't support hard forks | 1 |
| [L-11](#L-11) | Possible rounding issue | 6 |
| [L-12](#L-12) | Loss of precision | 12 |
| [L-13](#L-13) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 16 |
| [L-14](#L-14) | File allows a version of solidity that is susceptible to an assembly optimizer bug | 11 |
| [L-15](#L-15) | `symbol()` is not a part of the ERC-20 standard | 1 |
| [L-16](#L-16) | Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting | 70 |
| [L-17](#L-17) | Unsafe ERC20 operation(s) | 6 |
| [L-18](#L-18) | Upgradeable contract not initialized | 15 |

### <a name="L-1"></a>[L-1] `approve()`/`safeApprove()` may revert if the current approval is not zero

- Some tokens (like the *very popular* USDT) do not work when changing the allowance from an existing non-zero allowance value (it will revert if the current approval is not zero to protect against front-running changes of approvals). These tokens must first be approved for zero and then the actual allowance can be approved.
- Furthermore, OZ's implementation of safeApprove would throw an error if an approve is attempted from a non-zero value (`"SafeERC20: approve from non-zero to non-zero allowance"`)

Set the allowance to zero immediately before each of the existing allowance calls

*Instances (4)*:

```solidity
File: contracts/libraries/InteractionHelper.sol

32:         IERC20Partial(token0).approve(address(sfpm), type(uint256).max);

33:         IERC20Partial(token1).approve(address(sfpm), type(uint256).max);

36:         IERC20Partial(token0).approve(address(ct0), type(uint256).max);

37:         IERC20Partial(token1).approve(address(ct1), type(uint256).max);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

### <a name="L-2"></a>[L-2] Some tokens may revert when zero value transfers are made

Example: <https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers>.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

317:         return ERC20Minimal.transfer(recipient, amount);

336:         return ERC20Minimal.transferFrom(from, to, amount);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="L-3"></a>[L-3] Missing checks for `address(0)` when assigning values to address state variables

*Instances (5)*:

```solidity
File: contracts/CollateralTracker.sol

239:         s_univ3token0 = token0;

240:         s_univ3token1 = token1;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

115:         WETH = _WETH9;

118:         POOL_REFERENCE = _poolReference;

119:         COLLATERAL_REFERENCE = _collateralReference;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

### <a name="L-4"></a>[L-4] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`

Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (21)*:

```solidity
File: contracts/base/FactoryNFT.sol

73:                     "data:application/json;base64,",

74:                     Base64.encode(

77:                                 '{"name":"',

78:                                 abi.encodePacked(

79:                                     LibString.toHexString(uint256(uint160(panopticPool)), 20),

80:                                     "-",

81:                                     string.concat(

87:                                 '", "description":"',

88:                                 string.concat(

97:                                 '", "attributes": [{',

98:                                 '"trait_type": "Rarity", "value": "',

99:                                 string.concat(

104:                                 '"}, {"trait_type": "Strategy", "value": "',

105:                                 metadata[bytes32("strategies")][lastCharVal].dataStr(),

106:                                 '"}, {"trait_type": "ChainId", "value": "',

107:                                 getChainName(),

108:                                 '"}]',

109:                                 '", "image": "',

110:                                 "data:image/svg+xml;base64,",

111:                                 Base64.encode(bytes(svgOut)),

112:                                 '"}'

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

### <a name="L-5"></a>[L-5] `decimals()` is not a part of the ERC-20 standard

The `decimals()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:

```solidity
File: contracts/libraries/InteractionHelper.sol

91:         try IERC20Metadata(token).decimals() returns (uint8 _decimals) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

### <a name="L-6"></a>[L-6] Deprecated approve() function

Due to the inheritance of ERC20's approve function, there's a vulnerability to the ERC20 approve and double spend front running attack. Briefly, an authorized spender could spend both allowances by front running an allowance-changing transaction. Consider implementing OpenZeppelin's `.safeApprove()` function to help mitigate this.

*Instances (4)*:

```solidity
File: contracts/libraries/InteractionHelper.sol

32:         IERC20Partial(token0).approve(address(sfpm), type(uint256).max);

33:         IERC20Partial(token1).approve(address(sfpm), type(uint256).max);

36:         IERC20Partial(token0).approve(address(ct0), type(uint256).max);

37:         IERC20Partial(token1).approve(address(ct1), type(uint256).max);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

### <a name="L-7"></a>[L-7] Division by zero not prevented

The divisions below take an input parameter which does not have any zero-value checks, which may lead to the functions reverting when zero is passed.

*Instances (17)*:

```solidity
File: contracts/CollateralTracker.sol

706:                         uint256(Math.abs(currentTick - positionId.strike(leg)) / range)

762:             return int256((s_inAMM * DECIMALS) / totalAssets());

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

372:             tickLower = (Constants.MIN_V3POOL_TICK / tickSpacing) * tickSpacing;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

1453:             effectiveLiquidityFactorX32 = (uint256(removedLiquidity) * 2 ** 32) / netLiquidity;

1696:                                     totalLiquidityBefore) / (totalLiquidity)

1704:                                     totalLiquidityBefore) / (totalLiquidity)

1907:                                     ) / totalLiquidity

1923:                                     ) / totalLiquidity

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

229:               s_accountPremiumOwed += feeGrowthX128 * R * (1 + ν*R/N) / R

272:                                 = ∆feeGrowthX128 * t * (T - R + ν*R^2/T) / N 

273:                                 = ∆feeGrowthX128 * t * (N + ν*R^2/T) / N

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

243:             uint256 _scale = (3400 * maxWidth) / offset;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Math.sol

176:             if (tick > 0) sqrtR = type(uint256).max / sqrtR;

200:                 ) / lowPriceX96;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

293:                     (tickCumulatives[i] - tickCumulatives[i + 1]) / int56(uint56(twapWindow / 20))

381:             int24 minTick = (Constants.MIN_V3POOL_TICK / tickSpacing) * tickSpacing;

382:             int24 maxTick = (Constants.MAX_V3POOL_TICK / tickSpacing) * tickSpacing;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="L-8"></a>[L-8] External calls in an un-bounded `for-`loop may result in a DOS

Consider limiting the number of iterations in for-loops that make external calls

*Instances (15)*:

```solidity
File: contracts/PanopticPool.sol

1641:             s_settledTokens[chunkKey] = s_settledTokens[chunkKey].add(collectedByLeg[leg]);

1824:             LeftRightUnsigned settledTokens = s_settledTokens[chunkKey].add(collectedByLeg[leg]);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/FactoryNFT.sol

226:                 bytes32(metadata[bytes32("charOffsets")][uint256(bytes32(bytes(chars)[i]))].data())

235:                 metadata[bytes32("charPaths")][uint256(bytes32(bytes(chars)[i]))].dataStr(),

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

57:                     tokenId,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

878:                             uint128(longPremium.rightSlot())

878:                             uint128(longPremium.rightSlot())

882:                             uint128(longPremium.leftSlot())

882:                             uint128(longPremium.leftSlot())

899:                         settled1 = Math.max(

899:                         settled1 = Math.max(

904:                         _settledTokens[chunkKey] = _settledTokens[chunkKey].add(

904:                         _settledTokens[chunkKey] = _settledTokens[chunkKey].add(

905:                             LeftRightUnsigned.wrap(0).toRightSlot(uint128(settled0)).toLeftSlot(

905:                             LeftRightUnsigned.wrap(0).toRightSlot(uint128(settled0)).toLeftSlot(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="L-9"></a>[L-9] Prevent accidentally burning tokens

Minting and burning tokens to address(0) prevention

*Instances (26)*:

```solidity
File: contracts/CollateralTracker.sol

416:         _mint(receiver, shares);

474:         _mint(receiver, shares);

530:         _burn(owner, shares);

574:         _burn(owner, shares);

637:         _burn(owner, shares);

982:         // if requested amount < delegatee balance, then just transfer shares back

1043:             // update stored asset balances with net moved amounts

1045:             // however, any intrinsic value is paid for by the users, so we only add the portion that comes from PLPs: the short/long amounts

1090:             // update stored asset balances with net moved amounts

1092:             // premia is not included in the balance since it is the property of options buyers and sellers, not PLPs

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

228:         (uint256 amount0, uint256 amount1) = _mintFullRange(v3Pool, token0, token1, fee);

234:         _mint(msg.sender, tokenId);

384:             IUniswapV3Pool(v3Pool).mint(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

533:         _mintOptions(

553:         _burnOptions(COMMIT_LONG_SETTLED, tokenId, msg.sender, tickLimitLow, tickLimitHigh);

569:         _burnAllOptionsFrom(

617:         uint128 poolUtilizations = _mintInSFPMAndUpdateCollateral(

773:             (paidAmounts, premiasByLeg[i]) = _burnOptions(

806:         (premiaOwed, premiaByLeg, paidAmounts) = _burnAndHandleExercise(

1054:             (netExchanged, premiasByLeg) = _burnAllOptionsFrom(

1194:         _burnAllOptionsFrom(account, MIN_SWAP_TICK, MAX_SWAP_TICK, COMMIT_LONG_SETTLED, touchedId);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

502:     /// @param slippageTickLimitLow The lower bound of an acceptable open interval for the ending price

537:     /// @param from The user to transfer tokens from

1100:     /// @notice Updates the premium accumulators for a chunk with the latest collected tokens.

1101:     /// @param positionKey A key representing a liquidity chunk/range in Uniswap

1227:         // amount0 The amount of token0 that was sent back to the Panoptic Pool

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

### <a name="L-10"></a>[L-10] NFT ownership doesn't support hard forks

To ensure clarity regarding the ownership of the NFT on a specific chain, it is recommended to add `require(block.chainid == 1, "Invalid Chain")` or the desired chain ID in the functions below.

Alternatively, consider including the chain ID in the URI itself. By doing so, any confusion regarding the chain responsible for owning the NFT will be eliminated.

*Instances (1)*:

```solidity
File: contracts/base/FactoryNFT.sol

40:     function tokenURI(uint256 tokenId) public view override returns (string memory) {
            address panopticPool = address(uint160(tokenId));
    
            return

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

### <a name="L-11"></a>[L-11] Possible rounding issue

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator. Also, there is indication of multiplication and division without the use of parenthesis which could result in issues.

*Instances (6)*:

```solidity
File: contracts/CollateralTracker.sol

762:             return int256((s_inAMM * DECIMALS) / totalAssets());

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

1696:                                     totalLiquidityBefore) / (totalLiquidity)

1704:                                     totalLiquidityBefore) / (totalLiquidity)

1907:                                     ) / totalLiquidity

1923:                                     ) / totalLiquidity

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

684:                 uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="L-12"></a>[L-12] Loss of precision

Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (12)*:

```solidity
File: contracts/CollateralTracker.sol

247:             s_ITMSpreadFee = uint128((ITM_SPREAD_MULTIPLIER * fee) / DECIMALS);

430:             return (convertToShares(type(uint104).max) * (DECIMALS - COMMISSION_FEE)) / DECIMALS;

751:                 .toRightSlot(int128((longAmounts.rightSlot() * fee) / DECIMALS_128))

752:                 .toLeftSlot(int128((longAmounts.leftSlot() * fee) / DECIMALS_128));

762:             return int256((s_inAMM * DECIMALS) / totalAssets());

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticPool.sol

1696:                                     totalLiquidityBefore) / (totalLiquidity)

1704:                                     totalLiquidityBefore) / (totalLiquidity)

1907:                                     ) / totalLiquidity

1923:                                     ) / totalLiquidity

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

1358:                     uint256 numerator = netLiquidity + (removedLiquidity / 2 ** VEGOID);

1382:                         ((removedLiquidity ** 2) / 2 ** (VEGOID));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

684:                 uint256 bonusCross = Math.min(balanceCross / 2, thresholdCross - balanceCross);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="L-13"></a>[L-13] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`

The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (16)*:

```solidity
File: contracts/CollateralTracker.sol

2: pragma solidity ^0.8.18;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

2: pragma solidity ^0.8.18;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

2: pragma solidity ^0.8.18;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

2: pragma solidity ^0.8.18;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/base/FactoryNFT.sol

2: pragma solidity ^0.8.18;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/CallbackLib.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Constants.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Constants.sol)

```solidity
File: contracts/libraries/Errors.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Errors.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/Math.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/LeftRight.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="L-14"></a>[L-14] File allows a version of solidity that is susceptible to an assembly optimizer bug

In solidity versions 0.8.13 and 0.8.14, there is an [optimizer bug](https://github.com/ethereum/solidity-blog/blob/499ab8abc19391be7b7b34f88953a067029a5b45/_posts/2022-06-15-inline-assembly-memory-side-effects-bug.md) where, if the use of a variable is in a separate `assembly` block from the block in which it was stored, the `mstore` operation is optimized out, leading to uninitialized memory. The code currently does not have such a pattern of execution, but it does use `mstore`s in `assembly` blocks, so it is a risk for future changes. The affected solidity versions should be avoided if at all possible.

*Instances (11)*:

```solidity
File: contracts/libraries/CallbackLib.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/CallbackLib.sol)

```solidity
File: contracts/libraries/Constants.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Constants.sol)

```solidity
File: contracts/libraries/Errors.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Errors.sol)

```solidity
File: contracts/libraries/FeesCalc.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/Math.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/libraries/SafeTransferLib.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/SafeTransferLib.sol)

```solidity
File: contracts/types/LeftRight.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/LiquidityChunk.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LiquidityChunk.sol)

```solidity
File: contracts/types/TokenId.sol

2: pragma solidity ^0.8.0;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="L-15"></a>[L-15] `symbol()` is not a part of the ERC-20 standard

The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:

```solidity
File: contracts/libraries/PanopticMath.sol

88:         try IERC20Metadata(token).symbol() returns (string memory symbol) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="L-16"></a>[L-16] Consider using OpenZeppelin's SafeCast library to prevent unexpected overflows when downcasting

Downcasting from `uint256`/`int256` in Solidity does not revert on overflow. This can result in undesired exploitation or bugs, since developers usually assume that overflows raise errors. [OpenZeppelin's SafeCast library](https://docs.openzeppelin.com/contracts/3.x/api/utils#SafeCast) restores this intuition by reverting the transaction when such an operation overflows. Using this library eliminates an entire class of bugs, so it's recommended to use it always. Some exceptions are acceptable like with the classic `uint256(uint160(address(variable)))`

*Instances (70)*:

```solidity
File: contracts/CollateralTracker.sol

247:             s_ITMSpreadFee = uint128((ITM_SPREAD_MULTIPLIER * fee) / DECIMALS);

420:             s_poolAssets += uint128(assets);

478:             s_poolAssets += uint128(assets);

534:             s_poolAssets -= uint128(assets);

578:             s_poolAssets -= uint128(assets);

641:             s_poolAssets -= uint128(assets);

696:                     int24 range = int24(

738:                         .toRightSlot(int128(uint128(oracleValue0)) - int128(uint128(currentValue0)))

739:                         .toLeftSlot(int128(uint128(oracleValue1)) - int128(uint128(currentValue1)))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

332:                 fullRangeLiquidity = uint128(

336:                 fullRangeLiquidity = uint128(

345:                 uint128 liquidity0 = uint128(

348:                 uint128 liquidity1 = uint128(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

742:                     uint64(Math.min(effectiveLiquidityLimitX32, MAX_SPREAD))

1692:                             uint128(

1700:                             uint128(

1741:                         uint128(

1750:                         uint128(

1895:                                 uint128(

1911:                                 uint128(

1928:                             .toRightSlot(uint128(premiumAccumulatorsByLeg[_leg][0]))

1929:                             .toLeftSlot(uint128(premiumAccumulatorsByLeg[_leg][1]));

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/base/FactoryNFT.sol

41:         address panopticPool = address(uint160(tokenId));

94:                                     PanopticMath.uniswapFeeToString(uint24(fee)),

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/base/FactoryNFT.sol)

```solidity
File: contracts/libraries/Math.sol

179:             return uint160((sqrtR >> 32) + (sqrtR % (1 << 32) == 0 ? 0 : 1));

297:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) revert Errors.CastingError();

303:         if ((downcastedInt = uint128(toDowncast)) != toDowncast) {

319:         if (!((downcastedInt = int128(toCast)) == toCast)) revert Errors.CastingError();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Math.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

134:         uint256 updatedHash = uint248(existingHash) ^

139:             ? uint8(existingHash >> 248) + 1

140:             : uint8(existingHash >> 248) - 1;

190:             return int24(Math.sort(ticks)[cardinality / 2]);

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

213:                 (int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 3)) % 8) * 24))) +

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

214:                     int24(uint24(medianData >> ((uint24(medianData >> (192 + 3 * 4)) % 8) * 24)))) /

218:             if (block.timestamp >= uint256(uint40(medianData >> 216)) + period) {

218:             if (block.timestamp >= uint256(uint40(medianData >> 216)) + period) {

235:                 uint24 orderMap = uint24(medianData >> 192);

252:                     entry = int24(uint24(medianData >> (rank * 24)));

252:                     entry = int24(uint24(medianData >> (rank * 24)));

264:                     uint256(uint192(medianData << 24)) +

264:                     uint256(uint192(medianData << 24)) +

284:                 secondsAgos[i] = uint32(((i + 1) * twapWindow) / 20);

301:             return int24(sortedTicks[9]);

864:                 if (haircut1 != 0) collateral1.exercise(_liquidatee, 0, 0, 0, int128(haircut1));

944:                             int128(

962:                             int128(

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

```solidity
File: contracts/types/LeftRight.sol

39:         return uint128(LeftRightUnsigned.unwrap(self));

46:         return int128(LeftRightSigned.unwrap(self));

68:                         uint256(uint128(LeftRightUnsigned.unwrap(self)) + right)

68:                         uint256(uint128(LeftRightUnsigned.unwrap(self)) + right)

101:         return uint128(LeftRightUnsigned.unwrap(self) >> 128);

108:         return int128(LeftRightSigned.unwrap(self) >> 128);

161:                 (uint128(LeftRightUnsigned.unwrap(z)) < uint128(LeftRightUnsigned.unwrap(x)))

184:                 (uint128(LeftRightUnsigned.unwrap(z)) > uint128(LeftRightUnsigned.unwrap(x)))

196:             int128 left128 = int128(left);

201:             int128 right128 = int128(right);

216:             int128 left128 = int128(left256);

219:             int128 right128 = int128(right256);

234:             int128 left128 = int128(left256);

237:             int128 right128 = int128(right256);

256:             int128 left128 = int128(left256);

259:             int128 right128 = int128(right256);

265:                     int128(Math.max(left128, 0))

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/LeftRight.sol)

```solidity
File: contracts/types/TokenId.sol

89:             return uint64(TokenId.unwrap(self));

98:             return int24(uint24((TokenId.unwrap(self) >> 48) % 2 ** 16));

521:                     if (uint48(chunkData >> (48 * i)) == uint48(chunkData >> (48 * j))) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/types/TokenId.sol)

### <a name="L-17"></a>[L-17] Unsafe ERC20 operation(s)

*Instances (6)*:

```solidity
File: contracts/CollateralTracker.sol

317:         return ERC20Minimal.transfer(recipient, amount);

336:         return ERC20Minimal.transferFrom(from, to, amount);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

32:         IERC20Partial(token0).approve(address(sfpm), type(uint256).max);

33:         IERC20Partial(token1).approve(address(sfpm), type(uint256).max);

36:         IERC20Partial(token0).approve(address(ct0), type(uint256).max);

37:         IERC20Partial(token1).approve(address(ct1), type(uint256).max);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

### <a name="L-18"></a>[L-18] Upgradeable contract not initialized

Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (15)*:

```solidity
File: contracts/CollateralTracker.sol

92:     bool internal s_initialized;

218:         if (s_initialized) revert Errors.CollateralTokenAlreadyInitialized();

219:         s_initialized = true;

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

```solidity
File: contracts/PanopticFactory.sol

183:         if (address(v3Pool) == address(0)) revert Errors.UniswapPoolNotInitialized();

186:             revert Errors.PoolAlreadyInitialized();

189:         SFPM.initializeAMMPool(token0, token1, fee);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticFactory.sol)

```solidity
File: contracts/PanopticPool.sol

291:         if (address(s_univ3pool) != address(0)) revert Errors.PoolAlreadyInitialized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/PanopticPool.sol)

```solidity
File: contracts/SemiFungiblePositionManager.sol

80:     event PoolInitialized(address indexed uniswapPool, uint64 poolId);

352:     function initializeAMMPool(address token0, address token1, uint24 fee) external {

357:         if (univ3pool == address(0)) revert Errors.UniswapPoolNotInitialized();

392:         emit PoolInitialized(univ3pool, poolId);

701:         if (univ3pool == IUniswapV3Pool(address(0))) revert Errors.UniswapPoolNotInitialized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

```solidity
File: contracts/libraries/Errors.sol

13:     error CollateralTokenAlreadyInitialized();

75:     error PoolAlreadyInitialized();

107:     error UniswapPoolNotInitialized();

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/Errors.sol)

## Medium Issues

| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | `_safeMint()` should be used rather than `_mint()` wherever possible | 1 |
| [M-2](#M-2) | Library function isn't `internal` or `private` | 14 |
| [M-3](#M-3) | Return values of `transfer()`/`transferFrom()` not checked | 2 |
| [M-4](#M-4) | Unsafe use of `transfer()`/`transferFrom()` with `IERC20` | 2 |

### <a name="M-1"></a>[M-1] `_safeMint()` should be used rather than `_mint()` wherever possible

`_mint()` is [discouraged](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L271) in favor of `_safeMint()` which ensures that the recipient is either an EOA or implements `IERC721Receiver`. Both open [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/d4d8d2ed9798cc3383912a23b5e8d5cb602f7d4b/contracts/token/ERC721/ERC721.sol#L238-L250) and [solmate](https://github.com/Rari-Capital/solmate/blob/4eaf6b68202e36f67cab379768ac6be304c8ebde/src/tokens/ERC721.sol#L180) have versions of this function so that NFTs aren't lost if they're minted to contracts that cannot transfer them back out.

Be careful however to respect the CEI pattern or add a re-entrancy guard as `_safeMint` adds a callback-check (`_checkOnERC721Received`) and a malicious `onERC721Received` could be exploited if not careful.

Reading material:

- <https://blocksecteam.medium.com/when-safemint-becomes-unsafe-lessons-from-the-hypebears-security-incident-2965209bda2a>
- <https://samczsun.com/the-dangers-of-surprising-code/>
- <https://github.com/KadenZipfel/smart-contract-attack-vectors/blob/master/vulnerabilities/unprotected-callback.md>

*Instances (1)*:

```solidity
File: contracts/SemiFungiblePositionManager.sol

517:         _mint(msg.sender, TokenId.unwrap(tokenId), positionSize);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/SemiFungiblePositionManager.sol)

### <a name="M-2"></a>[M-2] Library function isn't `internal` or `private`

In a library, using an external or public visibility means that we won't be going through the library with a DELEGATECALL but with a CALL. This changes the context and should be done carefully.

*Instances (14)*:

```solidity
File: contracts/libraries/FeesCalc.sol

50:     ) external view returns (int256 value0, int256 value1) {

104:         // extract the amount of AMM fees collected within the liquidity chunk`

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/FeesCalc.sol)

```solidity
File: contracts/libraries/InteractionHelper.sol

24:     function doApprovals(

48:     function computeName(

78:     function computeSymbol(

88:     function computeDecimals(address token) external view returns (uint8) {

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/InteractionHelper.sol)

```solidity
File: contracts/libraries/PanopticMath.sol

76:     function numberOfLeadingHexZeros(address addr) external pure returns (uint256) {

85:     function safeERC20Symbol(address token) external view returns (string memory) {

160:     function computeMedianObservedPrice(

203:     function computeInternalMedian(

276:     function twapFilter(IUniswapV3Pool univ3pool, uint32 twapWindow) external view returns (int24) {

658:         LeftRightUnsigned tokenData1,

776:         TokenId[] memory positionIdList,

926:         LeftRightSigned refundValues,

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/libraries/PanopticMath.sol)

### <a name="M-3"></a>[M-3] Return values of `transfer()`/`transferFrom()` not checked

Not all `IERC20` implementations `revert()` when there's a failure in `transfer()`/`transferFrom()`. The function signature has a `boolean` return value and they indicate errors that way instead. By not checking the return value, operations that should have marked as failed, may potentially go through without actually making a payment

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

317:         return ERC20Minimal.transfer(recipient, amount);

336:         return ERC20Minimal.transferFrom(from, to, amount);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)

### <a name="M-4"></a>[M-4] Unsafe use of `transfer()`/`transferFrom()` with `IERC20`

Some tokens do not implement the ERC20 standard properly but are still accepted by most code that accepts ERC20 tokens.  For example Tether (USDT)'s `transfer()` and `transferFrom()` functions on L1 do not return booleans as the specification requires, and instead have no return value. When these sorts of tokens are cast to `IERC20`, their [function signatures](https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca) do not match and therefore the calls made, revert (see [this](https://gist.github.com/IllIllI000/2b00a32e8f0559e8f386ea4f1800abc5) link for a test case). Use OpenZeppelin's `SafeERC20`'s `safeTransfer()`/`safeTransferFrom()` instead

*Instances (2)*:

```solidity
File: contracts/CollateralTracker.sol

317:         return ERC20Minimal.transfer(recipient, amount);

336:         return ERC20Minimal.transferFrom(from, to, amount);

```

[Link to code](https://github.com/code-423n4/2024-06-panoptic/blob/main/contracts/CollateralTracker.sol)
