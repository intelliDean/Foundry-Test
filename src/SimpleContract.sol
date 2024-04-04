// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

//import "forge-std/console.sol";
import "lib/forge-std/src/console.sol";

contract SimpleContract {
    uint256 public result;

    function add(uint256 a, uint256 b) external {
        uint num = a + b;
        console.log("Result after the addition", num);
        result = num;
    }

    function sub(uint256 a, uint256 b) external {
        require(a > b, "first number must be greater");
        uint num = a - b;
        console.log("Result after the sub", num);
        result = num;
    }

    function multi(uint256 a, uint256 b) external {
        uint256 num = a * b;
        assert(num > 0);
        console.log("Result after multiplication", num);
        result = num;
    }
}
