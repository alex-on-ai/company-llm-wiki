# Contributing to company-llm-wiki (agent notes)

This repo ships three folder-scoped agent skills (`skills/*/SKILL.md`) plus a Claude Code plugin wrapper. When editing it, keep these invariants:

1. **Skill folders are self-contained.** The skills.sh installer copies only the skill folder, so every asset a skill references lives inside it. `llm-wiki.md` (root) is the canonical copy; the copies in each `skills/*/` and the copies of `templates/` and `prompts/interview-prompt.md` inside `skills/build-context-model/` must stay byte-identical to the root versions. After changing any of them, re-sync the copies.
2. **Three install paths must keep working:** `npx skills add alex-on-ai/company-llm-wiki` (primary), the Claude Code plugin (`.claude-plugin/marketplace.json` + `plugin.json`; keep the `skills` list and plugin name in sync, bump `version` on skill changes), and `./install.sh` (manual fallback).
3. **Run `tests/smoke.sh` before committing.** It checks install shape, self-containment, plugin manifests, and key skill invariants.
4. **No em dashes anywhere in this repo's text** except inside the verbatim `llm-wiki.md`. Use hyphens.
5. **English only.** Sparse, direct, no filler.
6. Design contract for the skills themselves: the working folder is the wiki root (never a nested company folder), `context-model.md` is created immediately and updated in place, `[GAP]` markers never block `/process-meeting` or `/ingest`, `⚠ UNVERIFIED` claims never enter client-facing output.
