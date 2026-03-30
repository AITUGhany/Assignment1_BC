
pragma solidity ^0.8.23;

contract VulnerableAccess {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function setOwner(address newOwner) external {
        owner = newOwner;
    }

    function withdrawAll() external {
        (bool ok, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(ok, "transfer failed");
    }
}
