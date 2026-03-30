**##Assignment_1##**
**##Advanced Solidity Patterns & Security Fundamentals##**

This project demonstrates advanced Solidity development patterns and smart contract security concepts using a banking vault model. The implementation includes contract deployment patterns, upgradeable contracts, gas optimization techniques, inline assembly usage, and practical demonstrations of common vulnerabilities and their fixes

The goal of this project is to provide both theoretical understanding and practical implementation of blockchain development concepts. The system includes a factory for contract deployment, an upgradeable proxy contract, optimized storage and computation examples, and security scenarios such as reentrancy and access control vulnerabilities. Each component is tested using an automated test suite to verify correctness and behavior

**To run the project, make sure Node.js and npm are installed on your system.**
Install project dependencies:
`npm install`

Compile the smart contracts:
`npx hardhat compile`

Run the full test suite:
`npx hardhat test`

To generate gas usage report:
`cmd /c "set REPORT_GAS=true && npx hardhat test"`

**Result slither:**
PS C:\Users\Ghani\Desktop\BCH1> slither .
'npx hardhat clean' running (wd: C:\Users\Ghani\Desktop\BCH1)
'npx hardhat clean --global' running (wd: C:\Users\Ghani\Desktop\BCH1)
'npx hardhat compile --force' running (wd: C:\Users\Ghani\Desktop\BCH1)
INFO:Detectors:
Detector: arbitrary-send-eth
VulnerableAccess.withdrawAll() (contracts/VulnerableAccess.sol#15-18) sends eth to arbitrary user
        Dangerous calls:
        - (ok,None) = address(msg.sender).call{value: address(this).balance}() (contracts/VulnerableAccess.sol#16)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations
INFO:Detectors:
Detector: reentrancy-eth
Reentrancy in VulnerableVault.withdraw(uint256) (contracts/VulnerableVault.sol#11-18):
        External calls:
        - (ok,None) = address(msg.sender).call{value: amount}() (contracts/VulnerableVault.sol#13)
        State variables written after the call(s):
        - balances[msg.sender] -= amount (contracts/VulnerableVault.sol#16)
        VulnerableVault.balances (contracts/VulnerableVault.sol#5) can be used in cross function reentrancies:
        - VulnerableVault.balances (contracts/VulnerableVault.sol#5)
        - VulnerableVault.deposit() (contracts/VulnerableVault.sol#7-9)
        - VulnerableVault.withdraw(uint256) (contracts/VulnerableVault.sol#11-18)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-1
INFO:Detectors:
Detector: locked-ether
Contract locking ether found:
        Contract AssemblyBank (contracts/AssemblyBank.sol#4-45) has payable functions:
         - AssemblyBank.deposit() (contracts/AssemblyBank.sol#10-14)
        But does not have a function to withdraw the ether
Contract locking ether found:
        Contract ChildContract (contracts/ChildContract.sol#4-18) has payable functions:
         - ChildContract.constructor(address,string) (contracts/ChildContract.sol#8-11)
         - ChildContract.receive() (contracts/ChildContract.sol#17)
        But does not have a function to withdraw the ether
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#contracts-that-lock-ether
INFO:Detectors:
Detector: unused-return
ERC1967Utils.upgradeToAndCall(address,bytes) (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#67-76) ignores return value by Address.functionDelegateCall(newImplementation,data) (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#72)
ERC1967Utils.upgradeBeaconToAndCall(address,bytes) (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#157-166) ignores return value by Address.functionDelegateCall(IBeacon(newBeacon).implementation(),data) (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#162)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-return
INFO:Detectors:
Detector: events-maths
Attacker.attack() (contracts/Attacker.sol#16-22) should emit an event for:
        - attackAmount = msg.value (contracts/Attacker.sol#19)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-events-arithmetic
INFO:Detectors:
Detector: missing-zero-check
ChildContract.constructor(address,string)._owner (contracts/ChildContract.sol#8) lacks a zero-check on :
                - owner = _owner (contracts/ChildContract.sol#9)
VulnerableAccess.setOwner(address).newOwner (contracts/VulnerableAccess.sol#11) lacks a zero-check on :
                - owner = newOwner (contracts/VulnerableAccess.sol#12)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation
INFO:Detectors:
Detector: reentrancy-events
Reentrancy in GasBankOptimized.withdraw(uint128) (contracts/GasBankOptimized.sol#45-59):
        External calls:
        - (ok,None) = address(msg.sender).call{value: payout}() (contracts/GasBankOptimized.sol#52)
        - (feeOk,None) = address(admin).call{value: fee}() (contracts/GasBankOptimized.sol#55)
        Event emitted after the call(s):
        - Withdraw(msg.sender,payout,fee) (contracts/GasBankOptimized.sol#58)
Reentrancy in GasBankOriginal.withdraw(uint256) (contracts/GasBankOriginal.sol#45-65):
        External calls:
        - (ok,None) = address(msg.sender).call{value: payout}() (contracts/GasBankOriginal.sol#56)
        - (feeOk,None) = address(admin).call{value: fee}() (contracts/GasBankOriginal.sol#60)
        Event emitted after the call(s):
        - Withdraw(msg.sender,payout) (contracts/GasBankOriginal.sol#64)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-4
INFO:Detectors:
Detector: assembly
OwnableUpgradeable._getOwnableStorage() (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#30-34) uses assembly        
        - INLINE ASM (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#31-33)
Initializable._getInitializableStorage() (node_modules/@openzeppelin/contracts/proxy/utils/Initializable.sol#232-237) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/proxy/utils/Initializable.sol#234-236)
LowLevelCall.callNoReturn(address,uint256,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#19-23) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#20-22)
LowLevelCall.callReturn64Bytes(address,uint256,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#38-48) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#43-47)
LowLevelCall.staticcallNoReturn(address,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#51-55) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#52-54)
LowLevelCall.staticcallReturn64Bytes(address,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#62-71) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#66-70)
LowLevelCall.delegatecallNoReturn(address,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#74-78) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#75-77)
LowLevelCall.delegatecallReturn64Bytes(address,bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#85-94) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#89-93)
LowLevelCall.returnDataSize() (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#97-101) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#98-100)
LowLevelCall.returnData() (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#104-111) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#105-110)
LowLevelCall.bubbleRevert() (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#114-120) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#115-119)
LowLevelCall.bubbleRevert(bytes) (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#122-126) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#123-125)
StorageSlot.getAddressSlot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#66-70) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#67-69)
StorageSlot.getBooleanSlot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#75-79) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#76-78)
StorageSlot.getBytes32Slot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#84-88) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#85-87)
StorageSlot.getUint256Slot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#93-97) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#94-96)
StorageSlot.getInt256Slot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#102-106) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#103-105)
StorageSlot.getStringSlot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#111-115) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#112-114)
StorageSlot.getStringSlot(string) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#120-124) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#121-123)
StorageSlot.getBytesSlot(bytes32) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#129-133) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#130-132)
StorageSlot.getBytesSlot(bytes) (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#138-142) uses assembly
        - INLINE ASM (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#139-141)
AssemblyBank.getCallerWithAssembly() (contracts/AssemblyBank.sol#16-20) uses assembly
        - INLINE ASM (contracts/AssemblyBank.sol#17-19)
AssemblyBank.isPowerOfTwo(uint256) (contracts/AssemblyBank.sol#22-28) uses assembly
        - INLINE ASM (contracts/AssemblyBank.sol#23-27)
AssemblyBank.getTotalDepositsRaw() (contracts/AssemblyBank.sol#30-34) uses assembly
        - INLINE ASM (contracts/AssemblyBank.sol#31-33)
AssemblyBank.setTotalDepositsRaw(uint256) (contracts/AssemblyBank.sol#36-40) uses assembly
        - INLINE ASM (contracts/AssemblyBank.sol#37-39)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage
INFO:Detectors:
Detector: boolean-equal
GasBankOriginal.withdraw(uint256) (contracts/GasBankOriginal.sol#45-65) compares to a boolean constant:
        -require(bool,string)(accounts[msg.sender].active == true,inactive) (contracts/GasBankOriginal.sol#46)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#boolean-equality
INFO:Detectors:
Detector: pragma
6 different versions of Solidity are used:
        - Version constraint ^0.8.20 is used by:
                -^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol#3)
                -^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/access/Ownable.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/proxy/utils/Initializable.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/Address.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/Context.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/Errors.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol#4)
                -^0.8.20 (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#5)
        - Version constraint ^0.8.22 is used by:
                -^0.8.22 (node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#3)
                -^0.8.22 (node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol#4)
        - Version constraint >=0.4.11 is used by:
                ->=0.4.11 (node_modules/@openzeppelin/contracts/interfaces/IERC1967.sol#4)
        - Version constraint >=0.4.16 is used by:
                ->=0.4.16 (node_modules/@openzeppelin/contracts/interfaces/draft-IERC1822.sol#4)
                ->=0.4.16 (node_modules/@openzeppelin/contracts/proxy/beacon/IBeacon.sol#4)
        - Version constraint ^0.8.21 is used by:
                -^0.8.21 (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#4)
        - Version constraint ^0.8.23 is used by:
                -^0.8.23 (contracts/AssemblyBank.sol#2)
                -^0.8.23 (contracts/Attacker.sol#2)
                -^0.8.23 (contracts/Bank.sol#2)
                -^0.8.23 (contracts/ChildContract.sol#2)
                -^0.8.23 (contracts/Factory.sol#2)
                -^0.8.23 (contracts/FixedAccess.sol#2)
                -^0.8.23 (contracts/FixedVault.sol#2)
                -^0.8.23 (contracts/FixedVaultAttackHarness.sol#2)
                -^0.8.23 (contracts/GasBankOptimized.sol#2)
                -^0.8.23 (contracts/GasBankOriginal.sol#2)
                -^0.8.23 (contracts/LogicV1.sol#2)
                -^0.8.23 (contracts/LogicV2.sol#2)
                -^0.8.23 (contracts/VulnerableAccess.sol#2)
                -^0.8.23 (contracts/VulnerableVault.sol#2)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used
INFO:Detectors:
Detector: solc-version
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - VerbatimInvalidDeduplication
        - FullInlinerNonExpressionSplitArgumentEvaluationOrder
        - MissingSideEffectsOnSelectorAccess.
It is used by:
        - ^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol#3)
        - ^0.8.20 (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/access/Ownable.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/proxy/utils/Initializable.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/Address.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/Context.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/Errors.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/LowLevelCall.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/ReentrancyGuard.sol#4)
        - ^0.8.20 (node_modules/@openzeppelin/contracts/utils/StorageSlot.sol#5)
Version constraint ^0.8.22 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - VerbatimInvalidDeduplication.
It is used by:
        - ^0.8.22 (node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#3)
        - ^0.8.22 (node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol#4)
Version constraint >=0.4.11 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - DirtyBytesArrayToStorage
        - KeccakCaching
        - EmptyByteArrayCopy
        - DynamicArrayCleanup
        - ImplicitConstructorCallvalueCheck
        - TupleAssignmentMultiStackSlotComponents
        - MemoryArrayCreationOverflow
        - privateCanBeOverridden
        - SignedArrayStorageCopy
        - UninitializedFunctionPointerInConstructor_0.4.x
        - IncorrectEventSignatureInLibraries_0.4.x
        - ExpExponentCleanup
        - NestedArrayFunctionCallDecoder
        - ZeroFunctionSelector
        - DelegateCallReturnValue
        - ECRecoverMalformedInput
        - SkipEmptyStringLiteral.
It is used by:
        - >=0.4.11 (node_modules/@openzeppelin/contracts/interfaces/IERC1967.sol#4)
Version constraint >=0.4.16 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - DirtyBytesArrayToStorage
        - ABIDecodeTwoDimensionalArrayMemory
        - KeccakCaching
        - EmptyByteArrayCopy
        - DynamicArrayCleanup
        - ImplicitConstructorCallvalueCheck
        - TupleAssignmentMultiStackSlotComponents
        - MemoryArrayCreationOverflow
        - privateCanBeOverridden
        - SignedArrayStorageCopy
        - ABIEncoderV2StorageArrayWithMultiSlotElement
        - DynamicConstructorArgumentsClippedABIV2
        - UninitializedFunctionPointerInConstructor_0.4.x
        - IncorrectEventSignatureInLibraries_0.4.x
        - ExpExponentCleanup
        - NestedArrayFunctionCallDecoder
        - ZeroFunctionSelector.
It is used by:
        - >=0.4.16 (node_modules/@openzeppelin/contracts/interfaces/draft-IERC1822.sol#4)
        - >=0.4.16 (node_modules/@openzeppelin/contracts/proxy/beacon/IBeacon.sol#4)
Version constraint ^0.8.21 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
        - VerbatimInvalidDeduplication.
It is used by:
        - ^0.8.21 (node_modules/@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol#4)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
INFO:Detectors:
Detector: low-level-calls
Low level call in Attacker.withdrawLoot() (contracts/Attacker.sol#30-34):
        - (ok,None) = address(owner).call{value: address(this).balance}() (contracts/Attacker.sol#32)
Low level call in Bank.withdraw(uint256) (contracts/Bank.sol#11-16):
        - (ok,None) = address(msg.sender).call{value: amount}() (contracts/Bank.sol#14)
Low level call in FixedAccess.withdrawAll() (contracts/FixedAccess.sol#9-12):
        - (ok,None) = address(owner()).call{value: address(this).balance}() (contracts/FixedAccess.sol#10)
Low level call in FixedVault.withdraw(uint256) (contracts/FixedVault.sol#13-18):
        - (ok,None) = address(msg.sender).call{value: amount}() (contracts/FixedVault.sol#16)
Low level call in GasBankOptimized.withdraw(uint128) (contracts/GasBankOptimized.sol#45-59):
        - (ok,None) = address(msg.sender).call{value: payout}() (contracts/GasBankOptimized.sol#52)
        - (feeOk,None) = address(admin).call{value: fee}() (contracts/GasBankOptimized.sol#55)
Low level call in GasBankOriginal.withdraw(uint256) (contracts/GasBankOriginal.sol#45-65):
        - (ok,None) = address(msg.sender).call{value: payout}() (contracts/GasBankOriginal.sol#56)
        - (feeOk,None) = address(admin).call{value: fee}() (contracts/GasBankOriginal.sol#60)
Low level call in VulnerableAccess.withdrawAll() (contracts/VulnerableAccess.sol#15-18):
        - (ok,None) = address(msg.sender).call{value: address(this).balance}() (contracts/VulnerableAccess.sol#16)
Low level call in VulnerableVault.withdraw(uint256) (contracts/VulnerableVault.sol#11-18):
        - (ok,None) = address(msg.sender).call{value: amount}() (contracts/VulnerableVault.sol#13)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
Detector: missing-inheritance
Bank (contracts/Bank.sol#4-17) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
FixedVault (contracts/FixedVault.sol#6-23) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
VulnerableVault (contracts/VulnerableVault.sol#4-23) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-inheritance
INFO:Detectors:
Detector: naming-convention
Function OwnableUpgradeable.__Ownable_init(address) (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#51-53) is not in mixedCase
Function OwnableUpgradeable.__Ownable_init_unchained(address) (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#55-60) is not in mixedCase
Constant OwnableUpgradeable.OwnableStorageLocation (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#28) is not in UPPER_CASE_WITH_UNDERSCORES
Function ContextUpgradeable.__Context_init() (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#18-19) is not in mixedCase
Function ContextUpgradeable.__Context_init_unchained() (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#21-22) is not in mixedCase
Variable UUPSUpgradeable.__self (node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol#23) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
INFO:Detectors:
Detector: redundant-statements
Low level call in VulnerableVault.withdraw(uint256) (contracts/VulnerableVault.sol#11-18):
        - (ok,None) = address(msg.sender).call{value: amount}() (contracts/VulnerableVault.sol#13)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
Detector: missing-inheritance
Bank (contracts/Bank.sol#4-17) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
FixedVault (contracts/FixedVault.sol#6-23) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
VulnerableVault (contracts/VulnerableVault.sol#4-23) should inherit from IFixedVault (contracts/FixedVaultAttackHarness.sol#4-7)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-inheritance
INFO:Detectors:
Detector: naming-convention
Function OwnableUpgradeable.__Ownable_init(address) (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#51-53) is not in mixedCase
Function OwnableUpgradeable.__Ownable_init_unchained(address) (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#55-60) is not in mixedCase
Constant OwnableUpgradeable.OwnableStorageLocation (node_modules/@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol#28) is not in UPPER_CASE_WITH_UNDERSCORES
Function ContextUpgradeable.__Context_init() (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#18-19) is not in mixedCase
Function ContextUpgradeable.__Context_init_unchained() (node_modules/@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol#21-22) is not in mixedCase
Variable UUPSUpgradeable.__self (node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol#23) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
INFO:Detectors:
Detector: redundant-statements
Redundant expression "note (contracts/GasBankOriginal.sol#29)" inGasBankOriginal (contracts/GasBankOriginal.sol#4-66)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#redundant-statements
INFO:Detectors:
Detector: unindexed-event-address
Event IERC1967.AdminChanged(address,address) (node_modules/@openzeppelin/contracts/interfaces/IERC1967.sol#18) has address parameters but no indexed parameters
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unindexed-event-address-parameters
INFO:Detectors:
Detector: immutable-states
ChildContract.owner (contracts/ChildContract.sol#5) should be immutable
GasBankOriginal.admin (contracts/GasBankOriginal.sol#14) should be immutable
GasBankOriginal.feeBps (contracts/GasBankOriginal.sol#15) should be immutable
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variables-that-could-be-declared-immutable
INFO:Slither:. analyzed (30 contracts with 101 detectors), 65 result(s) found
PS C:\Users\Ghani\Desktop\BCH1>
