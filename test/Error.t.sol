// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/Error.sol";

contract CounterTest is Test {
    Error public error;

    function setUp() public {
        error = new Error();
    }

    function generateAddress(string memory name) public returns (address) {
        address addr = address( //then cast it from uint160 to address
            uint160( //down cast it from uint256 to uint160
                uint256( //cast the hashed name into uint256
                    keccak256(abi.encodePacked(name)) //first hash the name
                )
            )
        );
        vm.label(addr, name);
        return addr;
    }

    function testFailSub() public {
        error.sub(5, 10);
    }

    function testRequireMessage() public {
        vm.expectRevert(bytes("first number must be greater"));
        error.sub(5, 10);
    }

    function testCustomError() public {
        error.sub(20, 12);

        //pranking the owner will make the caller different from address(this)
        //which is in this case the owner of the contract
        vm.prank(generateAddress("newContractOwner"));

        vm.expectRevert(Error.Unauthorized.selector);
        error.getResult();
    }

    function testFailAssert() public {
        error.multi(12, 0);
    }

    function testAssertLabel() public {
        error.multi(23, 7);
        assertEq(error.getResult(), 161, "First assert");

        error.multi(43, 2);
        assertEq(error.getResult(), 83, "Second assert");

        error.multi(43, 9);
        assertEq(error.getResult(), 387, "Third assert");
    }
}