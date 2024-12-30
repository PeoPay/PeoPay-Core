// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/Staking.sol";
import "../src/PeoCoin.sol";

contract StakingTest is Test {
    Staking staking;
    PeoCoin peoCoin;
    address user = address(0x2);

    function setUp() public {
        peoCoin = new PeoCoin();
        staking = new Staking(address(peoCoin));

        // Mint tokens for user and staking contract
        peoCoin.mint(user, 1_000 * 10**18);
        peoCoin.mint(address(staking), 10_000 * 10**18);
    }

    function testStaking() public {
        vm.startPrank(user);
        peoCoin.approve(address(staking), 500 * 10**18);
        staking.stake(500 * 10**18);
        (uint256 amount, uint256 startTimestamp, bool exists) = staking.stakes(user);

        assertEq(amount, 500 * 10**18, "Staked amount mismatch");
        assertTrue(exists, "Stake should exist");
        vm.stopPrank();
    }

    function testUnstaking() public {
        uint256 stakedAmount = 500 * 10**18;
        uint256 baseAPY = 10;
        uint256 stakedDays = 30;

        // Fund the staking contract
        peoCoin.mint(address(staking), 10_000 * 10**18);

        // User stakes tokens
        vm.startPrank(user);
        peoCoin.approve(address(staking), stakedAmount);
        staking.stake(stakedAmount);

        vm.warp(block.timestamp + stakedDays * 1 days); // Simulate 30 days

        // Unstake tokens
        staking.unstake();

        uint256 reward = (stakedAmount * baseAPY * stakedDays) / (365 * 100);
        uint256 expectedBalance = 1_000 * 10**18 + reward;
        uint256 userBalance = peoCoin.balanceOf(user);

        console.log("User Balance:", userBalance);
        console.log("Expected Balance:", expectedBalance);
        console.log("Reward:", reward);

        assertEq(userBalance, expectedBalance, "Balance mismatch");
        vm.stopPrank();
    }

}
