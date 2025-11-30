// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MockTrap {
    event TrapTriggered(address sender, string reason);

    function triggerTrap(string memory reason) public {
        emit TrapTriggered(msg.sender, reason);
    }
}
