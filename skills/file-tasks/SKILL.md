---
name: file-tasks
description: Create the team tasks from a processed meeting in the company's connected task tracker - Linear, Jira, Asana, Azure DevOps, Trello or similar. Reads the task table produced by /process-meeting (or any task list the user names), maps owners to tracker users, shows the exact batch for confirmation, creates nothing without it, skips duplicates, reports links back. Requires a connected tracker tool; without one it stops and says so. Triggers - "file tasks", "/file-tasks", "file the tasks", "create the tasks in Linear", "create these tasks in Jira", "push tasks to the tracker", "send the tasks to the board".
---

# File tasks - from output/ to your task tracker

The wiki files knowledge; the tracker runs the team. This command bridges them: it takes the team tasks `/process-meeting` produced and creates real, assigned tasks in whatever tracker is connected. It is deliberately the only skill in this kit that writes to an external system, so it carries one extra gate: **nothing is created until the user confirms the exact batch.**

## Step 0 - preconditions

1. Resolve the **wiki root** as the exact current folder (or the exact folder the user names).
2. Locate the task list: the file or pasted list the user names, else the newest file in `output/` that contains a team-task table (owner, task, deadline). Nothing found → say so and stop; `/process-meeting` produces the list.
3. Detect the tracker: check the connected tools (MCP servers or connectors) for a task system - Linear, Jira, Asana, Azure DevOps, Trello, ClickUp or similar. Exactly one → use it. Several → ask which one. None → stop and tell the user to connect their tracker in the agent's connector settings first. Never simulate a tracker write.

## Step 1 - map before creating

- **Team / project**: ask once where the tasks should land if it is not obvious from the context model or an earlier run. If the user says "always here", flag `context-model.md` for a `/refresh` so the default gets recorded - do not edit the model silently.
- **Assignees**: match each task owner to a tracker user by name. No match → leave the task unassigned and keep the owner's name as the first line of the description. Two similar names → ask, never guess.
- **Deadlines**: map to due dates where the tracker supports them.

## Step 2 - confirm the batch

Show the exact list that will be created - title, assignee, due date, target team/project - and wait for explicit confirmation. The user can drop or edit items ("all except 3"). **No confirmation, no writes.** This mirrors the kit-wide rule: the agent drafts, the user fires.

## Step 3 - create, skipping duplicates

For each confirmed task: search open tasks in the target team/project for the same title first - found → skip and report as already filed. Then create. Each task description carries:

1. One line of context: what this task is about, from the meeting.
2. A source line: `From meeting: YYYY-MM-DD - [topic]`.
3. When the wiki root is a git repo with a remote, a context pointer: `Context: [remote URL] - read context-model.md and wiki/meetings/[page] for background.` This makes every task self-serve: a teammate or an autonomous agent picking it up later finds the full context without asking.

## Step 4 - close the books

Add a `Tasks filed:` line with the created links to the meeting's `wiki/meetings/` page, append to `log.md`: `## [YYYY-MM-DD] file-tasks | [meeting] → [tracker]`. If the wiki root is a git repository, commit the bookkeeping changes (message `file-tasks: [meeting]`) and push when a remote exists - the context pointers in the created tasks only help if the remote is current. Then report:

```
✅ Filed [N] tasks to [tracker] ([team/project]):
- [task title] → [link]

Skipped: [already filed / dropped by user]
```

# Hard rules

1. **No confirmation, no writes.** Never create, update or delete anything in the tracker without the user confirming the exact batch shown in Step 2.
2. **Only tasks from the list.** Never invent, merge or reword tasks beyond light title cleanup.
3. **Team tasks only by default.** Owner action items are the user's personal list; file them only when explicitly asked.
4. **No tracker, no theater.** If no tracker tool is connected, stop and say so.
5. **Respond in the user's language; keep task titles and descriptions in the language of the task list** unless asked otherwise.
6. This skill writes the tracker plus light wiki bookkeeping (the meeting page line and `log.md`). It never edits `context-model.md` (flag `/refresh` instead) and never touches `raw/`.

# Attribution

The root wiki pattern is Andrej Karpathy's "LLM Wiki", written once by `/build-context-model`. Four commands run the system: `/build-context-model` bootstraps the folder once, `/process-meeting` handles every meeting, `/ingest` files everything else, `/file-tasks` creates the team tasks in your connected tracker.
