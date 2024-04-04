// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/Event.sol";

contract CounterTest is Test {
    Event public eventContract;

    event Transfer(address indexed from, address indexed to, uint amount);


    function setUp() public {
        eventContract = new Event();
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

    function testEmitTransfer() public {
        /* function expectEmit(
            bool checkTopic1,
            bool checkTopic2,
            bool checkTopic3,
            bool checkData,
        );*/

        //steps
        // 1. tell foundry which data to check
        //this tells foundry to check for first, second indexed data, but not bothered about the rest data
        vm.expectEmit(true, true, false, true);
        //2. emit the expected event
        address toAddress = generateAddress("toAddress");
        emit Transfer(address(this), toAddress, 900);
        //3. call the function that is expected to emit the eventContract
        eventContract.transfer(address(this), toAddress, 900);

        //to check index 1 of the event only
        vm.expectEmit(true, false, false, false);
        emit Transfer(address(this), toAddress, 200);
        eventContract.transfer(address(this), address(12), 300);
    }

    function testEmitManyTransferEvents() public {
        address[] memory to = new address[](2);
        to[0] = generateAddress("firstAddress");
        to[1] = generateAddress("secondAddress");

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 230;
        amounts[1] = 129;

        for (uint i; i < to.length; i++) {
            vm.expectEmit(true, true, false, true);
            emit Transfer(address(this), to[i], amounts[i]);
        }

        eventContract.transferMany(address(this), to, amounts);
    }

}