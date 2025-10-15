// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IPaymentTreasury} from "./interfaces/IPaymentTreasury.sol";

contract PaymentTreasuryAdapter is BaseAdminAdapter {
    constructor(address _admin) BaseAdminAdapter(_admin) {}

    function createPayment(
        address treasury,
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32 itemId,
        uint256 amount,
        uint256 expiration
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).createPayment(
            paymentId,
            buyerId,
            itemId,
            amount,
            expiration
        );
    }

    function cancelPayment(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).cancelPayment(paymentId);
    }

    function confirmPayment(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).confirmPayment(paymentId);
    }

    function confirmPaymentBatch(
        address treasury,
        bytes32[] calldata paymentIds
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).confirmPaymentBatch(paymentIds);
    }

    function claimRefund(
        address treasury,
        bytes32 paymentId,
        address refundAddress
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).claimRefund(
            paymentId,
            refundAddress
        );
    }
function claimRefund(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).claimRefund(paymentId);
    }

    function cancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).cancelTreasury(message);
    }

    function pauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).pauseTreasury(message);
    }

    function unpauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IPaymentTreasury(treasury).unpauseTreasury(message);
    }
}
