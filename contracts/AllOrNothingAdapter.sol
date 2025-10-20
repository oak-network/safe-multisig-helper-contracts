// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";

abstract contract AllOrNothingAdapter is BaseAdminAdapter {
    function aonCancelTreasury(
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

    function aonPauseTreasury(
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

    function aonUnpauseTreasury(
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
