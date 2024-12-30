// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "./interfaces/IPeoCoin.sol";
import "./interfaces/IDCS.sol";

/// @title Conversion Contract for Crypto-to-Mobile Money Transfers
/// @author dkrizhanovskyi
/// @notice This contract allows users to convert their PEO tokens into mobile money by emitting events that an off-chain backend service can respond to.
/// @dev The contract locks PEO tokens when a user requests a conversion. An authorized backend service then confirms the conversion after off-chain settlement.
contract Conversion {
    /// @notice The PEO token contract used for transfers.
    /// @dev Must implement IPeoCoin interface, providing `transferFrom` and other ERC-20-like methods.
    IPeoCoin public peoToken;

    /// @notice The authorized backend service allowed to confirm conversions.
    /// @dev Only this address can call `confirmConversion`, preventing unauthorized confirmations.
    address public backendService;

    /// @notice Emitted when a user requests a mobile money conversion.
    /// @param user The address initiating the request.
    /// @param amount The amount of PEO locked for conversion.
    /// @param mobileNumber The recipient mobile money account.
    /// @param currency The mobile money currency code (e.g., "KES").
    event ConversionRequested(address indexed user, uint256 amount, string mobileNumber, string currency);

    /// @notice Emitted when the backend service confirms a successful off-chain conversion.
    /// @param user The user who originally requested the conversion.
    /// @param amount The amount of PEO associated with the conversion.
    /// @param mobileNumber The mobile number used for the conversion.
    event ConversionConfirmed(address indexed user, uint256 amount, string mobileNumber);

    /// @notice Deploys the Conversion contract, setting up the PEO token and backend service addresses.
    /// @dev Both addresses must be valid contracts or externally owned accounts. The `peoToken` must comply with IPeoCoin.
    /// @param _peoToken The address of the PeoCoin contract.
    /// @param _backendService The authorized backend service address for confirming conversions.
    constructor(address _peoToken, address _backendService) {
        peoToken = IPeoCoin(_peoToken);
        backendService = _backendService;
    }

    /// @notice Request a conversion of PEO to mobile money.
    /// @dev Transfers PEO from the caller to this contract. The off-chain service will then pick up the event and process the conversion.
    ///      Reverts if `amount` is zero or if `transferFrom` fails due to insufficient balance or allowance.
    /// @param amount The amount of PEO to convert.
    /// @param mobileNumber The recipient mobile money account details.
    /// @param currency The currency code (e.g., "KES") for the mobile money transfer.
    function requestConversion(uint256 amount, string calldata mobileNumber, string calldata currency) external {
        require(amount > 0, "Amount must be greater than zero");

        bool success = peoToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        emit ConversionRequested(msg.sender, amount, mobileNumber, currency);
    }

    /// @notice Confirm conversion after off-chain processing is done.
    /// @dev Only the `backendService` can call this. Once confirmed, `ConversionConfirmed` event is emitted.
    ///      The PEO remains locked in the contract for future use (e.g., burning, redistribution).
    /// @param user The user who requested the conversion.
    /// @param amount The amount of PEO involved in the conversion.
    /// @param mobileNumber The mobile number used for the conversion, same as in the original request.
    function confirmConversion(address user, uint256 amount, string calldata mobileNumber) external {
        require(msg.sender == backendService, "Unauthorized caller");

        emit ConversionConfirmed(user, amount, mobileNumber);
    }
}
