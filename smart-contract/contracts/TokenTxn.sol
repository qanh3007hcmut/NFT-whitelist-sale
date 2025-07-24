// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TXNToken is ERC20 {
    constructor() ERC20("TXNToken", "TXNT") {
        _mint(msg.sender, 1_000_000 ether);
    }
}