// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/Wallet.sol";

contract CounterTest is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
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

    function testSetOwner() public {
        address newContractOwner = generateAddress("newContractOwner");
        wallet.setOwner(newContractOwner);
        assertEq(wallet.owner(), newContractOwner);
    }

    function testFailSetOwner() public {
        //generate 2 new addresses using the string names
        address newOwnerToCall = generateAddress("newOwnerToCall");
        address newContractOwner = generateAddress("newContractOwner");

        //this changes the contract owner away from the actual owner that deploys the contract
        vm.prank(newOwnerToCall);
        //this new owner is made to call the function setOwner meant to be called only by the contract owner
        wallet.setOwner(newContractOwner);
        //this is meant to fail
        assertEq(wallet.owner(), newContractOwner);
    }

    function testFailForAddressZero() public {
        address addressZero = address(0);
        //owner cannot be set to address zero
        wallet.setOwner(addressZero);

        //this is meant to fail
        assertEq(wallet.owner(), addressZero);
    }

    function testFailSetOwnerWithMultiplePranks() public {
        //this sets the new owner to newContractOwner
        address newContractOwner = generateAddress("newContractOwner");
        //the owner of the Wallet contract is no longer address(this) but newContractOwner
        wallet.setOwner(newContractOwner);

        //now newContractOwner is meant to call the function setOwner as the new owner of the contract
        vm.startPrank(newContractOwner);

        //and for each calls to setOwner(), the caller is newContractOwner
        wallet.setOwner(generateAddress("newContractOwner1"));
        wallet.setOwner(generateAddress("newContractOwner2"));
        wallet.setOwner(generateAddress("newContractOwner3"));

        //this stops the pranking... all is meant to go well up to till point
        vm.stopPrank();

        //this is meant to fail because the owner of the contract is no longer address(this) but newContractOwner
        address theLastOwner = generateAddress("theLastOwner");
        wallet.setOwner(theLastOwner);
        assertEq(wallet.owner(), theLastOwner);
    }
}
