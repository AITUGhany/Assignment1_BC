
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FixedAccess is Ownable {
    constructor(address initialOwner) payable Ownable(initialOwner) {}

    function withdrawAll() external onlyOwner {
        (bool ok, ) = payable(owner()).call{value: address(this).balance}("");
        require(ok, "transfer failed");
    }
}
