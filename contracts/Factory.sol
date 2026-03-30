
pragma solidity ^0.8.23;

import "./ChildContract.sol";

contract Factory {
    address[] private deployedContracts;
    mapping(address => bool) public isDeployedByFactory;

    event ChildDeployed(address indexed child, address indexed owner, string name, bool usedCreate2);

    function deployWithCreate(string calldata name_) external payable returns (address childAddr) {
        ChildContract child = new ChildContract{value: msg.value}(msg.sender, name_);
        childAddr = address(child);
        deployedContracts.push(childAddr);
        isDeployedByFactory[childAddr] = true;
        emit ChildDeployed(childAddr, msg.sender, name_, false);
    }

    function deployWithCreate2(string calldata name_, bytes32 salt) external payable returns (address childAddr) {
        ChildContract child = new ChildContract{salt: salt, value: msg.value}(msg.sender, name_);
        childAddr = address(child);
        deployedContracts.push(childAddr);
        isDeployedByFactory[childAddr] = true;
        emit ChildDeployed(childAddr, msg.sender, name_, true);
    }

    function predictCreate2Address(
        address deployer,
        string calldata name_,
        bytes32 salt
    ) external view returns (address predicted) {
        bytes memory bytecode = abi.encodePacked(type(ChildContract).creationCode, abi.encode(deployer, name_));
        bytes32 bytecodeHash = keccak256(bytecode);
        bytes32 digest = keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, bytecodeHash));
        predicted = address(uint160(uint256(digest)));
    }

    function getDeployedContracts() external view returns (address[] memory) {
        return deployedContracts;
    }

    function getContractsCount() external view returns (uint256) {
        return deployedContracts.length;
    }
}
