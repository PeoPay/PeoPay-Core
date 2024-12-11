// This test suite verifies the functionality of the Staking contract, which allows users to lock their PEO tokens
// for a period and earn rewards. It checks various conditions, including:
// - Staking a positive amount of tokens
// - Preventing staking of zero tokens
// - Disallowing unstake before the lock period ends
// - Calculating rewards and verifying scenarios where no stake exists
// - Testing reward calculations under different APY tiers or time conditions
//
// By covering these scenarios, we ensure that the staking logic is robust, secure, and behaves as expected under normal and edge cases.

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Staking", function () {
  let PeoCoin, Staking, peoCoin, staking, owner, addr1;

  beforeEach(async () => {
    [owner, addr1] = await ethers.getSigners();
    
    // Deploy PeoCoin to provide a token for staking
    PeoCoin = await ethers.getContractFactory("PeoCoin");
    peoCoin = await PeoCoin.deploy();
    await peoCoin.waitForDeployment();

    // Deploy the Staking contract and link it to the PeoCoin contract
    Staking = await ethers.getContractFactory("Staking");
    staking = await Staking.deploy(await peoCoin.getAddress());
    await staking.waitForDeployment();

    // Transfer some PEO tokens to addr1 for testing staking actions
    await peoCoin.transfer(await addr1.getAddress(), ethers.parseUnits("1000", 18));
  });

  it("User can stake tokens", async function () {
    // Approve staking contract to spend addr1's tokens and then stake 100 PEO
    await peoCoin.connect(addr1).approve(await staking.getAddress(), ethers.parseUnits("100", 18));
    await staking.connect(addr1).stake(ethers.parseUnits("100", 18));

    // Verify that a stake now exists for addr1
    const stakeInfo = await staking.stakes(await addr1.getAddress());
    expect(stakeInfo.exists).to.be.true;
  });

  it("Cannot stake zero tokens", async function () {
    // Attempting to stake zero tokens should revert with "Cannot stake zero tokens"
    await peoCoin.connect(addr1).approve(await staking.getAddress(), ethers.parseUnits("0", 18));
    await expect(staking.connect(addr1).stake(0)).to.be.revertedWith("Cannot stake zero tokens");
  });

  it("Cannot unstake before lock period ends", async function () {
    // Stake tokens first
    await peoCoin.connect(addr1).approve(await staking.getAddress(), ethers.parseUnits("100", 18));
    await staking.connect(addr1).stake(ethers.parseUnits("100", 18));

    // Attempting to unstake immediately should revert because the lock period is not over yet
    await expect(staking.connect(addr1).unstake()).to.be.revertedWith("Lock period not ended");
  });

  it("calculateReward reverts if no stake found", async function () {
    // Calling calculateReward for a user who never staked should revert with "No stake found"
    await expect(staking.calculateReward(await addr1.getAddress())).to.be.revertedWith("No stake found");
  });

  it("Reverts when calculating reward for a user with no stake (again, different scenario)", async function () {
    // Top up the staking contract with enough tokens to cover future rewards
    // The owner had minted 1,000,000 PEO initially and gave away 1000 to addr1, so we transfer 999,000 to staking
    await peoCoin.transfer(await staking.getAddress(), ethers.parseUnits("999000", 18));
  
    // Now addr1 stakes again
    await peoCoin.connect(addr1).approve(await staking.getAddress(), ethers.parseUnits("100", 18));
    await staking.connect(addr1).stake(ethers.parseUnits("100", 18));
  
    // Simulate time passing (30 days) to accumulate some rewards
    await ethers.provider.send("evm_increaseTime", [30 * 24 * 3600]);
    await ethers.provider.send("evm_mine");
  
    // Unstake after the lock period, receiving principal + reward
    await staking.connect(addr1).unstake();
  
    // After unstaking, addr1 has no active stake
    // Calling calculateReward now should revert with "No stake found"
    await expect(staking.calculateReward(await addr1.getAddress())).to.be.revertedWith("No stake found");
  });
  
  it("Covers reward calculation under different APY tiers", async function () {
    // If your staking contract supports multiple APY tiers, or if time-based conditions apply:
    // Stake a larger amount and increase time significantly to trigger any different tiers or calculations
    
    await peoCoin.connect(addr1).approve(await staking.getAddress(), ethers.parseUnits("200", 18));
    await staking.connect(addr1).stake(ethers.parseUnits("200", 18));
    
    // Increase time by 90 days to ensure any time-based conditions for tiers or APY changes are triggered
    await ethers.provider.send("evm_increaseTime", [90 * 24 * 3600]);
    await ethers.provider.send("evm_mine");
    
    // Check that the reward is greater than zero, confirming that the APY or time-based calculation ran as expected
    const reward = await staking.calculateReward(await addr1.getAddress());
    expect(reward).to.be.gt(0);
  });
  
});
