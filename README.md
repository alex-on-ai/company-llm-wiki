# Company LLM Wiki

**Give AI your company's context once, then turn every meeting into filed knowledge and finished drafts.**

Every AI assistant is a brilliant employee on their first day: smart, fast, and knowing nothing about your company. The fix is not a better prompt. It's context: a small LLM-maintained wiki about your company, in the pattern Andrej Karpathy described in [llm-wiki.md](llm-wiki.md) (included verbatim; the file says it "is designed to be copy pasted to your own LLM Agent").

Two skills, two operations:

| Skill | What it does | How often |
|---|---|---|
| `/build-context-model` | Interviews you or harvests your website + docs into `context-model.md`, the cornerstone page | once |
| `/ingest-meeting` | Files a transcript into linked wiki pages, then produces team tasks with owners, decisions with recommendations, a spec, client-facing drafts | every meeting |

The folder it maintains:

```
[your-company]/
├── llm-wiki.md           the pattern doc (Karpathy)
├── context-model.md      who we are; feeds every AI surface you use
├── raw/                  drop zone: transcripts, notes, letters
├── wiki/                 linked pages: clients, meetings, projects
└── output/               ready-to-use work: tasks, specs, draft letters
```

## Install

Works with Claude Code and Codex:

```bash
git clone https://github.com/alex-on-ai/company-llm-wiki.git
cd company-llm-wiki && ./install.sh
```

Then in any folder: `/build-context-model` once, `/ingest-meeting` after each meeting, `/refresh` weekly.

Prefer a plain chat (ChatGPT, Claude, Gemini)? The same flows live in `prompts/` as paste-able prompts. `./install.sh --chatgpt` copies the interview pack to your clipboard, `./install.sh --chatgpt ingest` the ingest prompt.

## Deliberately strict

1. **Verification markers.** Claims are tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. Unverified claims never enter client-facing output.
2. **Drafts only.** Client-facing work lands in `output/` for your review; the agent never sends anything.
3. **One cornerstone file.** `context-model.md` gets refreshed weekly and uploaded everywhere; the wiki grows around it.

## Where this comes from

The wiki pattern is [Andrej Karpathy's "LLM Wiki"](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), included verbatim as `llm-wiki.md`. Skill structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT), generalized from a LinkedIn-pipeline foundation into a company-wide AI operating layer.

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/), CEO [HighCraft.io](https://highcraft.io).

MIT license.
