# Unit Tests

Comprehensive unit tests for the AdapterManager system.

## Test Coverage

### 📦 AdapterManager (19 tests)

**Deployment Tests:**
- ✅ Sets correct admin address
- ✅ Prevents double initialization
- ✅ Rejects zero address as admin

**Access Control Tests:**
- ✅ Admin can change admin
- ✅ Non-admin cannot change admin
- ✅ Cannot change admin to zero address
- ✅ Non-admin cannot call adapter functions

**Execute Call Tests:**
- ✅ Admin can execute arbitrary calls
- ✅ Non-admin cannot execute calls
- ✅ Rejects zero address as target

**Zero Address Validation:**
- ✅ Validates treasury address for KeepWhatsRaised functions
- ✅ Validates treasury address for AllOrNothing functions
- ✅ Validates treasury address for PaymentTreasury functions

**UUPS Upgradeability:**
- ✅ Admin can upgrade contract
- ✅ Non-admin cannot upgrade
- ✅ State persists after upgrade

**Function Inheritance:**
- ✅ Has all KeepWhatsRaised functions
- ✅ Has all AllOrNothing functions
- ✅ Has all PaymentTreasury functions

### 🏦 KeepWhatsRaisedAdapter (9 tests)

- ✅ setPaymentGatewayFee - calls treasury correctly
- ✅ approveWithdrawal - calls treasury correctly
- ✅ withdraw - calls treasury correctly
- ✅ claimTip - calls treasury correctly
- ✅ claimFund - calls treasury correctly
- ✅ kwrCancelTreasury - calls treasury correctly
- ✅ kwrPauseTreasury - calls treasury correctly
- ✅ kwrUnpauseTreasury - calls treasury correctly
- ✅ All functions reject non-admin calls

### 🎯 AllOrNothingAdapter (6 tests)

- ✅ aonCancelTreasury - calls treasury and validates
- ✅ aonPauseTreasury - calls treasury and validates
- ✅ aonUnpauseTreasury - calls treasury and validates
- ✅ All functions reject non-admin calls
- ✅ All functions reject zero treasury address

### 💳 PaymentTreasuryAdapter (11 tests)

- ✅ createPayment - calls treasury correctly
- ✅ cancelPayment - calls treasury correctly
- ✅ confirmPayment - calls treasury correctly
- ✅ confirmPaymentBatch - handles multiple payments
- ✅ claimRefund (with address) - calls treasury correctly
- ✅ claimRefund (without address) - calls treasury correctly
- ✅ ptCancelTreasury - calls treasury correctly
- ✅ ptPauseTreasury - calls treasury correctly
- ✅ ptUnpauseTreasury - calls treasury correctly
- ✅ All functions reject non-admin calls

## Running Tests

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/AdapterManager.test.ts

# Run with gas reporting
REPORT_GAS=true npx hardhat test

# Run with coverage
npx hardhat coverage
```

## Test Structure

```
test/
├── AdapterManager.test.ts           # Main contract tests
├── KeepWhatsRaisedAdapter.test.ts   # KWR adapter tests
├── AllOrNothingAdapter.test.ts      # AON adapter tests
├── PaymentTreasuryAdapter.test.ts   # PT adapter tests
└── README.md                        # This file

contracts/mocks/
└── MockTreasury.sol                 # Mock treasury contracts for testing
```

## Mock Contracts

The test suite uses mock treasury contracts to verify that:
1. Correct functions are called on target treasuries
2. Correct parameters are passed
3. Events are emitted properly
4. Access control works correctly

## Test Results

```
✔ 45 tests passing
✔ 0 tests failing
✔ 100% success rate
```

## What's Tested

### ✅ Access Control
- Only admin can call functions
- Admin can be changed
- Zero address validations

### ✅ Function Calls
- All adapter functions call treasury correctly
- Parameters are passed correctly
- Events are emitted

### ✅ UUPS Upgradeability
- Proxy can be upgraded
- State persists after upgrade
- Only admin can upgrade

### ✅ Inheritance
- All functions from parent contracts are available
- No function conflicts
- Proper inheritance chain

## Adding New Tests

To add tests for new functionality:

1. Create test file in `test/` directory
2. Import required contracts and helpers
3. Follow existing test patterns
4. Run tests to verify

Example:
```typescript
import { expect } from "chai";
import { ethers, upgrades } from "hardhat";

describe("NewFeature", function () {
  beforeEach(async function () {
    // Setup
  });

  it("Should do something", async function () {
    // Test logic
  });
});
```

## Continuous Integration

Tests run automatically on:
- Every commit
- Pull requests
- Before deployment

Ensure all tests pass before deploying to production!

