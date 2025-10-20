# Safe Multisig Helper Contracts

A comprehensive adapter system for managing treasury contracts through Safe multisig wallets, with support for meta-transactions to preserve caller identity.

[![Tests](https://img.shields.io/badge/tests-52%20passing-brightgreen)]()
[![Solidity](https://img.shields.io/badge/solidity-0.8.22-blue)]()

## Overview

The **AdapterManager** contract enables Safe multisig wallets to efficiently manage multiple treasury contracts through a unified interface. It combines three specialized adapters into a single contract and implements a meta-transaction pattern to preserve the original caller's identity.

### Why This Helper Contract?

Managing multiple treasury contracts with a Safe multisig wallet creates operational bottlenecks:

- ❌ Each treasury requires separate role permissions
- ❌ Every permission change needs meeting the Safe's signature threshold
- ❌ Managing permissions across multiple treasuries is exponentially complex
- ❌ Each treasury update requires a full Safe transaction with multiple signatures

**AdapterManager solves this by:**

✅ **Consolidating permissions** - Configure Safe permission once for the AdapterManager  
✅ **Eliminating repetitive signatures** - Manage all treasury interactions through one contract  
✅ **Standardized interface** - Consistent API for all treasury operations  
✅ **Meta-transaction support** - Preserves original caller identity for access control  
✅ **Quick treasury additions** - Add new treasuries without Safe permission changes  

## Key Features

### 🎯 Unified Adapter System
- **AllOrNothingAdapter** - Cancel, pause, unpause operations
- **KeepWhatsRaisedAdapter** - Crowdfunding treasury management (13 functions)
- **PaymentTreasuryAdapter** - Payment processing operations (9 functions)

### 🔄 Meta-Transaction Pattern
- Preserves Safe multisig identity when calling treasury contracts
- Treasury contracts can verify the actual caller (not just the adapter)
- Enables proper access control and audit trails
- ~200-300 gas overhead per transaction

### 🔒 Security
- Simple admin-based access control
- Zero-address validation on all functions
- Custom error handling for gas efficiency
- Non-upgradeable design for simplicity

### 🛠️ Flexibility
- Generic `executeCall()` for any contract interaction
- Support for complex data types (structs, arrays)
- Overloaded function support
- Batch operations

## Architecture

```
┌─────────────────┐
│  Safe Multisig  │ (Admin)
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│       AdapterManager                │
│  ┌──────────────────────────────┐  │
│  │ KeepWhatsRaisedAdapter       │  │
│  │ AllOrNothingAdapter          │  │
│  │ PaymentTreasuryAdapter       │  │
│  │ BaseAdminAdapter             │  │
│  └──────────────────────────────┘  │
└────────┬────────────────────────────┘
         │ (with meta-transaction)
         ▼
┌─────────────────┐
│ Treasury        │
│ Contracts       │
└─────────────────┘
```

## Quick Start

### Prerequisites
- Node.js >=18.0
- npm package manager

### Installation

```bash
# Clone the repository
git clone https://github.com/ccprotocol/safe-multisig-helper-contracts.git
cd safe-multisig-helper-contracts

# Install dependencies
npm install

# Compile contracts
npm run compile
```

### 2. Install dependencies
```bash
# 1. Install dependencies
npm install
```

### 3. Set env
```bash
1. npx hardhat vars set PRIVATE_KEY
2. npx hardhat vars set SAFE_ADMIN
```
For more : [configuration-variables](https://hardhat.org/hardhat-runner/docs/guides/configuration-variables)

### Testing

```bash
# Run all tests (52 tests)
npm test

# Run with gas reporting
npm run test:gas

# Run with coverage
npm run test:coverage
```

### Deployment

```bash
# Deploy to Alfajores testnet
npm run deploy:alfajores

# Deploy to Celo mainnet
npm run deploy:celo

# Deploy with custom Safe multisig as admin
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network alfajores \
  --parameters '{"DeployAdapterManager":{"adminAddress":"0xYourSafeAddress"}}'
```

## Documentation

### 📚 Core Documentation

| Document | Description |
|----------|-------------|
| **[docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md)** | Comprehensive deployment guide with examples, verification, and troubleshooting |
| **[docs/META_TRANSACTIONS.md](./docs/META_TRANSACTIONS.md)** | Complete guide to the meta-transaction pattern implementation |
| **[docs/META_TRANSACTIONS_SUMMARY.md](./docs/META_TRANSACTIONS_SUMMARY.md)** | Quick reference for meta-transaction setup |

### 🚀 Deployment & Testing

| Document | Description |
|----------|-------------|
| **[ignition/README.md](./ignition/README.md)** | Hardhat Ignition deployment guide and quick reference |
| **[test/README.md](./test/README.md)** | Test suite documentation and usage |

### 📖 Additional Resources

- [Hardhat Documentation](https://hardhat.org)
- [Safe Multisig Documentation](https://docs.safe.global)
- [Celo Documentation](https://docs.celo.org)

## Contract Functions

### AllOrNothingAdapter (3 functions)
```solidity
aonCancelTreasury(address treasury, bytes32 message)
aonPauseTreasury(address treasury, bytes32 message)
aonUnpauseTreasury(address treasury, bytes32 message)
```

### KeepWhatsRaisedAdapter (13 functions)
```solidity
setPaymentGatewayFee(address treasury, bytes32 pledgeId, uint256 fee)
approveWithdrawal(address treasury)
configureTreasury(address treasury, ...)
updateDeadline(address treasury, uint256 deadline)
updateGoalAmount(address treasury, uint256 goalAmount)
setFeeAndPledge(address treasury, ...)
withdraw(address treasury, uint256 amount)
claimTip(address treasury)
claimFund(address treasury)
kwrCancelTreasury(address treasury, bytes32 message)
kwrPauseTreasury(address treasury, bytes32 message)
kwrUnpauseTreasury(address treasury, bytes32 message)
```

### PaymentTreasuryAdapter (9 functions)
```solidity
createPayment(address treasury, ...)
cancelPayment(address treasury, bytes32 paymentId)
confirmPayment(address treasury, bytes32 paymentId)
confirmPaymentBatch(address treasury, bytes32[] paymentIds)
claimRefund(address treasury, bytes32 paymentId)
claimRefund(address treasury, bytes32 paymentId, address refundAddress)
ptCancelTreasury(address treasury, bytes32 message)
ptPauseTreasury(address treasury, bytes32 message)
ptUnpauseTreasury(address treasury, bytes32 message)
```

### BaseAdminAdapter
```solidity
changeAdmin(address _newAdmin)
executeCall(address target, bytes calldata data) returns (bool, bytes)
```

## Meta-Transaction Pattern

All adapter functions append the caller's address to the calldata, allowing treasury contracts to extract and verify the original Safe multisig address:

```solidity
// In AdapterManager
bytes memory dataWithSender = abi.encodePacked(data, msg.sender);
treasury.call(dataWithSender);

// In Treasury Contract
function _msgSender() internal view returns (address) {
    if (msg.data.length >= 20) {
        assembly {
            sender := shr(96, calldataload(sub(calldatasize(), 20)))
        }
    } else {
        return msg.sender;
    }
}
```

See [docs/META_TRANSACTIONS.md](./docs/META_TRANSACTIONS.md) for complete implementation details.

## Testing

The project includes comprehensive test coverage:

- ✅ **52 tests passing**
- ✅ **AdapterManager tests** - Deployment, access control, inheritance
- ✅ **Meta-transaction tests** - Sender extraction, complex scenarios
- ✅ **Adapter tests** - All functions for each adapter type
- ✅ **Mock contracts** - Treasury implementations for testing

Run tests:


### 4. Compile the contracts
```bash
# Testnet
npm run deploy:alfajores

# Mainnet
npm run deploy:celo
```

### Verification

After deployment, verify on Celoscan:

```bash
npx hardhat verify --network alfajores <CONTRACT_ADDRESS> "<ADMIN_ADDRESS>"
```

### Post-Deployment

1. Save the deployed contract address
2. Verify the contract on Celoscan
3. Test admin functions
4. Transfer admin to Safe multisig if needed
5. Document for [multisig-permission-kit](https://github.com/ccprotocol/multisig-permission-kit)

See [docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md) for detailed deployment instructions.

## Project Structure

```
safe-multisig-helper-contracts/
├── contracts/
│   ├── AdapterManager.sol              # Main contract
│   ├── base/
│   │   └── BaseAdminAdapter.sol        # Base admin functionality
│   ├── AllOrNothingAdapter.sol         # AoN treasury adapter
│   ├── KeepWhatsRaisedAdapter.sol      # KWR treasury adapter
│   ├── PaymentTreasuryAdapter.sol      # Payment treasury adapter
│   ├── interfaces/                     # Treasury interfaces
│   └── mocks/                          # Mock contracts for testing
├── test/
│   ├── AdapterManager.test.ts          # Main contract tests
│   ├── MetaTransaction.test.ts         # Meta-transaction tests
│   ├── AllOrNothingAdapter.test.ts     # AoN adapter tests
│   ├── KeepWhatsRaisedAdapter.test.ts  # KWR adapter tests
│   ├── PaymentTreasuryAdapter.test.ts  # Payment adapter tests
│   └── README.md                       # Test documentation
├── ignition/
│   ├── modules/
│   │   └── deploy.ts                   # Deployment module
│   ├── parameters.json                 # Deployment parameters
│   └── README.md                       # Deployment guide
├── docs/
│   ├── DEPLOYMENT.md                   # Deployment documentation
│   ├── META_TRANSACTIONS.md            # Meta-transaction guide
│   └── META_TRANSACTIONS_SUMMARY.md    # Quick reference
├── hardhat.config.ts                   # Hardhat configuration
└── package.json                        # Dependencies and scripts
```
### 5. Future Use
Save the contract address for [multisig-permission-kit](https://github.com/ccprotocol/multisig-permission-kit.git)
