const hre = require("hardhat");
const { upgrades } = hre;

async function main() {
  const [owner] = await hre.ethers.getSigners();

  const LogicV1 = await hre.ethers.getContractFactory("LogicV1");
  const proxy = await upgrades.deployProxy(LogicV1, [owner.address, 5], {
    initializer: "initialize",
    kind: "uups",
  });
  await proxy.waitForDeployment();

  console.log("UUPS proxy deployed:", await proxy.getAddress());
  console.log("Counter before increment:", (await proxy.get()).toString());

  await (await proxy.increment()).wait();
  console.log("Counter after increment:", (await proxy.get()).toString());

  const LogicV2 = await hre.ethers.getContractFactory("LogicV2");
  const upgraded = await upgrades.upgradeProxy(await proxy.getAddress(), LogicV2);
  await upgraded.waitForDeployment();

  console.log("Upgraded proxy address:", await upgraded.getAddress());
  console.log("Counter persisted after upgrade:", (await upgraded.get()).toString());

  await (await upgraded.decrement()).wait();
  console.log("Counter after decrement:", (await upgraded.get()).toString());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
