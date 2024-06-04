# FeesCalc
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/libraries/FeesCalc.sol)

**Author:**
Axicon Labs Limited

Compute fees accumulated within option position legs (a leg is a liquidity chunk).

*Some options positions involve moving liquidity chunks to the AMM/Uniswap. Those chunks can then earn AMM swap fees.*


## Functions
### getPortfolioValue

Calculate NAV of user's option portfolio at a given tick.


```solidity
function getPortfolioValue(
    int24 atTick,
    mapping(TokenId tokenId => LeftRightUnsigned balance) storage userBalance,
    TokenId[] calldata positionIdList
) external view returns (int256 value0, int256 value1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`atTick`|`int24`|The tick to calculate the value at|
|`userBalance`|`mapping(TokenId tokenId => LeftRightUnsigned balance)`|The position balance array for the user (left=tokenId, right=positionSize)|
|`positionIdList`|`TokenId[]`|A list of all positions the user holds on that pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`value0`|`int256`|The amount of token0 owned by portfolio|
|`value1`|`int256`|The amount of token1 owned by portfolio|


### calculateAMMSwapFees

Calculate the AMM Swap/trading fees for a `liquidityChunk` of each token.

*Read from the uniswap pool and compute the accumulated fees from swapping activity.*


```solidity
function calculateAMMSwapFees(
    IUniswapV3Pool univ3pool,
    int24 currentTick,
    int24 tickLower,
    int24 tickUpper,
    uint128 liquidity
) public view returns (LeftRightSigned);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`univ3pool`|`IUniswapV3Pool`|The AMM/Uniswap pool where fees are collected from|
|`currentTick`|`int24`|The current price tick|
|`tickLower`|`int24`|The lower tick of the chunk to calculate fees for|
|`tickUpper`|`int24`|The upper tick of the chunk to calculate fees for|
|`liquidity`|`uint128`|The liquidity amount of the chunk to calculate fees for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`LeftRightSigned`|The fees collected from the AMM for each token (LeftRight-packed) with token0 in the right slot and token1 in the left slot|


### _getAMMSwapFeesPerLiquidityCollected

Calculates the fee growth that has occurred (per unit of liquidity) in the AMM/Uniswap for an
option position's tick range.

*Extracts the feeGrowth from the uniswap v3 pool.*


```solidity
function _getAMMSwapFeesPerLiquidityCollected(
    IUniswapV3Pool univ3pool,
    int24 currentTick,
    int24 tickLower,
    int24 tickUpper
) internal view returns (uint256 feeGrowthInside0X128, uint256 feeGrowthInside1X128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`univ3pool`|`IUniswapV3Pool`|The AMM pool where the leg is deployed|
|`currentTick`|`int24`|The current price tick in the AMM|
|`tickLower`|`int24`|The lower tick of the option position leg (a liquidity chunk)|
|`tickUpper`|`int24`|The upper tick of the option position leg (a liquidity chunk)|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`feeGrowthInside0X128`|`uint256`|The fee growth in the AMM of token0|
|`feeGrowthInside1X128`|`uint256`|The fee growth in the AMM of token1|


