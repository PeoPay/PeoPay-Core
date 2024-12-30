// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPeoCoin.sol";
import "./interfaces/IStaking.sol";

/// @title DCS (Dynamic Contribution Scoring)
/// @author dkrizhanovskyi
/// @notice Calculates a user's dynamic contribution score (DCS) based on their token holdings and staking duration.
/// @dev The DCS score can be used by governance or rewards contracts to weight votes or distribute benefits.
contract DCS is Ownable {
    /// @notice Reference to the PeoCoin contract, used to retrieve user balances.
    IPeoCoin public peoToken;

    /// @notice Reference to the staking contract, used to get staking amounts and durations.
    IStaking public staking;

    /// @notice Weight factor for token balances in the scoring formula.
    uint256 public tokenWeight = 1;

    /// @notice Weight factor for staked amounts in the scoring formula.
    uint256 public stakeWeight = 2;

    /// @notice Weight factor for time staked (duration) in the scoring formula.
    uint256 public timeWeight = 1;

    /// @notice Deploys the DCS contract and sets the owner.
    /// @dev Owner is set to the deployer via Ownable(msg.sender). The DCS depends on external contracts for data.
    /// @param _peoToken The address of the PeoCoin contract.
    /// @param _staking The address of the staking contract implementing IStaking.
    constructor(address _peoToken, address _staking) Ownable(msg.sender) {
        peoToken = IPeoCoin(_peoToken);
        staking = IStaking(_staking);
    }

    /// @notice Computes the DCS score for a given user.
    /// @dev The score formula:
    ///      score = (tokenBalance * tokenWeight)
    ///               + (stakedAmount * stakeWeight)
    ///               + ((stakedDurationInDays) * timeWeight)
    ///      stakedDurationInDays = (block.timestamp - startTimestamp) / 1 days
    /// @param user The address of the user whose DCS score is being queried.
    /// @return totalScore The computed DCS score for the user.
    function getScore(address user) external view returns (uint256) {
        uint256 tokenBalance = peoToken.balanceOf(user);
        (uint256 stakedAmount, uint256 startTimestamp, bool exists) = staking.stakes(user);

        uint256 stakeScore = 0;
        if (exists) {
            uint256 stakedDuration = block.timestamp - startTimestamp;
            // Convert duration to days by dividing by 1 day, then multiply by timeWeight.
            stakeScore = (stakedAmount * stakeWeight) + ((stakedDuration / 1 days) * timeWeight);
        }

        uint256 totalScore = (tokenBalance * tokenWeight) + stakeScore;
        return totalScore;
    }

    /// @notice Allows the owner to update the weight factors used in the DCS calculation.
    /// @dev By adjusting weights, governance can influence the importance of token balance, stake amount, or duration.
    /// @param _tokenWeight The new weight for token balances.
    /// @param _stakeWeight The new weight for staked amounts.
    /// @param _timeWeight The new weight for staking duration.
    function updateWeights(uint256 _tokenWeight, uint256 _stakeWeight, uint256 _timeWeight) external onlyOwner {
        tokenWeight = _tokenWeight;
        stakeWeight = _stakeWeight;
        timeWeight = _timeWeight;
    }
}
