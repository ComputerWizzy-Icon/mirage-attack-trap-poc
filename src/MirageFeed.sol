// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MirageFeed {
    int256 public lastDeltaBps;
    uint256 public lastTimestamp;

    address public owner;

    event ObservationPushed(int256 deltaBps, uint256 timestamp);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    function pushObservation(
        int256 deltaBps,
        uint256 timestamp
    ) external onlyOwner {
        lastDeltaBps = deltaBps;
        lastTimestamp = timestamp;
        emit ObservationPushed(deltaBps, timestamp);
    }

    function latestObservation() external view returns (int256, uint256) {
        return (lastDeltaBps, lastTimestamp);
    }
}
