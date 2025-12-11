// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {
    IPaymentTreasury,
    IPaymentTreasuryClaimRefundWithAddress,
    IPaymentTreasuryClaimRefundSingle
} from "./interfaces/IPaymentTreasury.sol";
import {ICampaignPaymentTreasury} from "./interfaces/ICampaignPaymentTreasury.sol";

abstract contract PaymentTreasuryAdapter is BaseAdminAdapter {
    function createPayment(
        address treasury,
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32 itemId,
        address paymentToken,
        uint256 amount,
        uint256 expiration,
        ICampaignPaymentTreasury.LineItem[] calldata lineItems,
        ICampaignPaymentTreasury.ExternalFees[] calldata externalFees
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.createPayment,
            (
                paymentId,
                buyerId,
                itemId,
                paymentToken,
                amount,
                expiration,
                lineItems,
                externalFees
            )
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
        bytes32 paymentId,
        address buyerAddress
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.confirmPayment,
            (paymentId, buyerAddress)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function confirmPaymentBatch(
        address treasury,
        bytes32[] calldata paymentIds,
        address[] calldata buyerAddresses
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IPaymentTreasury.confirmPaymentBatch,
            (paymentIds, buyerAddresses)
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
