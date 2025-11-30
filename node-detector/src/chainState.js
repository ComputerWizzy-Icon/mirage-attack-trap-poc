// chainState.js
// Simulated canonical chain states
module.exports = {
    getChainState(chain) {
        const states = {
            ChainA: { block: 120000, timestamp: 1710000000, finalized: true },
            ChainB: { block: 99990, timestamp: 1710000020, finalized: true },
            ChainC: { block: 540000, timestamp: 1710000035, finalized: true },
        };
        return states[chain];
    }
};
