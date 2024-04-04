// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Error {

    error Unauthorized();

    uint256 public result;
    address internal owner;

    constructor() {
        owner = msg.sender;
    }

    function getResult() external view returns(uint256) {
        if (msg.sender != owner) revert Unauthorized();
        return result;
    }


    function sub(uint256 a, uint256 b) external {
        require(a > b, "first number must be greater");
        uint num = a - b;
        result = num;
    }

    function multi(uint256 a, uint256 b) external {
        uint256 num = a * b;
        assert(num > 0);
        result = num;
    }
}
