// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BaseAdminAdapter
 * @dev Minimal admin-gated base for multisig-controlled adapters
 */
abstract contract BaseAdminAdapter {
    address public admin;

    event AdminChanged(address indexed previousAdmin, address indexed newAdmin);

    error NotAdmin();
    error ZeroAddress();
    error CallFailed();

    modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    constructor(address _admin) {
        if (_admin == address(0)) revert ZeroAddress();
        admin = _admin;
    }

    function changeAdmin(address _newAdmin) external onlyAdmin {
        if (_newAdmin == address(0)) revert ZeroAddress();
        address oldAdmin = admin;
        admin = _newAdmin;
        emit AdminChanged(oldAdmin, _newAdmin);
    }

    function executeCall(
        address target,
        bytes calldata data
    ) external onlyAdmin returns (bool success, bytes memory returnData) {
        if (target == address(0)) revert ZeroAddress();
        (success, returnData) = target.call(data);
        if (!success) revert CallFailed();
    }
}
