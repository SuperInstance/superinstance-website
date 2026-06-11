# Changelog

## 2026-06-11 — Ecosystem Sprint

### Added
- Z₃ lattice gauge theory (ternary-gauge-theory): Wilson action, Metropolis MC, Gauss's law verification, 11 tests passing
- Honest design pattern paper (TERNARY-DESIGN-PATTERN.md): corrects overclaims from formal isomorphism paper
- Ecosystem website: honest rewrite, no AI slop
- CI/CD workflows: 1,091 repos with GitHub Actions
- 7 agent repos scaffolded: fleet-midi, ghost-track, persona-engine, fleet-conductor, forgemaster, oracle2, construct

### Fixed
- ternary-hamiltonian: replaced clamp_ternary_f64 with proper Z₃ modular arithmetic, 30 tests passing
- 676 Cargo.toml edition fixes (2024 → 2021)
- 1,080 crates: added publishing metadata (description, license, repository)
- 20+ build failures resolved (97.5% pass rate across 1,537 crates)

### Published
- conservation-law 0.1.2
- ternary-cell 0.1.1
- construct-core 0.1.2
- entropy-conservation 0.1.0
- noether-bridge 0.1.0
- ternary-entropy 0.1.0
- ternary-pack 0.1.0
- ternary-matrix 0.1.0
- ternary-hash 0.1.0
- ternary-dispatch 0.1.0
- ternary-graph 0.1.0

### Documentation
- GRAND-SYNTHESIS.md: 4,200 words across 10 sections
- ECOSYSTEM-SYNTHESIS.md: 7 universal cross-domain patterns
- DEPENDENCY-MAP.md: full topology, 15 kernel crates
- ISOMORPHISM-REVIEW.md: honest review proving formal paper invalid
- RESEARCH-FRONTIERS.md: ternary-auto-vectorizer audit
- IMPLEMENTATION-ROADMAP.md: 14-week phased plan
