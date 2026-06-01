// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ICampaignPaymentTreasury} from "../interfaces/ICampaignPaymentTreasury.sol";

/**
 * @title MockTreasury
 * @notice Mock contract for testing adapter functions with meta-transaction support
 * @dev Extracts original sender from last 20 bytes of calldata (EIP-2771 pattern)
 */
contract MockKeepWhatsRaisedTreasury {
    event PaymentGatewayFeeSet(
        bytes32 indexed pledgeId,
        uint256 fee,
        address indexed sender
    );
    event WithdrawalApproved(address indexed sender);
    event TreasuryConfigured(address indexed sender);
    event DeadlineUpdated(uint256 deadline, address indexed sender);
    event GoalAmountUpdated(uint256 goalAmount, address indexed sender);
    event FeeAndPledgeSet(
        bytes32 indexed pledgeId,
        address indexed backer,
        address indexed sender
    );
    event Withdrawn(uint256 amount, address indexed sender);
    event TipClaimed(address indexed sender);
    event FundClaimed(address indexed sender);
    event TreasuryCancelled(bytes32 message, address indexed sender);
    event TreasuryPaused(bytes32 message, address indexed sender);
    event TreasuryUnpaused(bytes32 message, address indexed sender);
    event PledgeVoided(uint256 indexed tokenId, address indexed sender);

    /**
     * @dev Extract the original sender from calldata (last 20 bytes)
     * This implements the EIP-2771 meta-transaction pattern
     */
    function _msgSender() internal view returns (address sender) {
        if (msg.data.length >= 20) {
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            sender = msg.sender;
        }
    }

    function setPaymentGatewayFee(bytes32 pledgeId, uint256 fee) external {
        emit PaymentGatewayFeeSet(pledgeId, fee, _msgSender());
    }

    function approveWithdrawal() external {
        emit WithdrawalApproved(_msgSender());
    }

    function configureTreasury(
        Config calldata,
        CampaignData calldata,
        FeeKeys calldata,
        FeeValues calldata
    ) external {
        emit TreasuryConfigured(_msgSender());
    }

    function updateDeadline(uint256 deadline) external {
        emit DeadlineUpdated(deadline, _msgSender());
    }

    function updateGoalAmount(uint256 goalAmount) external {
        emit GoalAmountUpdated(goalAmount, _msgSender());
    }

    function setFeeAndPledge(
        bytes32 pledgeId,
        address backer,
        address,
        uint256,
        uint256,
        uint256,
        bytes32[] calldata,
        bool
    ) external {
        emit FeeAndPledgeSet(pledgeId, backer, _msgSender());
    }

    function withdraw() external {
        emit Withdrawn(0, _msgSender());
    }

    function withdraw(address, uint256 amount) external {
        emit Withdrawn(amount, _msgSender());
    }

    function claimTip() external {
        emit TipClaimed(_msgSender());
    }

    function claimFund() external {
        emit FundClaimed(_msgSender());
    }

    function cancelTreasury(bytes32 message) external {
        emit TreasuryCancelled(message, _msgSender());
    }

    function pauseTreasury(bytes32 message) external {
        emit TreasuryPaused(message, _msgSender());
    }

    function unpauseTreasury(bytes32 message) external {
        emit TreasuryUnpaused(message, _msgSender());
    }

    function voidPledge(uint256 tokenId) external {
        emit PledgeVoided(tokenId, _msgSender());
    }

    // Structs matching IKeepWhatsRaised
    struct Config {
        uint256 minimumWithdrawalForFeeExemption;
        uint256 withdrawalDelay;
        uint256 refundDelay;
        uint256 configLockPeriod;
        bool isColombianCreator;
        bool forwardTipsImmediately;
    }

    struct CampaignData {
        uint256 launchTime;
        uint256 deadline;
        uint256 goalAmount;
        bytes32 currency;
    }

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
}

contract MockAllOrNothingTreasury {
    event TreasuryCancelled(bytes32 message, address indexed sender);
    event TreasuryPaused(bytes32 message, address indexed sender);
    event TreasuryUnpaused(bytes32 message, address indexed sender);

    function _msgSender() internal view returns (address sender) {
        if (msg.data.length >= 20) {
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            sender = msg.sender;
        }
    }

    function cancelTreasury(bytes32 message) external {
        emit TreasuryCancelled(message, _msgSender());
    }

    function pauseTreasury(bytes32 message) external {
        emit TreasuryPaused(message, _msgSender());
    }

    function unpauseTreasury(bytes32 message) external {
        emit TreasuryUnpaused(message, _msgSender());
    }
}

contract MockPaymentTreasury {
    event PaymentCreated(
        bytes32 indexed paymentId,
        bytes32 indexed buyerId,
        address indexed sender
    );
    event PaymentCancelled(bytes32 indexed paymentId, address indexed sender);
    event PaymentConfirmed(bytes32 indexed paymentId, address indexed sender);
    event PaymentBatchConfirmed(uint256 count, address indexed sender);
    event RefundClaimed(
        bytes32 indexed paymentId,
        address indexed refundAddress,
        address indexed sender
    );
    event TreasuryCancelled(bytes32 message, address indexed sender);
    event TreasuryPaused(bytes32 message, address indexed sender);
    event TreasuryUnpaused(bytes32 message, address indexed sender);

    function _msgSender() internal view returns (address sender) {
        if (msg.data.length >= 20) {
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            sender = msg.sender;
        }
    }

    function createPayment(
        bytes32 paymentId,
        bytes32 buyerId,
        bytes32,
        address,
        uint256,
        uint256,
        ICampaignPaymentTreasury.LineItem[] calldata,
        ICampaignPaymentTreasury.ExternalFees[] calldata
    ) external {
        emit PaymentCreated(paymentId, buyerId, _msgSender());
    }

    function cancelPayment(bytes32 paymentId) external {
        emit PaymentCancelled(paymentId, _msgSender());
    }

    function confirmPayment(bytes32 paymentId, address) external {
        emit PaymentConfirmed(paymentId, _msgSender());
    }

    function confirmPaymentBatch(
        bytes32[] calldata paymentIds,
        address[] calldata
    ) external {
        emit PaymentBatchConfirmed(paymentIds.length, _msgSender());
    }

    function claimRefund(bytes32 paymentId, address refundAddress) external {
        emit RefundClaimed(paymentId, refundAddress, _msgSender());
    }

    function claimRefund(bytes32 paymentId) external {
        emit RefundClaimed(paymentId, msg.sender, _msgSender());
    }

    function cancelTreasury(bytes32 message) external {
        emit TreasuryCancelled(message, _msgSender());
    }

    function pauseTreasury(bytes32 message) external {
        emit TreasuryPaused(message, _msgSender());
    }

    function unpauseTreasury(bytes32 message) external {
        emit TreasuryUnpaused(message, _msgSender());
    }
}
