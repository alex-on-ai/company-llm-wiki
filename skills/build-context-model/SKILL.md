---
name: build-context-model
description: Build and maintain a Company Context Model - the single document that lets any AI assistant (ChatGPT, Claude, n8n agents) produce specific, on-brand, delegation-ready output instead of generic slop. Two build modes - /build harvest (draft from existing materials: website, docs, repos; ask only the gaps) and /build interview (guided interview in batches). /refresh runs the weekly update ritual. Triggers - "build context model", "build my context model", "/build-context-model", "/build", "/refresh", "set up company context", "my AI answers are generic".
---

# Context Model - the company's operating context for AI

Every AI assistant is a brilliant employee on their first day: smart, fast, and knowing nothing about your company. The Context Model fixes the "first day" problem once - one document that travels to every AI surface you use.

**What it feeds:**

| Surface | How |
|---|---|
| ChatGPT Projects | upload `context-model.md` as project file |
| Claude Projects / Claude Code | project knowledge / `CLAUDE.md` reference |
| n8n / API agents | inject as CONTEXT block in the system prompt |
| Any chat | paste as CONTEXT before your question |

Two commands:

| Command | Duration | What it does |
|---|---|---|
| `/build` (default) | 20-40 min | Creates `context-model.md` - harvest mode or interview mode |
| `/refresh` | 10 min | Weekly update ritual: new wins, changed facts, changelog |

---

# /build - create the model

## Step 0 - confirm before starting

Confirm with the user in one message:

1. **Output location** - where to create the folder. Default: current working directory.
2. **Company slug** - latin, no spaces (e.g. `acme-logistics`).
3. **Existing materials** - most companies have three: a **website URL**, a **company LinkedIn page**, and a **local folder with documents** (presentations, price lists, proposals, service descriptions). Also welcome: pitch deck, testimonials, prior briefs; for technical users - repo paths. This decides the mode:
   - Anything provided → **harvest mode** (default)
   - Nothing → **interview mode** ("nothing" is fine - the interview covers it)

## Folder created

Create the FULL structure immediately, before harvesting or interviewing - the user must see the whole machine after step 0, not just its first piece:

```
[slug]/
├── AGENTS.md             ← the schema: how this wiki operates (Codex reads this name)
├── CLAUDE.md             ← same content (Claude Code reads this name)
├── llm-wiki.md           ← the original pattern doc (Karpathy)
├── context-model.md      ← the cornerstone page: who we are (written at Synthesis)
├── index.md              ← catalog: one line per wiki page
├── log.md                ← append-only record of what happened when
├── raw/                  ← immutable source material (site dumps, docs, notes)
├── wiki/                 ← linked pages the agent maintains
└── output/               ← work products (drafts a human reviews)
```

Then, in order:

1. Get `llm-wiki.md` into the folder: copy from this skill's own directory (the folder containing this SKILL.md); if you cannot locate it, download `https://raw.githubusercontent.com/alex-on-ai/company-llm-wiki/main/llm-wiki.md`.
2. **Read `llm-wiki.md`.** You are instantiating that pattern for a company; the file explains why each piece exists.
3. Write `AGENTS.md` from the schema template below, and write the identical content to `CLAUDE.md`. With the schema in place, ANY agent opened in this folder knows how to operate the wiki - even without these skills installed. That is the point of the pattern.
4. Create `index.md` (header only for now) and `log.md` with its first entry: `## [YYYY-MM-DD] build | folder scaffolded`.

`context-model.md` is the only piece that arrives at the end (Synthesis step). It stays one master file, deliberately: it is the page every AI surface consumes, so it must remain uploadable as a single document.

## The schema (write as AGENTS.md, copy to CLAUDE.md)

