const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Gas workshop and assembly", function () {
  it("assembly contract supports caller, power-of-two check, and raw storage read", async function () {
    const [user] = await ethers.getSigners();
    const AssemblyBank = await ethers.getContractFactory("AssemblyBank");
    const bank = await AssemblyBank.deploy();
    await bank.waitForDeployment();

    expect(await bank.getCallerWithAssembly()).to.equal(user.address);
    expect(await bank.isPowerOfTwo(8)).to.equal(true);
    expect(await bank.isPowerOfTwo(7)).to.equal(false);

    await bank.deposit({ value: ethers.parseEther("1") });
    expect(await bank.getTotalDepositsRaw()).to.equal(ethers.parseEther("1"));

    await bank.setTotalDepositsRaw(123);
    expect(await bank.getTotalDepositsRaw()).to.equal(123n);
  });

  it("original and optimized gas-bank contracts both work", async function () {
    const [user] = await ethers.getSigners();

    const Original = await ethers.getContractFactory("GasBankOriginal");
    const original = await Original.deploy(100);
    await original.waitForDeployment();

    const Optimized = await ethers.getContractFactory("GasBankOptimized");
    const optimized = await Optimized.deploy(100);
    await optimized.waitForDeployment();

    await original.deposit(user.address, ethers.parseEther("1"), "0x", { value: ethers.parseEther("1") });
    await optimized.deposit(user.address, { value: ethers.parseEther("1") });

    const originalData = await original.accounts(user.address);
    const optimizedData = await optimized.accounts(user.address);

    expect(originalData.balance).to.equal(ethers.parseEther("1"));
    expect(optimizedData.balance).to.equal(ethers.parseEther("1"));
  });
});
