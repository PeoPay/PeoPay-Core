// SPDX-License-Identifier: GPL-3.0
//
// This script deploys the PeoCoin contract, which is an ERC-20 token used throughout the PeoPay ecosystem.
//
// Usage:
// 1. Ensure Hardhat environment is set up and you have a funded deployer account.
// 2. Run: npx hardhat run scripts/deploy_peocoin.js --network <your_network>
//
// Prerequisites:
// - Hardhat configured with RPC endpoint and a private key for deployer in .env
// - Access to a funded deployer account on the chosen network

const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying PeoCoin with the account:", await deployer.getAddress());

  // Load PeoCoin contract factory
  const PeoCoin = await ethers.getContractFactory("PeoCoin");

  // Deploy PeoCoin
  // PeoCoin is an ERC-20 token that mints an initial supply to the deployer
  const peoCoin = await PeoCoin.deploy();
  await peoCoin.waitForDeployment();

  console.log("PeoCoin deployed at:", await peoCoin.getAddress());
}

main().catch((error) => {
  console.error("Error deploying PeoCoin contract:", error);
  process.exitCode = 1;
});
