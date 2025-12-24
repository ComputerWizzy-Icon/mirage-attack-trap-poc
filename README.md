# **Mirage Attack Trap PoC**

<<<<<<< HEAD
This repository contains the **Mirage Attack Trap**, a Drosera‑style Proof of Concept designed to detect and deter malicious actors by feeding them **unreliable, mirrored state data** and observing their response behavior.
It follows the Drosera trap architecture of **Feed → Trap → Responder**.

The design simulates scenarios where an attacker relies on external signals that appear real but are intentionally distorted, enabling the trap to log, observe, and respond to exploitation attempts.
=======
This repository contains the **Mirage Attack Trap**, a Drosera-compatible Proof of Concept for detecting **abnormal feed signals** using a simple, deterministic threshold model.

The system follows the standard Drosera architecture:

**Feed → Trap → Responder**

This PoC focuses on **signal validation**, not behavioral honeypots, deception logic, or caller analysis.
>>>>>>> master

---

## **🧩 Architecture Overview**

<<<<<<< HEAD
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
=======
The PoC consists of three contracts:

### **1. MirageFeed.sol**

A minimal, owner-controlled feed contract that publishes observations used by the trap.

**What it does:**

- Stores a numeric signal (`deltaBps`) and timestamp  
- Exposes the latest observation via a view function  
- Acts as the data source for the trap  

**What it does NOT do:**

- No deception logic  
- No mirroring  
- No attacker interaction tracking  
>>>>>>> master

---

### **2. MirageTrap.sol**

<<<<<<< HEAD
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
=======
The core Drosera trap.

The trap samples the latest feed observation and evaluates whether the signal exceeds a fixed threshold.

**Detection logic:**

- Reads `(deltaBps, timestamp)` from `MirageFeed`
- Triggers if `deltaBps > +500` or `< -500`
- Uses a rising-edge guard to avoid repeated alerts
- Returns a typed payload `(int256 deltaBps, uint256 timestamp)`

**Important properties:**

- Stateless
- Deterministic
- No constructor arguments (Drosera-safe)
- Planner-safe guards included

**What it does NOT do:**

- No caller analysis
- No probing
- No timing heuristics
- No honeypot behavior
>>>>>>> master

---

### **3. MirageResponder.sol**

<<<<<<< HEAD
A minimal responder system that demonstrates how the trap **reacts** once an attacker is flagged.

Possible reactions (in a real trap):

* Emit alerts
* Freeze interactions
* Shadow-log addresses
* Trigger third‑party automations
* Mark callers for automated offchain analysis

In this PoC, the responder is intentionally simple:
it records detections and surfaces them for analysis.
=======
A typed responder contract invoked by Drosera when the trap fires.

**Behavior:**

- Accepts `(int256 deltaBps, uint256 timestamp)`
- Emits an event recording the alert
- Contains no imperative or blocking logic

This responder exists solely to surface detection events.
>>>>>>> master

---

## **⚙️ Deployment Details**

<<<<<<< HEAD
The PoC is deployed using Foundry’s `forge script`.

Your deployed contract addresses:

| Component           | Address                                      |
| ------------------- | -------------------------------------------- |
| **MirageTrap**      | `0x3c919331d1968e3af36508991f96Dc74de70dC91` |
| **MirageFeed**      | `0x525d661D435241621eF37692d381EeA609402511` |
| **MirageResponder** | `0x507f1088f601Ffb2f57E860A0D734cFC0f5FFb0B` |

All deployments succeeded on chain **560048 (Hoodi)**.
=======
The PoC is deployed using Foundry on **Hoodi (chain ID 560048)**.

| Component           | Address                                      |
|--------------------|----------------------------------------------|
| **MirageTrap**      | `0xB5122C0dCFE243A0e8ad1bC7b680878e2ED05427` |
| **MirageFeed**      | `0x902DA7fa5fE02De1D09C289B034C2f1238788bc9` |
| **MirageResponder** | `0x7ec91278416f2F74Ea11eD1178DA3d895B4D413f` |
>>>>>>> master

---

## **🚀 Deployment Script**

<<<<<<< HEAD
The project uses a single deployment script that:

1. Deploys **MirageFeed**
2. Deploys **MirageResponder**
3. Deploys **MirageTrap** with both addresses injected
4. Returns all addresses on completion
=======
The deployment script performs:

1. Deploy `MirageFeed`
2. Deploy `MirageResponder`
3. Deploy `MirageTrap` (no constructor arguments)
>>>>>>> master

Command used:

```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url $ETH_RPC_URL \
  --broadcast \
  --private-key $PRIVATE_KEY \
  -vv
<<<<<<< HEAD
```
=======
````
>>>>>>> master

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

<<<<<<< HEAD
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
=======
### **Step 1: Feed Update**

An authorized owner pushes a new observation to `MirageFeed`.

### **Step 2: Trap Sampling**

Drosera operators call `collect()` on the trap, which snapshots:

* `deltaBps`
* `timestamp`

### **Step 3: Detection**

`shouldRespond()` compares the latest sample against the threshold.

If the signal crosses into an abnormal range, the trap returns:

```
(int256 deltaBps, uint256 timestamp)
```

### **Step 4: Response**

Drosera calls the responder, which emits an alert event.

---

## **🧪 Testing**

Manual simulation example:

```bash
cast send <feed_address> "pushObservation(int256,uint256)" 800 123456
```

After sampling, Drosera will trigger the responder if the threshold is exceeded.

---

## **🔥 What This PoC Demonstrates**

* Correct Drosera trap wiring
* ABI-aligned trap → responder payloads
* Planner-safe stateless detection
* Rising-edge alert logic
* Clean, reproducible deployment path

---

## **🛠 Future Extensions (Out of Scope for This PoC)**

* Behavioral honeypots
* Deceptive feeds
* Caller profiling
* Multi-signal scoring
* Offchain analysis pipelines

These are intentionally **not implemented** here.

---

## **Status**

This trap has been reviewed and corrected for:

* Constructor safety
* ABI alignment
* TOML correctness
* README accuracy

It is suitable as a **reference Drosera PoC**.

````
>>>>>>> master

