// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPaymentTreasury {
    function createPayment(
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32 itemId,
        uint256 amount,
        uint256 expiration
    ) external;

    function cancelPayment(bytes32 paymentId) external;

    function confirmPayment(bytes32 paymentId) external;

    function confirmPaymentBatch(bytes32[] calldata paymentIds) external;

    function claimRefund(bytes32 paymentId, address refundAddress) external;

    function claimRefund(bytes32 paymentId) external;

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
