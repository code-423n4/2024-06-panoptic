# TokenIdLibrary
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/types/TokenId.sol)

**Author:**
Axicon Labs Limited

This is the token ID used in the ERC1155 representation of the option position in the SFPM.

The SFPM "overloads" the ERC1155 `id` by storing all option information in said `id`.

Contains methods for packing and unpacking a Panoptic options position into a uint256 bit pattern.


## State Variables
### LONG_MASK
AND mask to extract all `isLong` bits for each leg from a TokenId.


```solidity
uint256 internal constant LONG_MASK = 0x100_000000000100_000000000100_000000000100_0000000000000000;
```


### CLEAR_POOLID_MASK
AND mask to clear `poolId` from a TokenId.


```solidity
uint256 internal constant CLEAR_POOLID_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF_0000000000000000;
```


### OPTION_RATIO_MASK
AND mask to clear all bits except for the option ratios of the legs.


```solidity
uint256 internal constant OPTION_RATIO_MASK = 0x0000000000FE_0000000000FE_0000000000FE_0000000000FE_0000000000000000;
```


### CHUNK_MASK
AND mask to clear all bits except for the components of the chunk key (strike, width, tokenType) for each leg.


```solidity
uint256 internal constant CHUNK_MASK = 0xFFFFFFFFF200_FFFFFFFFF200_FFFFFFFFF200_FFFFFFFFF200_0000000000000000;
```


### BITMASK_INT24
AND mask to cut a sign-extended int256 back to an int24.


```solidity
int256 internal constant BITMASK_INT24 = 0xFFFFFF;
```


## Functions
### poolId

The full poolId (Uniswap pool identifier + pool pattern) of this option position.


```solidity
function poolId(TokenId self) internal pure returns (uint64);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `poolId` from|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint64`|The `poolId` (Panoptic's pool fingerprint, contains the whole 64 bit sequence with the tickSpacing) of the Uniswap V3 pool|


### tickSpacing

The tickSpacing of this option position.


```solidity
function tickSpacing(TokenId self) internal pure returns (int24);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `tickSpacing` from|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`int24`|The `tickSpacing` of the Uniswap v3 pool|


### asset

Get the asset basis for this TokenId.

*Which token is the asset - can be token0 (return 0) or token1 (return 1).*

*Occupies the leftmost bit of the optionRatio 4 bits slot.*


```solidity
function asset(TokenId self, uint256 legIndex) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `asset` from|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3}) to extract `asset` from|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|0 if asset is token0, 1 if asset is token1|


### optionRatio

Get the number of contracts multiplier for leg `legIndex`.


```solidity
function optionRatio(TokenId self, uint256 legIndex) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `optionRatio` at `legIndex` from|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of contracts multiplier for leg `legIndex`|


### isLong

Return 1 if the nth leg (leg index `legIndex`) is a long position.


```solidity
function isLong(TokenId self, uint256 legIndex) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `isLong` at `legIndex` from|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|1 if long; 0 if not long|


### tokenType

Get the type of token moved for a given leg (implies a call or put). Either Token0 or Token1.


```solidity
function tokenType(TokenId self, uint256 legIndex) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `tokenType` at `legIndex` from|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|1 if the token moved is token1 or 0 if the token moved is token0|


### riskPartner

Get the associated risk partner of the leg index (generally another leg index in the position if enabled or the same leg index if no partner).


```solidity
function riskPartner(TokenId self, uint256 legIndex) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `riskPartner` at `legIndex` from|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The leg index of `legIndex`'s risk partner|


### strike

Get the strike price tick of the nth leg (with index `legIndex`).


```solidity
function strike(TokenId self, uint256 legIndex) internal pure returns (int24);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `strike` at `legIndex` from|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`int24`|The strike price (the underlying price of the leg)|


### width

Get the width of the nth leg (index `legIndex`). This is half the tick-range covered by the leg (tickUpper - tickLower)/2.

*Return as int24 to be compatible with the strike tick format (they naturally go together).*


```solidity
function width(TokenId self, uint256 legIndex) internal pure returns (int24);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract `width` at `legIndex` from|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`int24`|The width of the position|


### addPoolId

Add the Uniswap V3 Pool pointed to by this option position (contains the entropy and tickSpacing).


```solidity
function addPoolId(TokenId self, uint64 _poolId) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_poolId` to|
|`_poolId`|`uint64`|The PoolID to add to `self`|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_poolId` added to the PoolID slot|


### addTickSpacing

Add the `tickSpacing` to the PoolID for `self`.


```solidity
function addTickSpacing(TokenId self, int24 _tickSpacing) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_tickSpacing` to|
|`_tickSpacing`|`int24`|The tickSpacing to add to `self`|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_tickSpacing` added to the TickSpacing slot in the PoolID|


### addAsset

Add the asset basis for this position.

*Occupies the leftmost bit of the optionRatio 4 bits slot*


