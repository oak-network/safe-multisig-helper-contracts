import { expect } from "chai";
import { ethers } from "hardhat";
import { AdapterManager } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("AdapterManager", function () {
  let adapterManager: AdapterManager;
  let admin: SignerWithAddress;
  let user: SignerWithAddress;
  let mockTreasury: SignerWithAddress;

  beforeEach(async function () {
    [admin, user, mockTreasury] = await ethers.getSigners();

    const AdapterManager = await ethers.getContractFactory("AdapterManager");
    adapterManager = await AdapterManager.deploy(admin.address);
    await adapterManager.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the correct admin", async function () {
      expect(await adapterManager.admin()).to.equal(admin.address);
    });

    it("Should revert if admin is zero address", async function () {
      const AdapterManager = await ethers.getContractFactory("AdapterManager");
      await expect(
        AdapterManager.deploy(ethers.ZeroAddress)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });
  });

  describe("Access Control", function () {
    it("Should allow admin to change admin", async function () {
      await expect(adapterManager.connect(admin).changeAdmin(user.address))
        .to.emit(adapterManager, "AdminChanged")
        .withArgs(admin.address, user.address);

      expect(await adapterManager.admin()).to.equal(user.address);
    });

    it("Should not allow non-admin to change admin", async function () {
      await expect(
        adapterManager.connect(user).changeAdmin(user.address)
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });

    it("Should not allow changing admin to zero address", async function () {
      await expect(
        adapterManager.connect(admin).changeAdmin(ethers.ZeroAddress)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });

    it("Should not allow non-admin to call adapter functions", async function () {
      const message = ethers.encodeBytes32String("test");
      
      await expect(
        adapterManager.connect(user).kwrPauseTreasury(mockTreasury.address, message)
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");

      await expect(
        adapterManager.connect(user).aonPauseTreasury(mockTreasury.address, message)
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");

      await expect(
        adapterManager.connect(user).ptPauseTreasury(mockTreasury.address, message)
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });
  });

  describe("Execute Call", function () {
    it("Should allow admin to execute arbitrary calls", async function () {
      // Simple call data (empty bytes)
      const data = "0x";
      
      await expect(
        adapterManager.connect(admin).executeCall(mockTreasury.address, data)
      ).to.not.be.reverted;
    });

    it("Should not allow non-admin to execute calls", async function () {
      const data = "0x";
      
      await expect(
        adapterManager.connect(user).executeCall(mockTreasury.address, data)
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });

    it("Should revert if target is zero address", async function () {
      const data = "0x";
      
      await expect(
        adapterManager.connect(admin).executeCall(ethers.ZeroAddress, data)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });
  });

  describe("Zero Address Validation", function () {
    const message = ethers.encodeBytes32String("test");
    const pledgeId = ethers.encodeBytes32String("pledge1");

    it("Should revert on zero treasury address for KeepWhatsRaised functions", async function () {
      await expect(
        adapterManager.connect(admin).kwrPauseTreasury(ethers.ZeroAddress, message)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");

      await expect(
        adapterManager.connect(admin).setPaymentGatewayFee(ethers.ZeroAddress, pledgeId, 100)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });

    it("Should revert on zero treasury address for AllOrNothing functions", async function () {
      await expect(
        adapterManager.connect(admin).aonPauseTreasury(ethers.ZeroAddress, message)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });

    it("Should revert on zero treasury address for PaymentTreasury functions", async function () {
      await expect(
        adapterManager.connect(admin).ptPauseTreasury(ethers.ZeroAddress, message)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });
  });


  describe("Function Inheritance", function () {
    it("Should have all KeepWhatsRaised functions", async function () {
      expect(adapterManager.setPaymentGatewayFee).to.exist;
      expect(adapterManager.approveWithdrawal).to.exist;
      expect(adapterManager.withdraw).to.exist;
      expect(adapterManager.claimTip).to.exist;
      expect(adapterManager.claimFund).to.exist;
      expect(adapterManager.kwrPauseTreasury).to.exist;
      expect(adapterManager.kwrUnpauseTreasury).to.exist;
      expect(adapterManager.kwrCancelTreasury).to.exist;
    });

    it("Should have all AllOrNothing functions", async function () {
      expect(adapterManager.aonPauseTreasury).to.exist;
      expect(adapterManager.aonUnpauseTreasury).to.exist;
      expect(adapterManager.aonCancelTreasury).to.exist;
    });

    it("Should have all PaymentTreasury functions", async function () {
      expect(adapterManager.createPayment).to.exist;
      expect(adapterManager.cancelPayment).to.exist;
      expect(adapterManager.confirmPayment).to.exist;
      expect(adapterManager.confirmPaymentBatch).to.exist;
      expect(adapterManager.ptPauseTreasury).to.exist;
      expect(adapterManager.ptUnpauseTreasury).to.exist;
      expect(adapterManager.ptCancelTreasury).to.exist;
    });
  });
});

