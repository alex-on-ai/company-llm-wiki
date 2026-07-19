# Company LLM Wiki

**Give AI your company's context once — then turn every meeting into filed knowledge and finished drafts.**

Every AI assistant — ChatGPT, Claude, an n8n agent — is a brilliant employee on their first day: smart, fast, and knowing nothing about you. Ask it to draft a client reply and you get polished emptiness. The fix is not a better prompt. It's **context**: a small, LLM-maintained wiki about your company, in the pattern Andrej Karpathy described in [llm-wiki.md](llm-wiki.md) (included verbatim — the file itself says it "is designed to be copy pasted to your own LLM Agent").

Two operations, two skills:

| Operation | Skill / prompt | How often |
|---|---|---|
| **Build** — bootstrap the wiki: interview you *or* harvest your website + docs into `context-model.md`, the cornerstone page | `/build-context-model` · `prompts/interview-prompt.md` | once per company |
| **Ingest** — drop a meeting transcript into `raw/`, get linked wiki pages + team tasks with owners + decisions with recommendations + a spec + client-facing drafts | `/ingest-meeting` · `prompts/ingest-prompt.md` | every meeting, forever |

The folder it maintains:

```
[your-company]/
├── llm-wiki.md           the pattern doc (Karpathy)
├── context-model.md      who we are — feeds every AI surface you use
├── raw/                  drop zone: transcripts, notes, letters
├── wiki/                 linked pages: clients, meetings, projects
└── output/               ready-to-use work: tasks, specs, draft letters
```

## Track A — you only use a chat (ChatGPT, Claude, Gemini)

No install, no terminal:

1. If your AI supports projects (ChatGPT Projects, Claude Projects, Gemini Gems), create one and attach `templates/context-model-template.md` — otherwise just paste it into the chat
2. Paste `prompts/interview-prompt.md`, answer 6 batches of questions → save the result as `context-model.md`
3. From then on: paste `prompts/ingest-prompt.md` + a transcript → get the task list and drafts

## Track B — you use a terminal agent (Claude Code, Codex CLI)

```bash
git clone https://github.com/alex-on-ai/company-llm-wiki.git
cd company-llm-wiki && ./install.sh
```

One script installs **both skills** into `~/.claude/skills` and `~/.codex/skills` (whichever you have — same SKILL.md format works in both). Then, in any folder:

- `/build-context-model` — point it at your website and docs; harvest mode drafts the model from what already exists and asks only the gaps
- `/ingest-meeting` — after each meeting, drop the transcript in `raw/` and run it

`./install.sh --chatgpt` copies the interview paste-pack to your clipboard; `./install.sh --chatgpt ingest` copies the ingest prompt — for teammates on Track A.

## What's deliberately strict

1. **Verification markers.** Every claim in Proof is tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. AI consuming the model must not use unverified claims in client-facing output. AI that is allowed to invent your case studies will.
2. **Drafts only.** Everything client-facing lands in `output/` for your review — the agent never sends anything.
3. **One cornerstone file.** `context-model.md` gets refreshed weekly (`/refresh`, 10 min) and uploaded everywhere; the wiki grows around it, one ingest at a time.

## Where this comes from

The wiki pattern is [Andrej Karpathy's "LLM Wiki"](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), included verbatim as `llm-wiki.md`; this repo is one company-shaped instantiation of it. Skill structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT) — a LinkedIn-pipeline foundation from the Profigent / Growth Factory leadgen program, generalized here into a company-wide AI operating layer: harvest mode, Team and Operations sections, verification markers, the ingest loop; the LinkedIn audit and positioning phases were dropped (see upstream for those).

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/) · CEO [HighCraft.io](https://highcraft.io) — AI engineering for business.

MIT license.
