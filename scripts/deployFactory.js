const hre = require("hardhat");

async function main() {
  const Factory = await hre.ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.waitForDeployment();

  console.log("Factory deployed to:", await factory.getAddress());

  const tx1 = await factory.deployWithCreate("Alpha Bank Child", { value: hre.ethers.parseEther("0.1") });
  const r1 = await tx1.wait();
  console.log("CREATE gas used:", r1.gasUsed.toString());

  const salt = hre.ethers.keccak256(hre.ethers.toUtf8Bytes("bank-salt-1"));
  const tx2 = await factory.deployWithCreate2("Beta Bank Child", salt, { value: hre.ethers.parseEther("0.1") });
  const r2 = await tx2.wait();
  console.log("CREATE2 gas used:", r2.gasUsed.toString());

  const deployed = await factory.getDeployedContracts();
  console.log("Deployed child contracts:", deployed);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
