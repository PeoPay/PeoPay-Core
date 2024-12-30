// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Governance.sol";
import "./mocks/MockPeoCoin.sol";
import "./mocks/MockDCS.sol";

/// @title Governance Contract Test Suite
/// @dev Validates functionality of the Governance contract.
contract GovernanceTest is Test {
    Governance private governance;
    MockPeoCoin private mockPeoToken;
    MockDCS private mockDCS;

    address private constant proposer = address(1);
    address private constant voter1 = address(2);
    address private constant voter2 = address(3);

    uint256 private constant quorum = 1000 * 10 ** 18;

    function setUp() public {
        mockPeoToken = new MockPeoCoin();
        mockDCS = new MockDCS();

        // Mint tokens and set scores
        mockPeoToken.mint(proposer, 1000 * 10 ** 18);
        mockPeoToken.mint(voter1, 500 * 10 ** 18);
        mockPeoToken.mint(voter2, 700 * 10 ** 18);

        mockDCS.setScore(proposer, 1000 * 10 ** 18);
        mockDCS.setScore(voter1, 500 * 10 ** 18);
        mockDCS.setScore(voter2, 700 * 10 ** 18);

        governance = new Governance(address(mockPeoToken), address(mockDCS));
    }

    /// @notice Tests the creation of a proposal.
    function testCreateProposal() public {
        vm.startPrank(proposer);
        string memory description = "Proposal #1";

        governance.createProposal(description);

        (address storedProposer, string memory storedDescription, uint256 startTime, uint256 endTime,,,) =
            governance.proposals(0);

        assertEq(storedProposer, proposer, "Proposer mismatch");
        assertEq(storedDescription, description, "Description mismatch");
        assertGt(startTime, 0, "Start time not set");
        assertGt(endTime, startTime, "End time not set");
    }

    /// @notice Ensures proposals cannot be created by users without PEO balance.
    function testCannotCreateProposalWithoutPEO() public {
        vm.startPrank(address(4)); // No PEO balance or score
        vm.expectRevert("Need PEO to propose");
        governance.createProposal("Invalid Proposal");
    }

    /// @notice Tests voting on a proposal.
    function testVote() public {
        vm.startPrank(proposer);
        governance.createProposal("Proposal #1");

        vm.startPrank(voter1);
        governance.vote(0, true);

        (,,,, uint256 yesVotes, uint256 noVotes,) = governance.proposals(0);

        assertEq(yesVotes, mockDCS.getScore(voter1), "Yes votes mismatch");
        assertEq(noVotes, 0, "No votes mismatch");
    }

    /// @notice Ensures users cannot vote twice on the same proposal.
    function testCannotVoteTwice() public {
        vm.startPrank(proposer);
        governance.createProposal("Proposal #1");

        vm.startPrank(voter1);
        governance.vote(0, true);

        vm.expectRevert("Already voted");
        governance.vote(0, false);
    }

    /// @notice Tests execution of a proposal meeting quorum and majority requirements.
    function testExecuteProposalSuccess() public {
        vm.startPrank(proposer);
        governance.createProposal("Proposal #1");

        vm.startPrank(voter1);
        governance.vote(0, true);

        vm.startPrank(voter2);
        governance.vote(0, true);

        // Simulate end of voting period
        vm.warp(block.timestamp + governance.votingPeriod() + 1);

        governance.executeProposal(0);

        (,,,,,, bool executed) = governance.proposals(0);

        assertEq(executed, true, "Proposal not marked as executed");
    }

    /// @notice Ensures proposals cannot be executed without meeting quorum.
    function testCannotExecuteProposalWithoutQuorum() public {
        vm.startPrank(proposer);
        governance.createProposal("Proposal #1");

        vm.startPrank(voter1);
        governance.vote(0, true); // Voter1 alone does not meet quorum

        // Simulate end of voting period
        vm.warp(block.timestamp + governance.votingPeriod() + 1);

        vm.expectRevert("Quorum not reached");
        governance.executeProposal(0);
    }

    /// @notice Ensures proposals cannot be executed twice.
    function testCannotExecuteProposalTwice() public {
        vm.startPrank(proposer);
        governance.createProposal("Proposal #1");

        vm.startPrank(voter1);
        governance.vote(0, true);

        vm.startPrank(voter2);
        governance.vote(0, true);

        // Simulate end of voting period
        vm.warp(block.timestamp + governance.votingPeriod() + 1);

        governance.executeProposal(0);

        vm.expectRevert("Already executed");
        governance.executeProposal(0);
    }
}
