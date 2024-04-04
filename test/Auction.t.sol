// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/Auction.sol";

contract CounterTest is Test {
    Auction public auction;
    uint public startAt;

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
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

    //vm.warp - set block.time to future timestamp
    //vm.roll - set block.number

    function testBidFailBeforeTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testBid() public {
        vm.warp(startAt + 1 days); //this fast forward the time to 1 day time
        auction.bid();
    }

    function testBidFailWhenTimePass() public {
        vm.warp(startAt + 6 days);

        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testTimeStamp() public {
        uint time = block.timestamp;
        //skip - increment current timestamp
        skip(120);
        assertEq(block.timestamp, time + 120);
        //rewind - decrement current timestamp
        rewind(60);
        assertEq(block.timestamp, time + 120 - 60);
    }

    function testRoll() public {
        console.log("Current block number", block.number);
        vm.roll(120);
        console.log("Block number after roll", block.number);
        assertEq(block.number, 120);
    }
}