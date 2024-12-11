// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "../contracts/PeoCoin.sol";
import "../contracts/Staking.sol";
import "../contracts/DCS.sol";
import "../contracts/Governance.sol";
import "../contracts/Conversion.sol";
import "../contracts/mocks/MockStaking.sol";

/// @title EchidnaFullTest - Fuzz Testing Integration of PeoPay Contracts with Echidna
/// @author dkrizhanovskyi
/// @notice This contract is designed for use with the Echidna fuzzer to perform property-based testing on
///         the PeoPay ecosystem contracts (PeoCoin, Staking, DCS, Governance, Conversion, MockStaking).
/// @dev Echidna will call the functions below with random parameters and states, attempting to break invariants
///      or find unexpected behavior. This setup helps ensure the system behaves safely under arbitrary conditions.
contract EchidnaFullTest {
    /// @notice Instances of the ecosystem’s contracts.
    PeoCoin public peo;
    Staking public staking;
    DCS public dcs;
    Governance public governance;
    Conversion public conversion;
    MockStaking public mockStaking; 

    /// @notice Tracks initial supply and owner address for reference.
    uint256 public initialSupply;
    address public owner;

    /// @notice A list of user addresses that Echidna can use to simulate transactions.
    address[] public users;

    /// @notice Parameters that Echidna can fuzz to test various actions.
    address public nextRecipient;
    uint256 public nextAmount;
    address public nextProposalVoter;
    bool public nextVoteSupport;
    string public nextProposalDescription = "Default proposal";
    string public nextMobileNumber = "123456789";
    string public nextCurrency = "KES";

    /// @notice Constructor sets up all contracts and initial conditions.
    /// @dev Creates all contracts, mints initial PeoCoin supply, and distributes tokens to a set of test user addresses.
    constructor() {
        owner = msg.sender;

        // Deploy ecosystem contracts
        peo = new PeoCoin();
        staking = new Staking(address(peo));
        mockStaking = new MockStaking();
        dcs = new DCS(address(peo), address(mockStaking));
        governance = new Governance(address(peo), address(dcs));
        conversion = new Conversion(address(peo), owner); // Using owner as the backendService for simplicity

        initialSupply = peo.totalSupply();

        // Distribute some tokens to pseudo-random user addresses for testing
        for (uint256 i = 0; i < 5; i++) {
            address user = address(uint160(uint256(keccak256(abi.encodePacked(i)))));
            users.push(user);
            peo.transfer(user, 1000 ether);
        }
    }

    // -------------------- Parameter Setters for Echidna --------------------
    /// @notice Sets parameters for random transfers that Echidna will attempt.
    /// @dev Echidna calls this with random inputs.
    /// @param _recipient The address to attempt transferring tokens to.
    /// @param _amount The amount of tokens to attempt transferring.
    function setTransferParams(address _recipient, uint256 _amount) public {
        nextRecipient = _recipient;
        nextAmount = _amount;
    }

    /// @notice Sets parameters for governance proposals and votes.
    /// @param voter The address that will attempt to vote on a proposal.
    /// @param support True if vote should be in support, false otherwise.
    /// @param desc A description for a new proposal, if created.
    function setProposalParams(address voter, bool support, string memory desc) public {
        nextProposalVoter = voter;
        nextVoteSupport = support;
        nextProposalDescription = desc;
    }

    /// @notice Sets parameters for conversion requests.
    /// @param mobileNumber The mobile number for the conversion.
    /// @param currency The currency code (e.g., "KES").
    /// @param amount The amount of PEO to convert.
    function setConversionParams(string memory mobileNumber, string memory currency, uint256 amount) public {
        nextMobileNumber = mobileNumber;
        nextCurrency = currency;
        nextAmount = amount;
    }

    // -------------------- Random Actions for Echidna to Call --------------------

    /// @notice Attempts a random token transfer from this contract to `nextRecipient`.
    /// @dev If balance is sufficient and recipient is nonzero, transfers tokens.
    function randomTransfer() public {
        if (peo.balanceOf(address(this)) >= nextAmount && nextRecipient != address(0)) {
            peo.transfer(nextRecipient, nextAmount);
        }
    }

    /// @notice Attempts to stake a given amount of PEO tokens from this contract into the staking contract.
    /// @dev Requires that this contract has a sufficient token balance and that amount > 0.
    /// @param amount The number of tokens to stake.
    function randomStake(uint256 amount) public {
        if (peo.balanceOf(address(this)) >= amount && amount > 0) {
            peo.approve(address(staking), amount);
            staking.stake(amount);
        }
    }

    /// @notice Attempts to unstake tokens. May revert if lock period not ended or no stake found.
    /// @dev Echidna learns from reverts. If it succeeds, we ensure invariants after state changes.
    function randomUnstake() public {
        staking.unstake();
    }

    /// @notice Attempts to create a governance proposal.
    /// @dev Requires the caller to have some PEO balance. 
    function randomCreateProposal() public {
        if (peo.balanceOf(msg.sender) > 0) {
            governance.createProposal(nextProposalDescription);
        }
    }

    /// @notice Attempts to vote on a governance proposal.
    /// @dev Reverts if the proposal doesn't exist or voting conditions are not met.
    /// @param proposalId The proposal ID to vote on.
    function randomVote(uint256 proposalId) public {
        governance.vote(proposalId, nextVoteSupport);
    }

    /// @notice Attempts to execute a governance proposal.
    /// @dev Reverts if conditions (quorum, majority) are not met or if not ended.
    /// @param proposalId The proposal ID to execute.
    function randomExecuteProposal(uint256 proposalId) public {
        governance.executeProposal(proposalId);
    }

    /// @notice Attempts to request a conversion of PEO to mobile money.
    /// @dev Requires sufficient balance and nextAmount > 0. Approves and calls requestConversion.
    function randomRequestConversion() public {
        if (peo.balanceOf(address(this)) >= nextAmount && nextAmount > 0) {
            peo.approve(address(conversion), nextAmount);
            conversion.requestConversion(nextAmount, nextMobileNumber, nextCurrency);
        }
    }

    /// @notice Attempts to confirm a conversion from the backend service.
    /// @dev Only `owner` can call confirmConversion. If msg.sender is owner, tries to confirm with given parameters.
    /// @param user The user who requested the conversion.
    /// @param amount The amount of PEO involved in the conversion.
    /// @param mobileNumber The mobile number used for the conversion.
    function randomConfirmConversion(address user, uint256 amount, string memory mobileNumber) public {
        if (msg.sender == owner) {
            conversion.confirmConversion(user, amount, mobileNumber);
        }
    }
}
