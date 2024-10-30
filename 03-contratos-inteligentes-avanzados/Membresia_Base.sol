// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MembershipBase {
    uint public fee = 10;
    address public owner;
    mapping(address => bool) public members;

    event MembershipPaid(address indexed member);

    constructor(uint _fee) {
        owner = msg.sender;
        fee = _fee;
    }

    function payFee() public payable virtual {
        require(msg.value == fee, "Please submit the exact fee.");
        members[msg.sender] = true;
        emit MembershipPaid(msg.sender);
    }

    function isMember(address _member) public view returns (bool) {
        return members[_member];
    }
}
