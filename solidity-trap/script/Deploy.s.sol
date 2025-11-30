// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "src/MockTrap.sol";
import "forge-std/Script.sol";

contract DeployMockTrap is Script {
    function run() external returns (address) {
        vm.startBroadcast();
        MockTrap trap = new MockTrap();
        vm.stopBroadcast();
        return address(trap);
    }
}
