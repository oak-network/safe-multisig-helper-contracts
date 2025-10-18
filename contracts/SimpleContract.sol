// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

/**
 * @title Simple Target Contract
 * @notice Contract that extracts the real sender using EIP-2771
 */
contract SimpleTarget is ERC2771Context {
    address public lastCaller;
    string public lastMessage;

    event MessageReceived(address indexed realSender, string message);

    constructor(address _forwarder) ERC2771Context(_forwarder) {
        // ERC2771Context handles trustedForwarder internally
    }

    /**
     * @notice Simple function to test EIP-2771
     * @dev Uses OpenZeppelin's _msgSender() from ERC2771Context
     */
    function setMessage(string memory message) external {
        address realSender = _msgSender();

        lastCaller = realSender;
        lastMessage = message;

        emit MessageReceived(realSender, message);
    }
}

/**
 * ============================================================================
 * HOW TO TEST
 * ============================================================================
 *
 * 1. Deploy SimpleForwarder:
 *    forwarder = new SimpleForwarder();
 *
 * 2. Deploy SimpleTarget with forwarder address:
 *    target = new SimpleTarget(address(forwarder));
 *
 * 3. Call directly (without forwarder):
 *    target.setMessage("Hello");
 *    // target.lastCaller will be YOUR address
 *
 * 4. Call through forwarder:
 *    bytes memory data = abi.encodeWithSignature("setMessage(string)", "Hello from forwarder");
 *    forwarder.forward(address(target), data);
 *    // target.lastCaller will STILL be YOUR address (preserved!)
 *
 * 5. Verify:
 *    address caller = target.lastCaller();
 *    // caller == YOUR_ADDRESS (not forwarder address!)
 *
 * ============================================================================
 * SIMPLE JAVASCRIPT TEST (Hardhat/Foundry)
 * ============================================================================
 *
 * // Deploy
 * const forwarder = await SimpleForwarder.deploy();
 * const target = await SimpleTarget.deploy(forwarder.address);
 *
 * // Test direct call
 * await target.setMessage("Direct call");
 * console.log(await target.lastCaller()); // Your address
 *
 * // Test forwarded call
 * const data = target.interface.encodeFunctionData("setMessage", ["Forwarded call"]);
 * await forwarder.forward(target.address, data);
 * console.log(await target.lastCaller()); // Still your address!
 *
 * // Verify msg.sender is preserved
 * const [signer] = await ethers.getSigners();
 * assert(await target.lastCaller() === signer.address);
 */
