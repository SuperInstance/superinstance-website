# Setup TODO — what to verify before going live

## Buy Me a Coffee link
- Currently set to: https://www.buymeacoffee.com/superinstance
- If your actual handle is different, find/replace across:
  - `index.html` (2 occurrences)
  - `quilt.html` (3 occurrences)
  - `quilt-ecosystem.html` (1 occurrence)
- After update, re-run the deploy workflow

## Custom domain
- CNAME = `superinstance.dev` (set)
- Need to: configure Cloudflare DNS to point `superinstance.dev` to GitHub Pages
  - A records: 185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153
  - Or CNAME: `superinstance.github.io`
- Optional: also set up `quilt.superinstance.dev` as a CNAME to the same Pages site

## Quilt ecosystem link
- The Quilt demos currently live at `https://superinstance.github.io/quilt/landing/...`
- This is a separate GitHub Pages project (the `quilt` repo's landing folder)
- The new `superinstance.dev/quilt.html` (this repo) and `quilt.superinstance.dev` (TBD) will cross-link
