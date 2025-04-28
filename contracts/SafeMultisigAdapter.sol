// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SafeTreasuryHelper
 * @dev Helper contract for Safe multisig to interact with multiple treasury contracts
 */
contract SafeMultisigAdapter {
    address public admin;

    event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
    event TokenApproved(
        address indexed token,
        address indexed spender,
        uint256 amount
    );
    event ContractCalled(address indexed contractAddress, bytes4 methodId);

    error NotAdmin();
    error ZeroAddress();
    error CallFailed();

    /**
     * @dev Modifier to check if caller is the admin
     */
    modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    /**
     * @dev Constructor sets the Safe multisig as the admin
     * @param _admin Address of the Safe multisig
     */
    constructor(address _admin) {
        if (_admin == address(0)) revert ZeroAddress();
        admin = _admin;
    }

    /**
     * @dev Change the admin address
     * @param _newAdmin New admin address
     */
    function changeAdmin(address _newAdmin) external onlyAdmin {
        if (_newAdmin == address(0)) revert ZeroAddress();
        address oldAdmin = admin;
        admin = _newAdmin;
        emit AdminChanged(oldAdmin, _newAdmin);
    }

    /**
     * @dev Calls disburseFees function on the specified treasury contract
     * @param treasuryAddress Address of the treasury contract implementing disburseFees()
     */
    function disburseFees(address treasuryAddress) external onlyAdmin {
        if (treasuryAddress == address(0)) revert ZeroAddress();

        (bool success, ) = treasuryAddress.call(
            abi.encodeWithSignature("disburseFees()")
        );
        if (!success) revert CallFailed();

        emit ContractCalled(
            treasuryAddress,
            bytes4(keccak256("disburseFees()"))
        );
    }

    /**
     * @dev Calls withdraw function on the specified treasury contract
     * @param treasuryAddress Address of the treasury contract implementing withdraw()
     */
    function withdraw(address treasuryAddress) external onlyAdmin {
        if (treasuryAddress == address(0)) revert ZeroAddress();

        (bool success, ) = treasuryAddress.call(
            abi.encodeWithSignature("withdraw()")
        );
        if (!success) revert CallFailed();

        emit ContractCalled(treasuryAddress, bytes4(keccak256("withdraw()")));
    }

    /**
     * @dev Calls pauseTreasury function on the specified contract
     * @param treasuryAddress Address of the treasury contract
     * @param message Message parameter required by the pauseTreasury function
     */
    function pauseTreasury(
        address treasuryAddress,
        bytes32 message
    ) external onlyAdmin {
        if (treasuryAddress == address(0)) revert ZeroAddress();

        (bool success, ) = treasuryAddress.call(
            abi.encodeWithSignature("pauseTreasury(bytes32)", message)
        );
        if (!success) revert CallFailed();

        emit ContractCalled(
            treasuryAddress,
            bytes4(keccak256("pauseTreasury(bytes32)"))
        );
    }

    /**
     * @dev Calls unpauseTreasury function on the specified contract
     * @param treasuryAddress Address of the treasury contract
     * @param message Message parameter required by the unpauseTreasury function
     */
    function unpauseTreasury(
        address treasuryAddress,
        bytes32 message
    ) external onlyAdmin {
        if (treasuryAddress == address(0)) revert ZeroAddress();

        (bool success, ) = treasuryAddress.call(
            abi.encodeWithSignature("unpauseTreasury(bytes32)", message)
        );
        if (!success) revert CallFailed();

        emit ContractCalled(
            treasuryAddress,
            bytes4(keccak256("unpauseTreasury(bytes32)"))
        );
    }

    /**
     * @dev Generic function to call any function on any contract
     * @param target Address of the contract to call
     * @param data Function call data
     * @return success Boolean indicating if the call was successful
     * @return returnData Data returned from the call
     */
    function executeCall(
        address target,
        bytes calldata data
    ) external onlyAdmin returns (bool success, bytes memory returnData) {
        if (target == address(0)) revert ZeroAddress();

        (success, returnData) = target.call(data);
        if (!success) revert CallFailed();

        return (success, returnData);
    }
}
