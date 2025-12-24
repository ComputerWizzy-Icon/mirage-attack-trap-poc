// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MirageFeed.sol";
import "../src/MirageTrap.sol";
import "../src/MirageResponder.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        MirageFeed feed = new MirageFeed();
        MirageResponder responder = new MirageResponder();
        MirageTrap trap = new MirageTrap();

        console.log("MirageFeed:", address(feed));
        console.log("MirageResponder:", address(responder));
        console.log("MirageTrap:", address(trap));

        vm.stopBroadcast();
    }
}
