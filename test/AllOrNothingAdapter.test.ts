import { expect } from "chai";
import { ethers } from "hardhat";
import { AdapterManager } from "../typechain-types";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("AllOrNothingAdapter Functions", function () {
  let adapterManager: AdapterManager;
  let admin: SignerWithAddress;
  let user: SignerWithAddress;
  let mockTreasury: any;

  beforeEach(async function () {
    [admin, user] = await ethers.getSigners();

    // Deploy mock treasury
    const MockTreasury = await ethers.getContractFactory("MockAllOrNothingTreasury");
    mockTreasury = await MockTreasury.deploy();
    await mockTreasury.waitForDeployment();

    // Deploy AdapterManager
    const AdapterManager = await ethers.getContractFactory("AdapterManager");
    adapterManager = await AdapterManager.deploy(admin.address);
    await adapterManager.waitForDeployment();
  });

  describe("aonCancelTreasury", function () {
    it("Should call cancelTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("cancelled");

      await expect(
        adapterManager.connect(admin).aonCancelTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryCancelled")
        .withArgs(message, admin.address);
    });

    it("Should revert if non-admin calls", async function () {
      const message = ethers.encodeBytes32String("cancelled");

      await expect(
        adapterManager.connect(user).aonCancelTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });

    it("Should revert if treasury is zero address", async function () {
      const message = ethers.encodeBytes32String("cancelled");

      await expect(
        adapterManager.connect(admin).aonCancelTreasury(ethers.ZeroAddress, message)
      ).to.be.revertedWithCustomError(adapterManager, "ZeroAddress");
    });
  });

  describe("aonPauseTreasury", function () {
    it("Should call pauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("paused");

      await expect(
        adapterManager.connect(admin).aonPauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryPaused")
        .withArgs(message, admin.address);
    });

    it("Should revert if non-admin calls", async function () {
      const message = ethers.encodeBytes32String("paused");

      await expect(
        adapterManager.connect(user).aonPauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });
  });

  describe("aonUnpauseTreasury", function () {
    it("Should call unpauseTreasury on treasury", async function () {
      const message = ethers.encodeBytes32String("unpaused");

      await expect(
        adapterManager.connect(admin).aonUnpauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.emit(mockTreasury, "TreasuryUnpaused")
        .withArgs(message, admin.address);
    });

    it("Should revert if non-admin calls", async function () {
      const message = ethers.encodeBytes32String("unpaused");

      await expect(
        adapterManager.connect(user).aonUnpauseTreasury(
          await mockTreasury.getAddress(),
          message
        )
      ).to.be.revertedWithCustomError(adapterManager, "NotAdmin");
    });
  });
});

