const { ethers } = require("ethers");

// Connect to Anvil
const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");

// Get signer from Anvil accounts
async function getSigner() {
    const accounts = await provider.listAccounts();
    const address = accounts[0].address || accounts[0];   // normalize
    return await provider.getSigner(address);
}

// Paste YOUR deployed contract address
const contractAddress = "0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519";

// ABI for the trap
const abi = [
    "function triggerTrap(string reason) public"
];

async function fireTrap(reason) {
    try {
        const signer = await getSigner();
        const trapContract = new ethers.Contract(contractAddress, abi, signer);

        const tx = await trapContract.triggerTrap(reason);
        console.log("Transaction sent:", tx.hash);

        await tx.wait();
        console.log("Trap triggered successfully!");
    } catch (error) {
        console.error("Failed to trigger trap:", error);
    }
}

module.exports = { fireTrap };
