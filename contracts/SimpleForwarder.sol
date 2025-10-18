// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Simple EIP-2771 Forwarder
 * @notice Forwards calls while appending the original sender
 */
contract SimpleForwarder {
    /**
     * @notice Forward a call with EIP-2771 (append msg.sender)
     */
    function forward(address target, bytes memory data) external {
        // Append msg.sender to the end of calldata
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        // Make the call
        (bool success, ) = target.call(dataWithSender);
        require(success, "Call failed");
    }

    /**
     * @notice Convenience function to call setMessage on a target contract
     */
    function forwardSetMessage(address target, string memory message) external {
        // Encode the setMessage function call
        bytes memory data = abi.encodeWithSignature(
            "setMessage(string)",
            message
        );

        // Append msg.sender to the end of calldata
        bytes memory dataWithSender = abi.encodePacked(data, msg.sender);

        // Make the call
        (bool success, ) = target.call(dataWithSender);
        require(success, "Call failed");
    }
}
