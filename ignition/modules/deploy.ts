import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeployModule = buildModule("DeployAdapterManager", (m) => {
  // Get admin address parameter or use deployer account as default
  const admin = m.getParameter("SAFE_ADMIN", m.getAccount(0));
  // Deploy AdapterManager directly with constructor
  const adapterManager = m.contract("AdapterManager", [admin], {
    id: "AdapterManager",
  });

  return { 
    adapterManager 
  };
});

export default DeployModule;

