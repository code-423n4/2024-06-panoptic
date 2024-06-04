# IERC20Partial
[Git Source](https://github.com/code-423n4/2024-06-panoptic/blob/a868cbaf8b56e1739446f63a0ed03b03b5f60685/contracts/tokens/interfaces/IERC20Partial.sol)

**Author:**
Axicon Labs Limited

*Does not include return values as certain tokens such as USDT fail to implement them.*

*Since the return value is not expected, this interface works with both compliant and non-compliant tokens.*

*Clients are recommended to consume and handle the return of negative success values.*

*However, we cannot productively handle a failed approval and such a situation would surely cause a revert later in execution.*

*In addition, no notable instances exist of tokens that both i) contain a failure case for `approve` and ii) return `false` instead of reverting.*


## Functions
### balanceOf

Returns the amount of tokens owned by `account`.

*This function is unchanged from the EIP*


```solidity
function balanceOf(address account) external view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`account`|`address`|The address to query the balance of|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The amount of tokens owned by `account`|


### approve

Sets `amount` as the allowance of `spender` over the caller's tokens.

*While this function is specified to return a boolean value in the EIP, this interface does not expect one*


```solidity
function approve(address spender, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`spender`|`address`|The address which will spend the funds|
|`amount`|`uint256`|The amount of tokens allowed to be spent|


### transfer

Transfers tokens from the caller to another user.


```solidity
function transfer(address to, uint256 amount) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`to`|`address`|The user to transfer tokens to|
|`amount`|`uint256`|The amount of tokens to transfer|


