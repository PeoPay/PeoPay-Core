// SPDX-License-Identifier: GPL-3.0
//
// This script deploys the Governance contract, which depends on:
// - A deployed PeoCoin contract for token balance checks
// - A deployed DCS contract for scoring users' voting power
//
// Usage:
// 1. Update peoCoinAddress and dcsAddress with the actual deployed contract addresses.
// 2. Run: npx hardhat run scripts/deploy_governance.js --network <your_network>
//
// Prerequisites:
// - Properly set Hardhat environment
// - Access to a funded deployer account
// - Deployed PeoCoin and DCS contracts

const { ethers } = require("hardhat");

async function main() {
  // Replace these placeholders with actual deployed contract addresses
  const peoCoinAddress = "0xPeoCoinContractAddress";
  const dcsAddress = "0xDCSContractAddress";

  const [deployer] = await ethers.getSigners();
  console.log("Deploying Governance with the account:", await deployer.getAddress());

  // Load the Governance contract factory
  const Governance = await ethers.getContractFactory("Governance");

  // Deploy Governance with the PeoCoin and DCS addresses
  // Governance constructor: constructor(address _peoToken, address _dcs)
  const governance = await Governance.deploy(peoCoinAddress, dcsAddress);
  await governance.waitForDeployment();

  console.log("Governance deployed at:", await governance.getAddress());
}

main().catch((error) => {
  console.error("Error deploying Governance contract:", error);
  process.exitCode = 1;
});
