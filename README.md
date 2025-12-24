# **Mirage Attack Trap PoC**

This repository contains the **Mirage Attack Trap**, a Drosera-compatible Proof of Concept for detecting **abnormal feed signals** using a simple, deterministic threshold model.

The system follows the standard Drosera architecture:

**Feed → Trap → Responder**

This PoC focuses on **signal validation**, not behavioral honeypots, deception logic, or caller analysis.

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

| Component           | Address                                      |
|--------------------|----------------------------------------------|
| **MirageTrap**      | `0xB5122C0dCFE243A0e8ad1bC7b680878e2ED05427` |
| **MirageFeed**      | `0x902DA7fa5fE02De1D09C289B034C2f1238788bc9` |
| **MirageResponder** | `0x7ec91278416f2F74Ea11eD1178DA3d895B4D413f` |

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
  --private-key $PRIVATE_KEY \
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

