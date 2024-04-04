// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/SimpleContract.sol";

contract SimpleContractTest is Test {
    SimpleContract public simpleContract;

    function setUp() public {
        simpleContract = new SimpleContract();
    }

    function testAdd() public {
        simpleContract.add(67, 90);
        assertEq(simpleContract.result(), 157);
    }

    function testFailAdd() public {
        simpleContract.add(67, 90);
        assertEq(simpleContract.result(), 158);
    }

    function testSub() public {
        simpleContract.sub(12, 8);
        assertEq(simpleContract.result(), 4);
    }

    function testFailSub() public {
        simpleContract.sub(5, 8);
    }

    function testMultiply() public {
        simpleContract.multi(12, 8);
        assertEq(simpleContract.result(), 96);
    }

    function testFailMulti() public {
        simpleContract.multi(12, 0);
    }
}
