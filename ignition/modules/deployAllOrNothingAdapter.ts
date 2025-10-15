import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const { vars } = require("hardhat/config");

const allOrNothingAdapterModule = buildModule(
  "AllOrNothingAdapterModule",
  (m) => {
    const SAFE_ADMIN_ADDRESS = vars.get("SAFE_ADMIN");
    const allOrNothingAdapter = m.contract("AllOrNothingAdapter", [
      SAFE_ADMIN_ADDRESS,
    ]);

    return { allOrNothingAdapter };
  }
);

export default allOrNothingAdapterModule;


