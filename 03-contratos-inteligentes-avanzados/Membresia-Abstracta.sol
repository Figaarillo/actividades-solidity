// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./IMembresia.sol";

abstract contract AbstractMembership is IMembership {
    uint public fee;
    address public owner;

    constructor(uint _fee) {
        owner = msg.sender;
        fee = _fee;
    }

    function isMember(address _member) public view virtual override returns (bool);
}
