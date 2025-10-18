import { expect } from "chai";
import { ethers } from "hardhat";
import { AdapterManager } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("PaymentTreasuryAdapter Functions", function () {
  let adapterManager: AdapterManager;
  let admin: SignerWithAddress;
  let user: SignerWithAddress;
  let mockTreasury: any;

  beforeEach(async function () {
    [admin, user] = await ethers.getSigners();

    // Deploy mock treasury
    const MockTreasury = await ethers.getContractFactory("MockPaymentTreasury");
    mockTreasury = await MockTreasury.deploy();
    await mockTreasury.waitForDeployment();

    // Deploy AdapterManager
    const AdapterManager = await ethers.getContractFactory("AdapterManager");
    adapterManager = await AdapterManager.deploy(admin.address);
    await adapterManager.waitForDeployment();
  });

  describe("createPayment", function () {
    it("Should call createPayment on treasury", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");
      const buyerId = ethers.encodeBytes32String("buyer1");
      const itemId = ethers.encodeBytes32String("item1");
      const amount = ethers.parseEther("1");
      const expiration = Math.floor(Date.now() / 1000) + 3600;

      await expect(
        adapterManager.connect(admin).createPayment(
          await mockTreasury.getAddress(),
          paymentId,
          buyerId,
          itemId,
          amount,
          expiration
        )
      ).to.emit(mockTreasury, "PaymentCreated")
        .withArgs(paymentId, buyerId, admin.address);
    });

    it("Should revert if non-admin calls", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");
      const buyerId = ethers.encodeBytes32String("buyer1");
      const itemId = ethers.encodeBytes32String("item1");

      await expect(
        adapterManager.connect(user).createPayment(
          await mockTreasury.getAddress(),
          paymentId,
          buyerId,
          itemId,
          100,
          123456
        )
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });
  });

  describe("cancelPayment", function () {
    it("Should call cancelPayment on treasury", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");

      await expect(
        adapterManager.connect(admin).cancelPayment(
          await mockTreasury.getAddress(),
          paymentId
        )
      ).to.emit(mockTreasury, "PaymentCancelled")
        .withArgs(paymentId, admin.address);
    });
  });

  describe("confirmPayment", function () {
    it("Should call confirmPayment on treasury", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");

      await expect(
        adapterManager.connect(admin).confirmPayment(
          await mockTreasury.getAddress(),
          paymentId
        )
      ).to.emit(mockTreasury, "PaymentConfirmed")
        .withArgs(paymentId, admin.address);
    });
  });

  describe("confirmPaymentBatch", function () {
    it("Should call confirmPaymentBatch on treasury", async function () {
      const paymentIds = [
        ethers.encodeBytes32String("payment1"),
        ethers.encodeBytes32String("payment2"),
        ethers.encodeBytes32String("payment3"),
      ];

      await expect(
        adapterManager.connect(admin).confirmPaymentBatch(
          await mockTreasury.getAddress(),
          paymentIds
        )
      ).to.emit(mockTreasury, "PaymentBatchConfirmed")
        .withArgs(paymentIds.length, admin.address);
    });
  });

  describe("claimRefund", function () {
    it("Should call claimRefund with address on treasury", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");
      const refundAddress = user.address;

      await expect(
        adapterManager.connect(admin)["claimRefund(address,bytes32,address)"](
          await mockTreasury.getAddress(),
          paymentId,
          refundAddress
        )
      ).to.emit(mockTreasury, "RefundClaimed")
        .withArgs(paymentId, refundAddress, admin.address);
    });

    it("Should call claimRefund without address on treasury", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");

      await expect(
        adapterManager.connect(admin)["claimRefund(address,bytes32)"](
          await mockTreasury.getAddress(),
          paymentId
        )
      ).to.emit(mockTreasury, "RefundClaimed");
    });
  });

  describe("ptCancelTreasury", function () {
    it("Should call cancelTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("cancelled");

      await expect(
        adapterManager.connect(admin).ptCancelTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);
    });
  });

  describe("ptPauseTreasury", function () {
    it("Should call pauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("paused");

      await expect(
        adapterManager.connect(admin).ptPauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryPaused")
        .withArgs(message, admin.address);
    });
  });

  describe("ptUnpauseTreasury", function () {
    it("Should call unpauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("unpaused");

      await expect(
        adapterManager.connect(admin).ptUnpauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryUnpaused")
        .withArgs(message, admin.address);
    });
  });
});

