// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {IAllOrNothing} from "./interfaces/IAllOrNothing.sol";

contract AllOrNothingAdapter is BaseAdminAdapter {
    constructor(address _admin) BaseAdminAdapter(_admin) {}

    function cancelTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IAllOrNothing(treasury).cancelTreasury(message);
    }

    function pauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IAllOrNothing(treasury).pauseTreasury(message);
    }

    function unpauseTreasury(
        address treasury,
        bytes32 message
    ) external onlyAdmin {
        if (treasury == address(0)) revert ZeroAddress();
        IAllOrNothing(treasury).unpauseTreasury(message);
    }
}
