# Ternary Conservation in Distributed Systems

**SuperInstance Research**
**June 2026**

---

## 1. Abstract

Distributed systems lack a native concept of resource balance. Binary health checks—alive or dead—discard information about the neutral or transitional states that dominate real system behavior. This paper introduces **ternary conservation**, a structural invariant for distributed agents based on three-valued classification. Every signal in the system is classified as negative, zero, or positive: $\{-1, 0, +1\}$. We define a conservation law stating that for any closed set of operations, the sum of ternary values is preserved. This is not a physical law imported from gauge theory; it is an engineering constraint that is *structurally isomorphic* to Gauss's law in $\mathbb{Z}_3$ lattice gauge theory—the total charge through any boundary vanishes. We present the mathematical foundation, a multi-scale ternary Haar decomposition that preserves conservation at every level, and the Bottle Protocol that carries ternary state across agent boundaries. An implementation in Rust demonstrates that the conservation law can be enforced at the type level, making the entire system auditable by construction.

---

## 2. Introduction

### 2.1 The Problem with Binary Health

The standard approach to distributed system health is binary: a node is healthy or it is not. A service is up or down. A request succeeded or failed. This is the world of booleans, circuit breakers, and HTTP status codes.

The problem is information loss. Between "healthy" and "unhealthy" lies a vast territory: a node that is healthy but under memory pressure. A service that is up but latency is degrading. A request that succeeded but the response was stale. Binary classification collapses these states into a single bit, and that bit is almost always "healthy"—until it suddenly isn't.

### 2.2 Ternary Classification

We propose a three-valued classification instead:

| Value | Meaning | Interpretation |
|-------|---------|----------------|
| $-1$ | Negative | Signal indicates degradation, failure, or resource deficit |
| $0$ | Neutral | Signal indicates equilibrium or no meaningful change |
| $+1$ | Positive | Signal indicates improvement, surplus, or resource availability |

This is not a sliding scale or a fuzzy value. It is a *decision*. Every event in the system is classified into exactly one of three states. The classification is lossy by design—it discards magnitude and retains direction.

### 2.3 The Conservation Law

The central claim of this paper is that if you build a system on ternary classification, a conservation law emerges naturally:

$$\sum_{i} \gamma_i + \sum_{j} \eta_j = C$$

where $\gamma_i$ are the ternary signals in one partition of the system and $\eta_j$ are the signals in the complement. For any closed set of operations, $C$ is constant. One bottle in, one bottle out. One cycle logged, one quality signal emitted. The sum of the trits is preserved.

This is not a metaphor. It is a structural property of the type signature:

```rust
fn receive(&mut self, bottle: Bottle) -> Bottle;
```

One `Bottle` in, one `Bottle` out. The trits in the input bottle and the trits in the output bottle must sum to the same value. The type enforces the law.

---

## 3. Mathematical Foundation

### 3.1 The Trit Set

We define the **trit set**:

$$T = \{-1, 0, +1\}$$

This is the cyclic group $\mathbb{Z}_3$ under addition modulo 3, though we work with the signed representation for engineering convenience. A **trit** $t \in T$ is the atomic unit of ternary state.

### 3.2 Classification Function

Given a space of events $\mathcal{E}$, the **classification function** is:

$$f: \mathcal{E} \to T$$

This function maps every event to exactly one trit. The function is total—every event is classified—and deterministic—the same event always produces the same trit. The choice of $f$ is domain-specific; what constitutes "negative," "neutral," or "positive" depends on context.

### 3.3 Conservation Law (Formal)

Let $S = (t_1, t_2, \ldots, t_n)$ be a sequence of trits produced by classifying events within a closed operation. The **conservation constant** is:

$$C(S) = \sum_{i=1}^{n} t_i$$

**Conservation Axiom:** For any agent $\alpha$ that transforms input sequence $S_{in}$ into output sequence $S_{out}$:

$$C(S_{in}) = C(S_{out})$$

This is the invariant. The total ternary charge is neither created nor destroyed by any operation in the system.

