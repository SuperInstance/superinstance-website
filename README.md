# SuperInstance Website

The **SuperInstance Website** is the public-facing portal for the SuperInstance ecosystem — a multi-page static site documenting 100+ research crates, cluster architecture, tutorials, live ecosystem stats, and the ternary computation thesis. Built with shell-templated HTML and deployed on Cloudflare Pages.

## Why It Matters

A research ecosystem of 100+ crates needs a navigable index. Raw GitHub repositories serve developers, but visitors need curated entry points: what is ternary computation? Why does γ + η = C matter? What can I actually use today? The website answers these questions with interactive cluster maps, domain browsing, quality reports, and tutorial walkthroughs. It also serves as the canonical URL for papers, social posts, and documentation references — the single link that represents the entire ecosystem to the outside world.

## How It Works

### Static Site Generation

The site is generated from shell scripts that template HTML with data from `ecosystem-data.json` and `domains.json`:

```
build-domains.sh → reads ecosystem-data.json → injects into template → dist/*.html
```

This avoids heavy build tools (Hugo, Jekyll) and keeps the build process inspectable. Complexity: O(N) where N = number of crates.

### Page Structure

| Page | Content | Data Source |
|------|---------|-------------|
| `index.html` | Landing page, thesis statement, ecosystem overview | Static |
| `ecosystem.html` | Interactive cluster map of all crates | `ecosystem-data.json` |
| `browse.html` | Domain-tagged browsing with filters | `domains.json` |
| `stats.html` | Live quality metrics, test counts, LOC | `quality-report.json` |
| `search.html` | Crate search by name/domain/keyword | Client-side JS |
| `education.html` | Tutorials and learning paths | `tutorials/` |
| `status.html` | Fleet status dashboard | `status API` |

### Cluster Visualization

The cluster map (`cluster-map.svg`) renders crates as nodes in a force-directed graph, with edges representing domain overlap:

```
edge_weight(A, B) = cosine_similarity(embedding(A), embedding(B))
```

Generated from the 32-dimensional crate embeddings. Nodes are colored by domain.

### Quality Reporting

`quality-report.json` aggregates per-crate metrics:

```json
{
  "total_crates": 104,
  "total_loc": 45000,
  "total_tests": 1200,
  "average_test_coverage": 0.73,
  "crates_with_readme": 104
}
```

This drives the stats dashboard and tracks ecosystem health over time.

## Quick Start

```bash
# Build the site
./build-domains.sh

# Serve locally
python3 -m http.server 8000 dist/

# Deploy to Cloudflare Pages
npx wrangler pages deploy dist --project-name superinstance
```

## API

| Resource | Path | Description |
|----------|------|-------------|
| Ecosystem data | `ecosystem-data.json` | Crate metadata for all repos |
| Domain taxonomy | `domains.json` | Domain classification schema |
| Quality metrics | `quality-report.json` | Aggregate health metrics |
| Dependency graph | `ternary-deps.dot` | Graphviz DOT of ternary crate dependencies |
| Tutorials | `tutorials/` | Learning materials |
| Papers | `papers/` | Research papers and writeups |

## Architecture Notes

The website is the external projection of the fleet's γ + η = C work. It makes the constructive output (γ — crates, papers, tutorials) discoverable and provides quality metrics (η — testing, coverage) that signal reliability. The cluster visualization reveals cross-domain synergies, helping visitors understand the ecosystem's topology of competence C. See [ARCHITECTURE.md](https://github.com/SuperInstance/SuperInstance/blob/main/ARCHITECTURE.md).

## References

1. Csörgő, A., et al. (2018). "Static Site Generators: A Survey." *arXiv:1806.00308*.
2. Bostock, M., Ogievetsky, V., & Heer, J. (2011). "D³: Data-Driven Documents." *IEEE InfoVis*. — Force-directed graph layout.
3. RFC 3986. "Uniform Resource Identifier (URI): Generic Syntax." — URL design for the site's page structure.

## License

MIT
