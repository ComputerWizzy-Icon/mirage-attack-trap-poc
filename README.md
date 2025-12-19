# **Mirage Attack Trap PoC**

This repository contains the **Mirage Attack Trap**, a Drosera‑style Proof of Concept designed to detect and deter malicious actors by feeding them **unreliable, mirrored state data** and observing their response behavior.
It follows the Drosera trap architecture of **Feed → Trap → Responder**.

The design simulates scenarios where an attacker relies on external signals that appear real but are intentionally distorted, enabling the trap to log, observe, and respond to exploitation attempts.

---

## **🧩 Architecture Overview**

The PoC implements three core contracts:

### **1. MirageFeed.sol**

A lightweight feed contract that outputs **controlled, adjustable values** that appear legitimate to external observers.

**Purpose:**

* Acts as a decoy information source
* Lets the trap present misleading but structured onchain data
* Attracts bots and automated exploit scanners

**Key Features:**

* Owner‑controlled updates
* Predictable interface (mirrors common oracle-style feeds)
* Can be expanded with fake volatility, patterns or mirrored onchain state

---

### **2. MirageTrap.sol**

The primary detection logic.

This contract consumes the MirageFeed and monitors calls that would normally attempt to exploit the feed’s state.
It then determines whether the caller is acting suspiciously based on patterns such as:

* Execution timing
* Repeated probing
* Calling the trap immediately after unusual feed updates
* Using abnormal parameters
* Predictable “bot-like” triggers

**Core responsibility:**
Serve as a monitoring honeypot that logs attackers who trust the MirageFeed without realizing it is intentionally deceptive.

---

### **3. MirageResponder.sol**

A minimal responder system that demonstrates how the trap **reacts** once an attacker is flagged.

Possible reactions (in a real trap):

* Emit alerts
* Freeze interactions
* Shadow-log addresses
* Trigger third‑party automations
* Mark callers for automated offchain analysis

In this PoC, the responder is intentionally simple:
it records detections and surfaces them for analysis.

---

## **⚙️ Deployment Details**

The PoC is deployed using Foundry’s `forge script`.

Your deployed contract addresses:

| Component           | Address                                      |
| ------------------- | -------------------------------------------- |
| **MirageTrap**      | `0x3c919331d1968e3af36508991f96Dc74de70dC91` |
| **MirageFeed**      | `0x525d661D435241621eF37692d381EeA609402511` |
| **MirageResponder** | `0x507f1088f601Ffb2f57E860A0D734cFC0f5FFb0B` |

All deployments succeeded on chain **560048 (Hoodi)**.

---

## **🚀 Deployment Script**

The project uses a single deployment script that:

1. Deploys **MirageFeed**
2. Deploys **MirageResponder**
3. Deploys **MirageTrap** with both addresses injected
4. Returns all addresses on completion

Command used:

```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url $ETH_RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY \
  -vv
```

---

## **📁 Project Structure**

```
mirage-attack-trap-poc/
│
├── src/
│   ├── MirageFeed.sol
│   ├── MirageTrap.sol
│   └── MirageResponder.sol
│
├── script/
│   └── Deploy.s.sol
│
├── drosera.toml
└── README.md
```

---

## **🔍 How It Works**

### **Step 1: Feed Provides a Mirage**

Attackers, bots, or scanners read from the MirageFeed thinking it is a real data source.

### **Step 2: Trap Evaluates Calls**

MirageTrap examines how callers behave relative to the fake data.

Example triggers:

* Caller reacts instantly to a manipulated feed update
* Caller attempts an exploit using predictable timing
* Caller performs repetitive probing behavior

### **Step 3: Responder Records Suspects**

The MirageResponder logs and exposes flagged addresses for later review.

---

## **🧪 Testing the Trap**

You can confirm behavior using Foundry:

### **1. Call the feed**

```bash
cast call <feed_address> "getValue()(uint256)"
```

### **2. Trigger suspicious interaction**

```bash
cast send <trap_address> "probe(uint256)" 123
```

### **3. Check responder log**

```bash
cast call <responder_address> "lastFlagged()(address)"
```

---

## **🔥 Why This Trap Matters**

This PoC demonstrates:

* How **misinformation can be used defensively** in web3 security
* How controlled feeds attract exploit bots
* How to structure Drosera traps using the standard **Feed → Trap → Responder** pattern
* How to deploy clean, modular trap components

It fits Drosera’s philosophy of:

> “Study the attacker by letting them think they’re winning.”

---

## **🛠 Future Improvements**

You can extend this PoC with:

* Dynamic feed patterns (random, mirrored, delayed)
* More complex attacker profiling
* Integration with Drosera offchain responders
* Nonce-based honeypots
* Multi-signal behavior scoring

