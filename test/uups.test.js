const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("UUPS Upgradeable Counter", function () {
  it("upgrades from V1 to V2 and preserves state", async function () {
    const [owner] = await ethers.getSigners();

    const LogicV1 = await ethers.getContractFactory("LogicV1");
    const proxy = await upgrades.deployProxy(LogicV1, [owner.address, 10], {
      initializer: "initialize",
      kind: "uups",
    });
    await proxy.waitForDeployment();

    await (await proxy.increment()).wait();
    expect(await proxy.get()).to.equal(11n);

    const LogicV2 = await ethers.getContractFactory("LogicV2");
    const upgraded = await upgrades.upgradeProxy(await proxy.getAddress(), LogicV2);

    expect(await upgraded.get()).to.equal(11n);

    await (await upgraded.decrement()).wait();
    expect(await upgraded.get()).to.equal(10n);

    await (await upgraded.reset()).wait();
    expect(await upgraded.get()).to.equal(0n);
  });
});
