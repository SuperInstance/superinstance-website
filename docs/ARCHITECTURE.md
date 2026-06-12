# SuperInstance Ecosystem Architecture

**Generated:** 2026-06-11  
**Scope:** 1,605 repos · 7 CF Workers · 2 D1 databases · 2 Vectorize indexes

---

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           EXTERNAL INTEGRATIONS                             │
│                                                                             │
│   crates.io ◄──── Publish waves ────┐                                      │
│   npm registry ◄─── 12 packages ────┤                                      │
│   GitHub ◄───────── 579 repos ──────┤   SuperInstance/superinstance-website │
│   Cloudflare Edge ◄── 7 Workers ────┘                                      │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CLOUDFLARE WORKERS (Edge)                           │
│                                                                             │
│  ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐        │
│  │  fleet-vector-api │   │  fleet-edge      │   │  fleet-auth      │        │
│  │  Semantic search  │   │  Static hosting  │   │  API key mgmt    │        │
│  │  POST /search     │   │  ecosystem.html  │   │  D1 + KV store   │        │
│  │  POST /ingest     │   │  cluster-map     │   │                  │        │
│  │  GET /stats       │   │  browse.html     │   │                  │        │
│  └────────┬─────────┘   └──────────────────┘   └──────────────────┘        │
│           │                                                                  │
│  ┌────────┴─────────┐   ┌──────────────────┐   ┌──────────────────┐        │
│  │  Vectorize        │   │ fleet-metrics-   │   │ knowledge-cron   │        │
│  │  fleet-crates     │   │ cron             │   │ (scheduled)      │        │
│  │  384-dim BGE      │   │ 5-min trigger    │   │ Nightly refresh  │        │
│  │  1,540 vectors    │   │ Metrics collect  │   │                  │        │
│  └──────────────────┘   └──────────────────┘   └──────────────────┘        │
│                                                                             │
│  ┌──────────────────┐   ┌──────────────────┐                               │
│  │  harness-api      │   │ superinstance-   │                               │
│  │  γ/η allocation   │   │ vectorize        │                               │
│  │  Self-optimizing  │   │ Knowledge search │                               │
│  │  EWMA tracking    │   │ 32-dim patterns  │                               │
│  └────────┬─────────┘   └──────────────────┘                               │
└───────────┼─────────────────────────────────────────────────────────────────┘
            │
┌───────────┼─────────────────────────────────────────────────────────────────┐
│           │              AGENT LAYER                                        │
│           │                                                                  │
│  ┌────────▼─────────┐   ┌──────────────────┐                               │
│  │  Forgemaster      │   │  Loom            │                               │
│  │  (OpenClaw/       │◄──►│  (Casey's other  │                               │
│  │   GLM-5.1)        │   │   agent)         │                               │
│  │  660+ subagents   │   │  4 harness cycles│                               │
│  └────────┬─────────┘   └──────────────────┘                               │
│           │                    ▲                                             │
│           │   construct-       │                                             │
│           │   coordination     │                                             │
│           │   repo (messages)  │                                             │
└───────────┼────────────────────┼─────────────────────────────────────────────┘
            │                    │
┌───────────┼────────────────────┼─────────────────────────────────────────────┐
│           ▼         DATA FLOW  │                                             │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐     │
│  │                    COMPOUND LEARNING CYCLE                         │     │
│  │                                                                    │     │
│  │  ┌──────────┐    ┌──────────────┐    ┌──────────────────────────┐│     │
│  │  │  Agent    │───▶│  Build Waves │───▶│  Pattern Extraction     ││     │
│  │  │  Session  │    │  (440 done)  │    │  (25 patterns indexed)  ││     │
│  │  └────▲──────┘    └──────────────┘    └──────────┬───────────────┘│     │
│  │       │                                            │              │     │
│  │       │              ┌──────────────┐              │              │     │
│  │       │              │  Vector Store│◀─────────────┘              │     │
│  │       │              │  (1,540 vecs)│                             │     │
│  │       │              └──────┬───────┘                             │     │
│  │       │                     │                                     │     │
│  │       └─────────────────────┘                                     │     │
│  │         Bootstrap Query: agent searches patterns                  │     │
│  │         before starting work                                      │     │
│  └────────────────────────────────────────────────────────────────────┘     │
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────┐     │
│  │                    HARNESS CONTROL LOOP                            │     │
│  │                                                                    │     │
│  │  GET /allocation ──▶ γ (exploitation) + η (exploration) = C       │     │
│  │       │                                                            │     │
│  │       ▼                                                            │     │
│  │  Agent works (split by γ/η)                                       │     │
│  │       │                                                            │     │
│  │       ▼                                                            │     │
│  │  POST /cycle (gamma_spent, eta_spent, output_quality, yield)      │     │
│  │       │                                                            │     │
│  │       ▼                                                            │     │
│  │  EWMA update → signal: {Increase, Maintain, Decrease, Rebalance}  │     │
│  │       │                                                            │     │
│  │       └──▶ Next GET /allocation (loop)                            │     │
│  └────────────────────────────────────────────────────────────────────┘     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                         CODE ECOSYSTEM                                      │
│                                                                             │
│   1,605 repositories    1,494 Rust crates    12 npm packages               │
│   ├── 967 REAL          ├── 362 ternary-*     ├── Published to npm         │
│   ├── 448 STUB          ├── 42 agent-*        └── Under superinstance org  │
│   └── 79 SKELETON       ├── 30 oxide-*                                    │
│                         ├── 19 fleet-*                                     │
│   Categories:           ├── 17 plato-*                                    │
│   ternary · agent       ├── 8 tensor-*                                    │
│   fleet · plato         ├── 8 wasm-*                                      │
│   oxide · tensor        └── 8 config-*                                    │
│   wasm · config                                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Service Connection Map

