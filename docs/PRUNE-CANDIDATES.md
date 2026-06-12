# Dead Weight Audit — Prune Candidates

**Date:** 2026-06-11  
**Scope:** 346 stub/skeleton crates (< 10 lines in `src/lib.rs`)

## Summary

| Category | Count | Description |
|----------|-------|-------------|
| **KEEP** | ~170 | Active projects, ecosystem infrastructure, crates depended on by others |
| **SEED** | ~144 | Empty stubs describing genuinely useful functionality worth implementing |
| **PRUNE** | 32 | Dead weight — decorative, confusing, or pure math with no software engineering path |

## PRUNE Candidates (32 crates)

These are auto-generated stubs with 0 lines, no README, no tests, no dependents, and names that are either pure abstract mathematics with no practical implementation path, or decorative/random names with no clear purpose.

### Algebraic Topology (16)

Pure abstract math. No path to useful software. Generated en masse as decorative placeholders.

| Crate | Lines | Reason |
|-------|-------|--------|
| `characteristic-class` | 0 | Abstract topology — no implementation value |
| `cup-product` | 0 | Cohomology operation — purely mathematical |
| `exact-sequence` | 0 | Homological algebra concept — not software |
| `excision-axiom` | 0 | Axiom of homology theory — not implementable |
| `gauge-group` | 0 | Lie group theory — no practical path |
| `hopf-invariant` | 0 | Homotopy theory invariant — decorative |
| `kunneth-formula` | 0 | Tensor product of homology — math, not code |
| `lefschetz-fixed` | 0 | Fixed-point theorem — no application |
| `moduli-space` | 0 | Parameter space of geometric structures |
| `noether-theorem` | 0 | Physics theorem — not a library |
| `poincare-map` | 0 | Dynamical systems concept — decorative |
| `sheaf-cohomology` | 0 | Abstract algebraic geometry |
| `spectral-sequence` | 0 | Computational homological algebra |
| `spectral-theory` | 0 | Operator theory — not a Rust library |
| `stiefel-whitney` | 0 | Characteristic class — abstract math |
| `universal-bundle` | 0 | Classifying space theory — not implementable |

### Pure Math — No Implementation Path (6)

| Crate | Lines | Reason |
|-------|-------|--------|
| `reproducing-kernel` | 0 | Functional analysis — no practical Rust library |
| `riemann-surface` | 0 | Complex analysis geometry — decorative |
| `riemann-zeta` | 0 | Number theory function — no practical use |
| `variational-principle` | 0 | Calculus of variations — not a library |
| `weierstrass-approx` | 0 | Approximation theorem — decorative |
| `zorn-lemma` | 0 | Set theory axiom — literally an axiom, not code |

### Decorative / Random / Confusing (10)

| Crate | Lines | Reason |
|-------|-------|--------|
| `canonical-repr` | 0 | Vague — "canonical representation" of what? |
| `channel-harmonics` | 0 | Sounds cool, means nothing specific |
| `evolving-boundary` | 0 | Decorative — no clear domain |
| `evolvable-signal` | 0 | Vague signal processing concept |
| `expanding-search` | 0 | Not a known algorithm or pattern |
| `jarke-barrantes` | 0 | A person's name — not a library concept |
| `periodic-boundary` | 0 | Physics boundary condition — no standalone library |
| `phase-lock` | 0 | Confusing — overlaps with `phase-locked-loop` if that existed |
| `quasicrystal` | 0 | Niche crystallography — no practical library |
| `todoroff-optimizer` | 0 | Named entity — not a known optimization algorithm |

### Dependency Check

**None of the 32 PRUNE candidates are depended on by any other crate.** Safe to remove without breaking anything.

Verified via:
```bash
# For each PRUNE candidate
grep -r "crate-name" /home/phoenix/repos/*/Cargo.toml
```

Zero external dependents found for all 32 crates.

## High-Value SEED Crates (24 worth implementing)

These are empty stubs that describe functionality genuinely useful for a distributed systems / fleet management / compiler platform. Listed in priority order.

### Infrastructure Patterns (Tier 1 — Direct fleet value)

| Crate | Description | Why Valuable |
|-------|-------------|--------------|
| `circuit-breaker` | Fault tolerance pattern | Core resilience for fleet services |
| `rate-limiter` | Rate limiting | Essential for API management |
| `feature-flag` | Feature toggles | Deployment safety across fleet |
| `config-center` | Distributed config | Fleet-wide configuration management |
| `service-discovery` | Service registry | Dynamic fleet node discovery |
| `load-balancer` | Request distribution | Fleet traffic management |
| `health-check` | Health monitoring | Fleet observability |
| `retry-backoff` | Retry with backoff | Resilience for distributed calls |

### Data & Compute (Tier 2 — Platform capabilities)

| Crate | Description | Why Valuable |
|-------|-------------|--------------|
| `key-value-store` | KV storage abstraction | Fleet state management |
| `document-store` | Document database | Log/event storage |
| `time-series-db` | Time series data | Fleet metrics storage |
| `columnar-store` | Columnar storage | Analytics data layout |
| `orchestration-engine` | Task orchestration | Fleet workflow management |
| `container-runtime` | Container abstraction | Fleet deployment |

### Compiler Pipeline (Tier 3 — Expr/VM chain)

| Crate | Description | Why Valuable |
|-------|-------------|--------------|
| `expr-parser` | Expression parsing | Query language foundation |
| `expr-typecheck` | Type checking | Query language safety |
| `expr-eval` | Expression evaluation | Query execution |
| `expr-optimize` | Optimization passes | Query performance |
| `expr-bytecode` | Bytecode compilation | Query compilation |
| `stack-vm` | Stack-based VM | Expression runtime |

