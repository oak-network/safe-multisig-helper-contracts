import { expect } from "chai";
import { ethers } from "hardhat";
import { AdapterManager } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("Meta-Transaction Pattern", function () {
  let adapterManager: AdapterManager;
  let admin: SignerWithAddress;
  let user: SignerWithAddress;
  let mockKeepWhatsRaisedTreasury: any;
  let mockAllOrNothingTreasury: any;
  let mockPaymentTreasury: any;

  beforeEach(async function () {
    [admin, user] = await ethers.getSigners();

    // Deploy mock treasuries
    const MockKWR = await ethers.getContractFactory("MockKeepWhatsRaisedTreasury");
    mockKeepWhatsRaisedTreasury = await MockKWR.deploy();
    await mockKeepWhatsRaisedTreasury.waitForDeployment();

    const MockAON = await ethers.getContractFactory("MockAllOrNothingTreasury");
    mockAllOrNothingTreasury = await MockAON.deploy();
    await mockAllOrNothingTreasury.waitForDeployment();

    const MockPT = await ethers.getContractFactory("MockPaymentTreasury");
    mockPaymentTreasury = await MockPT.deploy();
    await mockPaymentTreasury.waitForDeployment();

    // Deploy AdapterManager
    const AdapterManager = await ethers.getContractFactory("AdapterManager");
    adapterManager = await AdapterManager.deploy(admin.address);
    await adapterManager.waitForDeployment();
  });

  describe("Sender Extraction", function () {
    it("Should extract admin address from KeepWhatsRaised adapter calls", async function () {
      const pledgeId = ethers.encodeBytes32String("pledge1");
      const fee = 100;

      await expect(
        adapterManager.connect(admin).setPaymentGatewayFee(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          pledgeId,
          fee
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "PaymentGatewayFeeSet")
        .withArgs(pledgeId, fee, admin.address);
    });

    it("Should extract admin address from AllOrNothing adapter calls", async function () {
      const message = ethers.encodeBytes32String("paused");

      await expect(
        adapterManager.connect(admin).aonPauseTreasury(
          await mockAllOrNothingTreasury.getAddress(),
          message
        )
      )
        .to.emit(mockAllOrNothingTreasury, "TreasuryPaused")
        .withArgs(message, admin.address);
    });

    it("Should extract admin address from PaymentTreasury adapter calls", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");
      const buyerId = ethers.encodeBytes32String("buyer1");
      const itemId = ethers.encodeBytes32String("item1");
      const paymentToken = admin.address;
      const amount = ethers.parseEther("1");
      const expiration = Math.floor(Date.now() / 1000) + 3600;
      const lineItems = [
        {
          typeId: ethers.encodeBytes32String("line1"),
          amount: ethers.parseEther("0.5"),
        },
      ];
      const externalFees = [
        {
          feeType: ethers.encodeBytes32String("fee1"),
          feeAmount: ethers.parseEther("0.1"),
        },
      ];

      await expect(
        adapterManager.connect(admin).createPayment(
          await mockPaymentTreasury.getAddress(),
          paymentId,
          buyerId,
          itemId,
          paymentToken,
          amount,
          expiration,
          lineItems,
          externalFees
        )
      )
        .to.emit(mockPaymentTreasury, "PaymentCreated")
        .withArgs(paymentId, buyerId, admin.address);
    });

    it("Should extract admin address from executeCall", async function () {
      const message = ethers.encodeBytes32String("cancelled");
      
      // Encode the function call
      const data = mockKeepWhatsRaisedTreasury.interface.encodeFunctionData(
        "cancelTreasury",
        [message]
      );

      await expect(
        adapterManager.connect(admin).executeCall(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          data
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);
    });
  });

  describe("Multiple Operations", function () {
    it("Should preserve sender across multiple calls", async function () {
      const message1 = ethers.encodeBytes32String("pause");
      const message2 = ethers.encodeBytes32String("unpause");

      // First call
      await expect(
        adapterManager.connect(admin).kwrPauseTreasury(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          message1
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "TreasuryPaused")
        .withArgs(message1, admin.address);

      // Second call
      await expect(
        adapterManager.connect(admin).kwrUnpauseTreasury(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          message2
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "TreasuryUnpaused")
        .withArgs(message2, admin.address);
    });

    it("Should work with batch operations", async function () {
      const paymentIds = [
        ethers.encodeBytes32String("payment1"),
        ethers.encodeBytes32String("payment2"),
        ethers.encodeBytes32String("payment3"),
      ];
      const buyerAddresses = [admin.address, user.address, admin.address];

      await expect(
        adapterManager.connect(admin).confirmPaymentBatch(
          await mockPaymentTreasury.getAddress(),
          paymentIds,
          buyerAddresses
        )
      )
        .to.emit(mockPaymentTreasury, "PaymentBatchConfirmed")
        .withArgs(paymentIds.length, admin.address);
    });
  });

  describe("Complex Data Types", function () {
    it("Should handle struct parameters correctly", async function () {
      const pledgeId = ethers.encodeBytes32String("pledge1");
      const backer = user.address;
      const pledgeToken = admin.address;
      const pledgeAmount = ethers.parseEther("1");
      const tip = ethers.parseEther("0.1");
      const fee = ethers.parseEther("0.05");
      const reward = [ethers.encodeBytes32String("reward1")];
      const isPledgeForAReward = true;

      await expect(
        adapterManager.connect(admin).setFeeAndPledge(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          pledgeId,
          backer,
          pledgeToken,
          pledgeAmount,
          tip,
          fee,
          reward,
          isPledgeForAReward
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "FeeAndPledgeSet")
        .withArgs(pledgeId, backer, admin.address);
    });

    it("Should handle overloaded functions correctly", async function () {
      const paymentId = ethers.encodeBytes32String("payment1");
      const refundAddress = user.address;

      // With refundAddress parameter
      await expect(
        adapterManager.connect(admin)["claimRefund(address,bytes32,address)"](
          await mockPaymentTreasury.getAddress(),
          paymentId,
          refundAddress
        )
      )
        .to.emit(mockPaymentTreasury, "RefundClaimed")
        .withArgs(paymentId, refundAddress, admin.address);

      // Without refundAddress parameter
      await expect(
        adapterManager.connect(admin)["claimRefund(address,bytes32)"](
          await mockPaymentTreasury.getAddress(),
          paymentId
        )
      )
        .to.emit(mockPaymentTreasury, "RefundClaimed");
    });
  });

  describe("Sender Verification", function () {
    it("Should correctly identify different admins", async function () {
      // Deploy a new AdapterManager with user as admin
      const AdapterManager = await ethers.getContractFactory("AdapterManager");
      const userAdapterManager = await AdapterManager.deploy(user.address);
      await userAdapterManager.waitForDeployment();

      const message = ethers.encodeBytes32String("test");

      // Call from admin's AdapterManager
      await expect(
        adapterManager.connect(admin).aonCancelTreasury(
          await mockAllOrNothingTreasury.getAddress(),
          message
        )
      )
        .to.emit(mockAllOrNothingTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);

      // Call from user's AdapterManager
      await expect(
        userAdapterManager.connect(user).aonCancelTreasury(
          await mockAllOrNothingTreasury.getAddress(),
          message
        )
      )
        .to.emit(mockAllOrNothingTreasury, "TreasuryCancelled")
        .withArgs(message, user.address);
    });
  });

  describe("Edge Cases", function () {
    it("Should handle minimal calldata in executeCall", async function () {
      const message = ethers.encodeBytes32String("test");
      const data = mockKeepWhatsRaisedTreasury.interface.encodeFunctionData(
        "cancelTreasury",
        [message]
      );
      
      // executeCall should work with any valid calldata
      await expect(
        adapterManager.connect(admin).executeCall(
          await mockKeepWhatsRaisedTreasury.getAddress(),
          data
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);
    });

    it("Should handle all adapter functions consistently", async function () {
      const treasuryAddr = await mockKeepWhatsRaisedTreasury.getAddress();
      
      // Test various function types
      await expect(
        adapterManager.connect(admin).approveWithdrawal(treasuryAddr)
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "WithdrawalApproved")
        .withArgs(admin.address);

      await expect(
        adapterManager.connect(admin).claimTip(treasuryAddr)
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "TipClaimed")
        .withArgs(admin.address);

      await expect(
        adapterManager.connect(admin).claimFund(treasuryAddr)
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "FundClaimed")
        .withArgs(admin.address);

      await expect(
        adapterManager.connect(admin)["kwrWithdraw(address,address,uint256)"](
          treasuryAddr,
          admin.address,
          1000
        )
      )
        .to.emit(mockKeepWhatsRaisedTreasury, "Withdrawn")
        .withArgs(1000, admin.address);
    });
  });
});

