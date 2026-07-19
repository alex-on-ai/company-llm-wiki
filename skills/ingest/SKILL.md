---
name: ingest
description: File any raw material into the company's LLM wiki - articles, client emails, proposals, documents, notes. Creates or updates linked pages under wiki/, cross-references them, reconciles contradictions. Filing only; for the full meeting work package (tasks, spec, drafts) use /process-meeting. Requires a company folder with context-model.md (create one with /build-context-model). Triggers - "ingest", "/ingest", "ingest this", "file this into the wiki", "add this to the wiki".
---

# Ingest - file any material into the wiki

The librarian operation from `llm-wiki.md` (Andrej Karpathy, included in this folder - read it once): you drop material in, the wiki absorbs it. Every ingest makes the next answer and the next `/process-meeting` sharper. This command files knowledge; it does not produce work products unless you ask.

## Step 0 - preconditions

1. Find `context-model.md` in the current folder (or the folder the user names). If missing → stop and suggest `/build-context-model` first.
2. Ensure the folder shape exists - create missing dirs silently:

```
[company]/
├── llm-wiki.md           ← the pattern doc (copy from the skill directory if missing; fallback: download https://raw.githubusercontent.com/alex-on-ai/company-llm-wiki/main/llm-wiki.md)
├── context-model.md      ← who we are (built by /build-context-model)
├── raw/                  ← drop zone: anything worth keeping
├── wiki/                 ← linked pages the agent maintains
└── output/               ← work products (written on request)
```

3. Locate the source: the file the user named, else the newest unprocessed file in `raw/`. If the user pasted text or a URL, save the content first as `raw/YYYY-MM-DD - [short title].md` - raw material always lands in `raw/` before filing.

## Step 1 - read context first

Read `context-model.md`, then any existing `wiki/` pages for entities this material touches.

## Step 2 - file the knowledge

Create or update linked pages under `wiki/` for every entity the material touches:

- `wiki/clients/[Client Name].md` - clients and prospects
- `wiki/meetings/YYYY-MM-DD - [topic].md` - calls and meetings
- `wiki/projects/[Project].md` - ongoing efforts
- `wiki/topics/[Topic].md` - market notes, competitors, methods, anything not tied to one client or project

Cross-link with `[[Page Name]]`. If a new fact contradicts an earlier one, the newer wins and the page notes the change. If the material affects who we are (pricing, positioning, team), flag that `context-model.md` needs a `/refresh` - do not edit it silently. Never invent facts; mark unknowns `(to clarify)`.

## Step 3 - report

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

# Attribution

The wiki pattern is Andrej Karpathy's "LLM Wiki", included verbatim as `llm-wiki.md`. Three commands run the system: `/build-context-model` bootstraps the folder once, `/process-meeting` handles every meeting, `/ingest` files everything else.
