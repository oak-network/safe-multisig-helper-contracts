# Ignition Deployment Modules

Hardhat Ignition modules for deploying the AdapterManager system.

## 📦 Available Modules

### `deploy.ts` - Deployment

Deploys AdapterManager contract.

```bash
# Deploy to Alfajores testnet
npx hardhat ignition deploy ignition/modules/deploy.ts --network alfajores

# Deploy to Celo mainnet
npx hardhat ignition deploy ignition/modules/deploy.ts --network celo

# Deploy with custom admin address
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network alfajores \
  --parameters '{"adminAddress":"0xYourMultisigAddress"}'
```

**What it deploys:**
- AdapterManager contract with specified admin address

## 🔧 Configuration

### Setting Admin Address

Edit `ignition/parameters.json`:

```json
{
  "DeployAdapterManager": {
    "adminAddress": "0xYourSafeMultisigAddress"
  }
}
```

Then deploy:

```bash
npx hardhat ignition deploy ignition/modules/deploy.ts \
  --network alfajores \
  --parameters ignition/parameters.json
```

### Network Configuration

Networks are configured in `hardhat.config.ts`:

```typescript
networks: {
  alfajores: {
    url: "https://alfajores-forno.celo-testnet.org",
    accounts: [...],
    chainId: 44787,
  },
  celo: {
    url: "https://forno.celo.org",
    accounts: [...],
    chainId: 42220,
  }
}
```

## 🧪 Testing Before Deployment

**Always test before deploying:**

```bash
# Run all tests
npm test

# Run specific test suite
npm test test/AdapterManager.test.ts
npm test test/MetaTransaction.test.ts

# Run with gas reporting
npm run test:gas

# Run with coverage
npm run test:coverage
```

**Expected Results:**
- ✅ 52 tests passing
- ✅ 100% function coverage on adapters
- ✅ Meta-transaction pattern verified

## 📝 Deployment Process

### First Deployment

1. **Set environment variables**
   ```bash
   # .env file
   PRIVATE_KEY=your_private_key_without_0x
   CELOSCAN_API_KEY=your_celoscan_api_key
   ```

2. **Choose admin address**
   - For testing: Use deployer address (default)
   - For production: Use Safe multisig address

3. **Compile and test**
   ```bash
   npm run compile
   npm test
   ```

4. **Deploy to testnet first**
   ```bash
   npm run deploy:alfajores
   # Or with custom admin:
   npx hardhat ignition deploy ignition/modules/deploy.ts \
     --network alfajores \
     --parameters '{"DeployAdapterManager":{"adminAddress":"0xYourSafeAddress"}}'
   ```

5. **Verify contracts**
   ```bash
   npx hardhat verify --network alfajores <CONTRACT_ADDRESS> "<ADMIN_ADDRESS>"
   ```

6. **Test the deployment**
   - Call functions through the contract
   - Verify admin access control
   - Test adapter functions with treasury
   - Verify meta-transaction pattern works

7. **Deploy to mainnet**
   ```bash
   npm run deploy:celo
   ```


## 🔍 Verification

After deployment, verify contracts on Celoscan:

```bash
# Verify contract
npx hardhat verify --network alfajores <CONTRACT_ADDRESS> "<ADMIN_ADDRESS>"
```

## 📊 Deployment Outputs

After successful deployment, Ignition saves:

```
ignition/deployments/
├── chain-44787/           # Alfajores
│   ├── deployed_addresses.json
│   ├── journal.jsonl
│   └── artifacts/
└── chain-42220/           # Celo Mainnet
    ├── deployed_addresses.json
    ├── journal.jsonl
    └── artifacts/
```

**`deployed_addresses.json`** contains:
```json
{
  "DeployAdapterManager#AdapterManager": "0x..."
}
```

## 💡 Tips

### Using with Safe Multisig

1. Deploy with deployer as temporary admin:
   ```bash
   npx hardhat ignition deploy ignition/modules/deploy.ts --network alfajores
   ```

2. Transfer admin to Safe:
   ```javascript
   const manager = await ethers.getContractAt("AdapterManager", proxyAddress);
   await manager.changeAdmin(safeAddress);
   ```

3. All future operations must be done through Safe

### Verifying Deployment

```bash
# Get contract address from deployment
cat ignition/deployments/chain-44787/deployed_addresses.json

# Check admin
npx hardhat console --network alfajores
> const manager = await ethers.getContractAt("AdapterManager", "0xContractAddress")
> await manager.admin()

# Test function call
> await manager.kwrPauseTreasury("0xTreasuryAddress", ethers.encodeBytes32String("test"))
```

### Troubleshooting

**Error: "Contract already deployed"**
- Ignition tracks deployments to prevent duplicates
- Use `--reset` flag to force redeploy (⚠️ use carefully)
- Or deploy to different network

**Error: "NotAdmin"**
- Verify you're using correct admin account
- Check admin address with `manager.admin()`
- If using Safe, submit transaction through Safe UI

**Error: "Contract deployment failed"**
- Check constructor parameters are correct
- Verify admin address is valid (not zero address)
- Ensure you have enough gas

## 🔐 Security Checklist

Before mainnet deployment:

- [ ] Admin is a Safe multisig (not EOA)
- [ ] Private keys are secure
- [ ] Tested on Alfajores testnet
- [ ] All tests passing (`npm test`)
- [ ] Contracts verified on Celoscan
- [ ] Admin transfer completed (if applicable)
- [ ] Emergency procedures documented
- [ ] Team members have access to Safe

## 📚 Additional Documentation

### In `docs/` folder:

- **[DEPLOYMENT.md](../docs/DEPLOYMENT.md)** - Comprehensive deployment guide with examples, troubleshooting, and best practices
- **[META_TRANSACTIONS.md](../docs/META_TRANSACTIONS.md)** - Complete guide to the meta-transaction pattern implementation
- **[META_TRANSACTIONS_SUMMARY.md](../docs/META_TRANSACTIONS_SUMMARY.md)** - Quick reference for meta-transaction setup

### Test Documentation:

- **[test/README.md](../test/README.md)** - Test suite documentation and usage

## 📚 External References

- [Hardhat Ignition Docs](https://hardhat.org/ignition)
- [Safe Multisig](https://safe.global)
- [Celo Docs](https://docs.celo.org)
- [Celoscan](https://celoscan.io)

