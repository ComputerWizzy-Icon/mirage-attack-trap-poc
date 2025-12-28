# **Mirage Attack Trap PoC**

This repository contains the **Mirage Attack Trap**, a Drosera-compatible Proof of Concept for detecting **abnormal feed signals** using a simple, deterministic threshold model.

The system follows the standard Drosera architecture:

**Feed → Trap → Responder**

This PoC focuses on **signal validation**, not deception logic, behavioral honeypots, or caller profiling.

---

## **🧩 Architecture Overview**

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

---

### **2. MirageTrap.sol**

The core Drosera trap.

The trap samples the latest feed observation and evaluates whether the signal exceeds a fixed threshold.

**Detection logic:**

- Attempts to read `(deltaBps, timestamp)` from `MirageFeed`
- Returns `bytes("")` if the feed address has no code or the call fails
- Triggers if `deltaBps > +500` or `< -500`
- Uses a rising-edge guard to prevent repeated alerts
- Returns a typed payload `(int256 deltaBps, uint256 timestamp)`

**Important properties:**

- Stateless
- Deterministic
- No constructor arguments (Drosera-safe)
- Hardened against feed misconfiguration
- Planner-safe guards included

**What it does NOT do:**

- No caller analysis
- No probing
- No honeypot behavior

---

### **3. MirageResponder.sol**

A typed responder contract invoked by Drosera when the trap fires.

**Behavior:**

- Accepts `(int256 deltaBps, uint256 timestamp)`
- Emits an event recording the alert
- Contains no imperative or blocking logic

This responder exists solely to surface detection events.

---

## **⚙️ Deployment Details**

The PoC is deployed using Foundry on **Hoodi (chain ID 560048)**.

| Component | Address |
|---------|--------|
| **MirageTrap** | `0x45335eA1Ad4a6b713c606fcF3587EE1F7Cf24cbE` |
| **MirageFeed** | `0x7893321B15a0b83B18C106BaF2b0665646d1D4bE` |
| **MirageResponder** | `0xC6B77dE2241E925d92d199491b2031796d2e02Ec` |

The `MirageTrap` contract hardcodes the above `MirageFeed` address.  
All deployment references are intentionally kept consistent.

---

## **🚀 Deployment Script**

The deployment script performs:

1. Deploy `MirageFeed`
2. Deploy `MirageResponder`
3. Deploy `MirageTrap` (no constructor arguments)

Command used:

```bash
forge script script/Deploy.s.sol:Deploy \
  --rpc-url $ETH_RPC_URL \
  --broadcast \
  --sender <DEPLOYER_ADDRESS> \
  -vv
````

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

### **Step 1: Feed Update**

An authorized owner pushes a new observation to `MirageFeed`.

### **Step 2: Trap Sampling**

Drosera operators call `collect()` on the trap, which snapshots:

* `deltaBps`
* `timestamp`

If the feed is misconfigured or unavailable, `collect()` safely returns empty bytes instead of reverting.

### **Step 3: Detection**

`shouldRespond()` compares the most recent sample against the threshold and checks for a rising-edge condition.

### **Step 4: Response**

Drosera invokes the responder, which emits an alert event.

---

## **🧪 Testing**

Manual simulation example:

```bash
cast send <feed_address> "pushObservation(int256,uint256)" 800 123456
```

---

## **🔥 What This PoC Demonstrates**

* Correct Drosera trap wiring
* Hardened sampling behavior
* ABI-aligned trap → responder payloads
* Planner-safe stateless detection
* Rising-edge alert logic
* Clean and reproducible deployment path

---

## **🛠 Future Extensions (Out of Scope)**

* Timestamp staleness validation
* Monotonic feed comparisons
* Behavioral honeypots
* Multi-signal aggregation

These are intentionally excluded from this PoC.

---

## **Status**

This trap has been reviewed and corrected for:

* Constructor safety
* Feed call hardening
* ABI alignment
* Address consistency
* TOML correctness
* README accuracy

It is suitable as a **reference Drosera PoC**.

```
