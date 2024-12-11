// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

/// @title IDCS - Interface for Dynamic Contribution Scoring
/// @author dkrizhanovskyi
/// @notice Defines an interface to fetch a user's Dynamic Contribution Score (DCS).
/// @dev Implementations should calculate a user's DCS based on various metrics (e.g., token balance, staking duration, governance participation).
interface IDCS {
    /// @notice Retrieves the DCS score for a given user.
    /// @dev The scoring logic is implementation-dependent. Scores are typically used for weighting votes and rewards.
    /// @param user The address of the user whose DCS score is queried.
    /// @return The DCS score as a uint256. A higher score generally indicates greater contribution or engagement.
    function getScore(address user) external view returns (uint256);
}
