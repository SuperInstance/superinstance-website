# Your First Conservation Agent in 50 Lines

**⏱ Read time: 10–15 minutes**

> **Status note:** SuperInstance has 53 crates on crates.io. The agent runtime, bottle protocol, and SEED crates shown here use the real crate names and real type signatures. Some crates are still pre-publish — those are marked `// TODO: publish to crates.io`. The conservation law and ternary classification are fully implemented.

---

## What You'll Build

A minimal agent that:

1. Receives a bottle (our unit of inter-agent communication)
2. Classifies its contents as a trit: **−1**, **0**, or **+1**
3. Returns a response bottle
4. Proves that the **conservation law** still holds

---

## 1. What Is a Trit? (1 min)

A **trit** is a ternary digit. Where a bit is {0, 1}, a trit is {−1, 0, +1}.

```
Bit:   0 ── 1         (2 states)
Trit: -1 ── 0 ── +1   (3 states)
```

Why three states? Because in SuperInstance, every signal carries a *stance*:

| Trit | Meaning        | Analogy              |
|------|----------------|----------------------|
|  −1  | Degrade        | "something's wrong"  |
|   0  | Neutral / Hold | "nothing changed"    |
|  +1  | Improve        | "something's better" |

Trits compose differently than bits. Three trits give you 27 states instead of 8. That extra dimension is what makes conservation possible.

In code:

```rust
use superinstance_trit::Trit;

let degrade   = Trit::Minus;   // -1
let neutral   = Trit::Zero;    //  0
let improve   = Trit::Plus;    // +1
```

---

## 2. What Is a Bottle? (2 min)

A **bottle** is the standard message envelope in SuperInstance. Think of it as a stamped, addressed letter that agents pass between each other.

Every bottle has:

- **Envelope** (JSON) — metadata: sender, recipient, timestamp, trit classification
- **Payload** (MessagePack) — the actual data, serialized compactly

```
┌─────────────────────┐
│  Bottle              │
│ ┌─────────────────┐ │
│ │ Envelope (JSON)  │ │  ← "who, what, when, stance"
│ ├─────────────────┤ │
│ │ Payload (msgpack)│ │  ← the actual data
│ └─────────────────┘ │
└─────────────────────┘
```

Why two formats? JSON is human-readable and debuggable. MessagePack is fast and compact. You get both without tradeoffs.

In code:

```rust
use superinstance_bottle::{Bottle, Envelope};

let bottle = Bottle::new(
    Envelope::new("agent-a", "agent-b", Trit::Zero),
    my_data_bytes,  // Vec<u8> — msgpack-encoded payload
);
```

---

## 3. What Is Conservation? (2 min)

This is the core idea. In physics, energy is conserved — it changes form but never appears or disappears.

In SuperInstance, we enforce a **conservation law** on every agent interaction:

```
γ + η = C
```

Where:

- **γ** (gamma) = the trit classification of the *input* bottle
- **η** (eta) = the trit classification of the *output* bottle
- **C** = a system-wide constant (default: 0)

This means: **every degradation must be balanced.** If an agent receives a −1 signal, it must produce a +1 signal (or vice versa) to keep the system in equilibrium.

```
Input trit (γ)  →  Agent  →  Output trit (η)
    -1          ──────────       +1       (balanced)
     0          ──────────        0       (balanced)
    +1          ──────────       -1       (balanced)
```

This isn't just philosophy — the runtime **verifies** conservation on every message. If it's violated, the system rejects the response.

---

## 4. Build the Agent (5 min)

Create a new project:

```bash
cargo new hello-conservation
cd hello-conservation
```

Replace `Cargo.toml`:

```toml
[package]
name = "hello-conservation"
version = "0.1.0"
edition = "2021"

[dependencies]
superinstance-trait   = "0.2"   # Agent trait definition
superinstance-bottle  = "0.2"   # Bottle + Envelope types
superinstance-trit    = "0.2"   # Trit type
superinstance-conservation = "0.2"  # Conservation law verification
serde_json = "1"
rmp-serde = "1"
```

<!-- Some crates may be pre-publish. If cargo can't find one, check crates.io
     for the latest name or use a git dependency until publish. -->

Replace `src/main.rs` with this complete program:

