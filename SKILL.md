---
name: context-model
description: Build and maintain a Company Context Model — the single document that lets any AI assistant (ChatGPT, Claude, n8n agents) produce specific, on-brand, delegation-ready output instead of generic slop. Two build modes — /build harvest (draft from existing materials: website, docs, repos; ask only the gaps) and /build interview (guided interview in batches). /refresh runs the weekly update ritual. Triggers — "build context model", "context model", "/context-model", "/build", "/refresh", "set up company context", "my AI answers are generic".
---

# Context Model — the company's operating context for AI

Every AI assistant is a brilliant employee on their first day: smart, fast, and knowing nothing about your company. The Context Model fixes the "first day" problem once — one document that travels to every AI surface you use.

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
| `/build` (default) | 20-40 min | Creates `context-model.md` — harvest mode or interview mode |
| `/refresh` | 10 min | Weekly update ritual: new wins, changed facts, changelog |

---

# /build — create the model

## Step 0 — confirm before starting

Confirm with the user in one message:

1. **Output location** — where to create the folder. Default: current working directory.
2. **Company slug** — latin, no spaces (e.g. `acme-logistics`).
3. **Existing materials** — anything from: website URL, repo paths, pitch deck, service descriptions, testimonials, internal docs, prior briefs. This decides the mode:
   - Materials provided → **harvest mode** (default when anything is given)
   - Nothing → **interview mode**

## Folder created

```
[slug]/
├── context-model.md      ← the master document (this is what you upload/paste)
└── sources/              ← raw inputs used to build it (dumps, notes, decks)
```

One master file, deliberately. Multi-file structures rot; one file gets updated and uploaded everywhere.

## Harvest mode (materials exist)

1. Read every provided source: WebFetch the site, read repo content files, docs, decks. Save extracts worth keeping into `sources/`.
2. Draft ALL sections of `templates/context-model-template.md` from sources. Mark every fact you could not source as `[GAP]`.
3. Ask the user ONLY the `[GAP]` questions — in batches of 3-4, never one by one. Skip entire batches that sources already answered.
4. Then run the Verification pass (below).

**Never pad.** A short, true section beats a full, invented one.

## Interview mode (blank start)

Ask in **6 batches of 3-4 questions**. Write answers into the draft after each batch. Max 18 questions total; skip anything already answered.

### Batch 1 — Identity
1. Company name + one plain-language sentence: what do you do?
2. The category you compete in. Specific ("B2B freight forwarding", "fractional CTO"), not generic ("logistics company").
3. The enemy: what common practice / noisy trend in your industry are you against? One sentence.

### Batch 2 — Offer
4. What do you sell? Top-3 services/products/packages.
5. Price points. Ranges are fine; if custom — minimum contract.
6. Model: project / retainer / hourly / subscription / hybrid?

### Batch 3 — Ideal client (ICP)
7. Who is the ideal client? Role, company size, region, industry.
8. Their 3 sharpest pains right now — concrete ("quotes take 2 days, deals die waiting"), not "they want to grow".
9. Buying triggers: what signals a client is ready?
10. Who are you compared against? 2-3 named competitors or company types.

### Batch 4 — Differentiation & proof
11. Your unique mechanism, one sentence — the concrete "how".
12. Most impressive case with numbers: client + before/after + timeframe + what you did.
13. What do you do that competitors don't? 1-3 points.

### Batch 5 — Voice
14. How do you talk about your work? Direct / casual / consultative / provocative?
15. Phrases you repeat constantly (brand stickers) — and words you'd never use.

### Batch 6 — Team & operations
16. Who is on the team? First names + roles + what each person owns.
17. What tools run the company: task tracker, CRM, docs, messengers?
18. Operating rhythm: which meetings exist, what response times do you promise clients, what can be decided without the owner?

## Verification pass (always, both modes)

Before finishing, list every factual claim in Proof and Differentiation with its status:

```
✓ confirmed by user
✓ from source: [file/URL]
⚠ UNVERIFIED — do not use in client-facing output until confirmed
```

Unverified claims stay in the document but keep the `⚠ UNVERIFIED` marker. AI assistants consuming the model must treat marked claims as unusable in client-facing text. Never invent metrics, clients, or testimonials to fill a template.

## Synthesis

Generate `context-model.md` from `templates/context-model-template.md` — 10 sections + changelog. Concreteness rule: if a section reads like it could describe any company in the industry, it is not done; push for the specific detail.

## Closing message

```
✅ Context model created.

File: ./[slug]/context-model.md
Gaps remaining: [N] (marked [GAP] / ⚠ UNVERIFIED inside)

USE IT NOW:
→ ChatGPT: create a Project, upload context-model.md, ask anything
→ Claude Code: reference it from CLAUDE.md
→ n8n agent: paste into the system prompt as CONTEXT block

MAINTAIN IT:
→ /refresh weekly (10 min) — new wins, changed facts
```

---

# /refresh — weekly update ritual

Precondition: `context-model.md` exists (else suggest `/build`).

1. Ask one batch: "What changed since [last changelog date]? New clients/cases, pricing changes, new team members, new tools, positioning shifts, anything you keep re-typing into AI chats?"
2. Also accept pasted raw material (call notes, wins) — extract, don't interrogate.
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
8. **Don't re-ask what the model already contains** — read it first.
9. **Short beats padded.** Empty template lines are deleted, not filled with fluff.
10. **Scope: company context for AI assistants.** Not a resume, not a marketing site, not a brand book.

# Dependencies

Claude Code built-ins only (WebFetch for harvest mode). No MCP servers required; if better tools are connected, use them opportunistically.

# Attribution

Structure inspired by Volodymyr Kuts's `company-context-model` (Profigent, [boxa007/profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT) — generalized from a LinkedIn-pipeline foundation to a company-wide AI operating layer: added harvest mode, Team and Operations sections, the verification pass, and multi-surface consumption; dropped the LinkedIn profile-audit and positioning-research phases (see upstream for those).
