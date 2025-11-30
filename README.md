
---

# **Mirage Attack Trap – Drosera PoC**

A full Proof‑of‑Concept trap for **Drosera Network**, detecting *Mirage Price Attacks* using an off‑chain anomaly detector that automatically fires an on‑chain trap.

This PoC simulates a cross‑chain price/liquidity mismatch attack and triggers a Solidity trap when the anomaly exceeds a safe threshold.

---

## **📌 What This PoC Demonstrates**

* **Real‑time anomaly detection** using a Node.js engine
* Detects **Mirage Price Delta Attacks** (fake cross‑chain data meant to deceive protocols)
* Automatically triggers a **Drosera Trap Contract** using `ethers.js`
* Local execution using **Hoodi RPC** or **Anvil**
* Ready for submission to: *Hero of Janissaries*, *Captain*, *Sergeant* roles

---

## **📂 Project Structure**

```
mirage-attack-trap-poc/
│
├── solidity-trap/            # Solidity trap contract (Foundry)
│   └── src/MirageTrap.sol
│
├── node-detector/            # Node-based anomaly detector
│   ├── src/
│   │   ├── detector.js
│   │   ├── trap.js
│   │   └── simulateAttack.js
│   └── package.json
│
└── drosera.toml              # Drosera config (Hoodi-enabled)
```

---

## **🧪 How It Works**

### **1. Node Detector Flags Mirage Anomaly**

A fake cross‑chain update is simulated:

* ChainA price vs ChainB price
* Liquidity gaps
* Cross‑message integrity

If the price gap is unnatural:

```bash
Anomaly detected: PRICE_DELTA
Triggering Drosera Trap...
```

---

### **2. Node Automatically Fires the Trap**

It calls:

```solidity
triggerTrap(string reason)
```

On your deployed trap contract.

---

### **3. The Trap Writes the Incident On‑Chain**

Drosera Relay sees the incident and records your PoC.

---

## **🚀 Run the PoC Locally**

### **1. Install dependencies**

```
cd node-detector
npm install
```

### **2. Start your RPC**

Hoodi RPC recommended:

```
https://0xrpc.io/hoodi
```

or Anvil:

```
anvil
```

### **3. Run the attack simulation**

```
node src/simulateAttack.js
```

