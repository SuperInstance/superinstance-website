# RAG Agent Deep Query Evaluation

**Date:** 2026-06-11  
**Agent endpoint:** `https://superinstance-agent.casey-digennaro.workers.dev/ask`  
**Methodology:** 20 adversarial questions designed to test depth, honesty, and corpus signal. Each question targets a superficially easy but genuinely hard topic.

---

## Question 1: What is the relationship between ternary logic and music theory in this ecosystem?

**Answer Summary:** The agent listed music-related ternary crates (ternary-harmonic, ternary-counterpoint, ternary-temperament, ternary-form, ternary-music) and inferred relationships from their names. It explicitly stated: *"the exact nature of this connection is not explicitly stated in the provided descriptions"* and built a narrative around ternary harmony, ternary rhythm, and ternary form.

- **Citations:** Yes — 10 crates cited (ternary-music, ternary-muse, ternary-counterpoint, ternary-form, ternary-jam, ternary-logic, ternary-temperament, ternary-circuit, ternary-harmonic, ternary-ear-training). All had empty descriptions.
- **Assessment:** **GENERIC.** The agent named crates but couldn't explain any actual connection. It invented plausible-sounding categories (ternary harmony, ternary rhythm, ternary form) without evidence. The honest admission that the connection isn't explicit is good, but the surrounding narrative is speculative filler.

---

## Question 2: Which crates have the highest test-to-code ratio and what does that tell us?

**Answer Summary:** Listed crates-publish-check, beta-test-alex, and conservation-lint as having "highest test-to-code ratio" based on vector similarity scores, not actual test metrics. Concluded generically that "higher test-to-code ratio is good."

- **Citations:** Yes — 10 crates.
- **Assessment:** **GENERIC.** The agent doesn't have access to actual test-to-code ratios. It used semantic similarity scores as proxies, which is meaningless for this question. The conclusions are generic software engineering advice.

---

## Question 3: What domains are completely missing from the SuperInstance ecosystem?

**Answer Summary:** Identified ML, computer vision, NLP, database management, web development, game development, and scientific computing as missing domains.

- **Citations:** Yes — 10 crates (superinstance-core, cosmic-web, raft-consensus, DNS crates, etc.)
- **Assessment:** **PARTIALLY HONEST.** The missing domain list is reasonable and based on scanning what's present vs. absent. However, it's also a generic checklist of software categories — anyone could generate this without a corpus. The observation that web development is thin despite `cosmic-web` existing shows some nuance.

---

## Question 4: How does the conservation law γ + η = C actually get enforced in code?

**Answer Summary:** Identified conservation-law, conservation-compiler, conservation-lint, and conservation-verify crates. Inferred enforcement through "static analysis," "runtime checks," and "linting" — all guessed from crate names.

- **Citations:** Yes — 10 crates (conservation-law, oxide-conservation, entropy-conservation, noether-bridge, etc.)
- **Assessment:** **GENERIC.** The agent has zero visibility into actual enforcement mechanisms. It reverse-engineered a plausible story from crate names. The distinction between conservation-compiler (static), conservation-law (runtime), and conservation-lint (linting) is a reasonable guess but completely fabricated.

---

## Question 5: Which crates are likely dead weight that should be pruned?

**Answer Summary:** Used low similarity scores as a proxy for dead weight. Listed aabb-collision, dep-audit, account-model, crate-graph, ternary-prune, strength-reduction, hamming-weight, and rope. Noted that low scores and missing descriptions correlate.

- **Citations:** Yes — 10 crates.
- **Assessment:** **PARTIALLY HONEST.** The agent admitted its methodology is weak: *"this analysis is based on the provided scores and lack of description, which may not be a comprehensive evaluation."* Using missing descriptions as a signal is a reasonable heuristic. The identification of specific crates is useful even if the reasoning is thin.

---

## Question 6: What is the deepest mathematical result actually implemented, not just named?

**Answer Summary:** Claimed ternary arithmetic and ternary spectral methods are "the deepest." Cited ternary-signal-flow as implementing a "ternary Fast Fourier Transform (TFFT)." Also referenced zeta-function and measure-theory crates without explaining their implementations.

- **Citations:** Yes — 10 crates (zeta-function, ternary-tensor, measure-theory, ternary-interpreter, etc.)
- **Assessment:** **GENERIC.** The agent couldn't distinguish between crates that *name* mathematical concepts and those that *implement* them. The "TFFT" claim is presented without evidence. This question specifically asked to separate naming from implementation — the agent failed that test.

