# superinstance-website

Landing page for the [SuperInstance](https://github.com/SuperInstance) ecosystem.

## What it is

A single-page site that explains what SuperInstance actually is — a 1,596-repo ecosystem built around Z₃ (ternary {-1, 0, +1}) arithmetic and a conservation rule.

## Sections

- **Hero** — what Z₃ is and why it matters
- **Conservation rule** — γ + η = C, enforced at six system layers
- **Five-layer stack** — from bedrock (L0) to domain (L4)
- **Domain cards** — what's actually in the repo (ternary math, GPU, agents, edge, PLATO, gauge theory)
- **Kernel crates** — the 15 crates everything depends on

## Tech

Vanilla HTML + CSS. No frameworks, no build step, no JavaScript. Dark theme, monospace font.

## How to view

Open `index.html` in a browser. Or serve it locally:

```bash
python3 -m http.server 8000
# then http://localhost:8000
```

## Status

Work in progress. Not all links may work yet. Some domain sections describe real crates; others describe aspirations. The site is intentionally honest about which is which.

## Docs

Additional documents in `docs/`:

- `TERNARY-DESIGN-PATTERN.md` — design patterns for Z₃ systems
- `ISOMORPHISM-REVIEW.md` — review of ternary isomorphisms
- `FORMAL-ISOMORPHISM.md` — formal treatment
- `SYNERGY-PATTERNS.md` — cross-domain patterns

## Links

- **GitHub org:** [github.com/SuperInstance](https://github.com/SuperInstance)
- **Author:** [github.com/casey-digennaro](https://github.com/casey-digennaro)
