# SafeMultisigAdapter

A helper contract designed to facilitate interactions between Safe multisig wallets and various treasury contracts.


## Why This Helper Contract?

This contract solves a critical efficiency problem when managing multiple treasury contracts with a Safe multisig wallet. Without this helper:

- Each treasury interaction requires configuring separate role permissions
- Every permission change requires meeting the Safe's signature threshold
- Managing permissions across multiple treasuries becomes exponentially complex
- Each treasury update requires a full Safe transaction with multiple signatures

The SafeTreasuryHelper acts as a permission aggregator - configure the Safe permission once for the helper, then manage all treasury interactions through this single trusted contract. This dramatically reduces the operational overhead by:

1. Consolidating permissions into a single contract
2. Eliminating repetitive signature gathering for similar operations
3. Providing a standardized interface for all treasury interactions
4. Enabling quick addition of new treasury contracts without Safe permission changes

For teams managing multiple treasuries, this helper significantly streamlines operations while maintaining the security of the underlying Safe multisig authentication.

## Key Features

- Simple admin-based access control
- Support for calling common treasury functions across multiple contracts
- Custom error handling for better gas efficiency and debugging
- Flexible executeCall function for any contract interaction

This design follows the principle of least privilege while maximizing operational efficiency for treasury management.

# Project Setup 

This guide explains how to set up and deploy your Hardhat project using environment variables and Hardhat Ignition.

## Prerequisites
- Node.js >=18.0
- npm package manager

## Setup Steps

### 1. Clone the repository
```bash
git clone https://github.com/ccprotocol/safe-multisig-helper-contracts.git
cd safe-multisig-helper-contracts
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure environment variables
For helper contracts deployments, you need a PRIVATE_KEY and SAFE_ADMIN (your safe address) which will be the owner of the contract.
```bash
1. npx hardhat vars set PRIVATE_KEY
2. npx hardhat vars set SAFE_ADMIN
```
For more : [configuration-variables](https://hardhat.org/hardhat-runner/docs/guides/configuration-variables)

### 4. Compile the contracts
```bash
npx hardhat compile
```

### 5. Deploy using Hardhat Ignition
```bash
npx hardhat ignition deploy ./ignition/modules/deploy.ts --network celo
```
### 5. Future Use
Save the contract address for [multisig-permission-kit](https://github.com/ccprotocol/multisig-permission-kit.git)
