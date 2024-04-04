// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "src/Wallet.sol";

contract CounterTest is Test {
    Wallet public wallet;
    address public sender;

    function setUp() public {
        wallet = new Wallet();
        sender = generateAddress("sender");
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

    function _send(uint256 _amount) private {
        (bool ok,) = address(wallet).call{value: _amount}("");
        require(ok, "sending failed");
    }

    function testETHBalance() public {
        console.log("ETH Balance", address(this).balance / 1e18);
    }

    function testDeal() public {
        //deal(address, uint) - sets balance of the address
        //for example, it sets the balance of address(1) to 500
        deal(sender, 200);
        //this makes the address sender to be the caller instead of the default address(this)
        vm.prank(sender);
        _send(200);
        assertEq(address(wallet).balance, 200);
    }

    function testHoax() public {
        //hoax(address, uint) - this sets the address to be msg.sender, so no need to prank
        //it also set the balance of the address
        hoax(sender, 300);
        _send(300);

        assertEq(address(wallet).balance, 300);
    }
}