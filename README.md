# Company LLM Wiki

[![skills.sh](https://skills.sh/b/alex-on-ai/company-llm-wiki)](https://skills.sh/alex-on-ai/company-llm-wiki)

**Give AI your company's context once, then turn every meeting into filed knowledge and finished drafts.**

Every AI assistant is a brilliant employee on their first day: smart, fast, and knowing nothing about your company. The fix is not a better prompt. It's context: a small LLM-maintained wiki about your company, in the pattern Andrej Karpathy described in [llm-wiki.md](llm-wiki.md) (included verbatim; the file says it "is designed to be copy pasted to your own LLM Agent").

Four commands:

| Skill | What it does | How often |
|---|---|---|
| `/build-context-model` | Interviews you or harvests your website, LinkedIn and docs into the wiki (cases, topics, raw extracts), then distills `context-model.md` - the portable cornerstone every AI surface consumes | once |
| `/process-meeting` | Ingests a transcript into linked wiki pages, then produces team tasks with owners, your action items, decisions with recommendations, a spec, client-facing drafts | every meeting |
| `/ingest` | Files any other material into the wiki: articles, client emails, proposals, notes | as it arrives |
| `/file-tasks` | Creates the meeting's team tasks in your connected task tracker (Linear, Jira, Asana, ...) - you confirm the exact batch first, duplicates are skipped, links come back | after `/process-meeting`, when a tracker is connected |

The working folder is the wiki root. The build never creates a second company-named folder inside it:

```
[wiki-root]/
├── AGENTS.md + CLAUDE.md the schema: how this wiki operates
├── llm-wiki.md           the pattern doc (Karpathy)
├── context-model.md      who we are; feeds every AI surface you use
├── index.md              catalog: one line per wiki page
├── log.md                append-only record of what happened when
├── raw/                  drop zone: transcripts, notes, letters
├── wiki/                 linked pages: clients, meetings, projects, cases, topics
└── output/               ready-to-use work: tasks, specs, draft letters
```

The build writes the schema and a usable `context-model.md` into the working folder itself (`AGENTS.md` for Codex, `CLAUDE.md` for Claude Code, same content). That makes the wiki self-describing: any agent opened in the folder knows how to operate it, with or without these skills installed. Unknown facts stay marked `[GAP]`; they do not block `/process-meeting` or `/ingest`.

## Quickstart (30-second setup)

1. From the folder where your company wiki should live, run the [skills.sh](https://skills.sh) installer:

```bash
npx skills@latest add alex-on-ai/company-llm-wiki --skill "*" --agent codex claude-code -y
```

2. This installs all four skills project-locally for Codex and Claude Code only. Agents load them on the next session.

3. Restart your agent in that folder and run `/build-context-model`. It scaffolds the wiki, writes a usable `context-model.md` immediately, and asks only for what it cannot find on your website, LinkedIn, or documents.

4. From then on: `/process-meeting` after every meeting, `/file-tasks` to put its team tasks on your board, `/ingest` for anything else, `/refresh` weekly.

Or skip the terminal entirely and paste this into Claude Code or Codex:

> Run `npx skills@latest add alex-on-ai/company-llm-wiki --skill "*" --agent codex claude-code -y` in this project, then build my company's context model with the build-context-model skill you just installed.

## Install as a Claude Code plugin

Prefer a managed bundle you don't maintain by hand? These skills also ship as a native [Claude Code plugin](https://code.claude.com/docs/en/plugins) - a read-only set that updates when a new version ships, instead of editable copies in your repo.

Inside Claude Code:

```
/plugin marketplace add alex-on-ai/company-llm-wiki
/plugin install company-llm-wiki@alex-on-ai
```

Or from your shell:

```bash
claude plugin marketplace add alex-on-ai/company-llm-wiki
claude plugin install company-llm-wiki@alex-on-ai
```

Then run `/build-context-model` once per company folder, exactly as in the quickstart.

## Codex

The quickstart covers Codex: the skills.sh installer writes skills into `.agents/skills/`, which Codex reads natively (project and `~/.agents/skills` for user level), and every skill ships Codex metadata in `agents/openai.yaml`.

Manual alternatives from a clone:

- macOS/Linux: run `./install.sh` from your project folder (`--global` for machine-wide).
- Windows PowerShell: run `.\install.ps1` from your project folder (`-Global` for machine-wide).

Both install into `./.claude/skills` and `./.agents/skills` only.

## No agent at all (ChatGPT or any chat)

The same flows live in [prompts/](prompts/) as paste-able prompts. From a clone:

- macOS: `./install.sh --chatgpt` copies the interview pack; `./install.sh --chatgpt ingest` copies the ingest prompt.
- Windows PowerShell: `.\install.ps1 -ChatGPT` copies the interview pack; `.\install.ps1 -ChatGPT -Pack ingest` copies the ingest prompt.

## Install notes for agents

If a user asks you to install this repo's skills, the entire install is ONE command, run from the user's project folder:

```bash
npx skills@latest add alex-on-ai/company-llm-wiki --skill "*" --agent codex claude-code -y
```

1. That command is the whole job: no cloning, no copying files, no cleanup afterwards. Never pass `-g` (these skills are folder-scoped) or `--all` (`--all` expands to every skill and every supported agent). The scoped command installs only to `.agents/skills/` plus the Claude Code symlinks.
2. Verify all FOUR skills installed: `build-context-model`, `process-meeting`, `ingest`, `file-tasks`. A partial install is a failed install; re-run the command rather than repairing by hand.
3. Do not stop at installing - the user's goal is a working company wiki, not files on disk. Freshly installed skills register only in new sessions, so open the installed `build-context-model/SKILL.md`, read it fully, and execute it as your instructions now. Your turn ends either on the build's step 0 questions (exact wiki root, company name, sources - the consent gate) or after the build completes. The build writes root-level `context-model.md` immediately; gap questions never gate completion.
4. If any skill instruction conflicts with your environment, adapt minimally, tell the user what you changed and why, and record it in `./skill-feedback.md` in the project - that file is how improvements travel upstream (issue or PR on this repo).
5. Mention the ongoing commands: `/process-meeting` after every meeting, `/file-tasks` to create its team tasks in a connected tracker, `/ingest` for any other material, `/refresh` weekly.

The build skill bundles the canonical `llm-wiki.md` bootstrap asset. It copies that file once into the wiki root. The downstream skills read the root artifact and do not carry duplicate copies.

(Humans who prefer a manual install: clone the repo and run `./install.sh` on macOS/Linux or `.\install.ps1` on Windows from the project folder. Agents should use the one `npx` command above.)

`/build-context-model` populates the exact folder the user confirms; it does not create another `your-company/` directory inside it.

## Deliberately strict

1. **Verification markers.** Claims are tagged `✓ confirmed` / `✓ source` / `⚠ UNVERIFIED`. Unverified claims never enter client-facing output.
2. **Drafts only.** Client-facing work lands in `output/` for your review; the agent never sends anything.
3. **One cornerstone file.** `context-model.md` gets refreshed weekly and uploaded everywhere; the wiki grows around it.
4. **One working folder.** The current project folder is the wiki root. No nested company folder.
5. **Gaps are non-blocking.** The build creates `context-model.md` immediately and refines it in place; `[GAP]` and `⚠ UNVERIFIED` markers stay visible without blocking later skills.
6. **Private by default.** The build offers (never assumes) to version the wiki as a git repo; an accepted push always targets a PRIVATE repository. With a remote in place, `/file-tasks` stamps every created task with a context pointer, so autonomous agents that pick tasks up can clone the wiki and self-serve the background.

## Where this comes from

The wiki pattern is [Andrej Karpathy's "LLM Wiki"](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), included verbatim as `llm-wiki.md`. Skill structure inspired by [Volodymyr Kuts](https://github.com/boxa007)'s `company-context-model` ([profigent-lesson_1](https://github.com/boxa007/profigent-lesson_1), MIT), generalized from a LinkedIn-pipeline foundation into a company-wide AI operating layer. Repo packaging (skills.sh + Claude Code plugin + Codex metadata) follows the pattern of [mattpocock/skills](https://github.com/mattpocock/skills).

Built by [Oleksandr Pavlov](https://www.linkedin.com/in/alex-on-ai/), CEO [HighCraft.io](https://highcraft.io).

MIT license.
