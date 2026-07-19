# Context Model

**One document that makes AI work for *your* company instead of producing generic slop.**

Every AI assistant — ChatGPT, Claude, an n8n agent — is a brilliant employee on their first day: smart, fast, and knowing nothing about you. Ask it to draft a client reply and you get polished emptiness. The fix is not a better prompt. It's **context**: one maintained document that describes your company the way a great operator would brief a new hire — and that travels to every AI surface you use.

This repo gives you:

- **`llm-wiki.md`** — the original pattern document by Andrej Karpathy, included verbatim (it "is designed to be copy pasted to your own LLM Agent"); this repo is one company-shaped instantiation of it

- **`templates/context-model-template.md`** — the 10-section Company Context Model template
- **`prompts/interview-prompt.md`** — a universal interview prompt that runs in **any AI chat** (ChatGPT, Claude, Gemini, anything), no tools required
- **`prompts/ingest-prompt.md`** — step two: grow the folder into a small **LLM wiki** (pattern: Karpathy) — drop transcripts and documents into `raw/`, the agent files them as linked pages and produces the work outputs. Each ingest compounds
- **A Claude Code skill** (`SKILL.md`) — the automated version: `/build` interviews you *or* harvests your existing materials (website, docs, repos) and asks only the gaps; `/refresh` keeps it current in 10 minutes a week

## The 10 sections

Identity · Offer · Ideal client (ICP) · Differentiation · **Proof (with verification markers)** · Voice · **Team** · **Operations** · Goals · Using this model

Two things are deliberately strict:

1. **Verification markers.** Every claim in Proof is tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. AI consuming the model must not use unverified claims in client-facing output. AI that is allowed to invent your case studies will.
2. **One master file.** Multi-file knowledge bases rot. One file gets refreshed weekly and uploaded everywhere.

## Quick start — any AI chat (no tools needed)

1. Open your AI of choice; if it supports projects (ChatGPT Projects, Claude Projects, Gemini Gems), create one and attach `templates/context-model-template.md` — otherwise just paste the template into the chat
2. Paste the prompt from `prompts/interview-prompt.md`
3. Answer 6 batches of questions → save the result as `context-model.md`
4. Load that file wherever you work — the same document feeds every AI surface

## Install — Claude Code & Codex CLI

```bash
git clone https://github.com/alex-on-ai/build-context-model.git
cd build-context-model && ./install.sh
```

One script installs the skill into both `~/.claude/skills` and `~/.codex/skills` (whichever you have — same SKILL.md format). Then in any project: `/build-context-model` (or just say "build my context model"). Point it at your website and docs — harvest mode drafts the model from what already exists.

**ChatGPT / any other chat:** `./install.sh --chatgpt` copies the full paste-pack (interview prompt + template) to your clipboard — paste into a new chat and answer.

## Where this comes from

Structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT) — a LinkedIn-pipeline foundation from the Profigent / Growth Factory leadgen program. This version generalizes it into a company-wide AI operating layer: harvest mode, Team and Operations sections, verification markers, multi-surface consumption; the LinkedIn audit and positioning phases were dropped (see upstream for those).

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/) · CEO [HighCraft.io](https://highcraft.io) — AI engineering for business.

MIT license.
