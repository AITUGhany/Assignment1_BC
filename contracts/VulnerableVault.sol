
pragma solidity ^0.8.23;

contract VulnerableVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient balance");
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "transfer failed");
        unchecked {
            balances[msg.sender] -= amount;
        }
    }

    function vaultBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
