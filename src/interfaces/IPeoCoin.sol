// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

/// @title IPeoCoin Interface
/// @notice Defines the standard interface for interacting with the PeoCoin (PEO) token.
interface IPeoCoin {
    /// @notice Returns the balance of a given account.
    /// @param account The address whose balance is requested.
    /// @return The token balance of the given account.
    function balanceOf(address account) external view returns (uint256);

    /// @notice Transfers tokens from the caller's address to a specified recipient.
    /// @param recipient The address receiving the tokens.
    /// @param amount The number of tokens to transfer.
    /// @return A boolean indicating whether the operation succeeded.
    function transfer(address recipient, uint256 amount) external returns (bool);

    /// @notice Transfers tokens from a specified sender to a recipient, using the allowance mechanism.
    /// @param sender The address from which tokens are to be transferred.
    /// @param recipient The address to which tokens are to be sent.
    /// @param amount The number of tokens to transfer.
    /// @return A boolean indicating whether the operation succeeded.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /// @notice Approves a spender to withdraw tokens from the caller's account.
    /// @param spender The address allowed to withdraw tokens.
    /// @param amount The number of tokens approved for withdrawal.
    /// @return A boolean indicating whether the operation succeeded.
    function approve(address spender, uint256 amount) external returns (bool);

    /// @notice Returns the remaining number of tokens the spender is allowed to withdraw.
    /// @param owner The address of the token owner.
    /// @param spender The address of the spender.
    /// @return The remaining allowance for the spender.
    function allowance(address owner, address spender) external view returns (uint256);

    /// @notice Returns the number of decimal places used to represent token balances.
    /// @return The number of decimals.
    function decimals() external view returns (uint8);
}
