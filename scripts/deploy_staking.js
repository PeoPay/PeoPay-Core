// SPDX-License-Identifier: GPL-3.0
//
// This script deploys the Staking contract, which depends on PeoCoin for staking.
// Users stake PEO tokens, lock them for a period, and earn rewards.
//
// Usage:
// 1. Update peoCoinAddress with a valid, deployed PeoCoin contract address.
// 2. Run: npx hardhat run scripts/deploy_staking.js --network <your_network>
//
// Prerequisites:
// - A deployed PeoCoin contract (peoCoinAddress set below).
// - A configured Hardhat environment.
// - A funded deployer account on the chosen network.

const { ethers } = require("hardhat");

async function main() {
  // Replace this with the actual deployed PeoCoin address
  const peoCoinAddress = "0xPeoCoinContractAddress";

  const [deployer] = await ethers.getSigners();
  console.log("Deploying Staking with the account:", await deployer.getAddress());

  // Load Staking contract factory
  const Staking = await ethers.getContractFactory("Staking");

  // Deploy Staking with the PeoCoin address
  // constructor(address _peoToken)
  const staking = await Staking.deploy(peoCoinAddress);
  await staking.waitForDeployment();

  console.log("Staking deployed at:", await staking.getAddress());
}

main().catch((error) => {
  console.error("Error deploying Staking contract:", error);
  process.exitCode = 1;
});
