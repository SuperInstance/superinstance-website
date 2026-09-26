#!/usr/bin/env python3
"""build_state.py — regenerate /now/state.json from live gh data.
The page's stamp is only honest if regeneration is ONE command. Run:
  cd now && python3 build_state.py && ../(re-stamp index.html manually)
Writes state.json including this-file-removed self-hash. Idempotent."""
import json, hashlib, subprocess, datetime, sys

def gh(args, jq):
    out = subprocess.run(["gh"] + args + ["-q", jq], capture_output=True, text=True)
    if out.returncode != 0:
        raise SystemExit(f"gh failed: {args}\n{out.stderr}")
    return out.stdout.strip()

stamp = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%MZ")
window_start = (datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(hours=24)).strftime("%Y-%m-%dT%H:%MZ")

repos_json = gh(["repo", "list", "SuperInstance", "--limit", "1000", "--json", "name,pushedAt,isPrivate"], ".")
repos = json.loads(repos_json)
pub = [r for r in repos if not r.get("isPrivate")]
day = [r for r in pub if r["pushedAt"] > window_start]

state = {
    "generated_at": stamp.replace("Z", ":00Z"),
    "org": "SuperInstance",
    "measures": {
        "repos_public": {"value": len(pub), "source": "gh repo list SuperInstance --limit 1000 --json name,pushedAt,isPrivate"},
        "repos_pushed_24h": {"value": len(day), "window": f"pushedAt > {window_start}",
                              "source": "same listing, filtered"},
        "open_prs": {"value": None, "source": "gh search prs --owner SuperInstance --state open --limit 100 --json number"},
        "canon_pieces_markdown": {"value": None, "source": "gh api repos/SuperInstance/AI-Writings/git/trees/main?recursive=1 (blobs ending .md)"},
        "profile_repo_head": {"sha": None, "at": None, "source": "gh api repos/SuperInstance/SuperInstance/commits?per_page=1"},
    },
    "live_cells": {"value": 5, "basis": "self-reported: orchestrator tmux claude, cartographer, probe, skeptic, poet"},
    "machine_twin": "state.json",
    "distrust_after_minutes": 60,
    "re_stamp_command": "python3 build_state.py (this file)",
    "previous_stamps": ["2026-09-26T23:14:00Z"],
}

state["measures"]["open_prs"]["value"] = int(gh(["search", "prs", "--owner", "SuperInstance", "--state", "open", "--limit", "100", "--json", "number"], "length"))
state["measures"]["canon_pieces_markdown"]["value"] = int(gh(["api", "repos/SuperInstance/AI-Writings/git/trees/main?recursive=1"], '[.tree[] | select(.type=="blob" and (.path|endswith(".md")))] | length'))
head = json.loads(subprocess.run(["gh", "api", "repos/SuperInstance/SuperInstance/commits?per_page=1"], capture_output=True, text=True).stdout)[0]
state["measures"]["profile_repo_head"]["sha"] = head["sha"][:7]
state["measures"]["profile_repo_head"]["at"] = head["commit"]["committer"]["date"]

payload = {k: v for k, v in state.items() if k != "sha256_of_this_file_without_self_hash"}
state["sha256_of_this_file_without_self_hash"] = hashlib.sha256(
    json.dumps(payload, sort_keys=True, indent=2).encode()).hexdigest()

with open("state.json", "w") as f:
    json.dump(state, f, indent=2)
print(f"stamped {stamp}: repos={len(pub)} day={len(day)} prs={state['measures']['open_prs']['value']} canon={state['measures']['canon_pieces_markdown']['value']} head={state['measures']['profile_repo_head']['sha']}")