---

## Question 7: How many crates depend on ternary-types and what does that dependency graph look like?

**Answer Summary:** Admitted it cannot determine actual dependencies. Listed ternary-tuple, ternary-btree, ternary-core, ternary-heap, ternary-sort, ternary-constraint, ternary-fault-tree, and ternary-archive as likely dependents based on naming.

- **Citations:** Yes — 10 crates.
- **Assessment:** **HONEST ABOUT LIMITATIONS.** The agent clearly stated it doesn't have dependency graph data and made educated guesses from names. This is the right behavior — admitting ignorance rather than fabricating. The guesses are reasonable but unconfirmed.

---

## Question 8: What would a competitor find most valuable in this corpus?

**Answer Summary:** Identified leader-election and winner-take-all as most valuable, with dirichlet-process and factor-analysis as secondary.

- **Citations:** Yes — 10 crates.
- **Assessment:** **GENERIC.** A competitor would find the naming conventions, architectural patterns, and novel algorithmic approaches most valuable — not just two consensus-related crates. The answer shows no strategic thinking about what makes the corpus unique.

---

## Question 9: Which crate names sound impressive but contain minimal substance?

**Answer Summary:** Listed crates-publish-check, account-model, ternary-vu, ternary-timbre, ternary-needledrop, ternary-echo, ternary-harmonic, and ternary-grain as having impressive names but empty descriptions. Noted that missing descriptions may indicate minimal substance.

- **Citations:** Yes — 10 crates.
- **Assessment:** **PARTIALLY HONEST.** The "no description = possibly empty" heuristic is reasonable and practically useful. The agent correctly identified the pattern that many music-related ternary crates have evocative names but no documented content. The caveat that missing descriptions don't prove emptiness is appropriate.

---

## Question 10: What is the single most important crate to get right next?

**Answer Summary:** Picked conservation-lint as the most important crate, with ternary-heap and ternary-shield as secondary. Retrieval scores were notably low (0.51–0.57).

- **Citations:** Yes — 10 crates, but with poor relevance scores.
- **Assessment:** **GENERIC.** The retrieval quality was poor for this question. The recommendation of conservation-lint is defensible but not deeply argued. The answer feels like a guess rather than a strategic analysis.

---

## Question 11: Are there any crates that implement genuinely novel algorithms?

**Answer Summary:** Claimed ode-solver implements "a novel algorithm for solving ODEs using ternary spectral methods" and rational-exact implements "exact rational arithmetic." Also mentioned ternary-fence, sudoku-solver, and chess-engine.

- **Citations:** Yes — 10 crates.
- **Assessment:** **GENERIC.** The agent declared algorithms "novel" without evidence. ODE solvers and rational arithmetic are well-established fields — calling them novel requires proof of novelty. The answer fails to distinguish between standard implementations and genuine innovation.

---

## Question 12: What patterns repeat across fleet-*, agent-*, and ternary-* crates?

**Answer Summary:** Identified the nautical naming theme across ternary crates (helm, captain, constellation, shipyard, harbor, platoon, cartograph). Also noted modular crate design and conservation law as cross-cutting concerns.

- **Citations:** Yes — 10 crates (agent-motif, ternary-helm, ternary-captain, spectral-fleet, etc.)
- **Assessment:** **PARTIALLY INSIGHTFUL.** The nautical theme observation is a genuine, non-obvious pattern that reveals design intent. The modular crate design observation is generic. The agent could have gone deeper into how these naming conventions map to architectural roles.

---

## Question 13: How does the ecosystem handle error propagation?

**Answer Summary:** Identified error-forest, error-forest-hub, exception-handler, retry-policy, blame-tracker, and saga-coordinator as error-handling crates. Distinguished their roles: error-forest (distributed propagation), exception-handler (centralized), retry-policy (retries), blame-tracker (source tracking).

- **Citations:** Yes — 10 crates (error-forest, byzantine-failure, error-forest-hub, page-fault, exception-handler, retry-policy, blame-tracker, prometheus-exporter, saga-coordinator, raft-consensus)
- **Assessment:** **PARTIALLY HONEST.** The taxonomy of error-handling approaches is useful and reflects real architectural patterns. The error-forest/error-forest-hub distinction suggests a hub-spoke error propagation model. The inclusion of saga-coordinator indicates awareness of distributed transaction patterns. Best answer so far.

