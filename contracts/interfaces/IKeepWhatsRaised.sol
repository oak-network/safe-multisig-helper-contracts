// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IKeepWhatsRaised {
    struct FeeKeys {
        bytes32 flatFeeKey;
        bytes32 cumulativeFlatFeeKey;
        bytes32[] grossPercentageFeeKeys;
    }
    struct FeeValues {
        uint256 flatFeeValue;
        uint256 cumulativeFlatFeeValue;
        uint256[] grossPercentageFeeValues;
    }
    struct Config {
        uint256 minimumWithdrawalForFeeExemption;
        uint256 withdrawalDelay;
        uint256 refundDelay;
        uint256 configLockPeriod;
        bool isColombianCreator;
    }
    struct CampaignData {
        uint256 launchTime;
        uint256 deadline;
        uint256 goalAmount;
    }

    function setPaymentGatewayFee(bytes32 pledgeId, uint256 fee) external;

    function approveWithdrawal() external;

    function configureTreasury(
        Config memory config,
        CampaignData memory campaignData,
        FeeKeys memory feeKeys,
        FeeValues memory feeValues
    ) external;

    function updateDeadline(uint256 deadline) external;

    function updateGoalAmount(uint256 goalAmount) external;

    function setFeeAndPledge(
        bytes32 pledgeId,
        address backer,
        uint256 pledgeAmount,
        uint256 tip,
        uint256 fee,
        bytes32[] calldata reward,
        bool isPledgeForAReward
    ) external;

    function withdraw(uint256 amount) external;

    function claimTip() external;

    function claimFund() external;

    function cancelTreasury(bytes32 message) external;

    function pauseTreasury(bytes32 message) external;

    function unpauseTreasury(bytes32 message) external;
}
