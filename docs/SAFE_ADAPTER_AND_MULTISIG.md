# Safe multisig, adapter admin, and related operations

This document maps **treasury and factory** APIs to how they are exercised when the platform uses a **Gnosis Safe** (or similar) together with **`AdapterManager`**.

## How gating works in this repo

| Mechanism | Location | Who may call |
|-----------|----------|----------------|
| **`onlyAdmin`** | [`BaseAdminAdapter`](../contracts/base/BaseAdminAdapter.sol), inherited by `AdapterManager` | The `admin` address (typically the Safe that owns the adapter) |
| **Named adapter functions** | [`KeepWhatsRaisedAdapter`](../contracts/KeepWhatsRaisedAdapter.sol) | Same: `onlyAdmin` on `AdapterManager` |
| **Arbitrary calldata** | `BaseAdminAdapter.executeCall(address target, bytes calldata data)` | Same: `onlyAdmin`; appends `msg.sender` for meta-tx patterns used by treasuries |
| **Factory functions** | `CampaignInfoFactory` / `TreasuryFactory` (oak protocol) | Their own modifiers (e.g. platform admin / owner), **not** `onlyAdmin` on `AdapterManager` unless you route the call via Safe tx or `executeCall` |

**Reads (view/pure)** on the treasury do **not** use the adapter’s `onlyAdmin`. Wallets and UIs should call them with normal `eth_call` against the treasury contract.

---

## 1. KeepWhatsRaised — functions wrapped by `KeepWhatsRaisedAdapter` / `AdapterManager`

These **state-changing** treasury calls are implemented as dedicated methods on the adapter. The multisig sends a transaction **to `AdapterManager`** (as `admin`) using the adapter function name and passing the **treasury address** as the first argument where shown.

| Target API (on `KeepWhatsRaised` treasury) | `AdapterManager` / adapter function name |
|-------------------------------------------|------------------------------------------|
| `configureTreasury(...)` | `configureTreasury` |
| `updateDeadline(uint256)` | `updateDeadline` |
| `updateGoalAmount(uint256)` | `updateGoalAmount` |
| `setFeeAndPledge(...)` | `setFeeAndPledge` |
| `setPaymentGatewayFee(bytes32,uint256)` | `setPaymentGatewayFee` |
| `approveWithdrawal()` | `approveWithdrawal` |
| `withdraw()` (no arguments) | `kwrWithdraw(address treasury)` |
| `withdraw(address token, uint256 amount)` | `kwrWithdraw(address treasury, address token, uint256 amount)` |
| `claimTip()` | `claimTip` |
| `claimFund()` | `claimFund` |
| `cancelTreasury(bytes32)` | `kwrCancelTreasury` |
| `pauseTreasury(bytes32)` | `kwrPauseTreasury` |
| `unpauseTreasury(bytes32)` | `kwrUnpauseTreasury` |

Functions such as `disburseFees` (if present on your deployed ABI) and any **`withdraw(uint256)`** overload that does **not** match `(address,uint256)` are **not** given a dedicated wrapper in `KeepWhatsRaisedAdapter`; use **`executeCall`** toward the treasury with correctly encoded calldata (and confirm the on-chain signature matches your deployment).

---

## 2. Factory operations (not dedicated adapter methods)

These live on **factory** contracts. They are **not** implemented as named functions on `KeepWhatsRaisedAdapter`. Typical patterns:

- The **Safe** calls the factory directly (if the Safe has the required factory role), or  
- The Safe calls **`AdapterManager.executeCall(factory, data)`** if the admin should be the only caller surface.

### `TreasuryFactory` — `deploy`

Reference: [`ITreasuryFactory`](../oak-contracts/src/interfaces/ITreasuryFactory.sol).

```solidity
function deploy(bytes32 platformHash, address infoAddress, uint256 implementationId)
    external
    returns (address clone);
```

### `CampaignInfoFactory` — `createCampaign`

Reference: [`ICampaignInfoFactory`](../oak-contracts/src/interfaces/ICampaignInfoFactory.sol).

```solidity
function createCampaign(
    address creator,
    bytes32 identifierHash,
    bytes32[] calldata selectedPlatformHash,
    bytes32[] calldata platformDataKey,
    bytes32[] calldata platformDataValue,
    CampaignData calldata campaignData,
    string calldata nftName,
    string calldata nftSymbol,
    string calldata nftImageURI,
    string calldata contractURI
) external;
```

---

## 3. KeepWhatsRaised treasury — **view / getter** functions (no adapter `onlyAdmin`)

Use these for indexing, dashboards, and RPC reads. Call the **treasury** contract directly; they do **not** go through `AdapterManager`’s admin gate.

| Function | Returns (summary) |
|----------|---------------------|
| `getWithdrawalApprovalStatus()` | Whether withdrawal is approved |
| `getReward(bytes32 rewardName)` | Reward struct |
| `getRaisedAmount()` | Total raised (normalized) |
| `getLifetimeRaisedAmount()` | Lifetime raised |
| `getRefundedAmount()` | Refunded total |
| `getAvailableRaisedAmount()` | Available raised balance |
| `getLaunchTime()` | Campaign launch timestamp |
| `getDeadline()` | Campaign deadline |
| `getGoalAmount()` | Funding goal |
| `getPaymentGatewayFee(bytes32 pledgeId)` | Gateway fee for a pledge |
| `getFeeValue(bytes32 feeKey)` | Stored fee value for a key |
| `cancelled()` | Whether treasury/campaign is cancelled (from base treasury / pausable stack) |

Additional views may exist on base classes (e.g. pause state, platform hash); refer to the deployed ABI and [`KeepWhatsRaised`](../oak-contracts/src/treasuries/KeepWhatsRaised.sol) in oak-contracts.

---

## Related code

- [`contracts/AdapterManager.sol`](../contracts/AdapterManager.sol) — combines `KeepWhatsRaisedAdapter`, `AllOrNothingAdapter`, `PaymentTreasuryAdapter`
- [`contracts/KeepWhatsRaisedAdapter.sol`](../contracts/KeepWhatsRaisedAdapter.sol)
- [`contracts/interfaces/IKeepWhatsRaised.sol`](../contracts/interfaces/IKeepWhatsRaised.sol)
