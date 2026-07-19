# Context Model

**One document that makes AI work for *your* company instead of producing generic slop.**

Every AI assistant — ChatGPT, Claude, an n8n agent — is a brilliant employee on their first day: smart, fast, and knowing nothing about you. Ask it to draft a client reply and you get polished emptiness. The fix is not a better prompt. It's **context**: one maintained document that describes your company the way a great operator would brief a new hire — and that travels to every AI surface you use.

This repo gives you:

- **`templates/context-model-template.md`** — the 10-section Company Context Model template
- **A Claude Code skill** (`SKILL.md`) — builds the model for you: `/build` interviews you *or* harvests your existing materials (website, docs, repos) and asks only the gaps; `/refresh` keeps it current in 10 minutes a week
- **`prompts/chatgpt-interview.md`** — the same process for plain ChatGPT, no tools required
- **`examples/`** — a real filled model (HighCraft.io — the one shown live at the Scale Academy webinar)

## The 10 sections

Identity · Offer · Ideal client (ICP) · Differentiation · **Proof (with verification markers)** · Voice · **Team** · **Operations** · Goals · Using this model

Two things are deliberately strict:

1. **Verification markers.** Every claim in Proof is tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. AI consuming the model must not use unverified claims in client-facing output. AI that is allowed to invent your case studies will.
2. **One master file.** Multi-file knowledge bases rot. One file gets refreshed weekly and uploaded everywhere.

## Quick start — ChatGPT (no tools needed)

1. Create a ChatGPT **Project**, upload `templates/context-model-template.md`
2. Paste the prompt from `prompts/chatgpt-interview.md`
3. Answer 6 batches of questions → save the result as `context-model.md` into the project
4. Every chat in that project now knows your company

## Quick start — Claude Code

```bash
git clone https://github.com/alex-on-ai/context-model.git
cd context-model && ./install.sh
```

Then in any project: `/context-model` (or just say "build my context model"). Point it at your website and docs — harvest mode drafts the model from what already exists.

## Швидкий старт українською

1. Створіть **Проєкт** у ChatGPT, завантажте `templates/context-model-template.md`
2. Вставте промпт із `prompts/chatgpt-interview.md` — він проведе інтервʼю (відповідати можна українською; сам документ буде англійською, це найкраще переноситься між AI-інструментами)
3. Збережіть результат як `context-model.md` у проєкт
4. Перевірте різницю: попросіть відповідь на складний лист клієнта у чаті поза проєктом і всередині нього

## Where this comes from

Structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT) — a LinkedIn-pipeline foundation from the Profigent / Growth Factory leadgen program. This version generalizes it into a company-wide AI operating layer: harvest mode, Team and Operations sections, verification markers, multi-surface consumption; the LinkedIn audit and positioning phases were dropped (see upstream for those).

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/) · CEO [HighCraft.io](https://highcraft.io) — AI engineering for business.

MIT license.
