# BCHT2 Assignment 1 — Bank-Themed Solidity Project

This project is organized around a **bank / vault** theme so that every required task stays consistent.

## Implemented parts

### Part 1 — Advanced Solidity Design Patterns
1. **Factory Pattern**
   - `ChildContract.sol`
   - `Factory.sol`
   - Supports both `CREATE` and `CREATE2`
   - Stores deployed child contracts in array + mapping

2. **UUPS Upgradeable Contracts**
   - `LogicV1.sol`
   - `LogicV2.sol`
   - `deployUUPS.js` shows upgrade flow while preserving state

### Part 2 — Gas Optimization Workshop
3. **Storage & Computation Optimization**
   - `GasBankOriginal.sol`
   - `GasBankOptimized.sol`
   - Inline comments mark 7+ optimizations

4. **Inline Assembly (Yul) Basics**
   - `AssemblyBank.sol`
   - Uses `caller()`, bitwise arithmetic check, `sload` / `sstore`

### Part 3 — Security Fundamentals
5. **Vulnerability Analysis & Exploitation**
   - `VulnerableVault.sol`
   - `Attacker.sol`
   - `FixedVault.sol`
   - `VulnerableAccess.sol`
   - `FixedAccess.sol`
   - Tests show exploit before fix and rejection after fix

6. **Static Analysis with Slither**
   - `reports/slither_summary.md`
   - `reports/slither_before.txt`
   - `reports/slither_after.txt`

### Part 4 — Theoretical Analysis
7. **Written analysis**
   - `reports/written_analysis.md`

## How to run locally
```bash
npm install
npx hardhat compile
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat run scripts/deployFactory.js
npx hardhat run scripts/deployUUPS.js
slither . --filter-paths node_modules,test,artifacts,cache
```

## Important
This project includes all source code, scripts, tests, and written reports needed to match the assignment structure.
However, **screenshots, real gas report output, and real Slither logs must be generated on your machine** after installing dependencies. Placeholder report files are included so you can paste the real output there.
