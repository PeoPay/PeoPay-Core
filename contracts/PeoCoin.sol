// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title PeoCoin (PEO) ERC-20 Token Contract
/// @author dkrizhanovskyi
/// @notice PeoCoin is the primary token of the PeoPay ecosystem, providing a foundation for staking, governance, and conversions.
/// @dev This contract inherits from OpenZeppelin’s ERC20 and Ownable:
///      - ERC20 provides a secure and standard implementation of fungible tokens.
///      - Ownable restricts certain functions (like minting) to the contract owner.
///      
///      The contract mints an initial supply to the owner. Additional tokens can be minted or burned by the owner, allowing
///      for flexible supply management.
contract PeoCoin is ERC20, Ownable {
    /// @notice Deploys the PeoCoin contract and mints the initial supply to the deployer.
    /// @dev The constructor sets the token’s name and symbol via ERC20 and calls Ownable(msg.sender) to set the contract’s owner.
    ///      It mints 1,000,000 PEO tokens to the owner’s address.
    constructor() ERC20("PeoCoin", "PEO") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10**decimals());
    }

    /// @notice Mints new PEO tokens to a specified address.
    /// @dev Only the contract owner can call this function. This allows the ecosystem to increase supply if needed,
    ///      for example, distributing tokens to liquidity pools or rewarding participants.
    /// @param to The address receiving the newly minted tokens.
    /// @param amount The number of tokens to mint (in smallest units).
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Burns tokens from the caller’s account, reducing the total supply.
    /// @dev If the caller does not have enough tokens to burn, the function reverts. Burning can be used to deflate the supply,
    ///      potentially as part of a governance decision or a mechanism to stabilize the token’s value.
    /// @param amount The number of tokens to burn (in smallest units).
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    /// @notice Returns the number of decimal places used for token balances.
    /// @dev Overridden from ERC20 to highlight that this contract returns 18 decimals, a common standard for ERC-20 tokens.
    /// @return The number of decimals (18).
    function decimals() public view override returns (uint8) {
        return 18;
    }
}
