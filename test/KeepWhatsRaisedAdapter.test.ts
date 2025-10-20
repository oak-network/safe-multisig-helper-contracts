import { expect } from "chai";
import { ethers } from "hardhat";
import { AdapterManager } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("KeepWhatsRaisedAdapter Functions", function () {
  let adapterManager: AdapterManager;
  let admin: SignerWithAddress;
  let user: SignerWithAddress;
  let mockTreasury: any;

  beforeEach(async function () {
    [admin, user] = await ethers.getSigners();

    // Deploy mock treasury
    const MockTreasury = await ethers.getContractFactory("MockKeepWhatsRaisedTreasury");
    mockTreasury = await MockTreasury.deploy();
    await mockTreasury.waitForDeployment();

    // Deploy AdapterManager
    const AdapterManager = await ethers.getContractFactory("AdapterManager");
    adapterManager = await AdapterManager.deploy(admin.address);
    await adapterManager.waitForDeployment();
  });

  describe("setPaymentGatewayFee", function () {
    it("Should call setPaymentGatewayFee on treasury", async function () {
      const pledgeId = ethers.encodeBytes32String("pledge1");
      const fee = 100;

      await expect(
        adapterManager.connect(admin).setPaymentGatewayFee(
          await mockTreasury.getAddress(),
          pledgeId,
          fee
        )
      ).to.emit(mockTreasury, "PaymentGatewayFeeSet")
        .withArgs(pledgeId, fee, admin.address);
    });

    it("Should revert if non-admin calls", async function () {
      const pledgeId = ethers.encodeBytes32String("pledge1");
      await expect(
        adapterManager.connect(user).setPaymentGatewayFee(
          await mockTreasury.getAddress(),
          pledgeId,
          100
        )
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });
  });

  describe("approveWithdrawal", function () {
    it("Should call approveWithdrawal on treasury", async function () {
      await expect(
        adapterManager.connect(admin).approveWithdrawal(await mockTreasury.getAddress())
      ).to.emit(mockTreasury, "WithdrawalApproved")
        .withArgs(admin.address);
    });
  });

  describe("withdraw", function () {
    it("Should call withdraw on treasury", async function () {
      const amount = ethers.parseEther("1");

      await expect(
        adapterManager.connect(admin).withdraw(await mockTreasury.getAddress(), amount)
      ).to.emit(mockTreasury, "Withdrawn")
        .withArgs(amount, admin.address);
    });
  });

  describe("claimTip", function () {
    it("Should call claimTip on treasury", async function () {
      await expect(
        adapterManager.connect(admin).claimTip(await mockTreasury.getAddress())
      ).to.emit(mockTreasury, "TipClaimed")
        .withArgs(admin.address);
    });
  });

  describe("claimFund", function () {
    it("Should call claimFund on treasury", async function () {
      await expect(
        adapterManager.connect(admin).claimFund(await mockTreasury.getAddress())
      ).to.emit(mockTreasury, "FundClaimed")
        .withArgs(admin.address);
    });
  });

  describe("kwrCancelTreasury", function () {
    it("Should call cancelTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("cancelled");

      await expect(
        adapterManager.connect(admin).kwrCancelTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);
    });
  });

  describe("kwrPauseTreasury", function () {
    it("Should call pauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("paused");

      await expect(
        adapterManager.connect(admin).kwrPauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryPaused")
        .withArgs(message, admin.address);
    });
  });

  describe("kwrUnpauseTreasury", function () {
    it("Should call unpauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("unpaused");

      await expect(
        adapterManager.connect(admin).kwrUnpauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryUnpaused")
        .withArgs(message, admin.address);
    });
  });
});

