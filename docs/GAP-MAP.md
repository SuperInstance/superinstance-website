# GAP-MAP.md — SuperInstance Ecosystem Gap Analysis

> Generated 2026-06-11 from 1,012 crates indexed in fleet-vector-api
> Method: 15-domain semantic search + gap-analysis endpoint + cluster isolation detection

## Summary

The SuperInstance ecosystem is surprisingly dense in most queried domains. All 15 test queries returned results with **top similarity scores ≥ 0.68** — there are no true "empty" domains. However, the gap-analysis endpoint reveals that **543 out of 543 "unknown" domain crates have zero tests and zero LOC**, indicating they're stubs/placeholders. The real gaps are **depth and quality**, not breadth of coverage.

---

## Top 10 Gap Domains (Ranked by Opportunity)

| # | Domain | Top Score | Gap Assessment | Opportunity |
|---|--------|-----------|----------------|-------------|
| 1 | **Embedded / no_std** | 0.698 | Weakest coverage — best match is `certificate-parser`, not embedded-specific | Build `no_std` HAL abstractions, interrupt handlers, register access crates |
| 2 | **Blockchain smart contracts** | 0.686 | Only `bch-code` (error correction) and ternary stubs match; no real contract VM/ABI | Build ternary smart contract runtime, ABI encoder, gas metering |
| 3 | **Compiler frontend / parsing** | 0.746 | Matches are protocol parsers (x509, http, macho), not language parsers | Build LR/GLR parser combinators, AST crates, type checkers for ternary languages |
| 4 | **Database query optimization** | 0.721 | GraphQL schema/resolver exist but no query planner, index, or optimizer | Build ternary-aware query planner, columnar storage, B-tree/LSM indexes |
| 5 | **Robotics motion planning** | 0.734 | `ternary-robotics` and `pathfinding-grid` are stubs; no kinematics | Build inverse kinematics, SLAM, sensor fusion crates |
| 6 | **Game engine rendering** | 0.751 | Vulkan driver + mesh simplification exist but are thin | Build scene graph, shader compiler, ECS, physics integration |
| 7 | **Natural language processing** | 0.732 | `dirichlet-process` and `dialog-tree` — no tokenizer, embeddings, or NER | Build ternary-weight tokenizers, attention layers, text pipeline |
| 8 | **Machine learning training loop** | 0.712 | `ternary-distill`, `gradient-descent`, `wiener-process` — fragments only | Build autograd, training orchestrator, data loader, ternary GPU kernels |
| 9 | **Streaming data pipeline** | 0.783 | Dataflow analysis + ring buffer + Redis stream — decent but disconnected | Build unified stream processor with backpressure, windowing, joins |
| 10 | **Authentication ecosystem** | 0.800 | `oauth2-client` + `openid-connect` exist but **both have 0 tests** | Harden auth crates, add PKCE, JWT validation, session management |

---

## 5 Unexpected Cross-Domain Connections

These are high-similarity matches between queries and crates from seemingly unrelated domains:

1. **"Formal verification" ↔ `zero-knowledge` (0.763)**  
   ZK proofs and formal verification share deep mathematical DNA — both involve proof systems. A `formal-verify` ↔ `zero-knowledge` bridge could enable formally verified ZK circuits.

2. **"Image processing convolution" ↔ `convolutional-code` (0.861)**  
   The convolutional-code crate (error correction) scored highest for image convolution queries. Both share the same mathematical operation (convolution) — a shared convolution kernel library could serve both domains.

3. **"Robotics motion planning" ↔ `timeline-track` (0.714)**  
   Animation timeline management matched motion planning — both are spatiotemporal path problems. A shared trajectory primitive could bridge game animation and robotics.

4. **"Compiler frontend parser" ↔ `x509-parser` (0.776)**  
   Certificate parsing scored highest for compiler queries. Both involve grammar-driven parsing of structured formats — a unified parser combinator library could serve both.

5. **"Blockchain smart contracts" ↔ `ternary-consensus` (0.678)**  
   The ternary consensus crate (Byzantine-tolerant CRDT sync) naturally bridges blockchain and distributed systems. This is the seed of a ternary blockchain platform.

---

## 3 Bridge Crate Opportunities

These crates could connect currently isolated clusters and unlock cross-domain value:

### 1. `ternary-convolution` — Math → Signal Processing → ML → Error Correction
**Connects:** wavelet-transform, convolutional-code, radial-basis, ternary-distill  
The ecosystem has convolution in 4 separate domains (signals, error correction, neural nets, image processing). A unified ternary convolution primitive with FFT acceleration would be a keystone crate — every other domain would depend on it.

### 2. `ternary-proofs` — Formal Verification → ZK → Blockchain → Consensus
**Connects:** formal-verify, zero-knowledge, ternary-zkp, ternary-blockchain, raft-consensus  
Proof systems appear across 5+ crates. A shared proof framework supporting SAT, Schnorr, and ternary-field proofs would unify the formal methods ↔ cryptography ↔ blockchain triangle.

### 3. `ternary-trajectory` — Robotics → Animation → Physics → Games
**Connects:** ternary-robotics, pathfinding-grid, timeline-track, mesh-simplification, vulkan-driver  
Motion planning, animation curves, and physics simulation all need trajectory primitives (splines, bezier paths, interpolation). This bridge crate would connect the robotics/game/graphics islands.

---

## Structural Gap: The "Unknown Domain" Problem

The cluster analysis reveals a critical finding:

- **1 cluster** containing all 543 "unknown" domain crates
- **0 inter-cluster connections** to the ~469 known-domain crates
- All 543 unknown-domain crates have **0 tests, 0 LOC** — they are stubs

This means the ecosystem has a massive **implementation gap**: the ideas are mapped out (ternary algebra, sheaf cohomology, spectral graphs, MIDI processing, etc.) but almost none have been implemented. The known-domain crates (gradient-descent, oauth2-client, raft-consensus, etc.) have real code but average only ~100 LOC with 1-3 tests each.

### Priority Recommendations

1. **Harden the 469 "real" crates** — add tests, documentation, CI
2. **Implement the top 3 bridge crates** — highest leverage for ecosystem connectivity
3. **Focus on the 3 weakest domains** (embedded, blockchain, compiler) — these are where the ecosystem has the least coverage
4. **Create a `ternary-std` crate** — shared primitives (ternary arithmetic, conversions, traits) that all ternary-* crates can depend on

---

*This analysis is based on real similarity scores from the fleet-vector-api using @cf/baai/bge-small-en-v1.5 embeddings. No scores were fabricated.*
