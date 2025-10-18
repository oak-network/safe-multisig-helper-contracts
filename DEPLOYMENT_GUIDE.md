# Deployment Guide for Celo

This guide will walk you through deploying the SimpleForwarder and SimpleTarget contracts to Celo.

## Prerequisites

1. **Node.js and npm** installed
2. **A wallet with CELO tokens** (for mainnet) or test CELO (for Alfajores testnet)
3. **Your private key** (keep it secure!)

## Step-by-Step Deployment

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Environment Variables

Create a `.env` file in the project root:

```bash
cp .env.example .env
```

Edit `.env` and add your private key:

```
PRIVATE_KEY=your_private_key_without_0x_prefix
CELOSCAN_API_KEY=your_celoscan_api_key_optional
```

**⚠️ SECURITY WARNING:** Never commit your `.env` file or share your private key!

### 3. Get Test CELO (for Alfajores Testnet)

If deploying to testnet, get free test CELO from the faucet:
- Visit: https://faucet.celo.org
- Enter your wallet address
- Request test tokens

### 4. Compile Contracts

```bash
npx hardhat compile
```

### 5. Deploy to Celo

#### Deploy to Alfajores Testnet (Recommended for Testing)

```bash
npx hardhat run scripts/deploy.ts --network alfajores
```

#### Deploy to Celo Mainnet

```bash
npx hardhat run scripts/deploy.ts --network celo
```

### 6. Verify Contracts on Celoscan (Optional)

After deployment, you'll see verification commands in the output. Run them to verify your contracts:

```bash
npx hardhat verify --network alfajores <FORWARDER_ADDRESS>
npx hardhat verify --network alfajores <TARGET_ADDRESS> "<FORWARDER_ADDRESS>"
```

## Network Information

### Celo Mainnet
- **RPC URL:** https://forno.celo.org
- **Chain ID:** 42220
- **Explorer:** https://celoscan.io
- **Currency:** CELO

### Alfajores Testnet
- **RPC URL:** https://alfajores-forno.celo-testnet.org
- **Chain ID:** 44787
- **Explorer:** https://alfajores.celoscan.io
- **Faucet:** https://faucet.celo.org

## What Gets Deployed

The deployment script will:

1. ✅ Deploy `SimpleForwarder` contract
2. ✅ Deploy `SimpleTarget` contract (configured with the forwarder address)
3. ✅ Verify the setup is correct
4. ✅ Run a test transaction to ensure everything works
5. ✅ Display deployment summary with contract addresses

## Example Output

```
Starting deployment to Celo...

Deploying contracts with account: 0x1234...5678
Account balance: 10.5 CELO

Deploying SimpleForwarder...
✅ SimpleForwarder deployed to: 0xabcd...ef01

Deploying SimpleTarget...
✅ SimpleTarget deployed to: 0x2345...6789

Testing the setup...
✅ Message set successfully!
   Last message: Hello Celo!
   Last caller: 0x1234...5678

🎉 Deployment and testing complete!
```

## Using the Deployed Contracts

### Direct Call (without forwarder)
```javascript
await target.setMessage("Hello!");
// target.lastCaller will be YOUR address
```

### Forwarded Call (preserving msg.sender)
```javascript
await forwarder.forwardSetMessage(targetAddress, "Hello from forwarder!");
// target.lastCaller will STILL be YOUR address (not forwarder!)
```

### Generic Forward
```javascript
const data = target.interface.encodeFunctionData("setMessage", ["Hello"]);
await forwarder.forward(targetAddress, data);
```

## Troubleshooting

### "Insufficient funds" Error
- Make sure your wallet has enough CELO to cover gas fees
- For testnet, visit https://faucet.celo.org

### "Invalid private key" Error
- Ensure your private key in `.env` has no `0x` prefix
- Verify the private key is correct

### Deployment Hangs
- Check your internet connection
- Try using a different RPC endpoint
- Increase gas limit in hardhat.config.ts if needed

### Contract Verification Fails
- Make sure you have a Celoscan API key
- Check that the constructor arguments match exactly
- Wait a few minutes after deployment before verifying

## Additional Resources

- [Celo Documentation](https://docs.celo.org)
- [Hardhat Documentation](https://hardhat.org/docs)
- [OpenZeppelin ERC2771](https://docs.openzeppelin.com/contracts/4.x/api/metatx)
- [Celoscan](https://celoscan.io)

## Support

For issues or questions:
- Check Celo Discord: https://discord.gg/celo
- Hardhat Discord: https://discord.gg/hardhat


