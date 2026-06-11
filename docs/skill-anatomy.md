# Skill Anatomy — how to write a good skill

<!-- Guide d'écriture, basé sur les bonnes pratiques officielles d'Anthropic + retours communautaires. -->

A skill is a reference guide for a proven technique, pattern, or workflow. It helps a future agent
find and apply an effective approach. A skill is **not** a narrative of how you solved something
once. This guide distills the practices that matter most.

## 1. The description is the most important line

At startup, an agent loads only each skill's `name` and `description`. The full `SKILL.md` is read
only once the agent judges the skill relevant. So the description is the single signal used to
*select* the skill — get it wrong and the rest never runs.

- **Write in third person.** The description is injected into the system prompt; mixing points of
  view hurts discovery. Good: "Processes Excel files and generates reports." Avoid: "You can use
  this to process Excel files."
- **State what it does AND when to use it.** Include concrete trigger words and contexts.
- **Be a little pushy.** Agents tend to *under*-trigger skills. "Use when the user mentions
  dashboards, metrics, or data viz — even if they don't explicitly ask for a dashboard" beats a
  timid description.
- **Mind the budget.** The Agent Skills spec caps `description` at 1024 characters.

<!-- Exemple concret -->
```yaml
description: >
  Extracts text and tables from PDF files, fills forms, and merges documents.
  Use when working with PDFs or when the user mentions PDFs, forms, or document extraction.
```

## 2. Be concise — context is a public good

Once loaded, every token in your `SKILL.md` competes with conversation history and everything else
the agent needs. Keep it tight:

- Keep `SKILL.md` under ~500 lines. Move long reference material to a sibling file and link it
  (progressive disclosure — it loads only when needed).
- Prefer scripts over inline code: a script's body doesn't consume context, only its output does.
- File references work one level deep — link directly from `SKILL.md` to the supporting file.

## 3. Explain the *why*, don't just stack rules

A wall of ALL-CAPS MUST/ALWAYS/NEVER gives rigid rules with no context: the agent follows the
letter and misses edge cases. State the rule, then the reason, so the agent can generalize.

> "Use constructor injection. Field injection breaks testability because we can't mock the field
> without a Spring context." — better than "MUST use constructor injection. NEVER use field injection."

The reasoning becomes the rubric for situations the skill never spelled out.

## 4. Required sections

Every skill in this repo has:

- **Overview** — one or two sentences on what it accomplishes.
- **When to use this skill** — concrete triggers, plus at least one counter-example.
- **Process** — actionable, ordered steps, each with its rationale.
- **Common mistakes** — failures *and* the rationalization the agent might use to skip a step.
- **Verification** — evidence-based exit criteria. "Seems right" is never enough.

## 5. Test before you trust

<!-- Principe clé : si tu n'as pas vu un agent échouer sans le skill, tu ne sais pas s'il enseigne la bonne chose. -->

If you haven't watched an agent attempt the task *without* the skill, you don't know whether the
skill teaches the right thing. Minimal loop:

1. Give a fresh agent a real task (not a toy scenario) without the skill — observe what it gets wrong.
2. Write the skill to address those specific failures.
3. Give the agent the same kind of task with the skill — confirm it now complies.
4. Refine wording where it still slips. Fifteen minutes of testing saves hours later.

Clear-to-you does not mean clear-to-another-agent. Test it.

## Quick checklist

- [ ] `name` is `kebab-case` and matches the folder name.
- [ ] `description` is third person, says what + when, includes trigger terms.
- [ ] `SKILL.md` under ~500 lines; long material moved to linked files.
- [ ] Rules explain their reasoning.
- [ ] All five required sections present.
- [ ] Verified by watching an agent actually use it.
