# SuperInstance Ecosystem Roadmap

**Generated:** 2026-06-11  
**State:** 1,605 repos · 967 REAL · 448 STUB · 79 SKELETON · 34 crates on crates.io · 5 CF Workers live · 1,012 crates indexed · 97.5% build pass rate

---

## Near-Term (Next 2 Weeks)

### 1. Leverage Deployed CF Infrastructure

The vector search API, edge worker, auth layer, and metrics cron are live but underutilized.

- **Crates.io sync worker:** Nightly cron that detects newly published crates, fetches metadata, and upserts into the vectorize index. Replaces the manual embed pipeline.
- **Semantic dependency resolver:** Given a crate name, use vector similarity to suggest dependency candidates. Build a `fleet suggest-deps <crate>` CLI command backed by the vector API.
- **Quality dashboard:** The metrics cron already runs every 5 min — build a simple HTML dashboard (Canvas or static) that surfaces build pass rates, test counts, and publishing wave progress. Host on the edge worker.
- **Auth-gated API keys:** The fleet-auth worker (D1 + KV) is deployed but unused. Add API key issuance so external consumers can hit the vector search endpoint without open access.

### 2. Stub Promotion Priority

448 stubs represent dead weight. Prioritize by cross-domain impact:

| Priority | Crate | Reason |
|----------|-------|--------|
| P0 | `superinstance-protocol` | Fleet coordination depends on this; blocks all fleet work |
| P0 | `fleet-scheduler` | Required for any distributed task execution |
| P1 | `ternary-autodiff` | Enables gradient computation across the ternary stack |
| P1 | `oxide-kernel` | WASM runtime core; unblocks browser-based demos |
| P1 | `tensor-shape` | Shape inference needed by tensor-midi, tensor-harmony, etc. |
| P2 | `config-merge` | Multi-source config composition; useful everywhere |
| P2 | `wasm-ternary` | Ternary arithmetic in WASM; demo material |
| P2 | `plato-tile-index` | Enables fast tile lookup for the 7,800 remaining tiles |

### 3. CI Integration with Vector Search

- **Smart test selection:** On a PR, diff changed files → embed the diff → query vector API for semantically related test files. Only run relevant tests instead of the full suite. Could cut CI time by 60-80% for large repos.
- **Publish gate check:** GitHub Action that verifies Cargo.toml has description + license + repository before allowing `cargo publish`. Prevents the "forgot metadata" problem.

---

## Medium-Term (Next 2 Months)

### 1. Knowledge Graph

The vector index gives us semantic similarity. We also need **structural** connections.

- **Dependency graph:** Parse `Cargo.toml` files across all 1,605 repos to build a real dependency DAG. Store as edges in D1 or a dedicated graph store.
- **Semantic + structural fusion:** Combine dependency edges with vector similarity to create a weighted knowledge graph. Crates that depend on each other AND are semantically similar get higher edge weight.
- **Graph queries:** "What crates would break if I change `ternary-types`?" → graph traversal. "What's the most central crate?" → PageRank on the dependency graph.
- **Visualization:** Generate an interactive D3 or Excalidraw map of the ecosystem. The existing `ternary-deps.dot` is a start but only covers ternary.

### 2. Auto-Doc Generation

448 stubs have no real documentation. Workers AI can help.

- **README generator:** For each stub, send the public API surface (function signatures, type definitions) to Workers AI (`@cf/meta/llama-3-8b-instruct`) and generate a README explaining what the crate does.
- **Doc comment backfill:** Parse `src/` files, find undocumented public items, generate doc comments. Human review before commit.
- **Quality scoring:** Rate generated docs by checking: does the README reference actual API items? Does it include usage examples? Auto-reject low-quality output.

### 3. Fleet Protocol Implementation

`superinstance-protocol` is the P0 blocker for the entire fleet domain.

