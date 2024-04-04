// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    event Deposit(address account, uint256 amount);

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "Only owner");
        payable(msg.sender).transfer(_amount);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "Only owner");
        require(_owner != address(0), "Unauthorized address");
        owner = payable(_owner);
    }
}
