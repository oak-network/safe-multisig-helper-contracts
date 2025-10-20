# Meta-Transaction Pattern Documentation

## Overview

This system implements a meta-transaction pattern (inspired by EIP-2771) to preserve the identity of the original transaction signer when calls are forwarded through the `AdapterManager` contract.

## Why Meta-Transactions?

### The Problem

When a Safe multisig calls a treasury contract through the `AdapterManager`:

```
Safe Multisig → AdapterManager → Treasury Contract
```

The treasury contract would see `msg.sender` as the `AdapterManager` address, not the Safe multisig address. This breaks access control and audit trails.

### The Solution

The `AdapterManager` appends the original caller's address (`msg.sender`) to the calldata before forwarding:

```
Safe Multisig → AdapterManager (appends Safe address) → Treasury (extracts Safe address)
```

Now the treasury contract can extract the original signer's address from the calldata and use it for access control.

## How It Works

### 1. **Adapter Side (Sender)**

All adapter functions encode the function call and append `msg.sender`:

```solidity
function aonCancelTreasury(address treasury, bytes32 message) external onlyAdmin {
    if (treasury == address(0)) revert ZeroAddress();
    
    // Encode the function call
    bytes memory data = abi.encodeWithSignature(
        "cancelTreasury(bytes32)",
        message
    );
    
    // Append msg.sender (20 bytes) to the end of calldata
    bytes memory dataWithSender = abi.encodePacked(data, msg.sender);
    
    // Forward the modified calldata
    (bool success, ) = treasury.call(dataWithSender);
    if (!success) revert CallFailed();
}
```

**What gets sent:**
```
[4 bytes function selector] + [function parameters] + [20 bytes sender address]
```

### 2. **Treasury Side (Receiver)**

The treasury contract extracts the sender from the last 20 bytes:

```solidity
function _msgSender() internal view returns (address sender) {
    if (msg.data.length >= 20) {
        assembly {
            // Load last 20 bytes from calldata
            sender := shr(96, calldataload(sub(calldatasize(), 20)))
        }
    } else {
        sender = msg.sender;
    }
}
```

**Assembly Breakdown:**
- `calldatasize()` - Total length of calldata
- `sub(calldatasize(), 20)` - Position of last 20 bytes
- `calldataload(...)` - Load 32 bytes from that position
- `shr(96, ...)` - Right shift 96 bits (12 bytes) to get address (20 bytes)

### 3. **Using the Extracted Sender**

The treasury uses `_msgSender()` instead of `msg.sender`:

```solidity
function cancelTreasury(bytes32 message) external {
    address realSender = _msgSender(); // Gets the Safe multisig address
    
    // Use realSender for access control, events, etc.
    require(realSender == owner, "Not authorized");
    emit TreasuryCancelled(message, realSender);
}
```

## Implementation Details

### Contracts Using Meta-Transactions

#### **AdapterManager Contracts**
All these append `msg.sender` to calldata:

1. **AllOrNothingAdapter**
   - `aonCancelTreasury`
   - `aonPauseTreasury`
   - `aonUnpauseTreasury`

2. **KeepWhatsRaisedAdapter**
   - `setPaymentGatewayFee`
   - `approveWithdrawal`
   - `configureTreasury`
   - `updateDeadline`
   - `updateGoalAmount`
   - `setFeeAndPledge`
   - `withdraw`
   - `claimTip`
   - `claimFund`
   - `kwrCancelTreasury`
   - `kwrPauseTreasury`
   - `kwrUnpauseTreasury`

3. **PaymentTreasuryAdapter**
   - `createPayment`
   - `cancelPayment`
   - `confirmPayment`
   - `confirmPaymentBatch`
   - `claimRefund` (both overloads)
   - `ptCancelTreasury`
   - `ptPauseTreasury`
   - `ptUnpauseTreasury`

4. **BaseAdminAdapter**
   - `executeCall` - Generic function for any call

