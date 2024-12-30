// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/DCS.sol";
import "../src/PeoCoin.sol";
import "../src/Staking.sol";

contract DCSTest is Test {
    DCS dcs;
    PeoCoin peoCoin;
    Staking staking;

    address owner = address(0x1);
    address user = address(0x2);

    function setUp() public {
        // Deploy PeoCoin and Staking contracts
        peoCoin = new PeoCoin();
        staking = new Staking(address(peoCoin));

        // Deploy DCS contract
        dcs = new DCS(address(peoCoin), address(staking));

        // Mint tokens to the user
        peoCoin.mint(user, 1_000 * 10 ** 18);
    }

    function testInitialWeights() public {
        assertEq(dcs.tokenWeight(), 1);
        assertEq(dcs.stakeWeight(), 2);
        assertEq(dcs.timeWeight(), 1);
    }

    function testScoreCalculation() public {
        // User stakes tokens
        vm.startPrank(user);
        peoCoin.approve(address(staking), 500 * 10 ** 18);
        staking.stake(500 * 10 ** 18);
        vm.stopPrank();

        // Fast forward time
        vm.warp(block.timestamp + 30 days);

        // Calculate score
        uint256 score = dcs.getScore(user);
        assertGt(score, 0, "Score should be greater than zero");
    }
}
