const hre = require("hardhat");

async function main() {
  const Original = await hre.ethers.getContractFactory("GasBankOriginal");
  const original = await Original.deploy(100);
  await original.waitForDeployment();

  const Optimized = await hre.ethers.getContractFactory("GasBankOptimized");
  const optimized = await Optimized.deploy(100);
  await optimized.waitForDeployment();

  console.log("GasBankOriginal:", await original.getAddress());
  console.log("GasBankOptimized:", await optimized.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
