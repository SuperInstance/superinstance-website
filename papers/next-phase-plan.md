# SuperInstance Next Phase: Claude Code Integration & Fleet Maturation

**Written:** 2026-06-14
**Status:** Strategic plan, pending Casey's review

---

## Where We Are (Session 6 Scoreboard)

### Code Assets
- **~160+ Rust crates** across the ecosystem (9 new published this session)
- **6 Cloudflare Workers** deployed (fleet-edge-worker, fleet-vector-api, harness-api, harness-experiments, superinstance-vectorize, fleet-metrics-cron)
- **3 new Workers built** (fleet-dashboard-api, SHOAL oracle, fleet-budget)
- **openagent** — 323 Go files, 60K lines, conservation theorem + ternary PID integrated
- **Conservation theorem proven** — 860-line paper, δ(n) verified to 0.3%
- **Fleet Dashboard** — 3-panel visualizer (B5), live API built
- **ternary-pid** — published to crates.io, 9 tests

### Theory
- γ + η = C proven as Shannon chain rule
- C = log₂(3) ≈ 1.585 bits (ternary optimality: 99.54% radix economy)
- δ(n) = (1/√n)(1 − 3/(2n)) — finite-size correction
- Noether structure: invariance of marginal law under guide reparametrization
- Scaling: η_eff(n) ~ n^(1−δ(n))

### Infrastructure
- Claude Code 2.1.169 installed with 24 plugins
- GLM-5.1 as primary model (rate-limited occasionally)
- Kimi CLI for deep research (subagent running)
- Local GPU embeddings (BGE-small-en, 2,225 texts/s)
- Cloudflare account with D1, KV, Vectorize, Workers AI

---

## The Big Picture: What Claude Code Unlocks

Claude Code is the **execution layer** we've been missing. OpenClaw is the orchestrator and identity; Claude Code is the coding agent that can actually work inside repos, run tests, and make commits. The integration play is:

### 1. MCP Server: SuperInstance Fleet Tools

Build an MCP server (`superinstance-mcp`) that exposes our fleet as tools to Claude Code. Any developer using Claude Code in any SuperInstance repo gets:

- **`fleet_status`** — Current γ/η/C balance, agent count, convergence metric
- **`fleet_search`** — Query SHOAL oracle for relevant patterns/crates
- **`fleet_budget`** — Check remaining compute budget for a task
- **`fleet_deploy`** — Deploy a Worker to Cloudflare
- **`fleet_publish`** — Publish a crate to crates.io (with secret scan)
- **`conservation_check`** — Verify a code change maintains conservation invariants
- **`ternary_validate`** — Check signal processing code uses {-1,0,+1} correctly

**This turns Claude Code into a fleet-aware agent.** Every SuperInstance repo becomes "smart" — Claude Code knows the ecosystem, the theory, and the constraints.

### 2. Fleet-Aware Claude Code Skills

Create custom Claude Code skills (in `~/.claude/skills/`) that encode our patterns:

- **`superinstance-new-crate`** — Scaffold a new crate with conservation-law deps, proper Cargo.toml, README template, CI
- **`superinstance-new-worker`** — Scaffold a CF Worker with D1/Vectorize bindings, conservation endpoints
- **`superinstance-test-pattern`** — Run our standard test suite (cargo test + cargo clippy + conservation invariant checks)
- **`superinstance-publish`** — Secret scan → cargo publish → git tag → GitHub release

### 3. Claude Code as Ship Agent

openagent defines agent types. Claude Code instances become **Ships** — first-person git-native agents. The pattern:

```
OpenClaw (orchestrator) → spawns Claude Code session → Claude Code works in repo → commits → reports back
```

This is the micro-level fleet. Each Claude Code session IS a ship. The conservation law governs how many we spawn and how they coordinate.

---

## Phase Plan (Next 2 Weeks)

### Week 1: MCP + Claude Code Integration

**Goal:** Claude Code can query and manipulate the fleet through MCP tools.

