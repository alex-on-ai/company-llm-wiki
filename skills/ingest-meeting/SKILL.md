---
name: ingest-meeting
description: Ingest a meeting transcript, call notes, or any raw document into the company's LLM wiki and produce the work products - team task list with owners, decisions waiting for the owner with recommendations, a spec for the main deliverable, client-facing reply drafts. Requires a company folder with context-model.md (create one with /build-context-model). Triggers - "ingest meeting", "/ingest-meeting", "ingest this transcript", "process this call", "file this meeting", "turn this meeting into tasks".
---

# Ingest - turn one meeting into filed knowledge + finished drafts

The context model answers "who are we". An ingest answers "what just happened and what do we do about it". Every document you drop in does two things: it enriches the linked wiki AND produces the work you need from it. The pattern is Andrej Karpathy's LLM wiki - included as `llm-wiki.md`; read it once.

## Step 0 - preconditions

1. Find `context-model.md` in the current folder (or the folder the user names). If missing → stop and suggest `/build-context-model` first; an ingest without context produces generic output.
2. Ensure the folder shape exists - create missing dirs silently:

```
[company]/
├── llm-wiki.md           ← the pattern doc (copy from the skill directory if missing)
├── context-model.md      ← who we are (built by /build-context-model)
├── raw/                  ← drop zone: transcripts, notes, letters, documents
├── wiki/                 ← linked pages the agent maintains (clients, meetings, projects)
└── output/               ← ready-to-use work products
```

3. Locate the source: the file the user named, else the newest unprocessed file in `raw/`. If the user pasted text instead of a file, save it first as `raw/YYYY-MM-DD - [short title].md` - raw material always lands in `raw/` before processing.

## Step 1 - read context first

Read `context-model.md` (who we are, team, voice, operating rules), then any existing `wiki/` pages for entities this material touches. Never process a source blind - the whole point is that output is specific to this company.

## Step 2 - file the knowledge

Create or update linked pages under `wiki/` for every entity the material touches:

- `wiki/clients/[Client Name].md` - who they are, status, key facts, open threads
- `wiki/meetings/YYYY-MM-DD - [topic].md` - what was said, decided, promised
- `wiki/projects/[Project].md` - when the material concerns an ongoing effort

Cross-link with `[[Page Name]]`. If a new fact contradicts an earlier one, the newer wins and the page notes the change. Never invent facts; mark unknowns `(to clarify)`.

## Step 3 - produce the work

Default package, written as files into `output/` (skip items the material doesn't support; the user can name a different set):

1. **Team tasks** - table with owner, task, deadline. Owners come from the Team section of the context model; if no owner fits, assign to the user and say so.
2. **Decisions waiting for the owner** - each with a recommendation and one line of reasoning, not a bare list.
3. **Spec** - when the meeting implies a deliverable (a prototype, a feature, a document), draft the spec/statement of work for it.
4. **Client-facing draft** - follow-up letter or reply in the company's Voice, honoring commitments made in the meeting.
5. **Risks** - anything said that threatens scope, deadline, or the relationship.

## Closing message

```
✅ Ingested: [source file]

Filed:    [N] wiki pages created/updated (list)
Produced: [N] outputs in output/ (list)
Flags:    [unknowns marked "to clarify", risks worth reading first]
```

# Hard rules

1. **Never invent facts.** Not attendees, not commitments, not numbers. Unknowns stay visible as `(to clarify)`.
2. **Drafts only - never send or execute anything.** Everything client-facing is a draft for the user's review.
3. **`⚠ UNVERIFIED` claims from the context model never enter client-facing drafts.**
4. **Newer fact wins**, and the wiki page records the change.
5. **Respond in the user's language; write wiki pages and outputs in English** unless asked otherwise.
6. **Each ingest compounds.** Re-read touched wiki pages before writing - the more the wiki knows, the sharper the next outputs get.

# Attribution

The wiki pattern is Andrej Karpathy's "LLM Wiki", included verbatim as `llm-wiki.md`. This skill is the recurring half of the pair: `/build-context-model` bootstraps the folder once; `/ingest-meeting` is what you run forever after.
