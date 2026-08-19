# Deployment v0.1.0 — superinstance.dev live!

**Date:** 2026-08-19
**Status:** LIVE
**URLs:**
- https://superinstance.dev/ — main landing page (200 ✓)
- https://superinstance.dev/quilt.html — Quilt feature page (200 ✓)
- https://superinstance.dev/quilt-ecosystem.html — full Quilt showcase (200 ✓)
- https://quilt.superinstance.dev/ — Quilt subdomain (301 → /quilt.html ✓)
- https://www.superinstance.dev/ — www redirect (301 → apex ✓)

## What was deployed

### Content
1. **quilt.html** (18 KB) — the Quilt feature page
   - Hero with the cell-model insight
   - 9 cell kinds grid
   - 5 deployment tiers
   - 3 quick-start paths
   - 12 demo links
   - CTA with save-your-work + Buy Me a Coffee

2. **quilt-ecosystem.html** (40 KB) — full Quilt showcase
   - All 15 repos as cards
   - 12 live demos
   - 6 click-and-go templates (with save-your-work)
   - 8 setup paths
   - Hosted Quilt preview (Free/Pro/Team tiers)
   - Buy Me a Coffee bar

3. **index.html** (modified) — added Quilt nav link + feature section
   - '⬢ Quilt' link in nav (purple)
   - New 'Quilt - the cell model' section before the ecosystem section
   - Buy Casey a Coffee links (footer + bottom-bar)

### Infrastructure
- **Cloudflare DNS** (9 records, all proxied through Cloudflare):
  - 4 A records: superinstance.dev → 185.199.108-111.153 (GitHub Pages)
  - 4 A records: www.superinstance.dev → same (with www→apex redirect)
  - 1 CNAME: quilt.superinstance.dev → superinstance.github.io

- **Cloudflare SSL** — set to "full" mode, always-use-https on, min TLS 1.2

- **Cloudflare Page Rule** — quilt.superinstance.dev/* → 301 to superinstance.dev/quilt.html

- **GitHub Pages** — CNAME configured to `superinstance.dev`, deployed to `master` branch via workflow

### To verify (manual, by user)
- [ ] Update Buy Me a Coffee URL if `buymeacoffee.com/superinstance` is not the actual handle
- [ ] Wait for GitHub Pages to provision Let's Encrypt cert (typically 15-30 min after CNAME config) — once done, can enable `https_enforced: true`
- [ ] Set up GitHub Sponsors link in addition to Buy Me a Coffee
