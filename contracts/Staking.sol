// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "./interfaces/IPeoCoin.sol"; 

/// @title Staking Contract for PEO Tokens
/// @author dkrizhanovskyi
/// @notice Allows users to stake their PEO tokens for a certain lock period to earn rewards.
/// @dev Stakers receive a base APY, and a tier multiplier is applied to their rewards. Currently, all stakers are treated as "bronze".
///      In the future, different tiers could be added to give higher multipliers based on certain conditions.
contract Staking {
    /// @notice The PEO token contract used for staking and reward payout.
    IPeoCoin public peoToken;

    /// @notice Stores information about each user's stake.
    /// @dev `exists` is used to distinguish between a user who has never staked and one who has an active stake.
    struct StakeInfo {
        uint256 amount;
        uint256 startTimestamp;
        bool exists;
    }

    /// @notice Mapping from user address to their stake information.
    mapping(address => StakeInfo) public stakes;

    /// @notice Base Annual Percentage Yield (APY) in percent. For example, 10 means 10% per year.
    uint256 public baseAPY = 10;

    /// @notice Lock period during which the stake cannot be withdrawn (in seconds).
    /// @dev The default is 30 days. Users must wait at least this long before unstaking.
    uint256 public lockPeriod = 30 days;

    /// @notice Multiplier for the bronze tier expressed as a percentage. 100 means no bonus; 110 would be +10%, etc.
    /// @dev Currently, all stakers are considered bronze, so everyone gets this multiplier.
    uint256 public bronzeMultiplier = 100;

    /// @notice Deploys the Staking contract with a reference to the PEO token contract.
    /// @dev The staking contract must be approved to transfer tokens on behalf of stakers.
    /// @param _peoToken The address of the PeoCoin contract.
    constructor(address _peoToken) {
        peoToken = IPeoCoin(_peoToken);
    }

    /// @notice Stakes a specified amount of PEO tokens.
    /// @dev Transfers tokens from the caller to this contract. The user must have approved this contract beforehand.
    ///      Reverts if the user already has a stake or tries to stake zero tokens.
    /// @param amount The number of tokens to stake (in smallest units).
    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake zero tokens");
        require(!stakes[msg.sender].exists, "Already have a stake");

        bool success = peoToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        stakes[msg.sender] = StakeInfo(amount, block.timestamp, true);
    }

    /// @notice Calculates the staking reward for a given user.
    /// @dev The formula:
    ///      baseReward = (stakedAmount * baseAPY * stakedDays) / (365 * 100)
    ///      bonus = (baseReward * (tierMultiplier - 100)) / 100
    ///      totalReward = baseReward + bonus
    ///
    ///      Currently, tierMultiplier = bronzeMultiplier = 100, so no bonus is added.
    /// @param user The address of the user whose reward we are calculating.
    /// @return The total reward amount (in smallest units of PEO) that the user has earned.
    function calculateReward(address user) public view returns (uint256) {
        StakeInfo memory info = stakes[user];
        require(info.exists, "No stake found");

        uint256 stakedDuration = block.timestamp - info.startTimestamp;
        uint256 stakedDays = stakedDuration / 1 days;
        uint256 tierMultiplier = bronzeMultiplier; 

        // Calculate the base reward based on APY and time staked (annualized)
        uint256 baseReward = (info.amount * baseAPY * stakedDays) / (365 * 100);

        // Calculate any tier-based bonus. Bronze = 100 means no extra bonus.
        uint256 bonus = (baseReward * (tierMultiplier - 100)) / 100;

        return baseReward + bonus;
    }

    /// @notice Unstakes the user's tokens and pays out the accrued rewards.
    /// @dev The user must have passed the lock period. If successful, returns staked amount + reward to the user and removes their stake info.
    ///      Reverts if the lock period is not over or if the contract cannot transfer tokens (insufficient balance).
    function unstake() external {
        StakeInfo memory info = stakes[msg.sender];
        require(info.exists, "No stake found");
        require(block.timestamp >= info.startTimestamp + lockPeriod, "Lock period not ended");

        uint256 reward = calculateReward(msg.sender);

        // Transfer staked amount + reward back to the user
        bool success = peoToken.transfer(msg.sender, info.amount + reward);
        require(success, "Transfer failed");

        delete stakes[msg.sender];
    }
}