```
                    ┌─────────────────┐
                    │   Forgemaster   │
                    │   (OpenClaw)    │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
     ┌────────────┐  ┌────────────┐  ┌────────────┐
     │ harness-api│  │fleet-vector│  │  GitHub    │
     │            │  │    -api    │  │  (579)     │
     └─────┬──────┘  └─────┬──────┘  └────────────┘
           │               │
           │         ┌─────┴──────┐
           │         │ Vectorize  │
           │         │fleet-crates│
           │         │ 384-dim    │
           │         │ 1,540 vecs │
           │         └────────────┘
           │
     ┌─────┴──────┐         ┌──────────────┐
     │   Loom     │◄───────►│  construct-  │
     │            │  msgs    │ coordination │
     └────────────┘         └──────────────┘

     ┌────────────┐   ┌────────────┐   ┌────────────┐
     │ fleet-auth │   │ fleet-edge │   │fleet-metrics│
     │ D1 + KV   │   │ static     │   │  -cron     │
     └────────────┘   └────────────┘   └────────────┘

     ┌────────────────────┐   ┌──────────────────┐
     │superinstance-      │   │ knowledge-cron   │
     │  vectorize         │   │  (scheduled)     │
     │ 32-dim patterns    │   └──────────────────┘
     └────────────────────┘
```

---

## The Compound Loop Cycle

The self-improving architecture operates as a closed loop:

1. **Agent starts session** → queries vector store for relevant patterns
2. **Build/test runs** → 440 waves, 97.5% pass rate
3. **Pattern extraction** → successful patterns indexed (25 so far)
4. **Vector store grows** → 1,540 vectors, richer context each cycle
5. **Next agent starts smarter** → compound returns

The harness (`harness-api`) adds a meta-layer: it tracks γ (exploitation) and η (exploration) across cycles, using EWMA to smooth quality signals. When quality drops below 0.5, signals invert to prevent self-reinforcing loops. This creates an adaptive control system where the ecosystem learns not just *what* to build, but *how* to allocate effort.

---

## External Integrations

| Integration | Direction | Data |
|-------------|-----------|------|
| **crates.io** | Push | 38+ Rust crates published in waves |
| **npm** | Push | 12 packages under `superinstance` org |
| **GitHub** | Push | 579 repos synced to SuperInstance org |
| **Cloudflare Workers AI** | Pull | `@cf/baai/bge-small-en-v1.5` embeddings |
| **Cloudflare Vectorize** | Read/Write | 2 indexes (fleet-crates 384-dim, superinstance-knowledge 32-dim) |
| **Cloudflare D1** | Read/Write | 2 databases (fleet-events, fleet-auth-db) |
| **Cloudflare KV** | Read/Write | fleet-auth namespace |
| **construct-coordination** | Read/Write | Cross-agent messages (Forgemaster ↔ Loom) |

---

## Data Flow: Vector API ↔ Agents ↔ Harness ↔ Knowledge Base

```
Agent queries                    Agent reports
"what exists?"                   "what I did"
      │                               │
      ▼                               ▼
┌─────────────┐              ┌─────────────────┐
│fleet-vector-│              │  harness-api     │
│    api      │              │                  │
│ POST /search│              │ POST /cycle      │
│  {query,    │              │  {gamma_spent,   │
│   topK}     │              │   eta_spent,     │
└──────┬──────┘              │   quality}       │
       │                     └────────┬─────────┘
       │                              │
       ▼                              ▼
┌──────────────┐              ┌──────────────┐
│  Vectorize   │              │  EWMA state  │
│  fleet-crates│              │  D1 storage  │
│  1,540 vecs  │              └──────┬───────┘
│  384-dim BGE │                     │
└──────────────┘                     │
                                     ▼
                              ┌──────────────┐
                              │  Next cycle  │
                              │  allocation  │
                              │  γ + η = C   │
                              └──────────────┘
```

---

## Top Repos by Source Lines

| Repo | Source Lines | Tests | Docs |
|------|-------------|-------|------|
| cudaclaw | 21,735 | ✅ | ✅ |
| hermit-claw | 8,485 | ✅ | ✅ |
| conservation-spectral-topology-rs | 2,168 | ✅ | ✅ |
| cosmic-web | 1,645 | ✅ | ✅ |
| renormalization-group | 1,621 | ✅ | ✅ |
| ternary-compiler | 1,533 | ✅ | ✅ |
| fleet-build | 1,515 | ✅ | ✅ |
| session-miner | 1,475 | ✅ | ✅ |
| hodge-belief-rs | 1,437 | ✅ | ✅ |
