// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/Governance.sol";

contract DeployGovernance is Script {
    function run() external {
        vm.startBroadcast();

        // Replace with the deployed PeoCoin and DCS contract addresses
        address peoCoinAddress = vm.envAddress("PEO_COIN_ADDRESS");
        address dcsAddress = vm.envAddress("DCS_ADDRESS");

        // Deploy the Governance contract
        Governance governance = new Governance(peoCoinAddress, dcsAddress);
        console.log("Governance deployed at:", address(governance));

        vm.stopBroadcast();
    }
}
