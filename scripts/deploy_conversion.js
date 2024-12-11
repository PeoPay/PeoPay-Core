// This script deploys the Conversion contract after deploying PeoCoin.
// It assumes that the `backendServiceAddress` is known and that you have an RPC provider set up via Hardhat config.
//
// Instructions:
// 1. Set the `backendServiceAddress` variable below.
// 2. Run `npx hardhat run scripts/deploy_conversion.js --network <your_network>` to deploy.
// 3. After deployment, the script logs the Conversion contract address.
//
// Note: This script relies on Hardhat environment configuration for signers and RPC endpoints.
// Ensure `.env` is properly set up if you rely on environment variables for Infura/Alchemy URLs and private keys.

const { ethers } = require("hardhat");

async function main() {
  // Get the deployer's signer. Ensure the deployer has enough ETH for gas.
  const [deployer] = await ethers.getSigners();

  // Deploy PeoCoin first, as Conversion depends on it.
  // PeoCoin is the primary token contract. Adjust initial supply or other parameters directly in the contract if needed.
  const PeoCoin = await ethers.getContractFactory("PeoCoin");
  const peoCoin = await PeoCoin.deploy();
  await peoCoin.waitForDeployment();
  console.log("PeoCoin deployed at:", await peoCoin.getAddress());

  // Specify the backend service address.
  // This address represents the authorized off-chain service that confirms conversions.
  // Replace the placeholder with an actual address before deploying to production.
  const backendServiceAddress = "0xBackendServiceAddress";

  // Deploy the Conversion contract.
  // The Conversion contract locks PEO tokens until the backend service confirms the off-chain mobile money transfer.
  const Conversion = await ethers.getContractFactory("Conversion");
  const conversion = await Conversion.deploy(await peoCoin.getAddress(), backendServiceAddress);
  await conversion.waitForDeployment();
  console.log("Conversion deployed at:", await conversion.getAddress());

  // Additional logs or post-deployment steps can be added here if required.
}

main().catch((error) => {
  console.error("Error deploying Conversion contract:", error);
  process.exitCode = 1;
});
