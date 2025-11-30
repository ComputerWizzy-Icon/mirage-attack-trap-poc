DROSERA MIRAGE ATTACK TRAP – PROOF OF CONCEPT
Overview

This PoC demonstrates a complete end-to-end trap system for the Drosera Network.
It detects a class of cross-chain manipulation known as a Mirage Attack and triggers a smart-contract trap when suspicious behavior is found.

This includes:

Off-chain anomaly detection (Node.js)

On-chain trap execution (Solidity + Foundry)

End-to-end alert pipeline

✨ What Is a Mirage Attack?

A Mirage Attack is when a malicious actor injects inconsistent cross-chain state, such as mismatched prices, liquidity, or fake cross-messages.

This PoC simulates and catches:

abnormal price deltas

suspicious liquidity differences

malformed cross-messages

🔥 How It Works

1. Node detetor analyzes incoming cross-chain packets
2. If anomaly detected → triggers MirageTrap on-chain
3. Contract emits immutable evidence event

📦 Components
1. MirageTrap.sol

Simple & clean trap contract emitting an event with metadata.

2. detectMirageAttack()

Unique detection logic that inspects price, liquidity, and message structure.

3. fireTrap()

Sends on-chain alert to the deployed trap.

4. simulateAttack.js

Runs a complete attack simulation.

🚀 Run Locally
cd solidity-trap
forge script script/DeployTrap.s.sol --broadcast


Copy deployed address into node-detector/src/trap.js

cd ../node-detector
node src/simulateAttack.js
