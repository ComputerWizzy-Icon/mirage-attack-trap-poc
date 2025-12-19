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
    IObservationFeed public constant feed =
        IObservationFeed(0x06E48C756d2bFC6bE0E0C3381Fe8EA5F20cB6d5f);

    function collect() external view override returns (bytes memory) {
        (int256 deltaBps, uint256 ts) = feed.latestObservation();
        return abi.encode(deltaBps, ts);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        if (data.length == 0 || data[0].length == 0) return (false, bytes(""));

        (int256 deltaBps, uint256 ts) = abi.decode(data[0], (int256, uint256));

        if (ts == 0) return (false, bytes(""));

        bool alert = deltaBps > 500 || deltaBps < -500;
        if (!alert) return (false, bytes(""));

        return (true, abi.encode(deltaBps, ts));
    }
}