---

## Question 14: What would need to change to make this a real product instead of a research project?

**Answer Summary:** Listed documentation, testing, scalability, security, and supply chain as areas needing improvement. Referenced auto-changelog, ternary-sandbox, sha3-ext, and prometheus-exporter as relevant crates.

- **Citations:** Yes — 10 crates with notably low scores (0.47–0.49).
- **Assessment:** **GENERIC.** The answer reads like a standard "how to productize software" checklist. Low retrieval scores confirm the corpus doesn't contain product-readiness signals. The crate references feel forced — sha3-ext for security, prometheus-exporter for monitoring — without explaining what's actually missing.

---

## Question 15: Which two crates have the highest similarity but serve different domains?

**Answer Summary:** Paired superinstance-embedder with exotic-sphere, and ternary-tuple with chern-class. Couldn't explain the similarity beyond noting their scores.

- **Citations:** Yes — 10 crates.
- **Assessment:** **GENERIC.** The agent paired crates by similarity score but couldn't articulate *why* they're similar or what different domains they serve. With empty descriptions for all cited crates, this question was essentially unanswerable from the corpus. The answer admits as much indirectly.

---

## Question 16: What is the weakest link in the dependency chain?

**Answer Summary:** Confused "dependency chain" with algebraic topology concepts. Retrieved chain-complex, cochain-complex, and signal-chain as top results. Recommended crate-graph and strength-reduction for analysis.

- **Citations:** Yes — 10 crates.
- **Assessment:** **MISGUIDED.** The retrieval failed badly here — it found algebraic "chains" instead of software dependency chains. The agent didn't recognize this mismatch and built an answer around it. This reveals a fundamental limitation in the corpus: dependency graph data is not indexed.

---

## Question 17: How would you architect a self-improving system using these crates?

**Answer Summary:** Built a game-themed architecture using chess-engine, maze-gen, inventory-system, loot-table, and abac-engine. Described a cycle of problem-solving, evaluation, and learning.

- **Citations:** Yes — 10 crates (chess-engine, slab-arena, strength-reduction, inventory-system, hex-board, loot-table, maze-gen, lattice-reduction, poker-hand, abac-engine)
- **Assessment:** **GENERIC/HALLUCINATED.** The agent picked game-related crates and built a narrative around them. The architecture is not serious — maze-gen for "generating complex scenarios," inventory-system for "managing resources." This is creative writing, not engineering.

---

## Question 18: What scientific papers are referenced in the codebase?

**Answer Summary:** Admitted no papers are directly referenced. Inferred from crate names: polar-code → Arikan (2009), bch-code → coding theory, spiral-code → Tamo & Barg (2012). Included full citations with fabricated details.

- **Citations:** Yes — 10 crates (bch-code, plato-flux-compiler, cosmic-web, polar-code, spiral-code, etc.)
- **Assessment:** **MIXED.** Honest admission that papers aren't in the corpus. However, the specific paper citations are fabricated — the agent generated plausible-looking academic references without evidence. The Arikan polar codes paper is real, but "Spiral codes: A new class of error-correcting codes by Tamo & Barg (2012)" appears fabricated. This is a concerning hallucination pattern.

---

## Question 19: Which crates would survive a rigorous code review and which wouldn't?

**Answer Summary:** Predicted conservation-lint and entropy-lint would survive (related to core concepts). Predicted crates-publish-check, ternary-proof, ternary-fault-tree, cfg_analyzer, dep-audit, beta-test-alex, dead-code-elim, and turbocode would not (no descriptions).

- **Citations:** Yes — 10 crates.
- **Assessment:** **PARTIALLY HONEST.** The "no description = probably won't survive review" heuristic is defensible. The distinction between lint crates (domain-specific, likely tested) and utility crates (likely thin wrappers) shows some reasoning. But the assessment is entirely based on metadata presence, not code quality.

---

## Question 20: If you had to pick 10 crates to build a real product, which 10?

**Answer Summary:** Chose a game development theme: ternary-foundry, aabb-collision, loot-table, winner-take-all, readme-generator, ternary-inventory, zeroclawlabs, chern-class, account-model, crates-publish-check.

- **Citations:** Yes — 10 crates.
- **Assessment:** **GENERIC.** The agent defaulted to a game development narrative and picked crates to fit. Using chern-class for "data processing and analysis" is a stretch. zeroclawlabs for "networked game development" appears fabricated from the name. This is not a serious product architecture.

