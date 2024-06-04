# Multicall
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/base/Multicall.sol)

**Author:**
Axicon Labs Limited

Enables calling multiple methods in a single call to the contract.

*Helpful for performing batch operations such as an "emergency exit", or simply creating advanced positions.*


## Functions
### multicall

Performs multiple calls on the inheritor in a single transaction, and returns the data from each call.


```solidity
function multicall(bytes[] calldata data) public payable returns (bytes[] memory results);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`data`|`bytes[]`|The calldata for each call|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`results`|`bytes[]`|The data returned by each call|


