// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAllOrNothing {
    function cancelTreasury(bytes32 message) external;

    function pauseTreasury(bytes32 message) external;

    function unpauseTreasury(bytes32 message) external;
}