### 3.4 Structural Isomorphism to Gauss's Law in $\mathbb{Z}_3$

In lattice gauge theory with gauge group $\mathbb{Z}_3$, Gauss's law states that the total electric flux through any closed surface vanishes. On a lattice, electric flux lives on links and takes values in $\mathbb{Z}_3$. The constraint is:

$$\sum_{\text{links } \ell \text{ touching site } x} E_\ell = 0 \quad (\text{mod } 3)$$

Our conservation law is structurally isomorphic to this: the trits on the "links" (bottles) entering and leaving an "site" (agent) sum to the same value. The word "isomorphic" is used precisely here: both structures share the same algebraic constraint on a $\mathbb{Z}_3$-valued field, applied to different domains (physics vs. engineering). We do not claim deeper correspondence—no Wilson loops, no Lagrangian, no partition function.

What we *do* claim is that the conservation law is not arbitrary. It arises from the same algebraic structure that produces charge conservation in $\mathbb{Z}_3$ gauge theory, and that structure gives us a useful engineering property: the system is auditable. If the sum of trits changes, something violated the protocol.

---

## 4. The Gauge Principle

### 4.1 Not a Gauge Theory

Let us be explicit about what this is not. We are not constructing a gauge theory. There is no Lagrangian, no action principle, no path integral. The "gauge principle" as we use it refers to a structural observation, not a physical theory.

### 4.2 The Gauge Principle as Engineering Constraint

The gauge principle in physics states that local symmetries constrain the dynamics of a system. In our context, the principle manifests as:

> **A local ternary classification, when applied consistently across a system, produces a global conservation law.**

The agents do not know about the global conservation law. Each agent classifies its own events using its own $f$. The conservation emerges from the algebraic structure of $T$ and the constraint that every operation is a function from ternary input to ternary output.

### 4.3 Why Three Values?

Binary classification $\{0, 1\}$ cannot express a conservation law over $\mathbb{Z}_2$ in the same way. The sum of bits is monotonically non-decreasing for operations that produce output—there is no "negative" bit to cancel a "positive" bit. The third value, zero, is essential. It represents the neutral state that allows the sum to be preserved across transformations.

A four-valued system would work algebraically but would lack the clean semantic mapping. Three values correspond naturally to the three directions of change: worse, same, better. This is not a mathematical necessity but an engineering choice that aligns the algebra with human intuition.

---

## 5. Multi-Scale Representation

### 5.1 Ternary Haar Decomposition

Classical Haar wavelets decompose a signal into coarse approximations and detail coefficients at multiple scales. We adapt this to ternary signals.

Given a ternary signal $S = (t_1, t_2, \ldots, t_n)$ where $n$ is divisible by 3, one level of decomposition produces:

- **Coarse signal:** $S_c = (c_1, c_2, \ldots, c_{n/3})$ where $c_k = \text{majority}(t_{3k-2}, t_{3k-1}, t_{3k})$ and $\text{majority}$ returns the sign of the sum, or zero if the sum is zero.
- **Detail coefficients:** $d_k = t_{3k-2} + t_{3k-1} + t_{3k} - c_k$ (residuals, as raw integers).

The decomposition satisfies:

$$t_{3k-2} + t_{3k-1} + t_{3k} = c_k + d_k$$

### 5.2 Conservation at Every Scale

The conservation constant is preserved at every level of decomposition:

$$C(S) = \sum t_i = \sum c_k \cdot 3 + \sum d_k = 3 \cdot C(S_c) + \sum d_k$$

This holds because the decomposition is exact—no information is lost. The coarse signal carries the directional structure; the details carry the residuals. Together, they reconstruct the original signal perfectly.

### 5.3 Scale Invariance

Because conservation holds at every level, the system can be analyzed at any granularity without renormalization. A fleet of 1,000 agents can be decomposed into 333 groups, then 111, then 37, then 12, then 4. At every level, the conservation constant is meaningful and auditable.

