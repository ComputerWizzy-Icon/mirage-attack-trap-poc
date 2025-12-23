// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);

    function shouldRespond(
        bytes[] calldata data
    ) external pure returns (bool, bytes memory);
}

interface IObservationFeed {
    function latestObservation() external view returns (int256, uint256);
}

contract MirageTrap is ITrap {
    // Hardcoded feed address (Drosera-safe PoC)
    IObservationFeed public constant FEED =
        IObservationFeed(0xB77002de62ad3D7Fe91924E80479E3285f3Db045);
    int256 public constant THRESHOLD_BPS = 500;

    function collect() external view override returns (bytes memory) {
        (int256 deltaBps, uint256 ts) = FEED.latestObservation();
        return abi.encode(deltaBps, ts);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }

        (int256 deltaBps, uint256 ts) = abi.decode(data[0], (int256, uint256));

        if (ts == 0) return (false, bytes(""));

        bool alert = deltaBps > THRESHOLD_BPS || deltaBps < -THRESHOLD_BPS;

        if (!alert) return (false, bytes(""));

        // Payload matches responder decode
        return (true, abi.encode(deltaBps, ts));
    }
}
