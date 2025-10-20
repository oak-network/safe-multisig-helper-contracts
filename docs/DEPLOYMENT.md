# Deployment Guide

## Overview

This guide covers deploying the `AdapterManager` contract to Celo networks using Hardhat Ignition.

## Prerequisites

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Set Configuration Variables**
   ```bash
   # Set your private key
   npx hardhat vars set PRIVATE_KEY
   
   # Set Safe multisig admin address (optional, defaults to deployer)
   npx hardhat vars set SAFE_ADMIN
   
   # Set Celoscan API key for contract verification
   npx hardhat vars set CELOSCAN_API_KEY
   ```
   
   For more info: [Hardhat Configuration Variables](https://hardhat.org/hardhat-runner/docs/guides/configuration-variables)

3. **Compile Contracts**
   ```bash
   npm run compile
   ```

## Deployment Options

### Option 1: Deploy to Testnet (Alfajores)

```bash
npm run deploy:alfajores
```

### Option 2: Deploy to Mainnet (Celo)

```bash
npm run deploy:celo
```

### Option 3: Deploy to Mainnet (Celo)
```bash
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network celo \
  --parameters '{"DeployAdapterManager":{"adminAddress":"0xYourSafeMultisigAddress"}}'
```


## Deployment Process

When you run the deployment command:

1. **Hardhat Ignition will:**
   - Compile contracts (if needed)
   - Deploy `AdapterManager` with specified admin
   - Save deployment info to `ignition/deployments/chain-{id}/`
   - Display deployed contract address

2. **Example Output:**
   ```
   ✅ Deploying AdapterManager with admin: 0x123...abc
   ✅ AdapterManager deployed at: 0x456...def
   
   Deployment saved to: ignition/deployments/chain-44787/deployed_addresses.json
   ```

3. **Deployment Artifacts:**
   ```
   ignition/deployments/chain-44787/
   ├── deployed_addresses.json  # Contract addresses
   ├── journal.jsonl            # Deployment log
   └── artifacts/               # Deployment artifacts
   ```

## After Deployment

### 1. Get Deployed Address

```bash
# View deployed addresses
cat ignition/deployments/chain-44787/deployed_addresses.json
```

Output:
```json
{
  "DeployAdapterManager#AdapterManager": "0x456...def"
}
```

### 2. Verify Contract on Celoscan

**Using Hardhat:**
```bash
npx hardhat verify --network alfajores <CONTRACT_ADDRESS> "<ADMIN_ADDRESS>"
```

**Example:**
```bash
npx hardhat verify \
  --network alfajores \
  0x456...def \
  "0x123...abc"
```

### 3. Verify in Console

```bash
npx hardhat console --network alfajores
```

```javascript
// Get contract instance
const AdapterManager = await ethers.getContractFactory("AdapterManager");
const manager = AdapterManager.attach("0x456...def");

// Check admin
const admin = await manager.admin();
console.log("Admin:", admin);

// Check if you're the admin
const [deployer] = await ethers.getSigners();
console.log("Deployer:", deployer.address);
console.log("Is admin:", admin === deployer.address);
```

## Transfer Admin to Safe Multisig

If you deployed with your EOA but want to transfer to Safe:

```bash
npx hardhat console --network alfajores
```

```javascript
const AdapterManager = await ethers.getContractFactory("AdapterManager");
const manager = AdapterManager.attach("0x456...def");

// Transfer admin to Safe
const tx = await manager.changeAdmin("0xYourSafeAddress");
await tx.wait();

console.log("Admin transferred to Safe!");
```

## Network Configuration

### Alfajores Testnet
- **Chain ID:** 44787
- **RPC:** https://alfajores-forno.celo-testnet.org
- **Explorer:** https://alfajores.celoscan.io
- **Faucet:** https://faucet.celo.org/alfajores

### Celo Mainnet
- **Chain ID:** 42220
- **RPC:** https://forno.celo.org
- **Explorer:** https://celoscan.io

## Testing the Deployment

```bash
npx hardhat console --network alfajores
```

```javascript
// Connect to deployed contract
const manager = await ethers.getContractAt(
  "AdapterManager",
  "0x456...def"
);

// Test a function call (will revert if not admin)
const mockTreasuryAddress = "0x789...ghi";
const message = ethers.encodeBytes32String("test");

// This should work if you're the admin
await manager.aonPauseTreasury(mockTreasuryAddress, message);
```

## Deployment Checklist

### Pre-Deployment
- [ ] Contracts compiled successfully
- [ ] All tests passing (`npm test`)
- [ ] Configuration variables set (`PRIVATE_KEY`, `SAFE_ADMIN`, `CELOSCAN_API_KEY`)
- [ ] Sufficient balance for gas fees
- [ ] Admin address determined (deployer or Safe multisig)
- [ ] Network selected (alfajores or celo)

### During Deployment
- [ ] Review deployment parameters
- [ ] Confirm transaction
- [ ] Save deployed address
- [ ] Save deployment artifacts

### Post-Deployment
- [ ] Verify contract on Celoscan
- [ ] Test admin functions
- [ ] Transfer admin to Safe (if needed)
- [ ] Document contract address
- [ ] Test meta-transaction pattern with treasury

## Troubleshooting

### Error: "Insufficient funds"
```bash
# Check your balance
npx hardhat console --network alfajores
> const [deployer] = await ethers.getSigners();
> console.log(await ethers.provider.getBalance(deployer.address));
```

Get testnet CELO from: https://faucet.celo.org/alfajores

### Error: "Transaction underpriced"
The network might be congested. Try:
```bash
# Increase gas price in hardhat.config.ts
networks: {
  alfajores: {
    gasPrice: 1000000000, // 1 gwei
  }
}
```

### Error: "Contract already deployed"
Ignition prevents duplicate deployments. To redeploy:
```bash
# Use --reset flag (⚠️ use carefully)
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network alfajores \
  --reset
```

### Error: "Invalid admin address"
Make sure the admin address:
- Is a valid Ethereum address (42 characters with 0x prefix)
- Is not the zero address (0x0000...0000)
- Is checksummed correctly

## Gas Costs

Approximate gas costs (at 1 gwei):

| Network | Gas Used | Cost (CELO) |
|---------|----------|-------------|
| Alfajores | ~2.5M | ~0.0025 |
| Celo | ~2.5M | ~0.0025 |

*Actual costs may vary based on network conditions*

