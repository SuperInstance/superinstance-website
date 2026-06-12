# SuperInstance Education Site — Site Map

> "Educate don't sell." Every page teaches. Every demo runs. Every example is real.

---

## Navigation Structure

```
┌─────────────────────────────────────────────┐
│  HOME   CONCEPTS   CRATES   BUILD   PLAY    │
└─────────────────────────────────────────────┘
```

**Top nav (persistent):**
- **Home** — Landing, what this is, why it matters
- **Concepts** — Core theory (ternary, bottles, agents, conservation)
- **Crates** — SEED primitives catalog
- **Build** — Onboarding flow ("build your first agent")
- **Play** — Interactive playground

**Footer (every page):**
- Repo link (GitHub)
- Spec documents
- License
- "Found an error? PRs welcome."

---

## Pages

### 1. Home — `/` (or `index.html`)
**Purpose:** Zero-marketing landing. State what SuperInstance is, show it running, get out of the way.

**Sections:**
- **Hero:** One-line definition + live demo embed (a minimal agent receiving a bottle)
- **What this is:** 3-bullet honest summary (no adjectives, just facts)
- **The math:** γ + η = C, one equation, one sentence
- **Live stats:** Honest counters — crate count, test coverage %, spec version
- **Quick start:** 3-line code block, copy button
- **Concept map:** Clickable SVG showing how concepts connect

**Interactive elements:**
- Live agent demo (receives a bottle, shows γ/η decomposition)
- Copy-to-clipboard code blocks
- Expandable concept map (SVG, clickable nodes → concept pages)

**Code examples:**
- Minimal agent in Rust (2-method trait)
- Sending a bottle (curl or HTTP)
- Decoding a SEED crate

**Links:** → each concept page, → build flow, → repo

---

### 2. Concepts — `/concepts/` (index page)
**Purpose:** Overview of all core concepts with visual map.

**Sections:**
- Concept relationship graph (larger version of home page map)
- One-card-per-concept with: name, one-sentence summary, "Explore →" link

**Interactive elements:**
- Hoverable/clickable concept graph
- Filter by dependency depth (foundational → derived)

**Links:** → each individual concept page

---

### 3. Ternary Conservation — `/concepts/ternary-conservation/`
**Purpose:** Teach γ + η = C, {-1, 0, +1} classification, gauge principle.

**Sections:**
- **The equation:** γ + η = C with interactive decomposition
- **Classification:** {-1, 0, +1} mapping to agent states
- **Gauge principle:** Why conservation matters, what it constrains
- **Conservation law:** Structural isomorphism to Gauss's law in Z₃

**Interactive elements:**
- **Conservation calculator:** Input γ and η → shows C. Slide γ, η adjusts. Violations flash red.
- **State classifier:** Paste any agent state → classified as {-1, 0, +1}
- **Vector field viz:** Small canvas showing divergence-free flow in Z₃

**Code examples:**
```rust
fn classify(state: i8) -> Ternary {
    match state {
        -1 => Ternary::Negative,
        0  => Ternary::Neutral,
        1  => Ternary::Positive,
        _  => panic!("non-ternary state"),
    }
}
```
- Conservation check function
- Gauge transformation example

**Links:** → spec document, → conservation law page, → agent lifecycle

---

### 4. Bottle Protocol — `/concepts/bottle-protocol/`
**Purpose:** Teach the JSON envelope + msgpack payload hybrid routing format.

**Sections:**
- **Envelope anatomy:** Field-by-field breakdown of JSON envelope
- **Payload encoding:** Why msgpack, when to use it vs JSON
- **Hybrid routing:** How routers read envelope without decoding payload
- **Wire format:** Hex dump of a real bottle with annotations

**Interactive elements:**
- **Bottle builder:** Form to construct a bottle — fills envelope fields, pick payload format, see raw bytes
- **Bottle decoder:** Paste hex/base64 → decoded envelope + payload
- **Round-trip verifier:** Encode → decode → verify integrity

**Code examples:**
```rust
struct Bottle {
    // JSON envelope — routers read this
    routing: RoutingEnvelope,
    // msgpack payload — only the target agent reads this
    payload: Vec<u8>,
}
```
- Minimal bottle creation
- Routing middleware example
- Agent receive handler

**Links:** → agent lifecycle, → spec, → repo bottle module

---

### 5. Agent Lifecycle — `/concepts/agent-lifecycle/`
**Purpose:** Teach the 2-method trait (receive/inspect), lifecycle-as-bottles.

**Sections:**
- **The trait:** `receive(bottle) -> Bottle` and `inspect() -> State` — why only two methods
- **Lifecycle states:** Born → Active → Suspended → Terminated, all communicated as bottles
- **Lifecycle as bottles:** How state transitions are themselves bottles (meta-circular)
- **Composition:** How agents compose via bottle passing

**Interactive elements:**
- **Lifecycle simulator:** Step-through an agent's lifecycle. Watch bottles arrive/depart at each transition.
- **Agent composition sandbox:** Drag two agents together → see bottle exchange