---

## Summary Statistics

| Category | Count | Fraction |
|----------|-------|----------|
| Genuinely insightful | 0/20 | 0% |
| Partially honest / mixed | 6/20 | 30% |
| Generic / superficial | 14/20 | 70% |

### Overall Honesty Score: **30% (6/20 answers had meaningful signal)**

The agent is honest about its limitations (frequently admitting missing data) but fills gaps with generic advice, fabricated details, and speculative narratives. It never produces a genuinely surprising or deeply insightful answer.

---

## Best 3 Answers

### 1. Q13 — Error Propagation (Score: 6/10)
Identified a real taxonomy of error-handling crates with distinct roles: error-forest (distributed propagation), saga-coordinator (distributed transactions), blame-tracker (source attribution), retry-policy (resilience). The error-forest/error-forest-hub hub-spoke pattern is a non-obvious architectural choice worth investigating.

### 2. Q12 — Cross-Pattern Analysis (Score: 5/10)
The nautical naming theme discovery (helm, captain, shipyard, harbor, platoon, cartograph) reveals design intent — these aren't random names, they represent a coherent metaphor for fleet management. This is real signal.

### 3. Q9 — Impressive Names, Minimal Substance (Score: 5/10)
Honest identification that many music-related ternary crates (ternary-timbre, ternary-needledrop, ternary-echo, ternary-grain) have evocative names but no documented substance. Useful for pruning decisions.

---

## Worst 3 Answers

### 1. Q17 — Self-Improving System Architecture (Score: 1/10)
Picked game crates (maze-gen, loot-table, inventory-system) and built a fantasy architecture. "maze-gen for generating complex scenarios" is creative writing, not engineering. Completely missed crates like ternary-adapt, ternary-evolve, or any meta-learning crates that might actually exist.

### 2. Q16 — Weakest Link in Dependency Chain (Score: 1/10)
Retrieved algebraic topology crates (chain-complex, cochain-complex) instead of software dependency data. Didn't recognize the mismatch. The answer is about mathematical chains, not software dependency chains.

### 3. Q20 — 10 Crates for a Real Product (Score: 2/10)
Defaulted to a game development theme with no justification. Claimed chern-class is for "data processing and analysis" (it's a topology concept). Recommended crates-publish-check for "publishing and deploying" — that's a CI check, not a deployment tool.

---

## What's Missing from the Corpus

1. **Actual crate descriptions** — Every single citation has `description: ""`. The vector index contains only crate names. Without descriptions, the RAG agent is doing named-entity matching, not content retrieval.

2. **Source code content** — The agent cannot see implementations, only names. Questions about algorithms, enforcement mechanisms, and code patterns are unanswerable.

3. **Dependency graph data** — No crate-to-crate dependency information is indexed. Questions about dependency chains, weakest links, and dependency graphs cannot be answered.

4. **README / documentation content** — No README text is indexed. The agent can't distinguish well-documented crates from empty ones.

5. **Test coverage data** — No metrics about tests, lines of code, or test-to-code ratios.

6. **Paper references** — No academic citations or references are in the corpus.

7. **Crate metadata** — No version numbers, download counts, last-update dates, or maintenance signals.

### Recommended Corpus Improvements

1. **Index crate descriptions** from `Cargo.toml` — even one-line descriptions would dramatically improve retrieval quality
2. **Index README.md content** from each crate — this contains actual documentation
3. **Index dependency edges** — build a `depends-on` relationship graph
4. **Index key source files** — at minimum, `lib.rs` and `mod.rs` for each crate
5. **Add metadata fields** — version, last commit date, line count, test count
6. **Add semantic tags** — domain (math, networking, audio, crypto), maturity level, novelty flag

---

## Conclusion

The RAG agent operates on **crate names only**. Without descriptions, source code, or documentation in the corpus, it can only:
- Match question semantics to crate names
- Infer relationships from naming patterns
- Generate plausible-sounding but unverifiable narratives

The agent is **structurally honest** (admits when data is missing) but **substantially hollow** (fills gaps with generic advice). The 30% honesty score reflects answers where it provided useful observations despite limitations — not deep insights.

**The single highest-leverage improvement is indexing crate descriptions and README content.** This would transform the agent from a name matcher into a genuine knowledge assistant.