```markdown
# [Company] LLM wiki

An LLM-maintained wiki about [Company], in the pattern of `llm-wiki.md` (read it once).
The agent maintains everything except `raw/`; the human curates sources and reviews outputs.

## Layers

- `context-model.md` - the cornerstone: who we are, distilled from the wiki into one portable file (uploadable to any AI surface). Read before any task. Update only via the refresh ritual, never silently; detail belongs in wiki pages, linked with `[[Page Name]]`.
- `raw/` - immutable sources. Read, never modify. New material always lands here first.
- `wiki/` - pages the agent creates and maintains: `clients/`, `meetings/`, `projects/`, `cases/`, `topics/`. Cross-link with `[[Page Name]]`.
- `output/` - work products (task lists, specs, letters). Drafts only; a human sends. Frozen once shipped.
- `index.md` - one line per wiki page. Update on every page change.
- `log.md` - append-only: `## [YYYY-MM-DD] <op> | <subject>` where op is build / ingest / process / refresh / query.

## Operations

- **Ingest** (any material): file the knowledge into `wiki/` pages, cross-link, update `index.md`, append to `log.md`.
- **Process a meeting**: ingest the transcript, then write to `output/`: team tasks with owners (from the Team section of the context model), owner action items, decisions waiting with recommendations, a spec when a deliverable is implied, a client-facing draft in the company Voice, risks.
- **Refresh** (weekly): update changed sections of `context-model.md`, resolve markers, append changelog + log entry.

## Rules

1. Never invent facts. Unknowns stay visible as `(to clarify)`.
2. Newer fact wins, and the page notes the change.
3. Claims marked `⚠ UNVERIFIED` never enter client-facing output.
4. Wiki pages and outputs in English; respond in the user's language.
5. Anything client-facing is a draft. Never send or execute anything.
```

## Harvest mode (materials exist)

1. Read every provided source. Start from the website: fetch the key pages (home, services, about, cases). Then the LinkedIn page, the local folder's documents, decks, and any repo files. If a URL can't be fetched (login-walled, common for LinkedIn), use a connected browser tool if available; otherwise ask the user to paste the page text instead of skipping the source. Save extracts worth keeping into `raw/`.
2. Draft ALL sections of `templates/context-model-template.md` from sources. Mark every fact you could not source as `[GAP]`.
3. **File durable entities as wiki pages.** A website harvest typically yields 3-8 pages: one page per named case study or flagship product (`wiki/cases/`), plus topics worth their own page - named competitors, the market segment, a signature method (`wiki/topics/`). Link them from the relevant context-model sections with `[[Page Name]]`, add each to `index.md`. This is what makes the folder a wiki and not one file with empty directories.
4. Ask the user ONLY the `[GAP]` questions - in batches of 3-4, never one by one. Skip entire batches that sources already answered.
5. Then run the Verification pass (below).

**Never pad.** A short, true section beats a full, invented one.

## Interview mode (blank start)

Ask in **6 batches of 3-4 questions**. Write answers into the draft after each batch. Max 18 questions total; skip anything already answered.

### Batch 1 - Identity
1. Company name + one plain-language sentence: what do you do?
2. The category you compete in. Specific ("B2B freight forwarding", "fractional CTO"), not generic ("logistics company").
3. The enemy: what common practice / noisy trend in your industry are you against? One sentence.

### Batch 2 - Offer
4. What do you sell? Top-3 services/products/packages.
5. Price points. Ranges are fine; if custom - minimum contract.
6. Model: project / retainer / hourly / subscription / hybrid?

### Batch 3 - Ideal client (ICP)
7. Who is the ideal client? Role, company size, region, industry.
8. Their 3 sharpest pains right now - concrete ("quotes take 2 days, deals die waiting"), not "they want to grow".
9. Buying triggers: what signals a client is ready?
10. Who are you compared against? 2-3 named competitors or company types.

### Batch 4 - Differentiation & proof
11. Your unique mechanism, one sentence - the concrete "how".
12. Most impressive case with numbers: client + before/after + timeframe + what you did.
13. What do you do that competitors don't? 1-3 points.

### Batch 5 - Voice
14. How do you talk about your work? Direct / casual / consultative / provocative?
15. Phrases you repeat constantly (brand stickers) - and words you'd never use.

### Batch 6 - Team & operations
16. Who is on the team? First names + roles + what each person owns.
17. What tools run the company: task tracker, CRM, docs, messengers?
18. Operating rhythm: which meetings exist, what response times do you promise clients, what can be decided without the owner?

## Verification pass (always, both modes)

Before finishing, list every factual claim in Proof and Differentiation with its status:

```
✓ confirmed by user
✓ from source: [file/URL]
⚠ UNVERIFIED - do not use in client-facing output until confirmed
```

Unverified claims stay in the document but keep the `⚠ UNVERIFIED` marker. AI assistants consuming the model must treat marked claims as unusable in client-facing text. Never invent metrics, clients, or testimonials to fill a template.

## Synthesis

Generate `context-model.md` from `templates/context-model-template.md` - 10 sections + changelog. The relationship to the wiki: **the wiki is the source of truth, the context model is the compiled artifact** - the wiki's synthesis page, kept short and portable because it gets uploaded to ChatGPT Projects, pasted into system prompts, and read first by every agent. Detail belongs in wiki pages; the model links to them with `[[Page Name]]` instead of absorbing them. `/refresh` recompiles it as the wiki learns.

Concreteness rule: if a section reads like it could describe any company in the industry, it is not done; push for the specific detail.

Then close the books: update `index.md` (one line per page, context-model.md first), and append to `log.md`: `## [YYYY-MM-DD] build | context model built from <sources>, N wiki pages filed`.

