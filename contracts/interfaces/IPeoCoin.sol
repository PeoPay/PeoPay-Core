// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

/// @title IPeoCoin Interface
/// @author dkrizhanovskyi
/// @notice Defines the standard interface for interacting with the PeoCoin (PEO) token.
/// @dev This interface extracts minimal ERC-20-like methods required by other contracts.
///      Full ERC-20 compliance depends on the implementing contract.
interface IPeoCoin {
    /// @notice Returns the balance of a given account.
    /// @param account The address whose balance is requested.
    /// @return The token balance of the given account.
    function balanceOf(address account) external view returns (uint256);

    /// @notice Transfers tokens from the caller's address to a specified recipient.
    /// @dev Reverts if the caller does not have enough balance.
    /// @param recipient The address receiving the tokens.
    /// @param amount The number of tokens to transfer (in the smallest units, e.g., wei form of tokens).
    /// @return A boolean indicating whether the operation succeeded.
    function transfer(address recipient, uint256 amount) external returns (bool);

    /// @notice Transfers tokens from a specified sender to a recipient, using the allowance mechanism.
    /// @dev Reverts if the sender does not have enough balance or if allowance is insufficient.
    ///      This function emits a Transfer event.
    /// @param sender The address from which tokens are to be transferred.
    /// @param recipient The address to which tokens are to be sent.
    /// @param amount The number of tokens to transfer.
    /// @return A boolean indicating whether the operation succeeded.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /// @notice Returns the number of decimal places used to represent token balances.
    /// @dev Commonly 18 for ERC-20 tokens.
    /// @return The number of decimals.
    function decimals() external view returns (uint8);
}
