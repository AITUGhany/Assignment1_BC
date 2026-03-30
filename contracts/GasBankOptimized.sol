// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract GasBankOptimized {
    address public immutable admin;
    uint16 public immutable feeBps;

    struct Account {
        uint128 balance;
        uint64 depositCount;
        uint64 withdrawCount;
        bool active;
    }

    mapping(address => Account) public accounts;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 payout, uint256 fee);

    constructor(uint16 feeBps_) {
        admin = msg.sender;
        feeBps = feeBps_;
    }

    function deposit(address user) external payable {
        require(user != address(0), "zero user");
        require(msg.value > 0, "zero amount");
        Account storage account = accounts[user];
        account.balance += uint128(msg.value);
        account.depositCount += 1;
        account.active = true;
        emit Deposit(user, msg.value);
    }

    function batchBalance(address[] calldata users) external view returns (uint256 sum) {
        uint256 length = users.length;
        for (uint256 i; i < length; ) {
            sum += accounts[users[i]].balance;
            unchecked {
                ++i;
            }
        }
    }

    function withdraw(uint128 amount) external {
        Account storage account = accounts[msg.sender];
        require(account.active && account.balance >= amount, "invalid withdraw");
        uint256 fee = (uint256(amount) * feeBps) / 10_000;
        uint256 payout = uint256(amount) - fee;
        account.balance -= amount;
        account.withdrawCount += 1;
        (bool ok, ) = payable(msg.sender).call{value: payout}("");
        require(ok, "transfer failed");
        if (fee != 0) {
            (bool feeOk, ) = payable(admin).call{value: fee}("");
            require(feeOk, "fee failed");
        }
        emit Withdraw(msg.sender, payout, fee);
    }
}
