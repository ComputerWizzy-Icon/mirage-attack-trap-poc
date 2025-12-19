// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MirageResponder {
    event MirageAttackResponded(int256 deltaBps, uint256 timestamp);

    function respond(bytes calldata payload) external {
        (int256 deltaBps, uint256 ts) = abi.decode(payload, (int256, uint256));
        emit MirageAttackResponded(deltaBps, ts);
    }
}
