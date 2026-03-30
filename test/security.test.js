const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Security Labs", function () {
  it("reentrancy drains funds from VulnerableVault", async function () {
    const [deployer, victim, attackerOwner] = await ethers.getSigners();

    const VulnerableVault = await ethers.getContractFactory("VulnerableVault", deployer);
    const vault = await VulnerableVault.deploy();
    await vault.waitForDeployment();

    await vault.connect(victim).deposit({ value: ethers.parseEther("5") });

    const Attacker = await ethers.getContractFactory("Attacker", attackerOwner);
    const attacker = await Attacker.deploy(await vault.getAddress());
    await attacker.waitForDeployment();

    await attacker.connect(attackerOwner).attack({ value: ethers.parseEther("1") });

    expect(await ethers.provider.getBalance(await vault.getAddress())).to.equal(0n);
    expect(await ethers.provider.getBalance(await attacker.getAddress())).to.equal(ethers.parseEther("6"));
  });

  it("fixed vault blocks reentrancy", async function () {
    const [deployer, victim, attackerOwner] = await ethers.getSigners();

    const FixedVault = await ethers.getContractFactory("FixedVault", deployer);
    const fixedVault = await FixedVault.deploy();
    await fixedVault.waitForDeployment();

    await fixedVault.connect(victim).deposit({ value: ethers.parseEther("5") });

    const AttackHarness = await ethers.getContractFactory("FixedVaultAttackHarness", attackerOwner);
    const harness = await AttackHarness.deploy(await fixedVault.getAddress());
    await harness.waitForDeployment();

    await expect(
      harness.connect(attackerOwner).attack({ value: ethers.parseEther("1") })
    ).to.be.reverted;
  });

  it("vulnerable access allows anyone to seize control and funds", async function () {
    const [owner, attacker] = await ethers.getSigners();

    const VulnerableAccess = await ethers.getContractFactory("VulnerableAccess", owner);
    const vulnerable = await VulnerableAccess.deploy({ value: ethers.parseEther("1") });
    await vulnerable.waitForDeployment();

    await vulnerable.connect(attacker).setOwner(attacker.address);
    expect(await vulnerable.owner()).to.equal(attacker.address);

    const before = await ethers.provider.getBalance(attacker.address);
    const tx = await vulnerable.connect(attacker).withdrawAll();
    const receipt = await tx.wait();
    const gasCost = receipt.gasUsed * receipt.gasPrice;
    const after = await ethers.provider.getBalance(attacker.address);

    expect(after).to.be.gt(before - gasCost);
    expect(await ethers.provider.getBalance(await vulnerable.getAddress())).to.equal(0n);
  });

  it("fixed access only allows owner to withdraw", async function () {
    const [owner, attacker] = await ethers.getSigners();

    const FixedAccess = await ethers.getContractFactory("FixedAccess", owner);
    const fixed = await FixedAccess.deploy(owner.address, { value: ethers.parseEther("1") });
    await fixed.waitForDeployment();

    await expect(fixed.connect(attacker).withdrawAll()).to.be.reverted;
    await fixed.connect(owner).withdrawAll();
    expect(await ethers.provider.getBalance(await fixed.getAddress())).to.equal(0n);
  });
});
