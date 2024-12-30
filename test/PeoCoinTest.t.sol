// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/PeoCoin.sol";

contract PeoCoinTest is Test {
    PeoCoin peoCoin;
    address owner = address(this);
    address user = address(0x2);

    function setUp() public {
        // Deploy PeoCoin contract
        peoCoin = new PeoCoin();
    }

    function testMinting() public {
        peoCoin.mint(user, 1_000 * 10**18);
        assertEq(peoCoin.balanceOf(user), 1_000 * 10**18);
    }

    function testBurning() public {
        peoCoin.mint(user, 500 * 10**18);
        vm.startPrank(user);
        peoCoin.burn(200 * 10**18);
        assertEq(peoCoin.balanceOf(user), 300 * 10**18);
        vm.stopPrank();
    }
}
