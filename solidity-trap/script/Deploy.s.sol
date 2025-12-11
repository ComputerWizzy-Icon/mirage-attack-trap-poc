// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MirageFeed.sol";
import "../src/MirageTrap.sol";
import "../src/MirageResponder.sol";

contract Deploy is Script {
    function run()
        external
        returns (address trap, address feed, address responder)
    {
        vm.startBroadcast();

        MirageFeed f = new MirageFeed();
        MirageResponder r = new MirageResponder();
        MirageTrap t = new MirageTrap(address(f)); // only feed here

        vm.stopBroadcast();

        return (address(t), address(f), address(r));
    }
}
