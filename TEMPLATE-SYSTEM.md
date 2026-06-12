# Cross-Domain Publishing Template System

Single template → 13 domain-specific sites. One build command regenerates everything.

## Files

| File | Purpose |
|------|---------|
| `domains.json` | Domain configs: name, tagline, accent color, demo variant, CTA, content angle |
| `templates/base.html` | HTML template with `{{SLOT}}` variables |
| `build-domains.sh` | Build script: reads config + template → outputs per-domain HTML |
| `dist/` | Generated output (one subdirectory per domain) |

## Slot Variables

| Slot | Source | Example |
|------|--------|---------|
| `{{DOMAIN_NAME}}` | `.name` | SuperInstance |
| `{{DOMAIN_TAGLINE}}` | `.tagline` | Bird's eye view of the fleet |
| `{{THEME_ACCENT}}` | `.accent` | #6C5CE7 |
| `{{DEMO_VARIANT}}` | `.demo_variant` | fleet-radar |
| `{{CTA_TEXT}}` | `.cta_text` | View the Fleet |
| `{{CONTENT_ANGLE}}` | `.content_angle` | How ternary conservation applies in this domain |
| `{{DOMAIN_ICON}}` | `.icon` | 🔭 |

## Domain Mapping (All 13)

| Domain | Accent | Demo Variant | Role | Content Angle (Summary) |
|--------|--------|-------------|------|------------------------|
| **superinstance.ai** | `#6C5CE7` | fleet-radar | hub | Bird's eye fleet observability. All ships, all signals. |
| **activelog** | `#00B894` | activity-stream | ship | The γ in γ+η=C. Activity as git commits. |
| **activeledger** | `#FDCB6E` | ledger-view | ship | Ternary conservation applied to finance. |
| **studylog.ai** | `#0984E3` | knowledge-graph | ship | Knowledge as a git graph. Study = commits. |
| **personallog.ai** | `#E17055` | timeline | ship | Journal entries as sealed bottles. |
| **dmlog.ai** | `#B53471` | campaign-map | ship | Campaign state as a git repo. |
| **fishinglog.ai** | `#00CEC9` | catch-heatmap | ship | Environmental data as agent signals. |
| **playerlog.ai** | `#FF6B6B` | session-stats | ship | Game sessions as commits. Win/loss = ternary. |
| **luciddreamer.ai** | `#A29BFE` | dream-map | ship | Dreams as honest agent output. |
| **deckboss.net** | `#2D3436` | nav-display | ship | Original bottle protocol. Maritime logs. |
| **purplepincher.org** | `#9B59B6` | repo-gallery | ship | Open source commons. PRs = signals. |
| **lucineer.com** | `#34495E` | career-timeline | ship | Career as a non-linear git graph. |
| **cocapn** | `#E74C3C` | coordination-matrix | captain | Multi-agent harness. Balances fleet conservation budget. |

## Build Script Usage

```bash
# First time: generate stub template
./build-domains.sh --init

# Build all 13 domains
./build-domains.sh

# Build single domain
./build-domains.sh superinstance.ai
```

Output goes to `dist/<domain>/index.html`.

## Adding a New Domain

1. Add entry to `domains.json` under `.domains` with all required fields
2. Run `./build-domains.sh <new-domain>` to generate
3. Add domain to Cloudflare Worker routing (see below)

## Deployment Plan: Single Cloudflare Worker

### Architecture

```
Request → Cloudflare Worker (fleet-gateway)
       → Check Host header
       → Look up domain in KV/domains.json
       → Return domain-specific HTML
```

### Worker Implementation (`fleet-gateway`)

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const host = request.headers.get('Host')?.split(':')[0];

    // Static assets from R2 or KV
    const cacheKey = new Request(`https://static/${host}/index.html`);
    const cache = caches.default;

    let response = await cache.match(cacheKey);
    if (response) return response;

    // Fetch from R2 bucket (pre-built HTML)
    const key = `${host}/index.html`;
    const obj = await env.SITES_BUCKET.get(key);
    if (!obj) {
      return new Response('Domain not found', { status: 404 });
    }

    response = new Response(obj.body, {
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
        'Cache-Control': 'public, max-age=3600, s-maxage=86400',
        'CDN-Cache-Control': 'public, max-age=86400',
        'X-Fleet-Domain': host,
      },
    });

    // Cache at edge
    await cache.put(cacheKey, response.clone());
    return response;
  }
};
```

### Wrangler Config

```jsonc
{
  "name": "fleet-gateway",
  "main": "src/worker.js",
  "r2_buckets": [
    { "binding": "SITES_BUCKET", "bucket_name": "fleet-sites" }
  ],
  "routes": [
    // Add each custom domain
    { "pattern": "superinstance.ai", "custom_domain": true },
    { "pattern": "activelog.*", "custom_domain": true },
    { "pattern": "activeledger.*", "custom_domain": true },
    { "pattern": "studylog.ai", "custom_domain": true },
    { "pattern": "personallog.ai", "custom_domain": true },
    { "pattern": "dmlog.ai", "custom_domain": true },
    { "pattern": "fishinglog.ai", "custom_domain": true },
    { "pattern": "playerlog.ai", "custom_domain": true },
    { "pattern": "luciddreamer.ai", "custom_domain": true },
    { "pattern": "deckboss.net", "custom_domain": true },
    { "pattern": "purplepincher.org", "custom_domain": true },
    { "pattern": "lucineer.com", "custom_domain": true },
    { "pattern": "cocapn.*", "custom_domain": true }
  ]
}
```

### Deploy Workflow

```bash
# 1. Build all domain sites
./build-domains.sh

# 2. Upload to R2
for dir in dist/*/; do
  domain=$(basename "$dir")
  wrangler r2 object put fleet-sites/${domain}/index.html --file "${dir}index.html"
done

# 3. Deploy worker
wrangler deploy
```

### Cache Strategy

| Layer | TTL | Invalidation |
|-------|-----|-------------|
| Cloudflare Edge | 24h (`s-maxage=86400`) | Re-upload to R2 + purge cache |
| Browser | 1h (`max-age=3600`) | Natural refresh |
| R2 | Persistent | Source of truth |

### Cache Busting

```bash
# After rebuilding:
wrangler r2 object put fleet-sites/superinstance.ai/index.html --file dist/superinstance.ai/index.html
# Optionally purge:
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -d '{"files":["https://superinstance.ai/"]}'
```

## Architecture Notes

### SuperInstance = Bird's Eye View
The hub. Sees every ship, every signal, every conservation budget across the fleet. Not a ship itself — the map room.

### Each Domain = First-Person View of a Ship
A git-native agent. Commits are actions. Branches are explorations. Merges are agreements. The bottle protocol sends sealed messages between agents.

### Fleet = Multi-Agent Harness
Ships are independent agents, not containers. They sail alone but coordinate through the fleet. CoCap'n is the captain — it doesn't steer ships, it balances the formation.

### Conservation Law: γ + η = C
- **γ** (gamma) = activity rate (commits, signals, actions)
- **η** (eta) = response latency (time between cause and effect)
- **C** = constant budget at fleet level

More activity means each action takes longer. More ships means each responds slower. The fleet can't exceed C. Each domain interprets this differently (see content_angle in domains.json).
