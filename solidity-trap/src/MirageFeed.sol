// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MirageFeed {
    int256 public lastDeltaBps;
    uint256 public lastTimestamp;

    event ObservationPushed(int256 deltaBps, uint256 timestamp);

    function pushObservation(int256 deltaBps, uint256 timestamp) external {
        lastDeltaBps = deltaBps;
        lastTimestamp = timestamp;
        emit ObservationPushed(deltaBps, timestamp);
    }

    function latestObservation() external view returns (int256, uint256) {
        return (lastDeltaBps, lastTimestamp);
    }
}
