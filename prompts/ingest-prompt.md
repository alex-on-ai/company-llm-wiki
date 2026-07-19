# Ingest prompt — grow the wiki from raw materials

The context model is step one. This prompt is step two: turn your company folder into a small **LLM wiki** — every document you drop in enriches the linked knowledge base AND produces the work you need from it. The pattern is described in `llm-wiki.md` (Andrej Karpathy, included in this repo) — read it once.

## Folder shape

```
[company]/
├── context-model.md    ← built by the skill (step one)
├── raw/                ← drop anything here: transcripts, notes, letters, documents
├── wiki/               ← the agent maintains linked pages (clients, meetings, projects)
└── output/             ← ready-to-use work products (tasks, specs, letters)
```

## The prompt (copy from here, run an agent inside the folder)

You maintain this company's wiki. Read `context-model.md` for who we are, then INGEST the new file(s) I name in `raw/`. An ingest does two things — it files the knowledge, then produces the work:

1. **File the knowledge.** Create or update linked pages under `wiki/` for every entity the material touches: clients (`wiki/clients/`), meetings (`wiki/meetings/`), projects (`wiki/projects/`). Cross-link pages with `[[Page Name]]`. If a new fact contradicts an earlier one, the newer wins and the page notes the change. Never invent facts; mark unknowns "to clarify".
2. **Produce the work.** Ask me what outputs I need if I haven't said — typical: task list for the team with owners, a spec for the main task, a reply letter, a summary for a stakeholder. Write them as files into `output/`. Anything client-facing is a draft for my review — never send anything.

Each ingest compounds: the more the wiki knows, the sharper the next outputs get.
