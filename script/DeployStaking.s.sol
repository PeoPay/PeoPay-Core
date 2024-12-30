// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/Staking.sol";

contract DeployStaking is Script {
    function run() external {
        vm.startBroadcast();

        // Replace with the deployed PeoCoin contract address
        address peoCoinAddress = vm.envAddress("PEO_COIN_ADDRESS");

        // Deploy the Staking contract
        Staking staking = new Staking(peoCoinAddress);
        console.log("Staking deployed at:", address(staking));

        vm.stopBroadcast();
    }
}