```solidity
function addAsset(TokenId self, uint256 _asset, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_asset` to|
|`_asset`|`uint256`|The asset to add to the Asset slot in `self` for `legIndex`|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_asset` added to the Asset slot|


### addOptionRatio

Add the number of contracts multiplier to leg index `legIndex`.


```solidity
function addOptionRatio(TokenId self, uint256 _optionRatio, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_optionRatio` to|
|`_optionRatio`|`uint256`|The number of contracts multiplier to add to the OptionRatio slot in `self` for LegIndex|
|`legIndex`|`uint256`|The leg index of the position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_optionRatio` added to the OptionRatio slot for `legIndex`|


### addIsLong

Add "isLong" parameter indicating whether a leg is long (isLong=1) or short (isLong=0).

returns 1 if the nth leg (leg index n-1) is a long position.


```solidity
function addIsLong(TokenId self, uint256 _isLong, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_isLong` to|
|`_isLong`|`uint256`|The isLong parameter to add to the IsLong slot in `self` for `legIndex`|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_isLong` added to the IsLong slot for `legIndex`|


### addTokenType

Add the type of token moved for a given leg (implies a call or put). Either Token0 or Token1.


```solidity
function addTokenType(TokenId self, uint256 _tokenType, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_tokenType` to|
|`_tokenType`|`uint256`|The tokenType to add to the TokenType slot in `self` for `legIndex`|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_tokenType` added to the TokenType slot for `legIndex`|


### addRiskPartner

Add the associated risk partner of the leg index (generally another leg in the overall position).


```solidity
function addRiskPartner(TokenId self, uint256 _riskPartner, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_riskPartner` to|
|`_riskPartner`|`uint256`|The riskPartner to add to the RiskPartner slot in `self` for `legIndex`|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_riskPartner` added to the RiskPartner slot for `legIndex`|


### addStrike

Add the strike price tick of the nth leg (index `legIndex`).


```solidity
function addStrike(TokenId self, int24 _strike, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_strike` to|
|`_strike`|`int24`|The strike price tick to add to the Strike slot in `self` for `legIndex`|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_strike` added to the Strike slot for `legIndex`|


### addWidth

Add the width of the nth leg (index `legIndex`).


```solidity
function addWidth(TokenId self, int24 _width, uint256 legIndex) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to add `_width` to|
|`_width`|`int24`|The width to add to the Width slot in `self` for `legIndex`|
|`legIndex`|`uint256`|the leg index of this position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with `_width` added to the Width slot for `legIndex`|


### addLeg

Add a leg to a TokenId.


```solidity
function addLeg(
    TokenId self,
    uint256 legIndex,
    uint256 _optionRatio,
    uint256 _asset,
    uint256 _isLong,
    uint256 _tokenType,
    uint256 _riskPartner,
    int24 _strike,
    int24 _width
) internal pure returns (TokenId tokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The tokenId in the SFPM representing an option position|
|`legIndex`|`uint256`|The leg index of this position (in {0,1,2,3}) to add|
|`_optionRatio`|`uint256`|The relative size of the leg|
|`_asset`|`uint256`|The asset of the leg|
|`_isLong`|`uint256`|Whether the leg is long|
|`_tokenType`|`uint256`|The type of token moved for the leg|
|`_riskPartner`|`uint256`|The associated risk partner of the leg|
|`_strike`|`int24`|The strike price tick of the leg|
|`_width`|`int24`|The width of the leg|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`tokenId`|`TokenId`|The tokenId with the leg added|


### flipToBurnToken

Flip all the `isLong` positions in the legs in the `tokenId` option position.

*Uses XOR on existing isLong bits.*

*Useful when we need to take an existing tokenId but now burn it.*

*The way to do this is to simply flip it to a short instead.*


```solidity
function flipToBurnToken(TokenId self) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to flip isLong for on all active legs|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|tokenId with all `isLong` bits flipped|


### countLongs

Get the number of longs in this option position.

Count the number of legs (out of a maximum of 4) that are long positions.


```solidity
function countLongs(TokenId self) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to count longs for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of long positions in `self` (in the range {0,...,4})|


### asTicks

Get the option position's nth leg's (index `legIndex`) tick ranges (lower, upper).

*NOTE: Does not extract liquidity which is the third piece of information in a LiquidityChunk.*


```solidity
function asTicks(TokenId self, uint256 legIndex) internal pure returns (int24 legLowerTick, int24 legUpperTick);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to extract the tick range from|
|`legIndex`|`uint256`|The leg index of the position (in {0,1,2,3})|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`legLowerTick`|`int24`|The lower tick of the leg/liquidity chunk|
|`legUpperTick`|`int24`|The upper tick of the leg/liquidity chunk|


### countLegs

Return the number of active legs in the option position.

*ASSUMPTION: There is at least 1 leg in this option position.*

*ASSUMPTION: For any leg, the option ratio is always > 0 (the leg always has a number of contracts associated with it).*


```solidity
function countLegs(TokenId self) internal pure returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to count active legs for|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The number of active legs in `self` (in the range {0,...,4})|


### clearLeg

Clear a leg in an option position with index `i`.

*set bits of the leg to zero. Also sets the optionRatio and asset to zero of that leg.*

*NOTE: it's important that the caller fills in the leg details after.*


```solidity
function clearLeg(TokenId self, uint256 i) internal pure returns (TokenId);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to clear the leg from|
|`i`|`uint256`|The leg index to reset, in {0,1,2,3}|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`TokenId`|`self` with the `i`th leg zeroed including optionRatio and asset|


### validate

Validate an option position and all its active legs; return the underlying AMM address.

*Used to validate a position tokenId and its legs.*


```solidity
function validate(TokenId self) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to validate|


### validateIsExercisable

Validate that a position `self` and its legs/chunks are exercisable.

*At least one long leg must be far-out-of-the-money (i.e. price is outside its range).*

*Reverts if the position is not exercisable.*


```solidity
function validateIsExercisable(TokenId self, int24 currentTick) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`TokenId`|The TokenId to validate for exercisability|
|`currentTick`|`int24`|The current tick corresponding to the current price in the Univ3 pool|


