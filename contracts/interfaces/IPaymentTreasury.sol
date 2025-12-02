// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ICampaignPaymentTreasury} from "./ICampaignPaymentTreasury.sol";

interface IPaymentTreasury {
    function createPayment(
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32 itemId,
        address paymentToken,
        uint256 amount,
        uint256 expiration,
        ICampaignPaymentTreasury.LineItem[] calldata lineItems,
        ICampaignPaymentTreasury.ExternalFees[] calldata externalFees
    ) external;

    function cancelPayment(bytes32 paymentId) external;

    function confirmPayment(
        bytes32 paymentId,
        address buyerAddress
    ) external;

    function confirmPaymentBatch(
        bytes32[] calldata paymentIds,
        address[] calldata buyerAddresses
    ) external;

    function cancelTreasury(bytes32 message) external;

    function pauseTreasury(bytes32 message) external;

    function unpauseTreasury(bytes32 message) external;
}

interface IPaymentTreasuryClaimRefundWithAddress {
    function claimRefund(bytes32 paymentId, address refundAddress) external;
}

interface IPaymentTreasuryClaimRefundSingle {
    function claimRefund(bytes32 paymentId) external;
}