- **Transport layer:** WebSocket-based message passing with JSON-RPC framing. Start simple, optimize later.
- **Node discovery:** mDNS for local, CF Durable Objects for global. Each node advertises capabilities (compute, storage, GPU).
- **Task distribution:** Round-robin with capability matching. Agent submits a task manifest, scheduler assigns to compatible nodes.
- **Failure handling:** Heartbeat-based liveness. Task reassignment on timeout. Exactly-once semantics via idempotency keys.
- **Milestone:** Two agents on separate machines coordinating a build-and-test cycle via the protocol.

### 4. PLATO Tile Extraction

- 7,800 tiles remaining out of an estimated 8,000+ total corpus.
- **Parallel extraction:** The extraction pipeline is CPU-bound. Distribute across fleet nodes once the protocol is live.
- **Quality verification:** Cross-reference extracted tiles against known correct patterns. Flag anomalies for human review.
- **Integration:** Index extracted tiles into the vector search API so they're discoverable alongside crates.

---

## Experimental / High-Risk

These are moonshots. Failure is expected; success would be extraordinary.

### 1. Gauge-Coupled Bottles

The bottle protocol in `superinstance-ecosystem` already formalizes message containers. What if we add **local gauge symmetry**?

- In physics, gauge invariance means the physics doesn't change under local transformations. In fleet coordination, this would mean a node can locally transform its internal state without affecting the global protocol.
- **Hypothesis:** Gauge-coupled coordination would let nodes self-optimize without centralized control, while maintaining global consistency through gauge fields (like electromagnetic fields mediating between charged particles).
- **Implementation:** Extend `bottle_protocol.py` with gauge field metadata. Each bottle carries a gauge potential; nodes apply gauge transformations on receive.
- **Risk:** Might be pure abstraction with no practical benefit. But if it works, it's a new paradigm for distributed systems.

### 2. Ternary Auto-Vectorizer

Can we automatically detect patterns in binary code that map to ternary operations, and vectorize them?

- **Approach:** Train a small model on known ternary↔binary mappings. Use it to identify opportunities in hot loops.
- **Benchmark:** Compare auto-vectorized ternary code against hand-optimized binary on matrix multiply, convolution, and sorting.
- **Paper potential:** If we show >2x speedup on real workloads, this is an MLSys or PLDI submission.
- **Risk:** Ternary hardware doesn't exist at scale, so all benchmarks would be simulation. Reviewers might not care.

### 3. Cross-Domain Transfer: Music → Fleet

The ecosystem has deep connections between music theory (agent-motif, agent-harmonic-field, spectral-prosody) and fleet coordination (fleet-build, fleet-mapper, fleet-scheduler).

- **Hypothesis:** Musical counterpoint (independent voices that harmonize) could improve multi-agent coordination. Agents as voices, tasks as melodic lines, constraints as harmonic rules.
- **Test:** Implement a counterpoint-based scheduler and compare against round-robin on synthetic fleet workloads.
- **Risk:** The metaphor might not survive contact with reality. Real fleet scheduling has constraints (latency, failure modes) that don't map to harmony.

### 4. Self-Improving Corpus

Agents that write better agents. The ecosystem already generates crates; can it evaluate and improve its own output?

- **Loop:** Agent generates a crate → test suite runs → quality metrics collected → feedback fed to next generation → iterate.
- **Scaffold:** Start with `readme-generator` (1,270 lines, 23 tests). Can an agent improve its own README generation by analyzing which READMEs get the most engagement?
- **Risk:** Degenerate loops where agents optimize for metrics rather than real quality. Needs strong evaluation signals.

---

## Revenue / Product Ideas

These are speculative but grounded in existing capabilities.

### 1. Ternary Computing SDK

**What:** A SDK for hardware designers exploring ternary (3-state) logic. Includes gate simulators, circuit builders, and a compiler backend (`ternary-compiler`).

**Why now:** 362 ternary crates exist. The compiler backend (1,849 lines, 55 tests) is real code. Quantum computing is driving interest in non-binary computation.

**Model:** Open-source core + paid support/consulting. Target: research labs, semiconductor companies, CS departments.

**Revenue potential:** Low near-term ($10-50K/yr consulting). High if ternary hardware takes off.

### 2. Vector Search as a Service

**What:** Generalize the fleet-vector-api to index any crate ecosystem, not just SuperInstance.

