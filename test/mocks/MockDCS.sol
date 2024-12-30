// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../../src/interfaces/IDCS.sol";

/// @title MockDCS
/// @notice A mock implementation of the IDCS interface for testing purposes.
contract MockDCS is IDCS {
    /// @notice A mapping to store the dynamic contribution scores for each user.
    mapping(address => uint256) public scores;

    /// @notice Retrieves the score for a given user.
    /// @param user The address of the user whose score is being queried.
    /// @return The DCS score of the user.
    function getScore(address user) external view override returns (uint256) {
        return scores[user];
    }

    /// @notice Sets a score for a user.
    /// @dev This is used in tests to simulate different scoring scenarios.
    /// @param user The address of the user whose score is being set.
    /// @param score The score value to set.
    function setScore(address user, uint256 score) external {
        scores[user] = score;
    }
}
