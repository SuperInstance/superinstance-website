# SuperInstance Website

The public-facing portal for the **SuperInstance ecosystem** — a multi-page static site documenting 100+ research crates, cluster architecture, interactive tutorials, live ecosystem statistics, and the ternary computation thesis ($\gamma + \eta = C$). Built with shell-templated HTML and deployed on Cloudflare Pages.

## Why It Matters

A research ecosystem of 100+ crates needs a navigable index. Raw GitHub repositories serve developers, but visitors need curated entry points: What is ternary computation? Why does $\gamma + \eta = C$ matter? What can I actually use today?

The website answers these questions through five page types — landing, ecosystem map, domain browser, quality dashboard, and education hub — all generated from JSON data sources via shell scripts. No build framework, no JavaScript bloat, no external dependencies. The complexity is $O(N)$ where $N$ = number of crates, and generation completes in under 1 second.

The site serves as the canonical URL for papers, social media, and documentation references — the single link that represents the entire ecosystem.

## How It Works

### Static Site Generation

The build pipeline is intentionally primitive — a shell script reads JSON data and injects it into HTML templates:

```
build-domains.sh
    ├── reads domains.json         (domain names, taglines, themes)
    ├── reads templates/base.html  (shared page skeleton)
    └── writes dist/<domain>/      (per-domain landing pages)
```

The stats and browse pages (`stats.html`, `browse.html`) load `quality-report.json` client-side at runtime; `ecosystem.html` polls the live fleet Workers APIs (fleet-vector-api, harness-api).

This avoids heavy frameworks (Hugo, Jekyll, Next.js) and keeps the build fully inspectable. The total build complexity is $O(N)$ where $N$ = crate count.

### Page Architecture

| Page | Purpose | Data Source | Size |
|------|---------|-------------|------|
| `index.html` | Thesis, overview, featured crates | Static | ~11 KB |
| `ecosystem.html` | Live fleet status via Workers APIs | fleet-vector-api / harness-api (runtime) | ~9 KB |
| `browse.html` | Domain-tagged browsing with filters | `quality-report.json` *(corrected 2026-09-03, audit r11 — previously listed `domains.json`, but browse.html fetches only `quality-report.json`; `domains.json` feeds `build-domains.sh`)* | ~12 KB |
| `stats.html` | Quality metrics, test counts, LOC | `quality-report.json` | ~13 KB |
| `search.html` | Vector search over the crate fleet | fleet-vector-api `/search` | ~7 KB |
| `education.html` | Tutorials and learning paths | `tutorials/` | ~21 KB |
| `status.html` | Deployment status, health checks | Runtime | ~13 KB |
| `cluster-map.html` | Dependency graph visualization | SVG + JS | ~14 KB |

### Dependency Graph

The ecosystem is visualized as a directed acyclic graph (DAG) of crate dependencies. Each node is a crate; each edge represents a `depends-on` relationship. The graph is rendered as an SVG with:

- Node position determined by domain clustering (force-directed layout)
- Edge weight proportional to dependency depth
- Color coding: core (red), infrastructure (blue), research (green), application (yellow)

The DAG is topologically sorted to verify no circular dependencies exist — a $O(V + E)$ check using Kahn's algorithm.

### Quality Metrics Pipeline

The `quality-report.json` (291 KB) contains per-crate metrics:

| Metric | Computation |
|--------|-------------|
| Test count | Parse `cargo test --no-run` output |
| Lines of code | `tokei` (accurate LOC by language) |
| Documentation coverage | `cargo doc` private item ratio |
| Dependency count | `Cargo.toml` parsing |
| README size | Byte count of `README.md` |

### Complexity

| Operation | Time |
|-----------|------|
| Full site build | $O(N)$ — N = crates |
| Client-side search | $O(N)$ per query (linear scan) |
| Quality report generation | $O(N)$ — one pass per crate |
| Topological sort (DAG check) | $O(V + E)$ |

## Quick Start

```bash
# Local development
cd superinstance-website
./build-domains.sh        # Generate dist/
python3 -m http.server 8000  # Serve locally
# Open http://localhost:8000

# Deploy to Cloudflare Pages
wrangler pages deploy dist/ --project-name superinstance
```

### Adding a New Crate

> **⚠️ Dated note (2026-09-03, audit r11):** these steps date from early scaffolding and no longer match the data reality. `ecosystem-data.json` is a *generated fleet inventory snapshot* (committed once, `"generated": "2026-06-11"` — 1,605 repos / 1,494 crates at snapshot time; no generator lives in this repo) consumed at runtime by `status.html`, and `quality-report.json` (291 KB) is consumed by `browse.html`/`stats.html`. Hand-editing the snapshot works mechanically but leaves it stale against the live fleet; `build-domains.sh` reads only `domains.json` + `templates/base.html`. Kept as-is for history — owner decision whether to replace with a regeneration step.

1. Add entry to `ecosystem-data.json`
2. Add domain tags to `domains.json`
3. Run `./build-domains.sh`
4. Commit and push — Cloudflare Pages auto-deploys

## API

No server-side API. All data is embedded in static JSON files served alongside HTML.

| File | Format | Description |
|------|--------|-------------|
| `ecosystem-data.json` | JSON | Fleet inventory snapshot (repo/crate/quality counts, generated 2026-06-11) |
| `domains.json` | JSON | Domain classifications and tags |
| `quality-report.json` | JSON | Per-crate quality metrics |

## Architecture Notes

The website embodies the **γ + η = C** conservation principle in information architecture:

- **γ (structure)**: the page templates and URL routing — the fixed skeleton that holds the site together
- **η (dynamics)**: the evolving crate ecosystem — new crates, updated descriptions, changing quality metrics
- **C (conservation)**: the information invariant — every crate that exists in the codebase is represented on the website. The build pipeline ensures $\sum \text{crates} = \sum \text{pages}$ (every crate appears somewhere)

The shell-template approach is deliberately minimal because the γ (structure) should not change when η (crates) is perturbed. Adding a crate updates data files; the templates remain untouched. This separation of concerns is the architectural conservation law.

## References

| Kahn, A.B. (1962). *Topological Sorting of Large Networks*. CACM. — DAG verification.
| Fielding, R.T. (2000). *Architectural Styles and the Design of Network-Based Software Architectures*. — REST and static resources.
| MacKenzie, J. et al. (2014). *The Pragmatic Programmer* — separation of data from presentation.

## License: MIT
