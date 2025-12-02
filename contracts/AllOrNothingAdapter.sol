// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IAllOrNothing} from "./interfaces/IAllOrNothing.sol";

abstract contract AllOrNothingAdapter is BaseAdminAdapter {
    function aonCancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();

        bytes memory data = abi.encodeCall(
            IAllOrNothing.cancelTreasury,
            (message)
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

        bytes memory data = abi.encodeCall(
            IAllOrNothing.pauseTreasury,
            (message)
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

        bytes memory data = abi.encodeCall(
            IAllOrNothing.unpauseTreasury,
            (message)
        );
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        (bool success, ) = treasury.call(dataWithSender);
        if (!success) revert CallFailed();
    }
}
