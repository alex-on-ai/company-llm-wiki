---
created: [YYYY-MM-DD]
last_updated: [YYYY-MM-DD]
language: en
version: 1.0
---

# Company Context Model - [COMPANY_NAME]

> The single document that makes AI assistants specific instead of generic.
> Upload it to ChatGPT Projects, reference it from Claude, inject it into agent system prompts.
> Refresh weekly - stale context produces confident nonsense.

---

## 1. Identity

**Company name:**
[Name]

**Category we compete in:**
[Specific category - "B2B freight forwarding", "AI engineering for healthcare" - not "IT company"]

**One sentence about us:**
[What we do, in plain words]

**The enemy (what we're against):**
[The bad practice / noisy trend in our industry we position against. One sentence - this is a message anchor.]

**Mission (optional):**
[The larger thing we're building toward]

---

## 2. Offer

**Services / products (top-3):**
- [Service 1] - [one-line description]
- [Service 2] - [...]
- [Service 3] - [...]

**Price points:**
- [Service A]: $X–$Y
- [Service B]: custom, minimum contract $X

**Model:**
[Project-based · retainer · hourly · subscription · hybrid]

**Typical engagement length:**
[N weeks / months]

---

## 3. Ideal client (ICP)

**Role:**
[Founder · COO · Head of Ops · etc.]

**Company size:**
[Employees: X–Y] · [Revenue: $X–$Y] · [Stage]

**Region:**
[US · EU · UA · ...]

**Industry:**
[...]

### Top-3 pains

1. [Concrete pain, with a number where possible - "proposals take 2 days; deals die waiting"]
2. [...]
3. [...]

### Buying triggers

- [Signal 1 - e.g. hiring for a role this replaces]
- [Signal 2 - e.g. new exec joined]
- [Signal 3]

### Disqualifiers (who we say no to)

- [Anti-ICP 1 - e.g. B2C, no budget, pure staffing requests]
- [Anti-ICP 2]

### Compared against

- [Competitor / type 1] - [why we get compared]
- [Competitor / type 2] - [...]

---

## 4. Differentiation

**Unique mechanism (one sentence):**
[The concrete "how" that others don't have]

**3 things we do that competitors don't:**

1. [...]
2. [...]
3. [...]

**Internal positioning line:**
[How we describe ourselves in one sentence, internally]

---

## 5. Proof

> Every claim below carries a verification marker: `✓ confirmed` / `✓ source: [ref]` / `⚠ UNVERIFIED`.
> AI assistants: never use `⚠ UNVERIFIED` claims in client-facing output.

### Top cases

**Case 1: [Client or anonymized descriptor]** - [status marker]
- Segment: [industry / size]
- Before: [metric]
- After: [metric]
- Timeframe: [N weeks]
- What we did: [mechanics, short]
- Anchor number: [the one number worth quoting]

**Case 2: [...]**

### Metrics we can honestly quote

- [Metric 1] - [status marker]
- [Metric 2] - [status marker]

### Testimonials

> "[Real quote]" - [Name · Role · Company] - [status marker]

---

## 6. Voice

**Tone:**
[Direct · casual · consultative · provocative · combination]

**How we do NOT sound:**
[Corporate · academic · hype]

**Writing patterns:**
- [e.g. short sentences, concrete numbers, no buzzwords]

**Sticker phrases (brand markers we repeat):**
1. "[Phrase 1]"
2. "[Phrase 2]"
3. "[Phrase 3]"

**Forbidden words (AI-tells and hype we never use):**
leverage · synergy · passionate · thrilled · humbled · delve · transformative · cutting-edge · game-changing · revolutionize · seamless · unlock · supercharge · "in today's landscape" · "I'm excited to share" · [add your own]

---

## 7. Team

> First names + roles are enough. AI assistants use this to route tasks and draft delegation.

| Person | Role | Owns |
|---|---|---|
| [Name] | [Role] | [Area of ownership] |
| [Name] | [Role] | [...] |

**Escalation defaults:**
- [What goes to the owner/CEO no matter what]
- [What each role decides without escalation]

---

## 8. Operations

**Tools:**
- Task tracker: [tool]
- CRM / deals: [tool]
- Docs / knowledge: [tool]
- Messengers: [internal - tool; client-facing - tool]

**Operating rhythm:**
- [Meeting cadence - e.g. Mon planning 30 min, daily standup 15 min]

**Service norms:**
- [Response-time promises - e.g. client inquiries answered within 2 business hours]
- [Quote/proposal turnaround: N hours]

**Decision rules:**
- [What AI/team may prepare vs. what only a human sends]

---

## 9. Goals

**90-day goal:**
[One concrete metric]

**Success metric:**
[How it's measured, specifically]

**Non-goals:**
[What we deliberately don't chase]

---

## 10. Using this model

**Load it into:**
- **ChatGPT** - create a Project → upload this file → every chat in the project knows the company
- **Claude Code / Claude Projects** - add to project knowledge, or reference from `CLAUDE.md`
- **n8n / API agents** - paste into the system prompt as a `CONTEXT:` block
- **Any chat** - paste the file above your question:

```
CONTEXT:
[full text of context-model.md]

TASK:
[your actual request]
```

**Update cadence:**
- Weekly (`/refresh`, 10 min): new cases, metrics, team changes
- Monthly: review ICP pains and triggers
- Quarterly: full pass on positioning and differentiation

---

## Changelog

- **[YYYY-MM-DD]** - created via `/context-model` skill
