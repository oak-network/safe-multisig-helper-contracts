// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IKeepWhatsRaised} from "./interfaces/IKeepWhatsRaised.sol";

contract KeepWhatsRaisedAdapter is BaseAdminAdapter {
    constructor(address _admin) BaseAdminAdapter(_admin) {}

    function setPaymentGatewayFee(
        address treasury,
        bytes32 pledgeId,
        uint256 fee
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).setPaymentGatewayFee(
            pledgeId,
            fee
        );
    }

    function approveWithdrawal(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).approveWithdrawal();
    }

    function configureTreasury(
        address treasury,
        IKeepWhatsRaised.Config calldata config,
        IKeepWhatsRaised.CampaignData calldata campaignData,
        IKeepWhatsRaised.FeeKeys calldata feeKeys,
        IKeepWhatsRaised.FeeValues calldata feeValues
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).configureTreasury(
            config,
            campaignData,
            feeKeys,
            feeValues
        );
    }

    function updateDeadline(
        address treasury,
        uint256 deadline
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).updateDeadline(deadline);
    }

    function updateGoalAmount(
        address treasury,
        uint256 goalAmount
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).updateGoalAmount(goalAmount);
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
        IKeepWhatsRaised(treasury).setFeeAndPledge(
            pledgeId,
            backer,
            pledgeAmount,
            tip,
            fee,
            reward,
            isPledgeForAReward
        );
    }

    function withdraw(address treasury, uint256 amount) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).withdraw(amount);
    }

    function claimTip(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).claimTip();
    }

    function claimFund(address treasury) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).claimFund();
    }

    function cancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).cancelTreasury(message);
    }

    function pauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).pauseTreasury(message);
    }

    function unpauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IKeepWhatsRaised(treasury).unpauseTreasury(message);
    }
}
