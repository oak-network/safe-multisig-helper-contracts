import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const { vars } = require("hardhat/config");

const safeMultisigAdapterModule = buildModule("LockModule", (m) => {
    const SAFE_ADMIN_ADDRESS = vars.get("SAFE_ADMIN")
    const safeMultisigAdapter = m.contract("SafeMultisigAdapter", [SAFE_ADMIN_ADDRESS]);

    return { safeMultisigAdapter };
});

export default safeMultisigAdapterModule;