**Why now:** The infrastructure is live. Workers AI embeddings work. The search endpoint handles POST /search with topK.

**Model:** Free tier (1,000 queries/day) + paid ($0.001/query). Enterprise (dedicated index, custom embeddings).

**Revenue potential:** $500-2K/mo at scale. More valuable as a feature than standalone product.

### 3. Fleet Management SaaS

**What:** A hosted version of the fleet coordination stack. Edge computing customers manage distributed nodes through a dashboard.

**Why now:** 5 Cloudflare Workers are deployed. The protocol is being built. The auth layer exists.

**Model:** Per-node pricing ($5/node/month). Dashboard + monitoring + deployment included.

**Revenue potential:** $5-20K/mo with 100-500 nodes. Requires the protocol to be production-ready first.

### 4. Knowledge Extraction API (Generalized PLATO)

**What:** The PLATO tile extraction pipeline extracts structured knowledge from unstructured sources. Generalize this as an API.

**Why now:** PLATO has real extraction code. The pipeline processes documents into structured tiles. The vector search indexes them.

**Model:** Per-document pricing. Free tier (100 docs/month). $0.10/doc for paid. Enterprise with custom extraction rules.

**Revenue potential:** $2-10K/mo. Strongest product-market fit of the four — document processing is a known market.

---

## Success Metrics

| Metric | Current | 2-Week Target | 2-Month Target |
|--------|---------|---------------|----------------|
| Published crates | 34 | 54 (+20 wave 5) | 100+ |
| REAL repos | 967 | 980 | 1,050 |
| STUB repos | 448 | 430 | 350 |
| Vector index | 1,012 crates | 1,200 | All REAL crates |
| Fleet protocol | Not started | Spec complete | Two-node demo |
| PLATO tiles | ~200 extracted | 500 | 3,000 |
| CF Workers | 5 | 7 (+sync, dashboard) | 10 |
| Build pass rate | 97.5% | 98% | 99% |
| Knowledge graph | None | Dependency DAG | Fused graph |
| Revenue | $0 | $0 | First paying user |

---

## Wave 5 Publishing (Next Batch)

See `/tmp/wave5-candidates.txt` for the full candidate list. Priority order:

1. **cudaclaw** — 32,241 lines, 352 tests. Flagship compute crate.
2. **hermit-claw** — 10,186 lines, 419 tests. AI assistant core.
3. **conservation-spectral-topology-rs** — 2,844 lines, 120 tests. Physics-based conservation laws.
4. **renormalization-group** — 2,122 lines, 61 tests. Multi-scale analysis.
5. **cosmic-web** — 2,061 lines, 61 tests. Cosmological fleet architecture.
6. **spectral-fleet** — 2,086 lines, 39 tests. Spectral analysis for fleet.
7. **ternary-compiler** — 1,849 lines, 55 tests. Ternary logic backend.
8. **fleet-build** — 1,826 lines, 61 tests. Build automation CLI.
9. **session-miner** — 1,752 lines, 24 tests. Transcript pattern mining.
10. **hodge-belief-rs** — 1,826 lines, 39 tests. Belief decomposition.
11. **error-forest** — 1,901 lines, 46 tests. Error taxonomy.
12. **ternary-coordination** — 1,884 lines, 75 tests. Ternary agent coordination.
13. **witness-topology** — 1,835 lines, 38 tests. Topological witnesses.
14. **symplectic-fleet** — 1,822 lines, 36 tests. Symplectic geometry for fleet.
15. **dial-theory** — 1,817 lines, 45 tests. Relational framework.
16. **dial-ecology** — 1,744 lines, 68 tests. Ecosystem dynamics.
17. **ferment-constraints** — 1,731 lines, 49 tests. Constraint solver.
18. **spectral-prosody** — 1,719 lines, 65 tests. Spectral speech analysis.
19. **meta-agent** — 1,715 lines, 30 tests. Self-improving agents.
20. **plato-dashboard** — 1,690 lines, 50 tests. PLATO visualization.

---

*This roadmap is a living document. Update as priorities shift and experiments succeed or fail.*
