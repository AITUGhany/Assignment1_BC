// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract LogicV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal counter;

    function initialize(address initialOwner, uint256 initialValue) public initializer {
        __Ownable_init(initialOwner);
        counter = initialValue;
    }

    function increment() external {
        counter += 1;
    }

    function get() external view returns (uint256) {
        return counter;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
