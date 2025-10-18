// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {BaseAdminAdapter} from "./base/BaseAdminAdapter.sol";
import {KeepWhatsRaisedAdapter} from "./KeepWhatsRaisedAdapter.sol";
import {AllOrNothingAdapter} from "./AllOrNothingAdapter.sol";
import {PaymentTreasuryAdapter} from "./PaymentTreasuryAdapter.sol";

/**
 * @title AdapterManager
 * @notice Unified manager combining all treasury adapter functionalities
 * @dev Inherits from all three adapter contracts
 *
 * This contract combines:
 * - KeepWhatsRaisedAdapter
 * - AllOrNothingAdapter
 * - PaymentTreasuryAdapter
 */
contract AdapterManager is
    KeepWhatsRaisedAdapter,
    AllOrNothingAdapter,
    PaymentTreasuryAdapter
{
    /**
     * @notice Deploy the AdapterManager
     * @param _admin The admin address (typically a Safe multisig)
     */
    constructor(address _admin) BaseAdminAdapter(_admin) {
        if (_admin == address(0)) revert ZeroAddress();
    }
}