### Example Flow

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│ Safe        │         │ AdapterManager   │         │ Treasury    │
│ Multisig    │         │                  │         │ Contract    │
└──────┬──────┘         └────────┬─────────┘         └──────┬──────┘
       │                         │                          │
       │  1. Call function       │                          │
       │  (msg.sender = Safe)    │                          │
       ├────────────────────────>│                          │
       │                         │                          │
       │                         │  2. Encode call +        │
       │                         │     append Safe address  │
       │                         │                          │
       │                         │  3. Forward call         │
       │                         │  (calldata includes Safe)│
       │                         ├─────────────────────────>│
       │                         │                          │
       │                         │                          │  4. Extract Safe
       │                         │                          │     from calldata
       │                         │                          │
       │                         │  5. Return result        │
       │                         │<─────────────────────────┤
       │                         │                          │
       │  6. Return result       │                          │
       │<────────────────────────┤                          │
       │                         │                          │
```

## Calldata Structure

### Example: `cancelTreasury(bytes32 message)`

**Normal call (without meta-transaction):**
```
0x12345678... (4 bytes selector)
+ message parameter (32 bytes)
= 36 bytes total
```

**With meta-transaction:**
```
0x12345678... (4 bytes selector)
+ message parameter (32 bytes)
+ Safe address (20 bytes)
= 56 bytes total
```

The treasury's function still receives the correct parameters because Solidity's ABI decoder reads from the beginning of calldata. The extra 20 bytes at the end are ignored by the ABI decoder but can be manually extracted.

## Security Considerations

### ✅ **Safe Practices**

1. **Consistent Application**: All adapter functions use the same pattern
2. **Fallback to msg.sender**: If calldata is too short, fallback to `msg.sender`
3. **Type Safety**: Address extraction uses assembly for precision
4. **No Gas Overhead**: Minimal gas cost for appending 20 bytes

### ⚠️ **Important Notes**

1. **Treasury Contracts Must Implement Extraction**: Your treasury contracts MUST implement `_msgSender()` to extract the original sender
2. **Not Standard EIP-2771**: This is inspired by but not fully compliant with EIP-2771
3. **Trusting the Forwarder**: Treasury contracts should verify calls come from trusted AdapterManager
4. **No Signature Verification**: Unlike EIP-2771, this doesn't verify signatures

### 🔒 **Recommended Treasury Implementation**

```solidity
contract Treasury {
    address public trustedForwarder; // AdapterManager address
    
    function _msgSender() internal view returns (address sender) {
        // Only extract sender if called by trusted forwarder
        if (msg.sender == trustedForwarder && msg.data.length >= 20) {
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            sender = msg.sender;
        }
    }
    
    modifier onlyOwner() {
        require(_msgSender() == owner, "Not owner");
        _;
    }
}
```

## Testing

### Verify Meta-Transaction Works

```typescript
it("Should extract admin address from adapter calls", async function () {
  const message = ethers.encodeBytes32String("test");
  
  await expect(
    adapterManager.connect(admin).aonPauseTreasury(
      treasuryAddress,
      message
    )
  )
    .to.emit(treasury, "TreasuryPaused")
    .withArgs(message, admin.address); // Verify admin address is emitted
});
```

### Test Suite

Run comprehensive meta-transaction tests:

```bash
npm test test/MetaTransaction.test.ts
```

This tests:
- ✅ Sender extraction from all adapter types
- ✅ Multiple operations preserving sender
- ✅ Complex data types (structs, arrays)
- ✅ Overloaded functions
- ✅ Different admin addresses
- ✅ Edge cases (empty calldata, etc.)



## References

- [EIP-2771: Secure Protocol for Native Meta Transactions](https://eips.ethereum.org/EIPS/eip-2771)
- [OpenZeppelin ERC2771Context](https://docs.openzeppelin.com/contracts/4.x/api/metatx#ERC2771Context)
- [Safe Multisig Documentation](https://docs.safe.global/)

## Support

For questions or issues:
1. Check test files: `test/MetaTransaction.test.ts`
2. Review mock implementations: `test/mocks/MockTreasury.sol`
3. See adapter implementations: `contracts/*Adapter.sol`

