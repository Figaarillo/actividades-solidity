// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StableCoin is ERC20{
    constructor(address account) ERC20("StableCoin","STC"){
        
        _mint(account, 100 * 1 ether);
    }

    function mint(address account, uint amount) public {
        _mint(account, amount);
    }

}
