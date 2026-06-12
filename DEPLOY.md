# Deployment Checklist — superinstance-website

## What to Deploy

Everything in the repo root (excluding build tooling):

```
index.html
education.html
browse.html
cluster-map.html
ecosystem.html
search.html
stats.html
status.html
papers/index.html
papers/ternary-conservation.md
tutorials/hello-world.md
.nojekyll
domains.json
ecosystem-data.json
```

Skip: `dist/`, `build-domains.sh`, `templates/`, `SITE-MAP.md`, `TEMPLATE-SYSTEM.md`, `.git/`.

## Where: Cloudflare Pages

1. **Project**: `superinstance-website` (or whatever name is set)
2. **Build command**: none (static site)
3. **Build output directory**: `/` (root)
4. **Framework preset**: None

### Setup via Wrangler

```bash
cd /home/phoenix/repos/superinstance-website
npx wrangler pages project create superinstance-website --production-branch main
npx wrangler pages deploy . --project-name superinstance-website
```

Or connect the GitHub repo directly in the Cloudflare dashboard for auto-deploys.

## DNS Config

If using a custom domain (e.g. `superinstance.dev`):

1. In Cloudflare Pages → Custom domains → Add `superinstance.dev`
2. Cloudflare will add a CNAME record pointing to the Pages deployment
3. SSL is automatic (Cloudflare managed)

If using the default `*.pages.dev` subdomain, no DNS needed.

## Verify

After deploy, check:

1. **Homepage loads**: `https://<domain>/index.html` (or just `/`)
2. **Education page**: click link from homepage → education.html renders
3. **Papers index**: click from homepage or education → `papers/` shows paper list
4. **Paper renders**: `papers/ternary-conservation.md` loads (GitHub Pages renders markdown; for CF Pages you may want to convert to HTML or serve raw)
5. **Tutorial**: `tutorials/hello-world.md` loads
6. **All nav links work**: click every nav link, verify no 404s
7. **Relative paths**: all links use relative paths (no leading `/`), so they work at any subdomain

### Known Issue: Markdown on Cloudflare Pages

CF Pages serves `.md` files as `text/plain` or `text/markdown` — browsers won't render them formatted. Options:
- Convert papers and tutorials to `.html` before deploy
- Add a `_headers` file to set `Content-Type: text/html` (if pre-rendered)
- Use a build step to convert markdown → HTML
- Live with raw markdown for now (it's readable)

## Quick Smoke Test

```bash
# Deploy
npx wrangler pages deploy . --project-name superinstance-website

# Check
curl -s -o /dev/null -w "%{http_code}" https://superinstance-website.pages.dev/
curl -s -o /dev/null -w "%{http_code}" https://superinstance-website.pages.dev/education.html
curl -s -o /dev/null -w "%{http_code}" https://superinstance-website.pages.dev/papers/
```

All should return 200.
