// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPeoCoin.sol";
import "./interfaces/IDCS.sol";

/// @title Governance Contract for Proposals and Voting
/// @author dkrizhanovskyi
/// @notice This contract allows PEO holders to create proposals and vote on them. Voting weight is determined by DCS scores.
/// @dev Proposals must meet a certain quorum and majority to be executed. The contract relies on IPeoCoin for token balances and IDCS for scoring.
contract Governance is Ownable {
    /// @notice Reference to the PeoCoin contract for checking PEO balances.
    IPeoCoin public peoToken;

    /// @notice Reference to the DCS contract for computing user voting scores.
    IDCS public dcs;

    /// @notice Structure storing proposal details.
    /// @dev `yesVotes` and `noVotes` track weighted votes. `executed` prevents re-execution.
    struct Proposal {
        address proposer;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        bool executed;
    }

    /// @notice Array of all proposals.
    Proposal[] public proposals;

    /// @notice Tracks which users have voted on which proposals.
    /// @dev proposalId -> voterAddress -> bool
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    /// @notice Voting parameters.
    uint256 public votingPeriod = 3 days; // Duration for voting
    uint256 public quorum = 1000 * 1e18; // Minimum weighted votes required
    uint256 public majorityPercentage = 50; // Percentage of yes votes needed > this value

    /// @notice Emitted when a proposal is created.
    /// @param proposalId The ID of the newly created proposal.
    /// @param proposer The address that created the proposal.
    /// @param description A short description of the proposal’s purpose.
    event ProposalCreated(uint256 proposalId, address proposer, string description);

    /// @notice Emitted when a user casts a vote.
    /// @param proposalId The ID of the proposal being voted on.
    /// @param voter The address of the voter.
    /// @param support True if the vote is in favor, false otherwise.
    /// @param weight The DCS-based voting weight applied to this vote.
    event VoteCast(uint256 proposalId, address voter, bool support, uint256 weight);

    /// @notice Emitted when a proposal is successfully executed.
    /// @param proposalId The ID of the proposal that was executed.
    event ProposalExecuted(uint256 proposalId);

    /// @notice Deploys the Governance contract and sets the initial owner.
    /// @dev Owner is set via Ownable(msg.sender). Requires addresses for PeoCoin and DCS contracts.
    /// @param _peoToken The address of the PeoCoin contract.
    /// @param _dcs The address of the DCS contract.
    constructor(address _peoToken, address _dcs) Ownable(msg.sender) {
        peoToken = IPeoCoin(_peoToken);
        dcs = IDCS(_dcs);
    }

    /// @notice Creates a new proposal that PEO holders can vote on.
    /// @dev Only users holding PEO can propose. The proposal is open for voting until `endTime`.
    /// @param description A short text describing the proposal’s purpose or action.
    function createProposal(string calldata description) external {
        require(peoToken.balanceOf(msg.sender) > 0, "Need PEO to propose");

        proposals.push(
            Proposal({
                proposer: msg.sender,
                description: description,
                startTime: block.timestamp,
                endTime: block.timestamp + votingPeriod,
                yesVotes: 0,
                noVotes: 0,
                executed: false
            })
        );

        emit ProposalCreated(proposals.length - 1, msg.sender, description);
    }

    /// @notice Casts a vote on a proposal.
    /// @dev Users can only vote once per proposal and only during the voting period.
    ///      Weight is determined by `dcs.getScore()`. Zero score means no voting power.
    /// @param proposalId The ID of the proposal to vote on.
    /// @param support True if voting in favor, false if voting against.
    function vote(uint256 proposalId, bool support) external {
        require(proposalId < proposals.length, "Invalid proposalId");
        Proposal storage prop = proposals[proposalId];
        require(block.timestamp >= prop.startTime && block.timestamp <= prop.endTime, "Voting closed");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        hasVoted[proposalId][msg.sender] = true;

        uint256 weight = dcs.getScore(msg.sender);
        require(weight > 0, "No voting power");

        if (support) {
            prop.yesVotes += weight;
        } else {
            prop.noVotes += weight;
        }

        emit VoteCast(proposalId, msg.sender, support, weight);
    }

    /// @notice Executes a proposal after the voting period has ended if it meets quorum and majority requirements.
    /// @dev The proposal must have enough total votes to meet `quorum` and a majority > `majorityPercentage`.
    /// @param proposalId The ID of the proposal to execute.
    function executeProposal(uint256 proposalId) external {
        require(proposalId < proposals.length, "Invalid proposalId");
        Proposal storage prop = proposals[proposalId];
        require(block.timestamp > prop.endTime, "Voting not ended");
        require(!prop.executed, "Already executed");

        uint256 totalVotes = prop.yesVotes + prop.noVotes;
        require(totalVotes >= quorum, "Quorum not reached");
        uint256 yesPercentage = (prop.yesVotes * 100) / totalVotes;
        require(yesPercentage > majorityPercentage, "Majority not reached");

        prop.executed = true;
        emit ProposalExecuted(proposalId);

        // Future logic could be added here to implement proposal actions once executed.
    }

    /// @notice Updates the voting parameters (period, quorum, majority).
    /// @dev Only the owner can adjust these values. This allows governance to evolve over time.
    /// @param _votingPeriod The new duration of the voting period in seconds.
    /// @param _quorum The new minimum total votes required for a proposal.
    /// @param _majorityPercentage The new majority threshold for yes votes (in percentage).
    function updateParameters(uint256 _votingPeriod, uint256 _quorum, uint256 _majorityPercentage) external onlyOwner {
        votingPeriod = _votingPeriod;
        quorum = _quorum;
        majorityPercentage = _majorityPercentage;
    }
}
