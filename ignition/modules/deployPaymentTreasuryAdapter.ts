import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const { vars } = require("hardhat/config");

const paymentTreasuryAdapterModule = buildModule(
  "PaymentTreasuryAdapterModule",
  (m) => {
    const SAFE_ADMIN_ADDRESS = vars.get("SAFE_ADMIN");
    const paymentTreasuryAdapter = m.contract("PaymentTreasuryAdapter", [
      SAFE_ADMIN_ADDRESS,
    ]);

    return { paymentTreasuryAdapter };
  }
);

export default paymentTreasuryAdapterModule;


