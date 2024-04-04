// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Event {

    event Transfer(address indexed from, address indexed to, uint amount);


    function transfer(address _from, address _to, uint _amount) external {
        emit Transfer(_from, _to, _amount);
    }

    function transferMany(address _from, address[] calldata _to, uint[] calldata _amount) external {
        for (uint i; i < _to.length; i++) {
            emit Transfer(_from, _to[i], _amount[i]);
        }
    }



}