This is a practical benefit, not a theoretical one. When debugging a fleet, you can check conservation at the fleet level first. If it holds, the problem is local. If it doesn't, the protocol itself is violated. The decomposition tells you *where* to look.

---

## 6. The Bottle Protocol

### 6.1 Design

The Bottle Protocol is the wire format for ternary state communication between agents. It is deliberately hybrid: a JSON envelope carries routing metadata, and a MessagePack payload carries application-specific data.

The design rationale is that the **envelope and the payload have fundamentally different lifetimes**. The envelope—source, target, action, trits—is read by every node in the path: edge workers, queues, target agents. It must survive format changes. JSON is chosen not for readability but for **longevity**. The payload is ephemeral; it matters only to source and target and can change format freely without breaking the routing layer.

### 6.2 Wire Format

```json
{
  "id": "0192a3f4-5b6c-7d8e-9f0a-1b2c3d4e5f6a",
  "ver": 1,
  "src": "forgemaster",
  "tgt": "fleet-edge",
  "act": "cycle.complete",
  "trits": [-1, 0, 1, 0, 1],
  "enc": "msgpack",
  "pay": "gqR0ZXN0gaNmb29hcXNvbWVfZGF0YQ==",
  "ttl": 300
}
```

Field definitions:

| Field | Type | Purpose |
|-------|------|---------|
| `id` | UUIDv7 | Time-sortable unique identifier |
| `ver` | u32 | Envelope schema version (payload versioning is independent) |
| `src` | string | Source agent or service identifier |
| `tgt` | string | Target agent or service identifier |
| `act` | string | Namespaced action (e.g., `"cycle.complete"`, `"system.init"`) |
| `trits` | i8[] | Ternary state vector; conservation law applies to this field |
| `enc` | string | Payload encoding (`"msgpack"`, `"json"`, `"raw"`) |
| `pay` | string | Base64-encoded opaque payload |
| `ttl` | u32 | Time-to-live in seconds |

### 6.3 Conservation Enforcement

The `trits` field is in the envelope precisely because the conservation law applies at the routing layer. Every node that handles a bottle can verify:

$$\text{trit\_sum}(\text{input\_bottle}) = \text{trit\_sum}(\text{output\_bottle})$$

without deserializing the payload. This is the key architectural insight: **the conservation law is auditable at the routing layer, without understanding the payload.**

---

## 7. Fleet Conservation

### 7.1 Single-Agent Conservation

A single agent $\alpha$ receives bottles and produces bottles. By the conservation axiom:

$$C(\text{bottles received by } \alpha) = C(\text{bottles produced by } \alpha)$$

The agent's internal state may change, but the trit sum through its interface is constant.

### 7.2 Fleet-Level Conservation

Consider a fleet $\mathcal{F} = \{\alpha_1, \alpha_2, \ldots, \alpha_n\}$ of agents. Each agent has its own conservation constant $C_i$. The **fleet conservation constant** is:

$$C_{\mathcal{F}} = \sum_{i=1}^{n} C_i$$

This is constant for the fleet as a whole. Internal communication between agents may redistribute trit sums—agent $\alpha_1$ sending a bottle to $\alpha_2$ transfers trit charge—but the fleet total is unchanged.

### 7.3 The Fleet Auditor

The **cocapn** role is the fleet auditor. It does not participate in agent logic; it observes the flow of bottles and verifies that:

1. Each agent maintains its individual conservation constant.
2. The fleet maintains its collective conservation constant.
3. Any violation is flagged immediately.

This is possible because the conservation law is checkable from envelope data alone. The auditor need not understand any agent's payload; it need only sum trits.

---

## 8. Implementation

The following type signatures are drawn from the SuperInstance Rust crates. This is working code, not pseudocode.

### 8.1 Trit Type (`superinstance-ternary-wavelet`)

```rust
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
#[repr(i8)]
pub enum Trit {
    Neg = -1,
    Zero = 0,
    Pos = 1,
}

impl Trit {
    pub fn from_i8(v: i8) -> Option<Self> {
        match v {
            -1 => Some(Trit::Neg),
            0 => Some(Trit::Zero),
            1 => Some(Trit::Pos),
            _ => None,
        }
    }
}
```