## Closing message

```
✅ LLM wiki set up for [Company].

Cornerstone: ./[slug]/context-model.md
Wiki pages:  [N] filed (see index.md)
Schema:      AGENTS.md + CLAUDE.md - any agent opened here knows how this wiki works
Gaps:        [N] (marked [GAP] / ⚠ UNVERIFIED inside)

USE IT NOW:
→ ChatGPT: create a Project, upload context-model.md, ask anything
→ Claude Code: reference it from CLAUDE.md
→ n8n agent: paste into the system prompt as CONTEXT block

NEXT:
→ /process-meeting - transcript in raw/ → wiki pages + tasks + spec + drafts
→ /ingest - file any other material into the wiki
→ /refresh weekly (10 min) - new wins, changed facts
```

---

# /refresh - weekly update ritual

Precondition: `context-model.md` exists (else suggest `/build`).

1. Ask one batch: "What changed since [last changelog date]? New clients/cases, pricing changes, new team members, new tools, positioning shifts, anything you keep re-typing into AI chats?"
2. Also accept pasted raw material (call notes, wins) - extract, don't interrogate.
3. Update the affected sections. Resolve `[GAP]` / `⚠ UNVERIFIED` markers the user can now confirm.
4. Append a one-line changelog entry with date.
5. Show a 3-line diff summary of what changed.

---

# Hard rules

1. **Parse before asking.** Whatever sources exist, read them first; ask only gaps.
2. **Batches of 3-4 questions.** Never one-by-one interrogation.
3. **Concreteness is mandatory.** "We're better than competitors" → re-ask for the mechanism.
4. **Never invent facts.** No made-up metrics, cases, clients, or quotes. Gaps stay visible as `[GAP]`.
5. **Verification pass is not optional.** Every Proof claim carries a status marker.
6. **Markdown, one master file.** No JSON, no sprawling folder trees.
7. **Respond in the user's language; write the model in English** unless the user asks otherwise (English travels best across AI tools).
8. **Don't re-ask what the model already contains** - read it first.
9. **Short beats padded.** Empty template lines are deleted, not filled with fluff.
10. **Scope: company context for AI assistants.** Not a resume, not a marketing site, not a brand book.

# Dependencies

Agent built-ins only (web fetch for harvest mode) - works the same in Claude Code and Codex. No MCP servers or API keys required. For login-walled pages (common for LinkedIn), use a connected browser tool if one is available; otherwise ask the user to paste the page text.

# Attribution

The wiki pattern this instantiates is Andrej Karpathy's "LLM Wiki" - included verbatim as `llm-wiki.md` (the file itself says it "is designed to be copy pasted to your own LLM Agent"). Skill structure inspired by Volodymyr Kuts's `company-context-model` (Profigent, [boxa007/profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT) - generalized from a LinkedIn-pipeline foundation to a company-wide AI operating layer: added harvest mode, Team and Operations sections, the verification pass, and multi-surface consumption; dropped the LinkedIn profile-audit and positioning-research phases (see upstream for those).
