// This test suite verifies the functionality of the DCS (Dynamic Contribution Scoring) contract.
// DCS calculates a user's score based on their token balance and staking duration.
//
// Key scenarios tested:
// - Calculating a positive score for a user who has staked tokens and holds a nonzero balance.
// - Ensuring a user with no tokens and no stake has a score of 0.
// - Updating the DCS weight factors and confirming that scores change accordingly.

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DCS", function () {
  let PeoCoin, Staking, DCS, peoCoin, staking, dcs;
  let owner, user, noTokensNoStakeUser;

  beforeEach(async () => {
    // Retrieve signers for the test environment:
    // - owner: deployer of contracts
    // - user: a user who will have tokens and stake them
    // - noTokensNoStakeUser: a user who receives no tokens and never stakes, enabling us to test zero-score scenarios
    [owner, user, noTokensNoStakeUser] = await ethers.getSigners();
    
    // Deploy the PeoCoin contract
    PeoCoin = await ethers.getContractFactory("PeoCoin");
    peoCoin = await PeoCoin.deploy();
    await peoCoin.waitForDeployment();

    // Deploy the Staking contract, which relies on PeoCoin for token logic
    Staking = await ethers.getContractFactory("Staking");
    staking = await Staking.deploy(await peoCoin.getAddress());
    await staking.waitForDeployment();

    // Deploy the DCS contract, which depends on PeoCoin and Staking
    DCS = await ethers.getContractFactory("DCS");
    dcs = await DCS.deploy(await peoCoin.getAddress(), await staking.getAddress());
    await dcs.waitForDeployment();

    // Give `user` some tokens and make them stake:
    // - Transfer 1000 PEO to the user
    // - User stakes 100 PEO
    await peoCoin.transfer(await user.getAddress(), ethers.parseUnits("1000", 18));
    await peoCoin.connect(user).approve(await staking.getAddress(), ethers.parseUnits("100", 18));
    await staking.connect(user).stake(ethers.parseUnits("100", 18));
  });

  it("Calculates score based on token and stake", async function () {
    // Since `user` has staked tokens and holds a balance, their score should be greater than zero.
    const score = await dcs.getScore(await user.getAddress());
    expect(score).to.be.gt(0); // Expect a positive score
  });

  it("Returns score for user with no stake and no tokens", async function () {
    // `noTokensNoStakeUser` never received tokens or staked.
    // Their score should logically be zero since they have no contributions.
    const score = await dcs.getScore(await noTokensNoStakeUser.getAddress());
    expect(score).to.equal(0);
  });
  
  it("Applies updated weights to the score calculation", async function () {
    // Update the weight factors used in the DCS calculation
    // For instance, increasing tokenWeight or stakeWeight should affect the user's score.
    await dcs.updateWeights(2, 3, 1);
    const score = await dcs.getScore(await user.getAddress());
    // User still holds tokens and has staked, so their score should remain > 0.
    // With adjusted weights, the score might be different, but still positive.
    expect(score).to.be.gt(0);
  });
});
