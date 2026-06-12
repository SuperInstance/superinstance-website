#!/usr/bin/env bash
set -euo pipefail

# build-domains.sh — Generate domain-specific HTML from base template + domains.json
# Usage:
#   ./build-domains.sh --init     Create stub base template
#   ./build-domains.sh            Build all domains
#   ./build-domains.sh <domain>   Build single domain (e.g. "superinstance.ai")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOMAINS_JSON="$SCRIPT_DIR/domains.json"
TEMPLATE_FILE="$SCRIPT_DIR/templates/base.html"
OUTPUT_DIR="$SCRIPT_DIR/dist"

command -v jq >/dev/null 2>&1 || { echo "ERROR: jq required (apt install jq)"; exit 1; }

if [[ ! -f "$DOMAINS_JSON" ]]; then
  echo "ERROR: $DOMAINS_JSON not found"
  exit 1
fi

# Handle --init early, before template file check
if [[ $# -eq 1 && "$1" == "--init" ]]; then
  mkdir -p "$(dirname "$TEMPLATE_FILE")"
  cat > "$TEMPLATE_FILE" << 'TEMPLATE_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{DOMAIN_NAME}} — {{DOMAIN_TAGLINE}}</title>
  <style>
    :root {
      --accent: {{THEME_ACCENT}};
      --bg: #0a0a0f;
      --text: #e0e0e0;
      --muted: #888;
      --card-bg: #14141f;
    }
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }
    header {
      border-bottom: 1px solid #222;
      padding: 1.5rem 2rem;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    header h1 { color: var(--accent); font-size: 1.4rem; font-weight: 700; }
    header .tagline { color: var(--muted); font-size: 0.85rem; }
    header .icon { font-size: 1.6rem; }
    main {
      flex: 1;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1.5rem;
      padding: 2rem;
      max-width: 1200px;
      margin: 0 auto;
    }
    @media (max-width: 768px) { main { grid-template-columns: 1fr; } }
    .card {
      background: var(--card-bg);
      border: 1px solid #222;
      border-radius: 8px;
      padding: 1.5rem;
    }
    .card h2 { color: var(--accent); font-size: 1.1rem; margin-bottom: 0.75rem; }
    .card p { color: var(--muted); line-height: 1.6; font-size: 0.9rem; }
    .card.accent-border { border-left: 3px solid var(--accent); }
    .demo-zone {
      grid-column: 1 / -1;
      min-height: 300px;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 1px dashed #333;
      border-radius: 8px;
      color: var(--muted);
      font-family: monospace;
    }
    .demo-zone::before { content: 'Demo: {{DEMO_VARIANT}}'; }
    .cta-bar {
      grid-column: 1 / -1;
      text-align: center;
      padding: 2rem;
    }
    .cta-button {
      display: inline-block;
      background: var(--accent);
      color: var(--bg);
      padding: 0.85rem 2.5rem;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 700;
      font-size: 1rem;
      transition: opacity 0.2s;
    }
    .cta-button:hover { opacity: 0.85; }
    footer {
      border-top: 1px solid #222;
      padding: 1rem 2rem;
      text-align: center;
      color: var(--muted);
      font-size: 0.75rem;
    }
    footer a { color: var(--accent); text-decoration: none; }
    .conservation {
      display: inline-flex;
      align-items: center;
      gap: 0.4rem;
      background: #1a1a2a;
      padding: 0.3rem 0.7rem;
      border-radius: 4px;
      font-family: monospace;
      font-size: 0.7rem;
      color: var(--muted);
      margin-top: 0.5rem;
    }
  </style>
</head>
<body>
  <header>
    <div>
      <h1>{{DOMAIN_NAME}}</h1>
      <div class="tagline">{{DOMAIN_TAGLINE}}</div>
      <div class="conservation">γ + η = C</div>
    </div>
    <div class="icon">{{DOMAIN_ICON}}</div>
  </header>

  <main>
    <div class="card accent-border">
      <h2>What This Is</h2>
      <p>{{CONTENT_ANGLE}}</p>
    </div>
    <div class="card">
      <h2>How It Works</h2>
      <p>
        First-person view of a git-native agent. Every action is a commit.
        Every signal is a bottle message — sealed, sent, opened on arrival.
        The ternary conservation law γ + η = C governs the rhythm:
        activity plus latency equals a constant the fleet can't exceed.
      </p>
    </div>
    <div class="demo-zone"></div>
    <div class="cta-bar">
      <a href="#" class="cta-button">{{CTA_TEXT}}</a>
    </div>
  </main>

  <footer>
    Part of the <a href="https://superinstance.ai">SuperInstance</a> fleet &middot;
    <a href="https://cocapn">CoCap'n</a> coordinates &middot;
    Every ship sails alone, together
  </footer>
</body>
</html>
TEMPLATE_EOF
  echo "✓ Stub template created at $TEMPLATE_FILE"
  echo "  Edit it, then run: ./build-domains.sh"
  exit 0
fi

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "ERROR: $TEMPLATE_FILE not found — run: ./build-domains.sh --init"
  exit 1
fi

TEMPLATE="$(cat "$TEMPLATE_FILE")"
ALL_KEYS=($(jq -r '.domains | keys[]' "$DOMAINS_JSON"))

if [[ $# -eq 1 ]]; then
  TARGET_KEY="$1"
  FOUND=false
  for k in "${ALL_KEYS[@]}"; do [[ "$k" == "$TARGET_KEY" ]] && FOUND=true; done
  if ! $FOUND; then
    echo "ERROR: Unknown domain '$TARGET_KEY'"
    echo "Available: ${ALL_KEYS[*]}"
    exit 1
  fi
  KEYS=("$TARGET_KEY")
else
  KEYS=("${ALL_KEYS[@]}")
fi

mkdir -p "$OUTPUT_DIR"

build_domain() {
  local key="$1"
  local domain_data
  domain_data=$(jq -r --arg k "$key" '.domains[$k]' "$DOMAINS_JSON")
  [[ "$domain_data" == "null" ]] && { echo "SKIP: $key"; return; }

  local name tagline accent demo cta angle icon
  name=$(echo "$domain_data" | jq -r '.name')
  tagline=$(echo "$domain_data" | jq -r '.tagline')
  accent=$(echo "$domain_data" | jq -r '.accent')
  demo=$(echo "$domain_data" | jq -r '.demo_variant')
  cta=$(echo "$domain_data" | jq -r '.cta_text')
  angle=$(echo "$domain_data" | jq -r '.content_angle')
  icon=$(echo "$domain_data" | jq -r '.icon')

  local html="$TEMPLATE"
  html="${html//\{\{DOMAIN_NAME\}\}/$name}"
  html="${html//\{\{DOMAIN_TAGLINE\}\}/$tagline}"
  html="${html//\{\{THEME_ACCENT\}\}/$accent}"
  html="${html//\{\{DEMO_VARIANT\}\}/$demo}"
  html="${html//\{\{CTA_TEXT\}\}/$cta}"
  html="${html//\{\{CONTENT_ANGLE\}\}/$angle}"
  html="${html//\{\{DOMAIN_ICON\}\}/$icon}"

  local out_dir="$OUTPUT_DIR/$key"
  mkdir -p "$out_dir"
  echo "$html" > "$out_dir/index.html"
  echo "✓ $key → $out_dir/index.html"
}

echo "Building ${#KEYS[@]} domain(s)..."
for key in "${KEYS[@]}"; do
  build_domain "$key"
done
echo "Done. Output in $OUTPUT_DIR/"
