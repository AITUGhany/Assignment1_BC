const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Factory", function () {
  it("deploys child contracts with CREATE and CREATE2", async function () {
    const [owner] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.waitForDeployment();

    const tx1 = await factory.deployWithCreate("Bank A", { value: ethers.parseEther("1") });
    await tx1.wait();

    const salt = ethers.keccak256(ethers.toUtf8Bytes("salt-1"));
    const tx2 = await factory.deployWithCreate2("Bank B", salt, { value: ethers.parseEther("1") });
    await tx2.wait();

    const deployed = await factory.getDeployedContracts();
    expect(deployed.length).to.equal(2);
    expect(await factory.isDeployedByFactory(deployed[0])).to.equal(true);
    expect(await factory.isDeployedByFactory(deployed[1])).to.equal(true);
    owner;
  });
});