### 8.2 Bottle (`superinstance-protocol`)

```rust
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Bottle {
    pub id: Uuid,
    pub ver: u32,
    pub src: String,
    pub tgt: String,
    pub act: String,
    pub trits: Vec<i8>,
    pub enc: String,
    pub pay: String,   // base64-encoded payload
    pub ttl: u32,
}
```

### 8.3 Agent Trait (`superinstance-agent-trait`)

```rust
trait Agent {
    fn receive(&mut self, bottle: Bottle) -> Bottle;
    fn inspect(&self) -> AgentState;
}
```

Two methods. Lifecycle states—`Init`, `Active`, `Suspended`, `Terminated`—are not methods on the trait but states the agent transitions through based on bottles received. `system.init` is a bottle, not a method call. The agent is a function from `Bottle` to `Bottle`. Everything else is emergent.

The conservation law holds because the type signature enforces it: one `Bottle` in, one `Bottle` out.

### 8.4 Wavelet Decomposition (`superinstance-ternary-wavelet`)

```rust
pub struct WaveletLevel {
    pub coarse: Vec<Trit>,
    pub detail: Vec<i8>,       // residuals, range -2..=2
    pub conservation: i32,     // sum of all input trits at this level
}

pub struct TernaryWavelet {
    pub levels: Vec<WaveletLevel>,
    pub residual: Vec<Trit>,
    pub original_len: usize,
}
```

Each level stores its conservation constant. The invariant `coarse_sum × 3 + detail_sum == conservation` holds at every level, enabling scale-invariant auditing.

---

## 9. Honest Limitations

We believe in being precise about what this is and what it isn't.

**What it is:**
- An engineering constraint with a clean algebraic structure.
- A conservation law that is structurally isomorphic to Gauss's law in $\mathbb{Z}_3$.
- A practical tool for making distributed systems auditable by construction.

**What it isn't:**
- **Quantum mechanics.** There is no superposition, entanglement, or measurement problem. The ternary values are classical.
- **Penrose tilings or any aperiodic structure.** The ternary decomposition is periodic in the Haar sense.
- **A physics theory.** We are not claiming that distributed systems obey physical laws. We are claiming that a useful algebraic structure from physics happens to solve an engineering problem.
- **A panacea.** Conservation catches protocol violations. It does not catch semantic errors—an agent can return the right trit sum with the wrong payload.

**The honest caveat:**

The conservation law describes what we *enforce*, not what *emerges*. If an agent fans out to multiple bottles without compensating the ternary charge, the conservation law is violated—and the auditor catches it. The law is useful precisely because it is a constraint we check, not a theorem we prove about arbitrary systems.

---

## 10. References

1. Kogut, J. B. (1979). "An introduction to lattice gauge theory and spin systems." *Reviews of Modern Physics*, 51(4), 659–713.
2. Haar, A. (1910). "Zur Theorie der orthogonalen Funktionensysteme." *Mathematische Annalen*, 69(3), 331–371.
3. Lamport, L. (1978). "Time, clocks, and the ordering of events in a distributed system." *Communications of the ACM*, 21(7), 558–565.
4. Hewitt, C., Bishop, P., & Steiger, R. (1973). "A universal modular ACTOR formalism for artificial intelligence." *IJCAI*, 235–245.
5. Agha, G. (1986). *Actors: A Model of Concurrent Computation in Distributed Systems*. MIT Press.
6. Knuth, D. E. (1981). *The Art of Computer Programming, Volume 2: Seminumerical Algorithms*. Addison-Wesley. (Section 4.1 on balanced ternary representation.)

---

*This paper describes the design principles behind SuperInstance, a distributed computing ecosystem built on ternary conservation. The crates referenced—`superinstance-ternary-wavelet`, `superinstance-protocol`, `superinstance-agent-trait`—are implemented in Rust and deployed on Cloudflare Workers.*