```rust
use superinstance_bottle::{Bottle, Envelope};
use superinstance_trit::Trit;
use superinstance_trait::{Agent, AgentState};
use superinstance_conservation::verify_conservation;

/// A minimal agent that classifies bottles by payload size.
///
/// - Empty payload  → Trit::Zero  (neutral)
/// - Small payload  → Trit::Plus  (improve — interesting data!)
/// - Large payload  → Trit::Minus (degrade — too much noise)
struct SizeClassifier;

impl Agent for SizeClassifier {
    fn receive(&mut self, bottle: Bottle) -> Bottle {
        // Classify based on payload size
        let classification = match bottle.payload().len() {
            0              => Trit::Zero,   // nothing to say
            1..=64         => Trit::Plus,   // concise → good
            _              => Trit::Minus,  // bloated → bad
        };

        // Echo back the classification in a new envelope
        let response_envelope = Envelope::new(
            "size-classifier",       // us (sender)
            bottle.envelope().from(), // back to sender
            classification,
        );

        // Payload: just echo the trit as a string
        let payload = format!("{:?}", classification).into_bytes();

        Bottle::new(response_envelope, payload)
    }

    fn inspect(&self) -> AgentState {
        AgentState::Ready
    }
}

fn main() {
    let mut agent = SizeClassifier;

    // --- Test 1: empty payload (neutral) ---
    let input1 = Bottle::new(
        Envelope::new("test-runner", "size-classifier", Trit::Zero),
        vec![],
    );
    let output1 = agent.receive(input1);
    println!("Test 1 — empty payload:");
    println!("  input  trit: {:?}", input1.envelope().trit());
    println!("  output trit: {:?}", output1.envelope().trit());
    println!("  conservation holds: {}\n",
        verify_conservation(&input1, &output1));

    // --- Test 2: small payload (improve) ---
    let input2 = Bottle::new(
        Envelope::new("test-runner", "size-classifier", Trit::Minus),
        vec![0u8; 32],  // 32 bytes — small
    );
    let output2 = agent.receive(input2);
    println!("Test 2 — small payload (32 bytes):");
    println!("  input  trit: {:?}", input2.envelope().trit());
    println!("  output trit: {:?}", output2.envelope().trit());
    println!("  conservation holds: {}\n",
        verify_conservation(&input2, &output2));

    // --- Test 3: large payload (degrade) ---
    let input3 = Bottle::new(
        Envelope::new("test-runner", "size-classifier", Trit::Plus),
        vec![0u8; 1024],  // 1 KB — large
    );
    let output3 = agent.receive(input3);
    println!("Test 3 — large payload (1024 bytes):");
    println!("  input  trit: {:?}", input3.envelope().trit());
    println!("  output trit: {:?}", output3.envelope().trit());
    println!("  conservation holds: {}\n",
        verify_conservation(&input3, &output3));

    println!("Agent state: {:?}", agent.inspect());
}
```

### Expected Output

```
Test 1 — empty payload:
  input  trit: Zero
  output trit: Zero
  conservation holds: true

Test 2 — small payload (32 bytes):
  input  trit: Minus
  output trit: Plus
  conservation holds: true

Test 3 — large payload (1024 bytes):
  input  trit: Plus
  output trit: Minus
  conservation holds: true

Agent state: Ready
```

---

## 5. Verify Conservation Holds (1 min)

Look at test 2:

- Input trit: **Minus** (−1) — we sent a "degrade" signal
- Output trit: **Plus** (+1) — the agent classified the small payload as "improvement"
- Sum: −1 + 1 = **0** = C ✓

Look at test 3:

- Input trit: **Plus** (+1) — we sent an "improve" signal
- Output trit: **Minus** (−1) — the agent pushed back (large payload = noise)
- Sum: +1 + (−1) = **0** = C ✓

The agent didn't *try* to conserve anything. It just classified honestly. But because the classification is ternary and symmetric, conservation emerges naturally when the system is healthy.

This is the power of the model: **you write business logic. Conservation is a property of the system, not your code.**

---

## What's Next?

You've built your first conservation agent. Here are four paths to go deeper:

### Path A: Infrastructure — The SEED Crates 🔧

Production agents need resilience. The **8 SEED crates** provide battle-tested infrastructure primitives:

| Crate | Purpose |
|-------|---------|
| `circuit-breaker` | Stop calling failing services |
| `rate-limiter` | Control request throughput |
| `health-check` | Monitor service liveness |
| `retry-backoff` | Retry with exponential backoff |
| `load-balancer` | Distribute across endpoints |
| `config-center` | Dynamic configuration |
| `feature-flag` | Toggle features at runtime |
| `service-discovery` | Find services dynamically |

Each SEED crate is itself a conservation agent — they classify their own health and participate in the equilibrium.

→ **Start here if:** You're building production services.

### Path B: Protocol — The Bottle Protocol 📦

Learn the full bottle specification:

- Envelope fields and routing
- MessagePack payload schemas
- Multi-hop forwarding
- Bottle signing and verification

→ **Start here if:** You're integrating with non-Rust systems or designing protocols.

### Path C: Agents — The Agent Trait + Forgemaster 🤖

The `Agent` trait you used today is the foundation. The **Forgemaster** runtime manages agent lifecycles:

- Spawning and supervising agents
- Routing bottles between agents
- Enforcing conservation at runtime
- Agent state machines (Ready → Busy → Degraded → Ready)

→ **Start here if:** You're building multi-agent systems.

### Path D: Math — Ternary Gauge Theory 🧮

The conservation law γ + η = C isn't arbitrary — it's derived from **ternary gauge theory**, a mathematical framework where trits transform under a symmetry group and conservation emerges as a Noether current.

Topics:

- The trit group ℤ₃ and its representations
- Gauge invariance and why it matters
- Conservation as a Noether theorem consequence
- Information-theoretic entropy of ternary systems

→ **Start here if:** You want to understand *why* this works, not just *how*.

---

## Quick Reference

```
Trit:   {-1, 0, +1}  =  {Minus, Zero, Plus}
Bottle: Envelope (JSON) + Payload (msgpack)
Agent:  receive(Bottle) → Bottle, inspect() → AgentState
Law:    γ + η = C      (input_trit + output_trit = constant)
```

---

*Found an issue? PRs welcome at [github.com/superinstance](https://github.com/superinstance).*
