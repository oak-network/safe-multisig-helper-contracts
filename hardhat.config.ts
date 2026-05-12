import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const { vars } = require("hardhat/config");

const PRIVATE_KEY = vars.get("PRIVATE_KEY");
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  networks: {
    alfajores: {
        url: `https://alfajores-forno.celo-testnet.org`,
        accounts: [PRIVATE_KEY],
        chainId: 44787,
    },
    celo: {
        url: "https://forno.celo.org",
        accounts: [PRIVATE_KEY],
        chainId: 42220,
    },
    sepolia: {
        url: "https://1rpc.io/sepolia",
        accounts: [PRIVATE_KEY],
        chainId: 11155111,
    },
    ethereum: {
        url: "https://1rpc.io/eth",
        accounts: [PRIVATE_KEY],
        chainId: 1,
    },
},
};

export default config;
