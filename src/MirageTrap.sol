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
    /**
     * @dev Hardcoded feed address (PoC).
     * Must match the deployed MirageFeed.
     * collect() is hardened so a bad address will NOT brick sampling.
     */
    IObservationFeed public constant FEED =
        IObservationFeed(0x7893321B15a0b83B18C106BaF2b0665646d1D4bE);

    int256 public constant THRESH_BPS = 500; // ±500 bps

    /**
     * @notice Snapshot the latest feed observation.
     * @dev Never reverts. Returns empty bytes on failure.
     */
    function collect() external view override returns (bytes memory) {
        address feedAddr = address(FEED);

        // --- extcodesize guard ---
        uint256 size;
        assembly {
            size := extcodesize(feedAddr)
        }

        if (size == 0) {
            // Feed is not a contract
            return bytes("");
        }

        // --- try/catch hardening ---
        try FEED.latestObservation() returns (int256 deltaBps, uint256 ts) {
            return abi.encode(deltaBps, ts);
        } catch {
            // Never brick sampling
            return bytes("");
        }
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

        // Optional sanity: ignore uninitialized / invalid timestamps
        if (curTs == 0) {
            return (false, bytes(""));
        }

        bool curAlert = curDelta > THRESH_BPS || curDelta < -THRESH_BPS;

        if (!curAlert) {
            return (false, bytes(""));
        }

        // Rising-edge guard: don’t spam alerts
        if (data.length > 1 && data[1].length > 0) {
            (int256 prevDelta, ) = abi.decode(data[1], (int256, uint256));

            bool prevAlert = prevDelta > THRESH_BPS || prevDelta < -THRESH_BPS;

            if (prevAlert) {
                return (false, bytes(""));
            }
        }

        // Payload EXACTLY matches responder ABI
        return (true, abi.encode(curDelta, curTs));
    }
}
