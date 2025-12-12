import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const { vars } = require("hardhat/config");

const DeployModule = buildModule("DeployAdapterManager", (m) => {
  // Get admin address from Hardhat vars, parameter, or use deployer account as default
  const admin = vars.get("SAFE_ADMIN") || m.getParameter("SAFE_ADMIN");
  console.log("🔧 Deploying AdapterManager with admin:", admin);
  // Deploy AdapterManager directly with constructor
  const adapterManager = m.contract("AdapterManager", [admin], {
    id: "AdapterManager",
  });

  return { 
    adapterManager 
  };
});

export default DeployModule;

