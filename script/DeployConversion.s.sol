// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/Conversion.sol";

contract DeployConversion is Script {
    function run() external {
        vm.startBroadcast();

        // Replace with the deployed PeoCoin contract address
        address peoCoinAddress = vm.envAddress("PEO_COIN_ADDRESS");

        // Deploy the Conversion contract
        Conversion conversion = new Conversion(peoCoinAddress);
        console.log("Conversion deployed at:", address(conversion));

        vm.stopBroadcast();
    }
}
