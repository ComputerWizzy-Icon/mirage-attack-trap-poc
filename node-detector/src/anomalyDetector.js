const { getChainState } = require("./chainState");

// Base anomaly detection
function detectAnomaly(packet) {
    const chainState = getChainState(packet.chain);

    // 1) Timestamp mismatch
    if (Math.abs(packet.timestamp - chainState.timestamp) > 30) {
        return { anomaly: true, reason: "TIMESTAMP_DELTA" };
    }

    // 2) Block mismatch
    if (packet.block !== chainState.block) {
        return { anomaly: true, reason: "BLOCK_MISMATCH" };
    }

    // 3) Replay detection
    if (packet.seenBefore) {
        return { anomaly: true, reason: "REPLAY_DETECTED" };
    }

    return { anomaly: false };
}

// Mirage-specific detection
function detectMirageAttack(packet) {
    // fallback defaults so code never crashes
    const priceA = packet.priceA || 0;
    const priceB = packet.priceB || 0;
    const liquidityA = packet.liquidityA || 0;
    const liquidityB = packet.liquidityB || 0;

    const priceDiff = Math.abs(priceA - priceB);
    const liquidityDiff = Math.abs(liquidityA - liquidityB);

    // simple detection rules
    if (priceDiff > 100) return { anomaly: true, reason: "PRICE_DELTA" };
    if (liquidityDiff > 500000) return { anomaly: true, reason: "LIQUIDITY_DELTA" };

    if (packet.crossMsg && packet.crossMsg.startsWith("0xFAKE")) {
        return { anomaly: true, reason: "FAKE_CROSS_MSG" };
    }

    return { anomaly: false };
}

module.exports = {
    detectAnomaly,
    detectMirageAttack
};
