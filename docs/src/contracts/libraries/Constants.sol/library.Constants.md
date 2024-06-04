# Constants
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/libraries/Constants.sol)

**Author:**
Axicon Labs Limited

This library provides constants used in Panoptic.


## State Variables
### FP96
Fixed point multiplier: 2**96


```solidity
uint256 internal constant FP96 = 0x1000000000000000000000000;
```


### MIN_V3POOL_TICK
Minimum possible price tick in a Uniswap V3 pool


```solidity
int24 internal constant MIN_V3POOL_TICK = -887272;
```


### MAX_V3POOL_TICK
Maximum possible price tick in a Uniswap V3 pool


```solidity
int24 internal constant MAX_V3POOL_TICK = 887272;
```


### MIN_V3POOL_SQRT_RATIO
Minimum possible sqrtPriceX96 in a Uniswap V3 pool


```solidity
uint160 internal constant MIN_V3POOL_SQRT_RATIO = 4295128739;
```


### MAX_V3POOL_SQRT_RATIO
Maximum possible sqrtPriceX96 in a Uniswap V3 pool


```solidity
uint160 internal constant MAX_V3POOL_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
```


