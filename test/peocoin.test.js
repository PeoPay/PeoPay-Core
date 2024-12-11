// This test suite verifies the core functionalities of the PeoCoin (PEO) ERC-20 token.
// Key functionalities tested:
// - Initial supply assigned to the owner at deployment
// - Owner-only minting privileges
// - Preventing non-owners from minting
// - Burning tokens from the user's own balance
//
// The tests ensure that the PeoCoin contract behaves as expected, following standard ERC-20 rules
// and the access control enforced by Ownable.

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PeoCoin", function () {
  let PeoCoin, peoCoin, owner, addr1;

  beforeEach(async () => {
    // Retrieve two accounts:
    // - owner: Will deploy the contract and have initial supply
    // - addr1: A secondary account used to test transfers, minting restrictions, and burning
    [owner, addr1] = await ethers.getSigners();

    // Deploy a fresh PeoCoin instance before each test to ensure a clean state
    PeoCoin = await ethers.getContractFactory("PeoCoin");
    peoCoin = await PeoCoin.deploy();
    await peoCoin.waitForDeployment();
  });

  it("Should assign initial supply to owner", async function () {
    // Check that the contract mints 1,000,000 PEO to the owner's address upon deployment.
    const ownerBalance = await peoCoin.balanceOf(await owner.getAddress());
    expect(ownerBalance).to.equal(ethers.parseUnits("1000000", 18));
  });

  it("Owner can mint tokens", async function () {
    // The owner should be able to mint additional tokens to any address.
    await peoCoin.mint(await addr1.getAddress(), ethers.parseUnits("1000", 18));
    const balance = await peoCoin.balanceOf(await addr1.getAddress());
    expect(balance).to.equal(ethers.parseUnits("1000", 18));
  });

  it("Non-owner cannot mint tokens", async function () {
    // Attempting to mint from a non-owner account should revert due to access control.
    // The contract uses Ownable to restrict minting to the owner only.
    await expect(
      peoCoin.connect(addr1).mint(await addr1.getAddress(), ethers.parseUnits("1000", 18))
    ).to.be.revertedWithCustomError(peoCoin, "OwnableUnauthorizedAccount");
  });

  it("User can burn their own tokens", async function () {
    // Transfer some tokens from owner to addr1, then let addr1 burn a portion.
    await peoCoin.transfer(await addr1.getAddress(), ethers.parseUnits("100", 18));
    await peoCoin.connect(addr1).burn(ethers.parseUnits("50", 18));

    // After burning 50 tokens, addr1 should have 50 remaining.
    const balance = await peoCoin.balanceOf(await addr1.getAddress());
    expect(balance).to.equal(ethers.parseUnits("50", 18));
  });
});
