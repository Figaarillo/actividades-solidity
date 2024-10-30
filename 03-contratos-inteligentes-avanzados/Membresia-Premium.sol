// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Membresia_Base.sol";

contract PremiumMembership is MembershipBase {
    uint public premiumFee;

    constructor(uint _fee, uint _premiumFee) MembershipBase(_fee) {
        premiumFee = _premiumFee;
    }

    function payFee() public payable override {
        require(msg.value == premiumFee, "Please submit the exact premium fee.");
        members[msg.sender] = true;
        emit MembershipPaid(msg.sender);
    }

    function accessPremiumContent() public view returns (string memory) {
        require(members[msg.sender], "Access restricted to Premium Members.");
        return "Premium Content Access Granted";
    }
}
