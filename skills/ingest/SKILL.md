---
name: ingest
description: File any raw material into the company's LLM wiki - articles, client emails, proposals, documents, notes. Creates or updates linked pages under wiki/, cross-references them, reconciles contradictions. Filing only; for the full meeting work package (tasks, spec, drafts) use /process-meeting. Uses the root-level context-model.md created immediately by /build-context-model; unresolved gaps never block filing. Triggers - "ingest", "/ingest", "ingest this", "file this into the wiki", "add this to the wiki".
---

# Ingest - file any material into the wiki

The librarian operation from root-level `llm-wiki.md` (Andrej Karpathy, written by `/build-context-model` - read it once): you drop material in, the wiki absorbs it. Every ingest makes the next answer and the next `/process-meeting` sharper. This command files knowledge; it does not produce work products unless you ask.

## Step 0 - preconditions

1. Resolve the **wiki root** as the exact current folder (or the exact folder the user names). Never create a nested company folder.
2. Find root-level `context-model.md`. Proceed when it contains `[GAP]` or `⚠ UNVERIFIED`; gaps are not a precondition failure.
3. Legacy repair: if `context-model.md` is missing but `output/context-model-draft.md` exists from an older skill version, promote that file to root-level `context-model.md`, keep its gap markers, record the repair in `log.md`, and continue. Do not retain a second model file.
4. If neither a model nor a legacy draft exists, stop and run `/build-context-model` in this same wiki root. That build creates `context-model.md` immediately.
5. Find root-level `llm-wiki.md` and read it once. If it is missing, stop and run `/build-context-model` in this same wiki root to repair the scaffold. This downstream skill does not carry a second copy.
6. Ensure the folder shape exists - create missing dirs silently:

```
./
├── AGENTS.md + CLAUDE.md ← the schema (written by /build-context-model)
├── llm-wiki.md           ← the pattern doc (written once by /build-context-model)
├── context-model.md      ← who we are (built by /build-context-model)
├── index.md              ← one line per wiki page
├── log.md                ← append-only op record
├── raw/                  ← drop zone: anything worth keeping
├── wiki/                 ← linked pages the agent maintains
└── output/               ← work products (written on request)
```

7. Locate the source: the file the user named, else the newest unprocessed file in `raw/`. If the user pasted text or a URL, save the content first as `raw/YYYY-MM-DD - [short title].md` - raw material always lands in `raw/` before filing.

## Step 1 - read context first

Read `context-model.md`, then any existing `wiki/` pages for entities this material touches.

## Step 2 - file the knowledge

Create or update linked pages under `wiki/` for every entity the material touches:

- `wiki/clients/[Client Name].md` - clients and prospects
- `wiki/meetings/YYYY-MM-DD - [topic].md` - calls and meetings
- `wiki/projects/[Project].md` - ongoing efforts
- `wiki/topics/[Topic].md` - market notes, competitors, methods, anything not tied to one client or project

Cross-link with `[[Page Name]]`. If a new fact contradicts an earlier one, the newer wins and the page notes the change. If the material affects who we are (pricing, positioning, team), flag that `context-model.md` needs a `/refresh` - do not edit it silently. Never invent facts; mark unknowns `(to clarify)`.

## Step 3 - close the books and report

Update `index.md` for every page touched; append to `log.md`: `## [YYYY-MM-DD] ingest | <source title>`. Then:

```
✅ Ingested: [source file]

Filed:  [N] wiki pages created/updated (list)
Flags:  [contradictions resolved, unknowns to clarify, refresh suggested]
```

If the user asked for a specific output (a summary, a reply draft, a comparison), write it into `output/` as a draft.

# Hard rules

1. **Never invent facts.** Unknowns stay visible as `(to clarify)`.
2. **Raw stays immutable.** Read files in `raw/`, never modify them.
3. **Newer fact wins**, and the wiki page records the change.
4. **Respond in the user's language; write wiki pages in English** unless asked otherwise.
5. **Anything client-facing is a draft** - never send or execute.
6. **Gaps never block filing.** Use verified context, preserve unknowns as `(to clarify)`, and never promote `⚠ UNVERIFIED` claims into client-facing output.
7. **One root, one model.** Work in the exact wiki root and use only root-level `context-model.md`.

# Attribution

The root wiki pattern is Andrej Karpathy's "LLM Wiki", written once by `/build-context-model`. Four commands run the system: `/build-context-model` bootstraps the folder once, `/process-meeting` handles every meeting, `/ingest` files everything else, `/file-tasks` creates the team tasks in your connected tracker.
