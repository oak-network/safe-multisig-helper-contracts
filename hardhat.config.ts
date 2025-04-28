import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const { vars } = require("hardhat/config");

const PRIVATE_KEY = vars.get("PRIVATE_KEY");
const config: HardhatUserConfig = {
  solidity: "0.8.28",
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
},
};

export default config;
