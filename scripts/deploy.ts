import { ethers } from "hardhat";

async function main() {
  console.log("Starting deployment to Celo...\n");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);
  
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "CELO\n");

  // Deploy SimpleForwarder
  console.log("Deploying SimpleForwarder...");
  const SimpleForwarder = await ethers.getContractFactory("SimpleForwarder");
  const forwarder = await SimpleForwarder.deploy();
  await forwarder.waitForDeployment();
  const forwarderAddress = await forwarder.getAddress();
  
  console.log("✅ SimpleForwarder deployed to:", forwarderAddress);
  console.log();

  // Deploy SimpleTarget with forwarder address
  console.log("Deploying SimpleTarget...");
  const SimpleTarget = await ethers.getContractFactory("SimpleTarget");
  const target = await SimpleTarget.deploy(forwarderAddress);
  await target.waitForDeployment();
  const targetAddress = await target.getAddress();
  
  console.log("✅ SimpleTarget deployed to:", targetAddress);
  console.log();

  // Verify the setup
  console.log("Verifying deployment...");
  const trustedForwarder = await target.trustedForwarder();
  console.log("SimpleTarget's trusted forwarder:", trustedForwarder);
  console.log("Matches SimpleForwarder address:", trustedForwarder === forwarderAddress);
  console.log();

  // Summary
  console.log("═══════════════════════════════════════════════");
  console.log("DEPLOYMENT SUMMARY");
  console.log("═══════════════════════════════════════════════");
  console.log("Network:", (await ethers.provider.getNetwork()).name);
  console.log("Chain ID:", (await ethers.provider.getNetwork()).chainId);
  console.log();
  console.log("SimpleForwarder:", forwarderAddress);
  console.log("SimpleTarget:", targetAddress);
  console.log("═══════════════════════════════════════════════");
  console.log();
  
  // Instructions for verification
  console.log("To verify contracts on Celoscan, run:");
  console.log(`npx hardhat verify --network ${(await ethers.provider.getNetwork()).name} ${forwarderAddress}`);
  console.log(`npx hardhat verify --network ${(await ethers.provider.getNetwork()).name} ${targetAddress} "${forwarderAddress}"`);
  console.log();

  // Test the setup
  console.log("Testing the setup...");
  console.log("Calling forwardSetMessage with 'Hello Celo!'...");
  const tx = await forwarder.forwardSetMessage(targetAddress, "Hello Celo!");
  await tx.wait();
  
  const lastMessage = await target.lastMessage();
  const lastCaller = await target.lastCaller();
  
  console.log("✅ Message set successfully!");
  console.log("   Last message:", lastMessage);
  console.log("   Last caller:", lastCaller);
  console.log("   Caller matches deployer:", lastCaller === deployer.address);
  console.log();
  
  console.log("🎉 Deployment and testing complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