**Code examples:**
```rust
trait Agent {
    fn receive(&mut self, bottle: Bottle) -> Bottle;
    fn inspect(&self) -> AgentState;
}
```
- Full lifecycle implementation
- Composing agents

**Links:** → bottle protocol, → SEED crates, → build flow

---

### 6. Self-Improving Harness — `/concepts/harness/`
**Purpose:** Teach build → fail → extract pattern → vectorize → feedback loop.

**Sections:**
- **The loop:** Visual of the 5-stage cycle
- **Build:** Write code, run tests
- **Fail:** Capture failure signal
- **Extract pattern:** What went wrong, generalized
- **Vectorize:** Embed the pattern, store in vector index
- **Feedback:** Retrieve relevant patterns on next failure

**Interactive elements:**
- **Harness walkthrough:** Animated step-through of a real failure → fix cycle
- **Pattern visualizer:** See vectorized patterns in a 2D projection (simple t-SNE-like plot)
- **Feedback demo:** Inject a failure → see which past patterns are retrieved

**Code examples:**
- Harness trait definition
- Pattern extraction logic
- Vectorize + store snippet
- Feedback retrieval

**Links:** → vectorize setup (TOOLS.md), → harness module in repo

---

### 7. Conservation Law — `/concepts/conservation-law/`
**Purpose:** Structural isomorphism to Gauss's law in Z₃. The deep math.

**Sections:**
- **Gauss's law:** Quick refresher on divergence and flux
- **Z₃ formulation:** What conservation looks like in ternary arithmetic
- **Structural isomorphism:** Mapping table — flux ↔ bottles, divergence ↔ agent balance
- **Implications:** What this buys you (provability, invariants)

**Interactive elements:**
- **Flux simulator:** Agent network with ternary flow, divergence meter
- **Invariant checker:** Given a network state, verify conservation holds
- **Comparison table:** Side-by-side electromagnetic vs SuperInstance terms

**Code examples:**
- Conservation invariant check
- Z₃ arithmetic operations
- Network flux calculation

**Links:** → ternary conservation, → academic references if any

---

### 8. Ternary Wavelet Decomposition — `/concepts/wavelet-decomposition/`
**Purpose:** Multi-scale representation of ternary signals (proosed). Mark as proposed/draft.

**Sections:**
- **What:** Decompose ternary signals at multiple scales
- **Why:** Coarse-grained patterns invisible at agent level
- **How:** Wavelet basis adapted for {-1, 0, +1}
- **Status:** Proposed, not yet implemented

**Interactive elements:**
- **Wavelet playground:** Input a ternary sequence → see multi-scale decomposition
- **Scale slider:** Adjust decomposition level, see coefficients change
- **Reconstruction:** Remove coefficients → see what's lost

**Code examples:**
- Proposed wavelet basis
- Forward transform pseudocode
- Inverse transform pseudocode

**Links:** → ternary conservation, → related work / references

---

### 9. SEED Crates Catalog — `/crates/`
**Purpose:** Catalog of all 8 infrastructure primitives.

**Sections:**
- Grid of 8 crate cards
- Each card: name, one-line purpose, status badge (stable/beta/proposed)
- Dependency graph between crates

**Interactive elements:**
- Clickable dependency graph
- Filter by status
- Search

**Links:** → individual crate pages, → playground for composition

---

### 10. Individual SEED Crate Pages — `/crates/{crate-name}/`

One page per crate. All 8:

| Crate | Slug |
|-------|------|
| Circuit Breaker | `/crates/circuit-breaker/` |
| Rate Limiter | `/crates/rate-limiter/` |
| Health Check | `/crates/health-check/` |
| Retry Backoff | `/crates/retry-backoff/` |
| Load Balancer | `/crates/load-balancer/` |
| Config Center | `/crates/config-center/` |
| Feature Flag | `/crates/feature-flag/` |
| Service Discovery | `/crates/service-discovery/` |

**Each page has:**
- **What it does:** 2-3 sentences, no fluff
- **How it works:** Internal mechanism, maybe a state diagram
- **Configuration:** All tunable parameters with defaults
- **Interaction with bottles:** How this crate sends/receives bottles
- **Conservation invariant:** What γ/η constraint it maintains

**Interactive elements:**
- **Live simulator:** Parameter sliders + real-time behavior visualization
  - Circuit breaker: trip/reset animation with configurable thresholds
  - Rate limiter: token bucket fill/drain animation
  - Health check: probe timeline with pass/fail
  - Retry backoff: exponential curve with jitter visualization
  - Load balancer: request distribution across backends
  - Config center: live config propagation to "agents"
  - Feature flag: toggle flags, see which agents see what
  - Service discovery: register/deregister, query resolution

**Code examples:**
- Crate initialization
- Integration with agent trait
- Configuration snippet
- Composing with other crates

**Links:** → crate source in repo, → playground, → related crates

---

### 11. Build Your First Agent — `/build/`
**Purpose:** Guided onboarding. Zero-to-agent in one page.

