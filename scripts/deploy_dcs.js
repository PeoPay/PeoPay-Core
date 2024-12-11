// SPDX-License-Identifier: GPL-3.0
//
// This script deploys the DCS (Dynamic Contribution Scoring) contract.
// It assumes that PeoCoin and a staking contract (e.g., MockStaking) are already deployed.
// Adjust the addresses or add deployment steps as needed.
//
// Usage:
// 1. Update the peoCoinAddress and stakingAddress with actual deployed contract addresses.
// 2. Run: npx hardhat run scripts/deploy_dcs.js --network <your_network>
//
// Prerequisites:
// - Hardhat environment set up
// - Access to a signer with deployer privileges
// - Deployed PeoCoin and staking contract

const { ethers } = require("hardhat");

async function main() {
  // Ensure these addresses point to already deployed contracts.
  // Replace the placeholders with actual addresses before running the script.
  const peoCoinAddress = "0xPeoCoinContractAddress";
  const stakingContractAddress = "0xStakingContractAddress"; // Could be MockStaking or a real Staking contract.

  const [deployer] = await ethers.getSigners();
  console.log("Deploying DCS with the account:", await deployer.getAddress());

  // Load the DCS contract factory
  const DCS = await ethers.getContractFactory("DCS");

  // Deploy DCS with the PeoCoin and staking contract addresses
  // DCS constructor: constructor(address _peoToken, address _staking)
  const dcs = await DCS.deploy(peoCoinAddress, stakingContractAddress);
  await dcs.waitForDeployment();

  console.log("DCS deployed at:", await dcs.getAddress());
}

main().catch((error) => {
  console.error("Error deploying DCS contract:", error);
  process.exitCode = 1;
});