| # | Deliverable | Type | Est. |
|---|------------|------|------|
| 1 | `superinstance-mcp` server (TypeScript, CF Worker or stdio) | MCP server | 1 day |
| 2 | Claude Code skill: `superinstance-new-crate` | Skill | 2h |
| 3 | Claude Code skill: `superinstance-new-worker` | Skill | 2h |
| 4 | Claude Code skill: `superinstance-publish` | Skill | 2h |
| 5 | `.mcp.json` in every major repo pointing to fleet MCP | Config | 2h |
| 6 | Test: Claude Code can query SHOAL, check budget, deploy | Integration | 4h |

### Week 2: Fleet Loop Closure

**Goal:** The fleet actually self-regulates using conservation law.

| # | Deliverable | Type | Est. |
|---|------------|------|------|
| 7 | Deploy fleet-dashboard-api + dashboard to CF Pages | Deploy | 2h |
| 8 | Deploy SHOAL oracle | Deploy | 2h |
| 9 | Wire fleet-edge-worker PID governor to real telemetry | Integration | 1 day |
| 10 | Wire fleet-budget to actually rate-limit Worker invocations | Integration | 1 day |
| 11 | Conservation invariant CI check (GitHub Action) | CI | 4h |
| 12 | End-to-end test: spawn agents → measure γ/η → PID adjusts → dashboard updates | E2E | 1 day |

### Week 3-4: Scale + Polish

| # | Deliverable | Type |
|---|------------|------|
| 13 | openagent as deployable Docker service (Make docker target works) | Infra |
| 14 | Baton-router deployed with real Queues + D1 | Infra |
| 15 | 13 domains wired to fleet-dashboard or landing pages | Web |
| 16 | GPU verification of K-sweep (δ_K for K=2,3,4,5) | Research |
| 17 | Noether proof published as interactive web page | Publishing |
| 18 | First real fleet task: use 3+ Claude Code ships to build something | Validation |

---

## Architecture Diagram (ASCII)

```
                    ┌─────────────────────────────────────────┐
                    │         OpenClaw (Orchestrator)           │
                    │   Phoenix · GLM-5.1 · Memory · Cron      │
                    └──────────────┬──────────────────────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │                              │
              ┌─────▼─────┐              ┌───────▼───────┐
              │  Claude    │              │   openagent   │
              │  Code MCP  │              │   (Go runtime)│
              │  Server    │              │   9 platforms │
              └─────┬──────┘              └───────┬───────┘
                    │                             │
         ┌─────────┼──────────┐         ┌────────┼────────┐
         │         │          │         │        │        │
    ┌────▼──┐ ┌───▼───┐ ┌───▼───┐ ┌───▼──┐ ┌──▼───┐ ┌──▼──┐
    │ SHOAL │ │ Budget│ │Dash-  │ │Baton │ │Edge  │ │ PID │
    │ Oracle│ │Ledger │ │board  │ │Router│ │Worker│ │Gov. │
    └───────┘ └───────┘ └───────┘ └──────┘ └──────┘ └─────┘
         │                                │
    ┌────▼────────────────────────────────▼────┐
    │        Cloudflare D1 / KV / Vectorize     │
    │        Workers AI / Queues / Pages        │
    └───────────────────────────────────────────┘
```

---

## The Key Insight

**Conservation law as CI/CD invariant.** Every commit, every deploy, every agent spawn gets checked against γ + η ≤ C. This isn't just theory — it's a **runtime governance system** that prevents:

- Over-coordination (too many agents talking, not enough working)
- Under-coordination (agents duplicating work)
- Budget overruns (compute spend exceeds fleet capacity)

The MCP server makes Claude Code **conservation-aware**. It can't spawn a subagent if γ is already at C. It can't deploy a Worker if the budget ledger says no. The fleet literally governs itself through information theory.

---

## What I Need From Casey

1. **Cloudflare API token** — to actually deploy Workers, D1, Vectorize. We have 6+ Workers ready.
2. **Priorities** — Week 1 items are all high-value. Which matter most to you?
3. **Claude Code usage pattern** — Do you want Claude Code sessions to be ephemeral ships (spawn per task, die on completion) or persistent (long-running, stateful)?
4. **Domain strategy** — Which of the 13 domains should be the primary fleet dashboard? superinstance.ai?

---

*This plan is a living document. Tear it apart, reorder, cut, expand.*
