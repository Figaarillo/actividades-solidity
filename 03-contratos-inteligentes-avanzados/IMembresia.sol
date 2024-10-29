// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IMembership {
    function payFee() external payable;
    function isMember(address _member) external view returns (bool);
}
