import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DeployModule = buildModule("DeployAdapterManager", (m) => {
  // Get admin address parameter or use deployer
  const adminAddress = m.getParameter("adminAddress", "");
  const admin = adminAddress || m.getAccount(0);

  console.log(`Deploying AdapterManager with admin: ${admin}`);

  // Deploy AdapterManager directly with constructor
  const adapterManager = m.contract("AdapterManager", [admin], {
    id: "AdapterManager",
  });

  return { 
    adapterManager 
  };
});

export default DeployModule;

