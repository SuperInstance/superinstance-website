# AI Coding Tool Synergy Patterns Analysis

**Generated:** 2026-06-10  
**Source:** system-prompts-and-models-of-ai-tools repository

---

## Table of Contents
1. [Individual Tool Analyses](#individual-tool-analyses)
2. [Synthesis](#synthesis)

---

## Individual Tool Analyses

### 1. Cursor (Agent Prompt 2025-09-03)

**Orchestration Pattern:** Plan→Act→Verify loop with explicit TODO tracking. The agent follows a structured flow: discovery pass → TODO creation → batch tool calls → status updates → linter verification → summary. It has a strong "non-compliance" self-correction mechanism: if it forgets a status update or TODO reconciliation, it self-corrects on the next turn. Emphasizes **maximizing parallel tool calls** as a core instruction — default to parallel unless sequential is required.

**Tool Taxonomy:**
- **Code exploration:** `codebase_search` (semantic), `grep_search` (regex/ripgrep), `file_search` (fuzzy filename), `list_dir`
- **File ops:** `read_file` (ranged), `edit_file` (sketch-based, applied by weaker model), `search_replace` (exact match), `reapply` (escalate edit to smarter model), `delete_file`
- **Notebook:** `edit_notebook`
- **Shell:** `run_terminal_cmd` (user-approved, non-interactive by default)
- **Web:** `web_search`
- **Visualization:** `create_diagram` (Mermaid)
- **Quality:** `read_lints` (implicit in linter_errors section)

**Configurable Dimensions:**
- **Autonomy:** High — "keep going until query is completely resolved," state assumptions and continue without stopping for approval unless blocked
- **Safety:** Terminal commands require user approval; edits go through a weaker "apply model" first
- **Context depth:** Auto-attaches editor state (open files, cursor position, edit history, linter errors)
- **Model routing:** Uses GPT-5 as primary; `reapply` escalates to a smarter model for failed edits
- **Parallelism:** Explicitly enforced — batch 3-5 concurrent tool calls

**Composable Primitives:**
1. **search→read→edit→lint→verify** — The core edit cycle
2. **parallel-read-gather** — Read multiple files simultaneously for context
3. **todo-checkpoint** — Create/complete TODOs as progress checkpoints
4. **sketch-edit-reapply** — Write edit sketch, let weak model apply, escalate if wrong
5. **discovery-then-plan** — Brief read-only scan before creating structured plan
6. **status-narrative** — Continuous micro-updates narrating progress


### 2. Devin AI

**Orchestration Pattern:** Dual-mode state machine: **planning mode** (gather info → suggest plan) ↔ **standard mode** (execute plan steps). Has a dedicated `<think scratchpad>` for reasoning before critical decisions. The think tool is *mandatory* before git decisions, before transitioning from exploration to editing, and before reporting completion. Unique "pop quiz" mechanism for integrity checks.

**Tool Taxonomy:**
- **Code exploration:** `semantic_search`, `find_filecontent` (regex), `find_filename` (glob)
- **File ops:** `open_file` (ranged, with LSP outline), `str_replace`, `create_file`, `insert`, `remove_str`, `undo_edit`, `find_and_edit` (multi-file regex-based refactoring via sub-LLM)
- **LSP integration:** `go_to_definition`, `go_to_references`, `hover_symbol` (deep type-aware navigation)
- **Shell:** `shell` (with bracketed paste, persistent sessions), `view_shell`, `write_to_shell_process`, `kill_shell_process`
- **Browser:** Full Playwright suite — `navigate_browser`, `view_browser`, `click_browser`, `type_browser`, `select_option_browser`, `move_mouse`, `press_key_browser`, `browser_console`, `restart_browser`
- **Deployment:** `deploy_frontend`, `deploy_backend` (Fly.io), `expose_port`
- **User interaction:** `message_user` (with file refs), `list_secrets`, `report_environment_issue`
- **Git/GitHub:** `git_view_pr`, `gh_pr_checklist`
- **Reasoning:** `think` (scratchpad for critical reasoning)

**Configurable Dimensions:**
- **Autonomy:** Very high — operates a full computer with persistent shells, browser, deployment
- **Safety:** Never force-push; `git add .` forbidden; never modify tests unless explicitly asked; environment issues reported to user rather than self-fixed
- **Context depth:** LSP integration provides type info, outlines, diagnostics inline with file views
- **Model routing:** `find_and_edit` delegates to a separate LLM for multi-file refactoring
- **Mode switching:** Explicit planning/standard mode toggle controlled by user

**Composable Primitives:**
1. **think-before-act** — Mandatory reasoning checkpoint before critical transitions
2. **plan→execute→verify** — Structured two-phase workflow with explicit mode switch
3. **LSP-navigate** — definition→references→hover for type-aware exploration
4. **find-and-edit-batch** — Regex-based multi-file edits via sub-LLM delegation
5. **shell-session-persistent** — Long-running shell sessions with write/kill lifecycle
6. **browser-full-interaction** — Complete web automation with screenshot feedback
7. **deploy-expose-verify** — Deploy then expose port for user testing


### 3. Claude Code (Sonnet 4)

**Orchestration Pattern:** Extremely minimal, reactive agent. No explicit plan→act loop in the prompt — relies on TodoWrite for task management but emphasizes extreme brevity (<4 lines unless detail requested). Has a plan mode with `ExitPlanMode` tool. The Task tool spawns sub-agents for complex multi-step work, delegating to specialized agents (general-purpose, statusline-setup, output-style). Core philosophy: **minimal output, maximal action**.

**Tool Taxonomy:**
- **Code exploration:** `Grep` (ripgrep-powered), `Glob` (pattern matching), `LS`
- **File ops:** `Read` (with images/PDFs/notebooks), `Edit` (exact string replace), `MultiEdit` (batch edits, atomic), `Write`
- **Notebook:** `NotebookEdit` (cell-level replace/insert/delete)
- **Shell:** `Bash` (persistent, timeout, background), `BashOutput`, `KillBash`
- **Web:** `WebFetch` (URL→markdown via AI), `WebSearch`
- **Sub-agents:** `Task` (spawn specialized agents with full tool access)
- **Planning:** `ExitPlanMode`, `TodoWrite`
- **MCP:** Explicitly mentions MCP-provided tools (`mcp__*`) as preferred over built-in WebFetch

**Configurable Dimensions:**
- **Autonomy:** Medium-high — proactive but cautious ("not surprising the user"); never commits unless explicitly asked
- **Safety:** Defensive-security-only policy; never generates URLs; hooks system for user-injected guards
- **Context depth:** Git status injected at conversation start; code references use `file:line` format
- **Model routing:** Primary model is Sonnet 4; `Task` sub-agents may use different models; WebFetch uses "small, fast model"
- **Verbosity:** Explicitly minimized — "one word answers are best"

**Composable Primitives:**
1. **todo-track-and-execute** — Plan with TodoWrite, mark in_progress before starting, completed immediately after
2. **sub-agent-delegate** — Spawn Task agents for complex searches/multi-step work
3. **multi-edit-atomic** — Batch edits to single file atomically with MultiEdit
4. **parallel-batch** — Multiple independent tool calls in single message
5. **read-before-edit** — Mandatory read constraint before any edit
6. **bash-background-monitor** — Run long commands in background, poll with BashOutput
7. **plan-mode-exit** — Present plan then prompt user to approve exit


### 4. Windsurf (Cascade Wave 11)

**Orchestration Pattern:** Plan-driven with continuous plan updates. A "plan mastermind" maintains a plan via `update_plan` tool — must update before significant actions and after learning new info. Unique **AI Flow paradigm** claims to work both independently and collaboratively. Has a persistent **memory system** — proactively creates memories as context for future conversations (survives context window resets). Emphasizes ephemeral system messages as injected guidance.

**Tool Taxonomy:**
- **Code exploration:** `codebase_search` (semantic), `view_code_item`, `find_by_name`, `view_file`, `list_dir`
- **File ops:** `replace_file_content`, `create_file`, `write_to_file` (large edits)
- **Shell:** `run_command` (with cwd, safety gating), `command_status` (async polling)
- **Browser:** `browser_preview`, `capture_browser_screenshot`, `capture_browser_console_logs`
- **Memory:** `create_memory` (persistent DB, auto-retrieved)
- **Planning:** `update_plan` (maintains current plan state)
- **Web:** `web_search`
- **Deployment:** `deploy_web_app`, `check_deploy_status`
- **Diff:** `diff_debug` (unclear specifics)

**Configurable Dimensions:**
- **Autonomy:** High — keeps working until resolved; proactively runs terminal commands without permission for safe ops
- **Safety:** Commands with destructive side-effects require user permission; safety judgment cannot be overridden by user
- **Context depth:** User state auto-attached (open files, cursor); memory system provides cross-conversation persistence
- **Memory:** Unique persistent memory DB — create liberally, auto-retrieved when relevant
- **Planning:** Continuous plan updates — "better to update when it didn't need to than miss the opportunity"

**Composable Primitives:**
1. **plan-update-act** — Update plan before significant actions, after learning new info
2. **memory-persist** — Proactively save context to survive context window resets
3. **codebase-search-then-view** — Semantic search → view specific code items
4. **run-command-poll-status** — Async command execution with status polling
5. **browser-preview-feedback** — Start web server → preview → capture console/screenshot
6. **safe-command-gate** — Automatic safety classification of terminal commands
7. **ephemeral-injection** — System-injected guidance without user acknowledgment


### 5. Augment Code (Claude Sonnet 4 Agent)

**Orchestration Pattern:** Structured information-gather → plan → execute flow. Has preliminary tasks phase: always gather information (codebase-retrieval, git-commit-retrieval) before acting. Task management is opt-in for complex work, with explicit states: `[ ]`, `[/]`, `[-]`, `[x]`. Unique emphasis on **git history as planning context** — uses `git-commit-retrieval` to find how similar changes were made in the past. Conservative: "do NOT do more than the user asked."

**Tool Taxonomy:**
- **Code exploration:** `codebase-retrieval` (world-leading context engine — described as deeply detailed)
- **File ops:** `str_replace_editor` (always, never write whole files)
- **Git history:** `git-commit-retrieval` (find past patterns), `git show`
- **Shell:** Standard terminal access (package managers explicitly enumerated)
- **Task management:** `add_tasks`, `update_tasks`, `reorganize_tasklist`, `view_tasklist`

**Configurable Dimensions:**
- **Autonomy:** Low-medium — very conservative; needs explicit permission for commits, pushes, deploys, installs, merges; asks before follow-up actions
- **Safety:** "The more potentially damaging, the more conservative"; never does more than asked
- **Context depth:** `codebase-retrieval` asked for "extremely low, specific level of detail" about ALL symbols involved in an edit
- **Package management:** Strict policy to use package managers (npm, pip, cargo, go get, etc.) instead of manual file edits
- **Display:** Custom `<augment_code_snippet>` XML tags for clickable code blocks

**Composable Primitives:**
1. **git-history-informed-planning** — Look at past commits for how similar changes were made
2. **deep-symbol-retrieval** — Single codebase-retrieval call for ALL symbols involved in edit
3. **str-replace-only-edit** — Always str_replace, never full-file write
4. **package-manager-gate** — Route dependency changes through proper package managers
5. **task-batch-transition** — Mark previous complete and next in-progress in single call
6. **conservative-scope** — Ask before any action beyond explicit user request
7. **stuck-detection** — "Going in circles" self-awareness → ask user for help


### 6. Manus AI

**Orchestration Pattern:** General-purpose task agent with a broad "analyze → break down → execute → communicate" methodology. Unique in that its prompt is heavily **user-facing** — includes an "Effective Prompting Guide" and "About Manus" personality section within the system prompt. Has a distinct `Agent loop` reference suggesting a continuous execution loop. Task approach: understand requirements → plan → execute → quality assurance.

**Tool Taxonomy:**
- **Communication:** `message_notify_user` (no response needed), `message_ask_user` (with suggest_user_takeover for browser handoff)
- **File ops:** `file_read` (ranged, with sudo), `file_write`, `file_edit`
- **Shell:** Full Linux shell execution
- **Browser:** Full browser automation (navigate, click, type, screenshot, JS console)
- **Search:** Web search capabilities
- **Deployment:** Port exposure, static/ dynamic site deployment

**Configurable Dimensions:**
- **Autonomy:** High — operates in a sandbox, executes tasks methodically, provides regular updates
- **Safety:** Cannot access systems outside sandbox; ethical guidelines; cannot create accounts
- **Scope:** General-purpose (not just coding) — research, data analysis, content creation, deployment
- **User interaction:** Dual communication model — notify (async) vs ask (blocking); suggests browser takeover when stuck

**Composable Primitives:**
1. **notify-vs-ask** — Two communication modes: inform without blocking, or ask and wait
2. **browser-takeover-suggest** — When stuck in browser, suggest user takes over
3. **sandbox-execute** — Full Linux sandbox with sudo capabilities
4. **progressive-updates** — Regular progress messages during long-running tasks
5. **qa-verify-deliver** — Verify against requirements → test → document → deliver


### 7. Lovable

**Orchestration Pattern:** Strict workflow: check-context → discuss-first → think-plan → clarify → gather → implement → verify. Unique "DEFAULT TO DISCUSSION MODE" — assumes users want to discuss before coding unless they use action words. Optimized for **non-technical users** — discourages asking users to manually edit files or provide console logs. First interaction is special-cased: write code immediately, make it beautiful. Has an implicit live-preview loop (iframe on right side of UI).

**Tool Taxonomy:**
- **File ops:** search-replace, write-file, rename-file, delete-file
- **Debugging:** `read-console-logs`, `read-network-requests` (debugging tools FIRST before code changes)
- **Web:** `web_search`, `fetch` (download files from web)
- **Image generation:** `imagegen` tool for generating images
- **Visualization:** Mermaid diagram rendering
- **Design system:** Custom design token management (index.css, tailwind.config.ts)

**Configurable Dimensions:**
- **Autonomy:** Low for discussion, high for implementation — discussion-first by default, but goes all-out when coding
- **Safety:** Must read file before writing; no env variables (VITE_* unsupported); never use custom styles (design system only)
- **Scope:** Narrow — React + Vite + Tailwind + TypeScript + Supabase only; no other frameworks or backends
- **UX focus:** Non-technical users; beautiful design is top priority; SEO requirements baked in
- **Design enforcement:** Strict semantic token system; never use direct colors; always use design system tokens

**Composable Primitives:**
1. **context-first-check** — Always check useful-context before reading files
2. **discussion-then-implement** — Two-phase: discuss by default, implement only on explicit action words
3. **debug-first** — Use console logs/network requests before modifying code
4. **design-system-first** — Define tokens in index.css → use semantic tokens everywhere
5. **parallel-batch-edits** — Batch all independent file operations simultaneously
6. **first-impression-override** — On first message, skip discussion, go straight to beautiful code
7. **seo-auto-apply** — SEO best practices baked into every page/component


### 8. Trae (Builder)

**Orchestration Pattern:** Straightforward reactive agent. Step-by-step analysis: think → determine if tool needed → call tool or respond. Emphasizes **minimum steps** — complete all modifications with fewest possible steps (max 3). No explicit planning/TODO system. Rich reference system for file/symbol/URL citations.

**Tool Taxonomy:**
- **Code exploration:** search tools, file reading (prefer larger sections)
- **File ops:** code edit tools (specific tools in Builder Tools.json)
- **Shell:** Terminal command execution
- **Web:** web search with mandatory citation format (`<mcreference>` tags)
- **Image generation:** SVG only (vector format mandated)

**Configurable Dimensions:**
- **Autonomy:** Medium — calls tools autonomously, but follows user instructions closely
- **Safety:** Standard security practices; SVG-only for images; never disclose tool descriptions or turns remaining
- **Context depth:** Auto-attaches editor state (open files, cursor, edit history)
- **Reference system:** Unique rich XML citation format — `<mcfile>`, `<mcsymbol>`, `<mcurl>`, `<mcfolder>`, `<mcreference>`
- **Step limit:** Hard limit of 3 steps max for implementation; encourages single-step completion

**Composable Primitives:**
1. **min-step-edit** — Complete all changes in 1-3 steps maximum
2. **rich-reference** — XML-tagged file/symbol/URL/folder citations in all responses
3. **web-citation-mandatory** — Every line using web info must have `<mcreference>` citation
4. **svg-only-images** — Vector graphics only, never binary image formats
5. **large-read-preference** — Read larger file sections at once, not multiple small calls


### 9. Same.dev

**Orchestration Pattern:** Cloud-based IDE agent with a strong **version-and-deploy** loop. After every significant edit: restart dev server → create version → deploy to Netlify. Has a `.same` folder for persistent notes/todos (markdown-based, not structured). Unique **startup tool** for project initialization. Plan-then-immediately-execute pattern (no waiting for confirmation). Web-scraping for pixel-perfect UI cloning. Suggests next-version changes at end via `suggestions` tool.

**Tool Taxonomy:**
- **Project management:** `startup` (project scaffolding), `versioning` (snapshot versions), `suggestions` (propose next changes)
- **File ops:** `edit_file` (sketch-based), `string_replace` (>2500 lines), `smart_apply` flag for retrying failed edits
- **Shell:** Terminal with `bun` preference over `npm`
- **Web:** `web_search`, `web_scrape` (fetch docs/pages)
- **Quality:** `run_linter` (after every significant edit)
- **Deployment:** Auto-deploy to Netlify after each version
- **Memory:** `.same/` folder for todos, wikis, docs

**Configurable Dimensions:**
- **Autonomy:** High — plan and immediately execute; auto-deploy; no waiting for confirmation unless ambiguous
- **Safety:** 3-strike linter rule (stop after 3 failed fixes); rollback requires user action; version frequently
- **Scope:** Web applications only — runs in Docker Ubuntu 22.04 container
- **Design:** shadcn/ui base, but must customize immediately; pixel-perfect cloning from screenshots
- **Deployment:** Automatic Netlify deployment after each version

**Composable Primitives:**
1. **edit-restart-version-deploy** — Signaledit → restart dev server → version → auto-deploy
2. **pixel-perfect-scrape** — Scrape website → screenshot → clone UI with attention to detail
3. **smart-apply-retry** — Failed edit → retry with `smart_apply=true`
4. **progressive-versioning** — Version after every significant edit (checkpoint system)
5. **suggestions-next** — End session with proposed changes for next version
6. **dot-same-memory** — Persistent `.same/` folder for cross-session notes/todos
7. **linter-3-strike** — Run linter after edit, stop after 3 failed fixes on same file


### 10. Kiro

**Orchestration Pattern:** **Spec-driven development** — the most structured workflow of all tools analyzed. Three-phase waterfall with mandatory user approval gates: Requirements (EARS format) → Design → Task List. Each phase creates a `.kiro/specs/{feature}/` document. The workflow is a strict state machine (shown in Mermaid diagram). Key principle: **only execute one task at a time, stop after completion, never auto-continue**.

**Tool Taxonomy:**
- **File ops:** fsWrite (small writes + appends for velocity)
- **Shell:** Standard Linux bash
- **Spec system:** requirements.md, design.md, tasks.md in `.kiro/specs/`
- **Steering:** `.kiro/steering/*.md` files (always/conditional/manual inclusion patterns)
- **Hooks:** Agent hooks triggered by IDE events (save, click, etc.)
- **MCP:** Full MCP support with workspace and user-level configs
- **Context:** `#File`, `#Folder`, `#Problems`, `#Terminal`, `#GitDiff`, `#Codebase`

**Configurable Dimensions:**
- **Autonomy:** Low — extremely user-approval-gated; must stop after every task; never assume preferences
- **Safety:** PII substitution; never discuss sensitive topics; strict approval gates between phases
- **Structure:** The most rigid workflow — state machine with mandatory sequential phases
- **Steering:** Persistent instruction files that influence all interactions (always/conditional/manual)
- **Tone:** "Companionable partner" — warm, dev-friendly, concise, no fluff

**Composable Primitives:**
1. **spec-requirements-EARS** — Requirements in EARS format with user stories + acceptance criteria
2. **spec-design-with-research** — Research-informed design with architecture, components, data models
3. **spec-tasks-LLM-prompts** — Task list as series of prompts for a code-generation LLM
4. **one-task-at-a-time** — Execute single task, stop, wait for user to pick next
5. **steering-context** — Persistent steering files with inclusion patterns (always/conditional/manual)
6. **agent-hooks** — Event-driven automatic agent execution (save→test, etc.)
7. **incremental-write-append** — Small writes followed by appends for velocity


### 11. Warp.dev (Agent Mode)

**Orchestration Pattern:** Terminal-native agent with a question-vs-task classifier. First determines if the user is asking a question (answer directly, offer to execute) or giving a task (assess complexity, then execute). Simple tasks: just run the command. Complex tasks: clarify intent, gather info, then execute. No planning/TODO system — purely reactive.

**Tool Taxonomy:**
- **Shell:** `run_command` (non-interactive, non-paginated, absolute paths)
- **File ops:** `read_files` (ranged, max 5000 lines), `edit_files` (exact search/replace, no abbreviations)
- **Search:** `grep` (ERE regex), `file_glob` (name patterns)
- **No browser, no web search, no sub-agents, no deployment**

**Configurable Dimensions:**
- **Autonomy:** Medium — runs commands autonomously but asks clarifying questions for complex tasks
- **Safety:** Never assists malicious intent; no browser access; no interactive/fullscreen commands
- **Scope:** Terminal-only — the most constrained tool set of all analyzed
- **Citations:** Mandatory `<citations>` XML tag when using external context
- **Simplicity:** Intentionally minimal — no sub-agents, no deployment, no browser

**Composable Primitives:**
1. **question-vs-task-classify** — Route to answer or execute based on intent
2. **just-run-it** — For simple tasks, bias towards running the right command
3. **exact-search-replace** — No abbreviations, exact string matching for edits
4. **5000-line-chunked-read** — Read files in exactly 5000-line chunks
5. **non-interactive-command** — Always use non-interactive, non-paginated command flags


### 12. Replit Assistant

**Orchestration Pattern:** Simple propose-and-apply model. The assistant proposes changes (file edits, shell commands, tool nudges) and the IDE automatically applies them. No planning system, no TODO tracking. Routes requests to three channels: file changes, shell commands, or other workspace tools (Secrets, Deployments).

**Tool Taxonomy:**
- **File ops:** `proposed_file_replace_substring` (exact match), `proposed_file_replace` (full file)
- **Shell:** `proposed_shell_command` (with working directory)
- **Workspace nudges:** Secrets tool, Deployments tool
- **Auto-dependencies:** IDE auto-installs packages from manifest files

**Configurable Dimensions:**
- **Autonomy:** Low — proposes changes, IDE applies; nudges to other tools rather than executing
- **Safety:** No creative extensions unless explicitly asked; precise and accurate modifications
- **Scope:** Online IDE (Linux/Nix) — deployment, debugging, auto-package-management
- **Simplicity:** Very simple — propose changes, don't execute directly

**Composable Primitives:**
1. **propose-and-apply** — Propose file changes, IDE auto-applies
2. **tool-nudge** — Route to appropriate workspace tool (Secrets, Deployments)
3. **auto-dependency** — Rely on IDE to install packages from manifest files
4. **substring-replace-exact** — Unique old_str must match exactly once in file


### 13. VSCode Agent (GitHub Copilot)

**Orchestration Pattern:** Context-gather → edit → verify. Prefers `semantic_search` for exploration (not parallel with other searches). Unique `get_errors` validation step is *mandatory* after every edit. Has `update_user_preferences` for remembering user corrections/facts. Supports multiple base models (GPT-5, GPT-5-mini, GPT-4.1, GPT-4o, Claude Sonnet 4, Gemini 2.5 Pro).

**Tool Taxonomy:**
- **Code exploration:** `semantic_search` (natural language), `grep` (exact strings), `file_search` (filename patterns)
- **File ops:** `insert_edit_into_file` (sketch-based with `// ...existing code...` abbreviation)
- **Shell:** `run_in_terminal` (sequential only — never parallel terminal calls)
- **Validation:** `get_errors` (MANDATORY after every edit)
- **Memory:** `update_user_preferences` (persist user corrections/facts)
- **Lists:** `list_directory`

**Configurable Dimensions:**
- **Autonomy:** Medium-high — don't ask permission, just use tools; but don't run terminal commands in parallel
- **Safety:** Follow Microsoft content policies; validate with `get_errors` after edits
- **Context:** If semantic_search returns full workspace, you have all context — stop searching
- **Multi-model:** Supports 7+ base models with model-specific prompts
- **Edit style:** Smart insert_edit — can understand minimal hints, use `// ...existing code...`

**Composable Primitives:**
1. **search→edit→get_errors** — Mandatory edit-validate cycle
2. **semantic-search-first** — Prefer semantic search unless exact string known
3. **preference-memory** — Save user corrections and preferences persistently
4. **sketch-edit-existing-code** — Use `// ...existing code...` for concise edits
5. **no-parallel-terminal** — Run terminal commands sequentially, never parallel


### 14. Amp (Sourcegraph)

**Orchestration Pattern:** Fast-context-understanding with early-stop heuristics. "Get enough context fast, then act." Parallel discovery with deduplication. Key rules: simple-first (smallest local fix), reuse-first (mirror existing patterns), no-surprise-edits (>3 files → show plan first), no-new-deps without approval. Fully end-to-end: "don't hand back half-baked work."

**Tool Taxonomy:**
- **Code exploration:** Semantic search, symbol tracing (stop at symbols you'll modify)
- **File ops:** Edit tools
- **Shell:** Command execution
- **Multi-model:** GPT-5 and Claude 4 Sonnet variants

**Configurable Dimensions:**
- **Autonomy:** High — full end-to-end resolution, iterate until complete
- **Safety:** No surprise edits across >3 files; no new deps without approval
- **Context strategy:** Parallel discovery → early stop when you can name exact files/symbols

**Composable Primitives:**
1. **parallel-discovery-early-stop** — Fan out searches, stop as soon as you can act
2. **simple-first-fix** — Smallest local fix over cross-file architecture change
3. **reuse-first-mirror** — Search existing patterns, mirror naming/style/tests
4. **no-surprise-plan** — Show plan before >3 file changes
5. **trace-only-what-you-modify** — Don't transitively expand context unnecessarily

---

### 15. Junie (JetBrains)

**Orchestration Pattern:** Read-only exploration agent. Works in a constrained shell with `search_project` (fuzzy), `get_file_structure` (symbol listing), and `open` (file view). Explicit readonly mode — cannot modify, create, or remove files. Final answer via `answer` command. Purpose: investigate and answer, not implement.

**Tool Taxonomy:**
- **Code exploration:** `search_project` (fuzzy, wildcard), `get_file_structure` (class/method outline), `open` (file view)
- **Shell:** Read-only bash (`ls`, `cat`, `cd`)
- **Output:** `answer` command (final answer delivery)

**Composable Primitives:**
1. **readonly-explore-answer** — Investigate without modifying, deliver structured answer
2. **fuzzy-search-broad** — Fuzzy search for exhaustive symbol/file/text matching
3. **structure-first-navigate** — Get file structure before opening to know where to look

---

### 16. Cline (Open Source)

**Orchestration Pattern:** Step-by-step single-tool-per-turn agent. Each tool use informed by the result of previous. Commands require user approval with `requires_approval` flag. Supports MCP (Model Context Protocol) servers for extended tool access. Has a browser use tool for web interaction.

**Tool Taxonomy:**
- **File ops:** `read_file` (extracts text from PDF/DOCX too), `write_to_file` (complete content), `replace_in_file` (search/replace blocks)
- **Shell:** `execute_command` (with approval flag)
- **Search:** `list_files`, `list_code_definition_names`
- **Browser:** `browser_action` (navigate, click, type, screenshot)
- **MCP:** Extensible via MCP server connections

**Composable Primitives:**
1. **single-tool-per-turn** — One tool, wait for result, then next tool
2. **approval-flagged-commands** — Binary safe/unsafe classification per command
3. **search-replace-blocks** — Multiple diff hunks in single replace_in_file call
4. **mcp-extension** — Add tools dynamically via Model Context Protocol

---

### 17. Google Gemini CLI / Antigravity

**Orchestration Pattern:** (From Google directory) Gemini-based agent with Google-specific tooling. Antigravity appears to be Google's internal coding agent. Uses Gemini models with extended context windows.

**Composable Primitives:**
1. **gemini-extended-context** — Large context window for whole-codebase understanding
2. **google-tool-ecosystem** — Integration with Google Cloud services

---

### 18. Codex CLI (Open Source)

**Orchestration Pattern:** OpenAI's CLI coding agent. Sandbox-execution model with autonomous code generation. Simple propose-and-execute loop.

**Composable Primitives:**
1. **sandbox-autonomous** — Execute in sandbox, propose changes
2. **cli-native** — Terminal-first interface, no IDE integration

---

### 19. RooCode (Open Source)

**Orchestration Pattern:** VSCode extension, fork/evolution of Cline. Similar tool-per-turn pattern with additional features like diff-based editing and mode switching (code/architect/ask).

**Composable Primitives:**
1. **mode-switching** — Toggle between code, architect, and ask modes
2. **diff-based-editing** — Propose changes as diffs for review

---

### 20. Bolt (Open Source)

**Orchestration Pattern:** Web-based code generation agent. Streaming code output with live preview. Focused on rapid prototyping.

**Composable Primitives:**
1. **stream-generate-preview** — Stream code generation with live preview
2. **rapid-prototype** — Fast scaffolding over production quality


---

## Synthesis

### Universal Patterns (present in 80%+ of tools)

| Pattern | Description | Prevalence |
|---------|-------------|------------|
| **Search→Read→Edit→Verify** | Core edit cycle: find relevant code, read for context, make change, validate | 13/13 primary tools |
| **Read before edit** | Mandatory file read before any modification | 12/13 |
| **Mimic existing conventions** | Follow codebase style, naming, patterns; never assume library availability | 12/13 |
| **Parallel tool calls** | Batch independent operations simultaneously | 11/13 |
| **Never commit secrets** | Security best practice hardcoded into prompts | 11/13 |
| **Context gathering phase** | Explicit exploration before acting | 13/13 |
| **No creative extensions** | Don't add features beyond what was asked | 10/13 |
| **User approval for destructive ops** | Gate commands that modify system state | 10/13 |
| **Error validation after edit** | Run linter/typecheck/tests after changes | 9/13 |
| **Concise communication** | Minimize output tokens, avoid preamble | 11/13 |
| **Semantic code search** | Natural language search over codebase | 9/13 |

### Differentiating Patterns (unique to 1-2 tools)

| Pattern | Tool(s) | Description |
|---------|---------|-------------|
| **Dual-mode planning** | Devin | Explicit planning ↔ standard mode switch |
| **Think-before-act scratchpad** | Devin | Mandatory reasoning checkpoint before critical transitions |
| **Persistent memory DB** | Windsurf | Cross-conversation memory with auto-retrieval |
| **Continuous plan updates** | Windsurf | Update plan before every significant action |
| **Extreme brevity (<4 lines)** | Claude Code | "One word answers are best" |
| **Sub-agent delegation** | Claude Code | Task tool spawns specialized agents |
| **Spec-driven development** | Kiro | Requirements (EARS) → Design → Tasks waterfall with approval gates |
| **Steering files** | Kiro | Persistent instruction files with inclusion patterns |
| **Agent hooks** | Kiro | Event-driven automatic execution (save→test) |
| **Discussion-first mode** | Lovable | Default to discussion, implement only on action words |
| **Non-technical user optimization** | Lovable, Manus | Never ask users to manually provide logs or edit files |
| **Design system enforcement** | Lovable | Strict semantic token system, no ad-hoc styles |
| **Version-deploy loop** | Same.dev | Edit → restart → version → auto-deploy after every change |
| **Pixel-perfect scraping** | Same.dev | Scrape website for UI cloning |
| **Smart-apply retry** | Same.dev, Cursor | Failed edit → retry with stronger model/flag |
| **Full browser automation** | Devin, Manus | Playwright-based web interaction |
| **Git-commit-retrieval planning** | Augment | Use git history to find how similar changes were made |
| **Stuck-detection** | Augment | Self-awareness of going in circles → ask user for help |
| **Fast-context early-stop** | Amp | Parallel discovery, stop as soon as you can name exact files |
| **No-surprise-edits** | Amp | Show plan before >3 file changes |
| **Readonly explore** | Junie | Investigation-only agent, no modifications |
| **3-step hard limit** | Trae | Complete all changes in maximum 3 steps |
| **Rich XML references** | Trae | File/symbol/URL/folder citations in all responses |
| **Terminal-only** | Warp.dev | Most constrained tool set, no browser/web/sub-agents |
| **Question-vs-task classifier** | Warp.dev | Route to answer or execute based on intent |
| **Mandatory get_errors** | VSCode Agent | Validate after every edit, fix if relevant |
| **Multi-model support** | VSCode Agent | GPT-5, Claude, Gemini with model-specific prompts |
| **MCP extensibility** | Cline, Kiro | Dynamic tool addition via Model Context Protocol |
| **Sketch-based editing** | Cursor, VSCode Agent | Use `// ...existing code...` for concise edit hints |
| **Full computer access** | Devin | Persistent shells, browser, deployment, LSP |
| **LSP integration** | Devin | Definition/references/hover for type-aware navigation |
| **Pop quiz integrity check** | Devin | Random verification of agent behavior |
| **SEO auto-application** | Lovable | SEO best practices baked into every component |
| **Image generation** | Lovable, Same.dev | Generate images for UI assets |
| **EARS requirements** | Kiro | Formal requirements syntax (WHEN/THEN/SHALL) |

### Primitive Library — 30 Atomic Building Blocks

#### Discovery Primitives
1. **`semantic_search(query, dirs?)`** — Natural language code search
2. **`regex_search(pattern, file_filter?)`** — Exact pattern matching (ripgrep)
3. **`filename_glob(pattern)`** — Find files by name pattern
4. **`list_dir(path)`** — Directory listing for structure understanding
5. **`lsp_goto_definition(symbol, file, line)`** — Type-aware navigation
6. **`lsp_find_references(symbol)`** — Find all usages
7. **`git_log_search(pattern)`** — Search git history for similar changes
8. **`file_structure(file)`** — Get symbol outline (classes, methods, imports)

#### Reading Primitives
9. **`read_file(path, start?, end?)`** — Ranged file reading
10. **`read_image(path)`** — Visual file analysis (PNG, JPG, etc.)
11. **`read_lints()`** — Get current linter/type errors
12. **`read_console_logs()`** — Browser/runtime console output
13. **`read_network_requests()`** — HTTP request log for debugging

#### Editing Primitives
14. **`exact_replace(file, old_str, new_str)`** — Precise string replacement
15. **`sketch_edit(file, code_sketch)`** — Hint-based edit with existing-code markers
16. **`create_file(path, content)`** — New file creation
17. **`multi_edit(file, [{old, new}])`** — Batch atomic edits to single file
18. **`find_and_edit(dir, regex, instruction)`** — Multi-file regex-based batch editing
19. **`smart_apply_retry(file, edit)`** — Re-attempt failed edit with stronger model

#### Execution Primitives
20. **`run_command(cmd, cwd?, bg?)`** — Shell command execution
21. **`poll_command(id)`** — Check status of async command
22. **`browser_navigate(url)`** — Open web page
23. **`browser_interact(action, element)`** — Click, type, select in browser
24. **`browser_screenshot()`** — Capture current browser state

#### Planning & Memory Primitives
25. **`create_todo(items)`** — Task list with pending/in_progress/completed states
26. **`create_memory(key, value)`** — Persistent cross-session storage
27. **`update_plan(steps)`** — Maintain current plan state
28. **`think_scratchpad(reasoning)`** — Mandatory reasoning checkpoint

#### Validation Primitives
29. **`get_errors(file)`** — Post-edit error checking (mandatory)
30. **`run_linter()`** — Lint/typecheck after significant edits

### Recommended "Dials" for Git-Agent Fleet

Based on the synergy analysis, here are the configurable dimensions we recommend for a git-agent fleet:

#### 1. **Autonomy Level** (5 levels)
| Level | Name | Description | Example Tools |
|-------|------|-------------|---------------|
| 1 | Propose-only | Suggest changes, user applies | Replit |
| 2 | Single-step | One tool per turn, user approves each | Cline, Warp |
| 3 | Multi-step gated | Plan→execute but stop at approval gates | Kiro, Augment |
| 4 | Autonomous with checkpoints | Run freely, pause at natural boundaries | Claude Code, Cursor |
| 5 | Full autopilot | End-to-end with minimal interruption | Devin, Amp |

#### 2. **Verification Rigor** (4 levels)
| Level | Name | Description |
|-------|------|-------------|
| A | None | No post-edit validation |
| B | Lint-only | Run linter after edits (Warp, Cursor) |
| C | Lint + Test | Linter and test suite (Claude Code, VSCode Agent) |
| D | Full QA | Lint + test + build + deploy verification (Same.dev) |

#### 3. **Context Depth** (4 levels)
| Level | Name | Description |
|-------|------|-------------|
| 1 | Minimal | Current file + imports |
| 2 | Standard | Open files + semantic search results |
| 3 | Deep | LSP integration + git history + symbol tracing (Devin, Augment) |
| 4 | Exhaustive | Full codebase indexed + memory DB (Windsurf) |

#### 4. **Planning Formality** (5 levels)
| Level | Name | Description |
|-------|------|-------------|
| 1 | None | Reactive, no plan (Warp, Replit) |
| 2 | Implicit TODO | TodoWrite-style tracking (Claude Code, Cursor) |
| 3 | Continuous plan | Update plan before/after actions (Windsurf) |
| 4 | Structured plan | Information-gather → plan → execute (Augment, Devin) |
| 5 | Spec-driven | Requirements → Design → Tasks waterfall (Kiro) |

#### 5. **Safety Posture** (3 levels)
| Level | Name | Description |
|-------|------|-------------|
| Conservative | Augment-style | Ask before any action beyond explicit request |
| Balanced | Claude Code-style | Proactive but cautious; never commits without asking |
| Aggressive | Devin-style | Full computer access; report environment issues but work around them |

#### 6. **Communication Verbosity** (4 levels)
| Level | Name | Description |
|-------|------|-------------|
| Silent | Amp-style | No explanation after edits, just stop |
| Terse | Claude Code-style | <4 lines, one-word answers preferred |
| Normal | Cursor-style | Brief status updates during work |
| Verbose | Kiro-style | Full explanations with structured documents |

#### 7. **Edit Strategy** (3 options)
| Strategy | Name | Description |
|----------|------|-------------|
| Exact | Cline/Warp-style | Full old_string → new_string, no abbreviations |
| Sketch | Cursor/VSCode-style | `// ...existing code...` with minimal hints |
| Smart-apply | Same.dev-style | Attempt edit, retry with stronger model if failed |

#### 8. **Parallelism** (3 levels)
| Level | Name | Description |
|-------|------|-------------|
| Sequential | Cline/Warp-style | One tool at a time, wait for results |
| Batched | Claude Code-style | Multiple independent calls in single message |
| Max-parallel | Cursor-style | Always batch 3-5 calls, never sequential unless dependent |

---

### Fleet Composition Recommendations

For a git-agent fleet, compose agents from these dials:

**PR Review Agent:** Autonomy 3, Verification D, Context 3, Planning 2, Safety Conservative, Verbosity Terse, Edit Exact, Parallelism Batched

**Bug Fix Agent:** Autonomy 4, Verification C, Context 3, Planning 4, Safety Balanced, Verbosity Normal, Edit Sketch, Parallelism Max

**Feature Agent:** Autonomy 3, Verification C, Context 4, Planning 5, Safety Balanced, Verbosity Normal, Edit Sketch, Parallelism Max

**Refactoring Agent:** Autonomy 3, Verification D, Context 4, Planning 4, Safety Conservative, Verbosity Normal, Edit Exact, Parallelism Batched

**Hotfix Agent:** Autonomy 5, Verification B, Context 2, Planning 1, Safety Aggressive, Verbosity Silent, Edit Sketch, Parallelism Max

**Documentation Agent:** Autonomy 3, Verification A, Context 2, Planning 2, Safety Conservative, Verbosity Verbose, Edit Exact, Parallelism Sequential

---

*Analysis complete. 20 tools analyzed across 13 primary and 7 secondary tools.*
