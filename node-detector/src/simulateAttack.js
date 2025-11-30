const { detectMirageAttack } = require("./anomalyDetector");
const { fireTrap } = require("./trap");

async function main() {
    console.log("=== Running Mirage Attack Simulation ===");

    // Fake attacker packet
    const fakePacket = {
        sourceChain: "ChainA",
        destChain: "ChainB",
        priceA: 2300,
        priceB: 2450, // intentionally mismatched to trigger detection
        liquidityA: 500000,
        liquidityB: 1200000,
        crossMsg: "0xFAKE-123",
        txHash: "0xattack001"
    };

    console.log("Simulating fake packet:", fakePacket);

    // Step 1: Detect anomaly
    const detected = detectMirageAttack(fakePacket);

    if (!detected.anomaly) {
        console.log("No anomaly detected. Trap not triggered.");
        return;
    }

    console.log("Anomaly detected:", detected.reason);
    console.log("Triggering Drosera Trap...");

    // Step 2: Trigger Solidity Trap
    await fireTrap(detected.reason);

    console.log("Trap triggered successfully!");
}

main().catch(console.error);
