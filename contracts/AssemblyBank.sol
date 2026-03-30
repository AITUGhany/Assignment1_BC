
pragma solidity ^0.8.23;

contract AssemblyBank {
    mapping(address => uint256) private balances;
    uint256 private totalDeposits;

    event Deposit(address indexed sender, uint256 amount);

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function getCallerWithAssembly() external view returns (address callerAddress) {
        assembly {
            callerAddress := caller()
        }
    }

    function isPowerOfTwo(uint256 x) external pure returns (bool result) {
        assembly {
            switch x
            case 0 { result := 0 }
            default { result := iszero(and(x, sub(x, 1))) }
        }
    }

    function getTotalDepositsRaw() external view returns (uint256 value) {
        assembly {
            value := sload(1)
        }
    }

    function setTotalDepositsRaw(uint256 newValue) external {
        assembly {
            sstore(1, newValue)
        }
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }
}
