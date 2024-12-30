// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/PeoCoin.sol";

contract DeployPeoCoin is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the PeoCoin contract
        PeoCoin peoCoin = new PeoCoin();
        console.log("PeoCoin deployed at:", address(peoCoin));

        vm.stopBroadcast();
    }
}
