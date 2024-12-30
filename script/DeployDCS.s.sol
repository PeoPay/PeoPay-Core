// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/DCS.sol";

contract DeployDCS is Script {
    function run() external {
        vm.startBroadcast();

        // Replace with the deployed PeoCoin and Staking contract addresses
        address peoCoinAddress = vm.envAddress("PEO_COIN_ADDRESS");
        address stakingAddress = vm.envAddress("STAKING_ADDRESS");

        // Deploy the DCS contract
        DCS dcs = new DCS(peoCoinAddress, stakingAddress);
        console.log("DCS deployed at:", address(dcs));

        vm.stopBroadcast();
    }
}
