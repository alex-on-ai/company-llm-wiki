# Company LLM Wiki

**Give AI your company's context once, then turn every meeting into filed knowledge and finished drafts.**

Every AI assistant is a brilliant employee on their first day: smart, fast, and knowing nothing about your company. The fix is not a better prompt. It's context: a small LLM-maintained wiki about your company, in the pattern Andrej Karpathy described in [llm-wiki.md](llm-wiki.md) (included verbatim; the file says it "is designed to be copy pasted to your own LLM Agent").

Three commands:

| Skill | What it does | How often |
|---|---|---|
| `/build-context-model` | Interviews you or harvests your website, LinkedIn and docs into the wiki (cases, topics, raw extracts), then distills `context-model.md` - the portable cornerstone every AI surface consumes | once |
| `/process-meeting` | Ingests a transcript into linked wiki pages, then produces team tasks with owners, your action items, decisions with recommendations, a spec, client-facing drafts | every meeting |
| `/ingest` | Files any other material into the wiki: articles, client emails, proposals, notes | as it arrives |

The folder it maintains:

```
[your-company]/
├── AGENTS.md + CLAUDE.md the schema: how this wiki operates
├── llm-wiki.md           the pattern doc (Karpathy)
├── context-model.md      who we are; feeds every AI surface you use
├── index.md              catalog: one line per wiki page
├── log.md                append-only record of what happened when
├── raw/                  drop zone: transcripts, notes, letters
├── wiki/                 linked pages: clients, meetings, projects, cases, topics
└── output/               ready-to-use work: tasks, specs, draft letters
```

The build writes the schema into the folder itself (`AGENTS.md` for Codex, `CLAUDE.md` for Claude Code, same content). That makes the wiki self-describing: any agent opened in the folder knows how to operate it, with or without these skills installed.

## Install

**Easiest - tell your agent.** Paste into Claude Code or Codex:

> Install the skills from https://github.com/alex-on-ai/company-llm-wiki into this project, then build my company's context model. Read that repo's README section "Install notes for agents" first and follow it exactly.

The agent installs locally and flows straight into the build - the build's own step 0 asks you to confirm sources and location before anything is created.

**Terminal.** The skills live with the company folder they operate on, so install from inside it:

```bash
git clone https://github.com/alex-on-ai/company-llm-wiki.git
mkdir your-company && cd your-company
../company-llm-wiki/install.sh
```

Machine-wide instead (every project, Claude Code + Codex): `./install.sh --global`.

Then: `/build-context-model` once, `/process-meeting` after each meeting, `/ingest` for anything else, `/refresh` weekly.

Prefer a plain chat (ChatGPT, Claude, Gemini)? The same flows live in `prompts/` as paste-able prompts. `./install.sh --chatgpt` copies the interview pack to your clipboard, `./install.sh --chatgpt ingest` the ingest prompt.

### Install notes for agents

If a user asks you to install this repo's skills, follow these steps exactly. Do NOT substitute a skills manager CLI (`npx skills` or similar), and never install globally (`-g`) - these skills are folder-scoped and belong to the project.

1. Clone `https://github.com/alex-on-ai/company-llm-wiki.git` to a temporary location (simplest: run its `install.sh` from the user's project folder, which performs steps 2-3; the manual steps follow).
2. Destination is the current project: BOTH `./.claude/skills/` and `./.codex/skills/` (create the directories if missing; Claude Code reads the first, Codex the second). Use `~/.claude/skills/` plus `~/.codex/skills/` only if the user explicitly asked for a global install.
3. Copy ALL THREE folders under `skills/` (`build-context-model`, `process-meeting`, `ingest`) into each destination - a partial install is a failed install. Into every installed skill folder also copy the repo's `llm-wiki.md`; into `build-context-model/` additionally copy `templates/` and `prompts/interview-prompt.md`.
4. Remove the temporary clone and verify: each destination contains the three skill folders, each with a `SKILL.md`.
5. Treat "install" as "install and set up": the user's goal is a working company wiki, not files on disk. After verifying the install, immediately open the installed `build-context-model/SKILL.md`, read it fully, and execute it as your instructions in this same session (freshly installed skills register only in new sessions - that is why you execute the file directly). Do NOT end your turn after installing: your turn ends either on the build's step 0 questions to the user (location, slug, sources - the consent gate) or after the build completes. Mention that from the next session onward the commands are `/build-context-model` (once), `/process-meeting` (every meeting), `/ingest` (anything else).
6. If any skill instruction conflicts with your environment, adapt minimally, tell the user what you changed and why, and record it in `./skill-feedback.md` in the project - that file is how improvements travel upstream (the user can open an issue or PR on this repo from it).

## Deliberately strict

1. **Verification markers.** Claims are tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. Unverified claims never enter client-facing output.
2. **Drafts only.** Client-facing work lands in `output/` for your review; the agent never sends anything.
3. **One cornerstone file.** `context-model.md` gets refreshed weekly and uploaded everywhere; the wiki grows around it.

## Where this comes from

The wiki pattern is [Andrej Karpathy's "LLM Wiki"](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), included verbatim as `llm-wiki.md`. Skill structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT), generalized from a LinkedIn-pipeline foundation into a company-wide AI operating layer.

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/), CEO [HighCraft.io](https://highcraft.io).

MIT license.