**Steps:**
1. **Pick a crate** (or start bare)
2. **Implement the trait** (receive + inspect)
3. **Wrap in a bottle** (create your first message)
4. **Run it** (in-browser simulation)
5. **Break it** (introduce a failure)
6. **Watch the harness** (see the self-improving loop catch it)

**Interactive elements:**
- **Step-by-step wizard:** Each step has explanation + editable code block
- **Live preview:** See the agent run in a simulated environment
- **"Break it" button:** Inject failure, watch recovery
- **Export:** Copy the complete agent code

**Code examples:**
- Each step builds on the previous
- Final assembled agent
- Test cases for the agent

**Links:** → agent lifecycle concept, → bottle protocol concept, → playground

---

### 12. Playground — `/playground/`
**Purpose:** Free-form composition space. Wire crates together, send bottles, observe.

**Sections:**
- **Canvas:** Drag-and-drop crate nodes, wire connections
- **Controls:** Send bottles, inject failures, adjust parameters
- **Output:** Real-time log of bottle traffic, agent states, conservation invariants
- **Presets:** Pre-built configurations (microservice, pipeline, mesh)

**Interactive elements:**
- **Node editor:** Drag crates from palette, connect with edges
- **Bottle inspector:** Click any edge → see bottle envelope + decoded payload
- **Invariant dashboard:** γ + η = C status for each agent, network-wide conservation
- **Export config:** Download the composed system as JSON
- **Share:** URL-encoded state for sharing configurations

**Code examples:**
- Preset configurations as code
- Custom crate registration
- Programmatic composition

**Links:** → all crate pages, → build flow, → repo

---

## Cross-cutting Elements

### Theme
- **Dark mode only.** Black/dark gray background, monospace primary font, syntax-highlighted code.
- **Accent colors:** Green (#00ff88) for positive, yellow for neutral, red for negative. Matches ternary.
- **No marketing language.** No "revolutionary", "cutting-edge", "seamless". Just facts.

### Mobile
- All pages responsive. Single-column on mobile.
- Interactive elements touch-friendly (sliders, buttons).
- Code blocks horizontally scrollable.
- Playground works on mobile (simplified canvas, tap-to-add).

### Typography
- Headings: Inter or system sans-serif
- Code: JetBrains Mono or system monospace
- Math: KaTeX rendering for equations

### Accessibility
- Keyboard navigable
- Alt text on all diagrams
- Color never the only differentiator (use labels/icons too)

---

## File Structure

```
superinstance-website/
├── SITE-MAP.md                    ← this document
├── pages/
│   ├── index.html                 ← home / landing
│   ├── education.html             ← education hub (alternative landing)
│   ├── concepts/
│   │   ├── index.html             ← concepts overview
│   │   ├── ternary-conservation.html
│   │   ├── bottle-protocol.html
│   │   ├── agent-lifecycle.html
│   │   ├── harness.html
│   │   ├── conservation-law.html
│   │   └── wavelet-decomposition.html
│   ├── crates/
│   │   ├── index.html             ← crate catalog
│   │   ├── circuit-breaker.html
│   │   ├── rate-limiter.html
│   │   ├── health-check.html
│   │   ├── retry-backoff.html
│   │   ├── load-balancer.html
│   │   ├── config-center.html
│   │   ├── feature-flag.html
│   │   └── service-discovery.html
│   ├── build/
│   │   └── index.html             ← build your first agent
│   └── playground/
│       └── index.html             ← composition playground
├── static/
│   ├── css/
│   │   └── style.css              ← shared dark theme
│   ├── js/
│   │   ├── common.js              ← shared utilities
│   │   ├── katex-render.js        ← math rendering
│   │   ├── ternary-calc.js        ← conservation calculator
│   │   ├── bottle-builder.js      ← bottle protocol demo
│   │   ├── agent-sim.js           ← lifecycle simulator
│   │   ├── harness-walk.js        ← harness walkthrough
│   │   ├── wavelet.js             ← wavelet playground
│   │   ├── crate-sims.js          ← all crate simulators
│   │   ├── build-wizard.js        ← onboarding flow
│   │   └── playground.js          ← node editor + composition
│   └── img/
│       ├── concept-map.svg        ← clickable concept graph
│       ├── crate-deps.svg         ← crate dependency graph
│       └── icons/                 ← ternary state icons
└── README.md
```

---

## Page Priority (Build Order)

1. **Landing / Home** — first impression, needs to exist
2. **Ternary Conservation** — core concept, everything builds on it
3. **Bottle Protocol** — second core concept
4. **Agent Lifecycle** — ties the first two together
5. **SEED Crates Catalog** — practical infrastructure
6. **Build Your First Agent** — onboarding
7. **Individual crate pages** — 8 pages, can be templated
8. **Playground** — most complex interactive element
9. **Self-Improving Harness** — advanced concept
10. **Conservation Law** — deep math, separate page
11. **Ternary Wavelet** — proposed, lowest priority
