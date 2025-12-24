// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IObservationFeed {
    function latestObservation()
        external
        view
        returns (int256 deltaBps, uint256 ts);
}

contract MirageTrap is ITrap {
    // Hardcoded feed address (PoC, Drosera-compatible)
    IObservationFeed public constant FEED =
        IObservationFeed(0xB77002de62ad3D7Fe91924E80479E3285f3Db045);

    int256 public constant THRESH_BPS = 500; // ±500 bps

    function collect() external view override returns (bytes memory) {
        (int256 deltaBps, uint256 ts) = FEED.latestObservation();
        return abi.encode(deltaBps, ts);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        // Planner safety
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }

        (int256 curDelta, uint256 curTs) = abi.decode(
            data[0],
            (int256, uint256)
        );

        bool curAlert = curDelta > THRESH_BPS || curDelta < -THRESH_BPS;

        if (!curAlert) return (false, bytes(""));

        // Rising-edge guard (don’t spam while condition persists)
        if (data.length > 1 && data[1].length > 0) {
            (int256 prevDelta, ) = abi.decode(data[1], (int256, uint256));

            bool prevAlert = prevDelta > THRESH_BPS || prevDelta < -THRESH_BPS;

            if (prevAlert) return (false, bytes(""));
        }

        // Payload EXACTLY matches responder signature
        return (true, abi.encode(curDelta, curTs));
    }
}
