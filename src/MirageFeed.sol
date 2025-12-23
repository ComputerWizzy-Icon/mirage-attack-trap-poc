// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MirageFeed {
    address public owner;

    int256 public lastDeltaBps;
    uint256 public lastTimestamp;

    event ObservationPushed(int256 deltaBps, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
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
