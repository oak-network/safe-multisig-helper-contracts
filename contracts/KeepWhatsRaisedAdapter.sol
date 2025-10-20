// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IKeepWhatsRaised} from "./interfaces/IKeepWhatsRaised.sol";

abstract contract KeepWhatsRaisedAdapter is BaseAdminAdapter {
    function setPaymentGatewayFee(
        address treasury,
        bytes32 pledgeId,
        uint256 fee
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature(
            "setPaymentGatewayFee(bytes32,uint256)",
            pledgeId,
            fee
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function approveWithdrawal(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature("approveWithdrawal()");
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

        bytes memory data = abi.encodeWithSignature(
            "configureTreasury((address,uint256),(uint256,uint256),(bytes32[]),(uint256[]))",
            config,
            campaignData,
            feeKeys,
            feeValues
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

        bytes memory data = abi.encodeWithSignature(
            "updateDeadline(uint256)",
            deadline
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

        bytes memory data = abi.encodeWithSignature(
            "updateGoalAmount(uint256)",
            goalAmount
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function setFeeAndPledge(
        address treasury,
        bytes32 pledgeId,
        address backer,
        uint256 pledgeAmount,
        uint256 tip,
        uint256 fee,
        bytes32[] calldata reward,
        bool isPledgeForAReward
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature(
            "setFeeAndPledge(bytes32,address,uint256,uint256,uint256,bytes32[],bool)",
            pledgeId,
            backer,
            pledgeAmount,
            tip,
            fee,
            reward,
            isPledgeForAReward
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function withdraw(address treasury, uint256 amount) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature(
            "withdraw(uint256)",
            amount
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimTip(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature("claimTip()");
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function claimFund(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature("claimFund()");
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }

    function kwrCancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeWithSignature(
            "cancelTreasury(bytes32)",
            message
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

        bytes memory data = abi.encodeWithSignature(
            "pauseTreasury(bytes32)",
            message
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

        bytes memory data = abi.encodeWithSignature(
            "unpauseTreasury(bytes32)",
            message
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }
}
