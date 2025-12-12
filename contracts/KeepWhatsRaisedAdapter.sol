// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IKeepWhatsRaised, IKeepWhatsRaisedWithdrawNoParams, IKeepWhatsRaisedWithdrawParams} from "./interfaces/IKeepWhatsRaised.sol";

abstract contract KeepWhatsRaisedAdapter is BaseAdminAdapter {
    function setPaymentGatewayFee(
        address treasury,
        bytes32 pledgeId,
        uint256 fee
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.setPaymentGatewayFee,
            (pledgeId, fee)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function approveWithdrawal(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.approveWithdrawal,
            ()
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function configureTreasury(
        address treasury,
        IKeepWhatsRaised.Config calldata config,
        IKeepWhatsRaised.CampaignData calldata campaignData,
        IKeepWhatsRaised.FeeKeys calldata feeKeys,
        IKeepWhatsRaised.FeeValues calldata feeValues
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.configureTreasury,
            (config, campaignData, feeKeys, feeValues)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function updateDeadline(
        address treasury,
        uint256 deadline
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.updateDeadline,
            (deadline)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function updateGoalAmount(
        address treasury,
        uint256 goalAmount
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.updateGoalAmount,
            (goalAmount)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function setFeeAndPledge(
        address treasury,
        bytes32 pledgeId,
        address backer,
        address pledgeToken,
        uint256 pledgeAmount,
        uint256 tip,
        uint256 fee,
        bytes32[] calldata reward,
        bool isPledgeForAReward
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.setFeeAndPledge,
            (
                pledgeId,
                backer,
                pledgeToken,
                pledgeAmount,
                tip,
                fee,
                reward,
                isPledgeForAReward
            )
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function withdraw(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaisedWithdrawNoParams.withdraw,
            ()
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function withdraw(
        address treasury,
        address token,
        uint256 amount
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaisedWithdrawParams.withdraw,
            (token, amount)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimTip(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(IKeepWhatsRaised.claimTip, ());
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimFund(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(IKeepWhatsRaised.claimFund, ());
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function kwrCancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.cancelTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function kwrPauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.pauseTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function kwrUnpauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IKeepWhatsRaised.unpauseTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }
}
