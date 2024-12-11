// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

/// @title MockStaking Contract
/// @author dkrizhanovskyi
/// @notice This mock contract simulates a staking scenario where the user always has a positive stake.
/// @dev Primarily used for testing. It ensures a user’s stake is never zero, allowing DCS scoring logic to return a positive value.
contract MockStaking {
    /// @notice Retrieves a mock stake for any given user.
    /// @dev This function always returns a fixed stake amount, a start time of one day ago, and `exists = true`.
    ///      Useful for tests that require non-zero stakes without having to stake real tokens.
    /// @param user The address for which the stake info is requested. (Currently unused, as this mock treats all users equally)
    /// @return amount A fixed stake amount of 100 tokens.
    /// @return startTimestamp A timestamp set to one day prior to the current block time.
    /// @return exists Always returns true to indicate a stake exists.
    function stakes(address user) external view returns (uint256 amount, uint256 startTimestamp, bool exists) {
        // Returning a static stake of 100 tokens, started 1 day ago, and always exists.
        return (100, block.timestamp - 1 days, true);
    }
}