### Linux System (Tier 4 — Container/observability stack)

| Crate | Description | Why Valuable |
|-------|-------------|--------------|
| `cgroup-monitor` | cgroup v2 monitoring | Container resource tracking |
| `procfs-scanner` | /proc scanner | Process introspection |
| `seccomp-filter` | Seccomp BPF profiles | Container security |

## KEEP — Crates with Dependencies

These stub crates have **zero lines** but are depended on by other crates. Do NOT prune.

| Crate | Depended On By |
|-------|----------------|
| `fiber-bundle` | `fibration-timing` |
| `superinstance` | `groove-compiler` |
| `cudaclaw` | `cudaclaw-bridge` |
| `lapce` | `open-iterator` |
| `pincher` | `intent-flux-bridge` |
| `logs` | `deno` |
| `tokio` | `deno`, `hermit-claw`, `hermit-zed` |

> ⚠️ **Note:** `tokio` and `logs` are name-shadowing the actual crates. The local stubs will conflict with the real `tokio` and `log` crates on crates.io. Consider renaming or removing these stubs.

## Full Category Breakdown

### KEEP (~170 crates)

All crates with at least one of: README, tests, real module structure, external dependents, or active ecosystem membership (fleet-*, superinstance-*, ternary-*, plato-*, oracle1-*).

Includes but not limited to: all `fleet-*` infrastructure crates, all `superinstance-*` platform crates, all `ternary-*` research crates, all `plato-*` IoT crates, all `oracle1-*` crates, all `beta-test-*` crates, and standalone active projects (deno, claw, git-agent, mud-arena, smartcrdt, etc.).

### SEED (~144 crates)

Empty stubs describing useful functionality. Not dead weight — they're architectural placeholders for a reason. The categories include:

- **Infrastructure patterns:** api-gateway, audit-log, backpressure-regulator, bulkhead-pattern, canary-release, config-center, container-runtime, credential-store, deployment-rollback, dns-resolver, document-store, fallback-strategy, feature-flag, graphql-engine, grpc-client, grpc-server, health-check, identity-vault, image-builder, key-value-store, load-balancer, log-aggregator, log-collector, message-bus, mock-server, node-agent, orchestration-engine, rate-limiter, registry-client, resilience-bus, rest-client, retry-backoff, reverse-proxy, row-store, service-discovery, service-mesh, supervisor-strategy, time-series-db, timeout-guard, trace-exporter
- **gRPC stack:** grpc-codec, grpc-frame, grpc-health, grpc-interceptor, grpc-router
- **UDF system:** udf-loader, udf-registry, udf-runner, udf-sandbox, udf-validator
- **Expr/compiler:** expr-bytecode, expr-eval, expr-optimize, expr-parser, expr-typecheck, ir-optimizer, op-codec, register-vm, stack-vm
- **Data structures:** byte-queue, byte-ring, heap-buffer, interval-tree, ring-buffer, segment-tree, skip-list, skip-list-concurrent, slab-buffer, sparse-matrix, suffix-array
- **Graph algorithms:** graph-astar, graph-bellman-ford, graph-bfs, graph-dfs, graph-dijkstra
- **Crypto:** base58-check, bech32-encode, bip32-derived, ed25519-bip44, slip0010
- **Compression:** gzip-stream, tar-reader, zip-writer, zlib-decoder, zlib-encoder
- **Network:** quic-transport, tcp-listener, tls-server, udp-socket, websocket-server
- **Embedded/HW:** adc-sensor, gpio-pin, i2c-bus, spi-device, uart-bridge
- **Graphics:** cairo-renderer, gradient-fill, svg-path
- **Actor system:** actor-context, actor-mailbox, actor-ref
- **Observability:** bench-runner, clip-quantize, composite-metric, dashboard-render, metric-recorder, property-test, snapshot-test, test-harness
- **Protobuf/Thrift:** protobuf-codec, protobuf-lite, thrift-protocol, thrift-binary
- **Codec:** cbor-stream, msgpack-value
- **Linux system:** cgroup-monitor, namespace-isolate, procfs-scanner, rlimit-set, seccomp-filter
- **Algorithms:** convex-hull-graham, hungarian-algorithm, knapsack-solver, stable-marriage, sort-heap, sort-merge, sort-quick, sort-radix, sort-tim, ackermann-function, fenwick-tree, polynomial-root
- **Math/Physics (with practical paths):** bayesian-inference, cell-automaton, fluid-sim, laplace-transform, mandelbrot-set, particle-system, power-spectrum, rigid-body, sampling-theory, scalar-field, simplex-method, spring-physics, stochastic-process
- **ML/AI:** falcon-7b-tools, entropy-flow-rs, fuzz-engine, wasm-interpreter
- **Docs/Tooling:** doc-generator, columnar-store, energy-budget, poison-pill, ledger-journal

## Recommendations

1. **Delete the 32 PRUNE crates** — zero dependents, zero value, decorative names
2. **Prioritize implementing Tier 1 SEED crates** — circuit-breaker, rate-limiter, feature-flag, config-center, service-discovery
3. **Rename or remove `tokio` and `logs` stubs** — they shadow real crates and will cause confusion
4. **Don't touch KEEP or SEED** — SEED crates are architectural placeholders with real intent behind them

---

*No crates were harmed in the making of this audit.*
