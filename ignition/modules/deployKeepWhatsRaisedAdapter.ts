import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const { vars } = require("hardhat/config");

const keepWhatsRaisedAdapterModule = buildModule(
  "KeepWhatsRaisedAdapterModule",
  (m) => {
    const SAFE_ADMIN_ADDRESS = vars.get("SAFE_ADMIN");
    const keepWhatsRaisedAdapter = m.contract("KeepWhatsRaisedAdapter", [
      SAFE_ADMIN_ADDRESS,
    ]);

    return { keepWhatsRaisedAdapter };
  }
);

export default keepWhatsRaisedAdapterModule;


