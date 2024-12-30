// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../../src/interfaces/IStaking.sol";

/// @title Mock Implementation of IStaking
/// @notice A mock implementation of the staking contract for testing purposes.
contract MockStaking is IStaking {
    struct Stake {
        uint256 amount;
        uint256 startTimestamp;
        bool exists;
    }

    mapping(address => Stake) private _stakes;

    function stakes(address user) external view override returns (uint256, uint256, bool) {
        Stake memory stake = _stakes[user];
        return (stake.amount, stake.startTimestamp, stake.exists);
    }

    function setStake(address user, uint256 amount, uint256 startTimestamp) external {
        _stakes[user] = Stake(amount, startTimestamp, true);
    }

    function clearStake(address user) external {
        delete _stakes[user];
    }
}
