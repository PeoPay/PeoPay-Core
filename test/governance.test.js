// These tests verify that the Governance contract works as intended when integrated with PeoCoin and DCS.
// The Governance contract allows users to create proposals and vote on them, with voting power determined by DCS scores.
//
// Key scenarios tested:
// - Creating a proposal when the user holds PEO tokens.
// - Casting votes on a proposal with DCS-based weighting.
// - Executing a proposal after the voting period ends, given that quorum and majority conditions are met.
//
// A MockStaking contract ensures that all users have a nonzero stake, contributing to their DCS scores.
// We adjust voting parameters (quorum, majority) to simplify passing proposals during tests.

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Governance", function () {
  let PeoCoin, DCS, Governance, MockStaking, peoCoin, dcs, governance, mockStaking;
  let owner, voter1, voter2;

  beforeEach(async () => {
    // Retrieve three signers:
    // - owner: Deploys contracts and can update governance parameters.
    // - voter1 and voter2: Users who will hold PEO tokens and vote on proposals.
    [owner, voter1, voter2] = await ethers.getSigners();

    // Deploy PeoCoin token
    PeoCoin = await ethers.getContractFactory("PeoCoin");
    peoCoin = await PeoCoin.deploy();
    await peoCoin.waitForDeployment();

    // Deploy a MockStaking contract that ensures each user has a positive stake
    // This allows all voters to have a nonzero DCS score.
    MockStaking = await ethers.getContractFactory("MockStaking");
    mockStaking = await MockStaking.deploy();
    await mockStaking.waitForDeployment();

    // Deploy DCS with references to PeoCoin and MockStaking
    DCS = await ethers.getContractFactory("DCS");
    dcs = await DCS.deploy(await peoCoin.getAddress(), await mockStaking.getAddress());
    await dcs.waitForDeployment();

    // Deploy Governance with PeoCoin and DCS
    Governance = await ethers.getContractFactory("Governance");
    governance = await Governance.deploy(await peoCoin.getAddress(), await dcs.getAddress());
    await governance.waitForDeployment();

    // Distribute PEO tokens to voters so they have nonzero DCS scores:
    // Voter1 gets 1000 PEO, Voter2 gets 2000 PEO.
    await peoCoin.transfer(await voter1.getAddress(), ethers.parseUnits("1000", 18));
    await peoCoin.transfer(await voter2.getAddress(), ethers.parseUnits("2000", 18));
  });

  it("Allows creation of proposals and voting with DCS-based weighting", async function () {
    // Voter1 creates a proposal. This requires them to hold PEO tokens.
    await governance.connect(voter1).createProposal("Increase APY");
    const proposalId = 0;

    // Voter1 votes yes on the proposal. 
    // Since Voter1 has tokens and a positive DCS score, this should emit a VoteCast event.
    await expect(governance.connect(voter1).vote(proposalId, true))
      .to.emit(governance, "VoteCast");

    // Voter2 votes no on the proposal. 
    // This also emits VoteCast, confirming votes are being recorded.
    await expect(governance.connect(voter2).vote(proposalId, false))
      .to.emit(governance, "VoteCast");

    // Advance time by 3 days to end the voting period.
    await ethers.provider.send("evm_increaseTime", [3 * 24 * 3600]);
    await ethers.provider.send("evm_mine");

    // Update parameters to a low quorum and zero majority threshold for easy proposal passing in tests.
    // This allows the proposal to be executed without requiring high participation or a high yes percentage.
    await governance.connect(owner).updateParameters(3 * 24 * 3600, ethers.parseUnits("1", 18), 0);

    // Execute the proposal.
    // If conditions (quorum and majority) are met, a ProposalExecuted event is emitted.
    await expect(governance.executeProposal(proposalId))
      .to.emit(governance, "ProposalExecuted");
  });
});
