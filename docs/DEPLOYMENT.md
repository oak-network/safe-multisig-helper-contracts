# Deployment Guide

## Overview

This guide covers deploying the `AdapterManager` contract to Celo networks using Hardhat Ignition.

## Prerequisites

1. **Environment Setup**
   ```bash
   # Create .env file with your private key
   PRIVATE_KEY=your_private_key_without_0x_prefix
   CELOSCAN_API_KEY=your_celoscan_api_key
   ```

2. **Install Dependencies**
   ```bash
   npm install
   ```

3. **Compile Contracts**
   ```bash
   npm run compile
   ```

## Deployment Options

### Option 1: Deploy to Testnet (Alfajores)

**Using deployer as admin:**
```bash
npx hardhat ignition deploy ignition/modules/deploy.ts --network alfajores
```

**Using Safe multisig as admin:**
```bash
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network alfajores \
  --parameters '{"DeployAdapterManager":{"adminAddress":"0xYourSafeMultisigAddress"}}'
```

### Option 2: Deploy to Mainnet (Celo)

**Using deployer as admin:**
```bash
npx hardhat ignition deploy ignition/modules/deploy.ts --network celo
```

**Using Safe multisig as admin:**
```bash
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network celo \
  --parameters '{"DeployAdapterManager":{"adminAddress":"0xYourSafeMultisigAddress"}}'
```

### Option 3: Using Parameters File

1. **Edit `ignition/parameters.json`:**
   ```json
   {
     "DeployAdapterManager": {
       "adminAddress": "0xYourSafeMultisigAddress"
     }
   }
   ```

2. **Deploy:**
   ```bash
   npx hardhat ignition deploy ignition/modules/deploy.ts \
     --network alfajores \
     --parameters ignition/parameters.json
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
- [ ] Private key in `.env` file
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

## Security Best Practices

1. **Use Safe Multisig for Production**
   - Deploy with Safe as admin, not EOA
   - Or transfer admin to Safe immediately after deployment

2. **Verify Contracts**
   - Always verify on Celoscan
   - Allows users to read source code
   - Enables Safe UI integration

3. **Test on Testnet First**
   - Deploy to Alfajores first
   - Test all functions
   - Verify meta-transactions work
   - Only then deploy to mainnet

4. **Backup Deployment Info**
   - Save deployment addresses
   - Keep deployment artifacts
   - Document admin address

## Example Deployment Flow

```bash
# 1. Compile
npm run compile

# 2. Run tests
npm test

# 3. Deploy to testnet
npx hardhat ignition deploy ignition/modules/deploy.ts --network alfajores

# 4. Save the address
# From: ignition/deployments/chain-44787/deployed_addresses.json

# 5. Verify on Celoscan
npx hardhat verify --network alfajores <ADDRESS> "<ADMIN>"

# 6. Test the deployment
npx hardhat console --network alfajores
> const manager = await ethers.getContractAt("AdapterManager", "<ADDRESS>");
> await manager.admin();

# 7. If successful, deploy to mainnet
npx hardhat ignition deploy ignition/modules/deploy.ts --network celo
```

## NPM Scripts

Quick commands from `package.json`:

```bash
# Deploy to Alfajores
npm run deploy:alfajores

# Deploy to Celo Mainnet
npm run deploy:celo
```

## Support

For issues or questions:
1. Check [Hardhat Ignition Docs](https://hardhat.org/ignition)
2. Review [Celo Documentation](https://docs.celo.org)
3. Check deployment logs in `ignition/deployments/`

---

**Ready to deploy?** Start with Alfajores testnet, then move to mainnet!

