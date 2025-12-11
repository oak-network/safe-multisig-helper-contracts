// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IPaymentTreasury, IPaymentTreasuryClaimRefundWithAddress, IPaymentTreasuryClaimRefundSingle} from "./interfaces/IPaymentTreasury.sol";

abstract contract PaymentTreasuryAdapter is BaseAdminAdapter {
    function createPayment(
        address treasury,
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32 itemId,
        uint256 amount,
        uint256 expiration
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.createPayment,
            (paymentId, buyerId, itemId, amount, expiration)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function cancelPayment(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.cancelPayment,
            (paymentId)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function confirmPayment(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.confirmPayment,
            (paymentId)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function confirmPaymentBatch(
        address treasury,
        bytes32[] calldata paymentIds
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.confirmPaymentBatch,
            (paymentIds)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimRefund(
        address treasury,
        bytes32 paymentId,
        address refundAddress
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasuryClaimRefundWithAddress.claimRefund,
            (paymentId, refundAddress)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimRefund(
        address treasury,
        bytes32 paymentId
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasuryClaimRefundSingle.claimRefund,
            (paymentId)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function ptCancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.cancelTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function ptPauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.pauseTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function ptUnpauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.unpauseTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }
}
