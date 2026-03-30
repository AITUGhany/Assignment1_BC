const hre = require("hardhat");

async function main() {
  const AssemblyBank = await hre.ethers.getContractFactory("AssemblyBank");
  const bank = await AssemblyBank.deploy();
  await bank.waitForDeployment();

  console.log("AssemblyBank deployed to:", await bank.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
