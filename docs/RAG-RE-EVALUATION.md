# RAG Re-Evaluation Post-Enrichment

**Date:** 2026-06-11  
**Index:** 1,512 crates (up from ~1,012)  
**Enrichment:** Descriptions, READMEs, and code summaries re-ingested  

---

## Executive Summary

**Verdict: Enrichment FAILED to surface. No meaningful improvement.**

Despite re-ingesting 1,512 crates with descriptions, READMEs, and code summaries, **every single citation returned by the RAG agent has `"description":""` (empty string)**. The agent is still operating on crate names alone — the enriched metadata is not being retrieved or surfaced.

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Overall honesty score | 30% | **~21%** | ↓ Worse |
| Citations with descriptions | 0% | **0%** | No change |
| Answers grounded in real content | ~3/10 | **~1/10** | ↓ Worse |
| Hallucinated code/examples | Moderate | **High** | ↑ Worse |

---

## Question-by-Question Analysis

### Q1: Relationship between ternary logic and music theory?

**Score: 2/10** (was 3/10)

The agent found relevant crates (ternary-music, ternary-timbre, ternary-counterpoint, ternary-dynamics) and correctly identified the naming pattern. However, the entire answer is **inferred from crate names** — it admits "descriptions are not available" and proceeds to speculate about what each crate does based on its name alone.

**Assessment:** Good crate retrieval, zero content grounding. The answer is plausible but entirely fabricated reasoning from naming conventions.

---

### Q2: Which crates are likely dead weight?

**Score: 2/10** (was 2/10)

The agent uses **"no description available" as its primary signal** for identifying dead weight — which means it's actually using the *absence* of enriched data as a heuristic. It recommends pruning crates-publish-check, aabb-collision, account-model, and ackermann_function based on lack of descriptions.

**Assessment:** Ironic — the enrichment failure itself becomes the detection signal. Not useful.

---

### Q3: Deepest mathematical result actually implemented?

**Score: 1/10** (was 2/10)

The agent **completely hallucinated**. It found `zeta-function` and invented an entire narrative about the Riemann Hypothesis being implemented. There is no evidence from actual code or descriptions — pure name-based inference presented as fact.

**Assessment:** Actively misleading. Worse than saying "I don't know."

---

### Q4: How is the conservation law γ + η = C enforced in code?

**Score: 2/10** (was 2/10)

Found relevant crates (conservation-law, oxide-conservation, conservation-compiler, conservation-lint) but the entire enforcement mechanism description — type checking, linting, code transformation — is **pure speculation** from crate names. No actual code or documentation was cited.

**Assessment:** Crate retrieval is good, but the "answer" is a hallucinated architecture.

---

### Q5: Which two crates have highest similarity but different domains?

**Score: 1/10** (was 1/10)

The agent **misunderstood the question entirely**, treating vector search similarity scores as "similarity between crates" and comparing scores across different search results. It suggested crates-publish-check and exotic-sphere, which have no meaningful relationship.

**Assessment:** Fundamental misunderstanding. The RAG system cannot answer cross-domain similarity questions.

---

### Q6: What would need to change to make this a real product?

**Score: 2/10** (was 2/10)

Generic product advice (documentation, scalability, security, deployment) with forced crate associations. The agent references cup_product as a "productization" crate and sample-wasm as deployment tooling — these are almost certainly wrong interpretations based on names alone.

**Assessment:** The advice is generic enough to be correct at a high level, but the crate-specific recommendations are unreliable.

---

### Q7: Which crate names sound impressive but contain minimal substance?

**Score: 3/10** (was 3/10)

Uses "lack of description" as the primary signal again. Reasonable guesses (ternary-vu, ternary-ear-training, ternary-baum-welch) but no actual substance analysis since there's no content to analyze.

**Assessment:** Best it can do without descriptions. The irony of using enrichment-failure as a proxy for "minimal substance" is noted.

---

### Q8: Single most important crate to get right next?

**Score: 2/10** (was 2/10)

Recommends `ternary-fence` as most important — based on pure speculation about ternary consensus mechanisms. The reasoning is fabricated from crate naming patterns, not from understanding actual crate functionality or dependencies.

**Assessment:** Plausible-sounding but entirely ungrounded.

---

### Q9: How does the ecosystem handle error propagation?

**Score: 3/10** (was 3/10)

Found genuinely relevant crates (error-forest, fallback-strategy, retry-policy, exception-handler) and even **hallucinated a complete Rust code example** showing how they work together. The crate retrieval is strong, but the code example is fabricated.

**Assessment:** Best retrieval result, but the hallucinated code example is dangerous — someone might try to use it.

---

### Q10: What scientific papers are referenced in the codebase?

**Score: 1/10** (was 1/10)

Pure guessing from crate names. Infers superinstance-papers contains papers, kv-journal contains journal articles. Cannot cite any actual paper references because the enriched content isn't being surfaced.

**Assessment:** No improvement. The enrichment should have included reference metadata but it's not reaching the agent.

---

## Root Cause Analysis

### The Enrichment Didn't Reach the Agent

Every citation in every response has:
```json
"description": ""
```

This means one of:
1. **The vectorize index wasn't updated** — enrichment data was prepared but not upserted
2. **The metadata field is mapped wrong** — descriptions exist in the index but aren't included in the response
3. **The agent response pipeline strips descriptions** — data is retrieved but not forwarded to the LLM

### Impact

Without descriptions, the agent is in the same position as before — guessing from crate names. In some ways it's **worse** because the agent now has more crate names to falsely reason about.

---

## Remaining Weaknesses

1. **No content grounding** — All answers are inferred from crate names, not actual code/docs
2. **Confident hallucination** — The agent presents speculation as fact with high confidence
3. **Fabricated code examples** — Dangerous for anyone trying to use the system
4. **No cross-referencing** — Cannot compare crates, trace dependencies, or identify relationships
5. **Score misuse** — Vector similarity scores are misinterpreted as crate quality/importance metrics

---

## Recommendations

1. **Debug the enrichment pipeline** — Verify descriptions actually made it into the Vectorize index
2. **Check the agent's response schema** — Ensure descriptions are included in the prompt/context
3. **Add a smoke test** — Query the index directly (not through the agent) to confirm metadata is present
4. **Consider chunk-level indexing** — Crate-level granularity may be too coarse even with descriptions
5. **Add source verification** — Agent should indicate confidence and when it's speculating vs. citing

---

## Verdict

**The RAG is NOT useful for real work.** The enrichment effort was valuable data work, but the pipeline is broken — the enriched content never reaches the LLM. The agent is still flying blind, making it worse than no RAG at all because its confident-sounding hallucinations could mislead users.

**Priority: Fix the data pipeline before any further evaluation.**

---

*Re-evaluation conducted 2026-06-11. Previous evaluation at ~30% honest assessment.*
