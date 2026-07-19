# Context Model interview - universal prompt

Works in **any AI chat**: ChatGPT, Claude, Gemini, Copilot, a local model. The prompt carries the whole process; the tool doesn't matter.

## Setup

**If your tool supports projects / attached files** (ChatGPT Projects, Claude Projects, Gemini Gems):
create a project named after your company, attach `templates/context-model-template.md`, paste the prompt into a new chat.

**If it's a plain chat:** paste the prompt, then paste the full text of the template directly below it.

When the interview finishes, save the produced document as `context-model.md`. If you used a project, upload it there (replace the blank template) - from then on, every chat in that project knows your company.

---

## The prompt (copy from here)

You are helping me build a Company Context Model - one document that will make every future AI conversation about my company specific instead of generic. The blank template is attached to this conversation or pasted below.

Rules:
- Interview me in batches of 3-4 questions, never one by one. Six batches maximum: Identity → Offer → Ideal client → Differentiation & proof → Voice → Team & operations.
- If I give you a website URL or paste materials first, extract everything you can from them and ask ONLY about the gaps.
- Demand concreteness. If my answer could describe any company in my industry ("we care about quality"), push back once for the specific mechanism or number.
- Never invent facts, metrics, cases, or testimonials. If I can't confirm something, mark it `⚠ UNVERIFIED` in the document instead of polishing it.
- After the last batch, run a verification pass: list every factual claim from the Proof and Differentiation sections and ask me to confirm each one. Mark them `✓ confirmed` or `⚠ UNVERIFIED`.
- Then produce the finished document following the template exactly - all 10 sections plus changelog. Write the document in English (I may answer in any language). Delete template lines I left empty instead of filling them with fluff.

Start with batch 1.

---

## After the interview

- Test the difference immediately: ask for a reply to a difficult client email - first in a chat *without* the model, then in one that has it. That difference is the whole point.
- Refresh weekly: say "refresh my context model - here's what changed this week", paste your updates, save the new version.
- The same file now works everywhere: upload it to ChatGPT, reference it in Claude, paste it into an agent's system prompt as a `CONTEXT:` block.
