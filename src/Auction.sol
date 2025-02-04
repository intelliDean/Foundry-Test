// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Auction {

    uint256 public startAt = block.timestamp + 1 days;
    uint256 public endAt = block.timestamp + 5 days;

    function bid() external {
        require(
            block.timestamp >= startAt &&
            block.timestamp < endAt,
            "cannot bid"
        );
    }

    function end() external {
        require(block.timestamp >= endAt, "cannot end");
    }
}
