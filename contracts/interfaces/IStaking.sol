// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

/// @title IStaking Interface
/// @author dkrizhanovskyi
/// @notice Defines the interface for querying user stakes in the staking contract.
/// @dev This interface focuses on retrieving stake information. Implementations may provide additional functionality.
interface IStaking {
    /// @notice Retrieves the staking information for a given user.
    /// @dev Returns multiple values describing the user's stake. 
    /// @param user The address of the user whose stake information is requested.
    /// @return amount The total amount of tokens the user has staked.
    /// @return startTimestamp The timestamp when the user's stake started, used for reward calculation or lock periods.
    /// @return exists A boolean indicating whether the user currently has an active stake.
    function stakes(address user) external view returns (
        uint256 amount,
        uint256 startTimestamp,
        bool exists
    );
}
