// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MirageResponder {
    event MirageAttackResponded(int256 deltaBps, uint256 timestamp);

    function respond(int256 deltaBps, uint256 ts) external {
        emit MirageAttackResponded(deltaBps, ts);
    }
}
