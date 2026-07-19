# Contributing to company-llm-wiki (agent notes)

This repo ships four folder-scoped agent skills (`skills/*/SKILL.md`) plus a Claude Code plugin wrapper. When editing it, keep these invariants:

1. **The build skill owns bootstrap assets.** `llm-wiki.md` (root) is canonical; only `skills/build-context-model/` bundles a byte-identical copy so the initial build works offline. Downstream skills use the root-level wiki artifact created by the build and must not bundle another copy. The copies of `templates/` and `prompts/interview-prompt.md` inside `skills/build-context-model/` must stay byte-identical to the root versions. Re-sync them after changes.
2. **Four install paths must keep working:** `npx skills add alex-on-ai/company-llm-wiki --skill "*" --agent codex claude-code -y` (primary), the Claude Code plugin (`.claude-plugin/marketplace.json` + `plugin.json`; keep the `skills` list and plugin name in sync, bump `version` on skill changes), `./install.sh` (macOS/Linux fallback), and `./install.ps1` (Windows fallback).
3. **Run `tests/smoke.sh` before committing.** When PowerShell is available, also run `tests/smoke.ps1`. CI runs both and exercises the real `npx` installer on Windows.
4. **No em dashes anywhere in this repo's text** except inside the verbatim `llm-wiki.md`. Use hyphens.
5. **English only.** Sparse, direct, no filler.
6. Design contract for the skills themselves: the working folder is the wiki root (never a nested company folder), `context-model.md` is created immediately and updated in place, `[GAP]` markers never block `/process-meeting` or `/ingest`, `⚠ UNVERIFIED` claims never enter client-facing output, and `/file-tasks` (the only skill that writes to an external system) never creates anything without the user confirming the exact batch.
