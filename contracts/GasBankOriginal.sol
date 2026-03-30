
pragma solidity ^0.8.23;

contract GasBankOriginal {
    struct Account {
        uint256 balance;
        uint256 depositCount;
        uint256 withdrawCount;
        bool active;
        address owner;
    }

    mapping(address => Account) public accounts;
    address public admin;
    uint256 public feeBps;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(uint256 _feeBps) {
        admin = msg.sender;
        feeBps = _feeBps;
    }

    function deposit(address user, uint256 amount, bytes memory note) external payable {
        require(user != address(0), "zero user");
        require(amount > 0, "zero amount");
        require(msg.value == amount, "wrong value");
        note;

        accounts[user].balance = accounts[user].balance + amount;
        accounts[user].depositCount = accounts[user].depositCount + 1;
        accounts[user].active = true;
        accounts[user].owner = user;

        emit Deposit(user, amount);
    }

    function batchBalance(address[] memory users) external view returns (uint256 sum) {
        for (uint256 i = 0; i < users.length; i++) {
            sum = sum + accounts[users[i]].balance;
        }
    }

    function withdraw(uint256 amount) external {
        require(accounts[msg.sender].active == true, "inactive");
        require(accounts[msg.sender].owner == msg.sender, "not owner");
        require(accounts[msg.sender].balance >= amount, "not enough");

        uint256 fee = (amount * feeBps) / 10000;
        uint256 payout = amount - fee;

        accounts[msg.sender].balance = accounts[msg.sender].balance - amount;
        accounts[msg.sender].withdrawCount = accounts[msg.sender].withdrawCount + 1;

        (bool ok, ) = payable(msg.sender).call{value: payout}("");
        require(ok, "transfer failed");

        if (fee > 0) {
            (bool feeOk, ) = payable(admin).call{value: fee}("");
            require(feeOk, "fee failed");
        }

        emit Withdraw(msg.sender, payout);
    }
}
