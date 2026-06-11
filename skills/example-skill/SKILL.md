---
name: example-skill
description: >
  Produces a structured three-part summary (main idea, key points, conclusion) of any
  text or document. Use when the user asks to summarize, condense, synthesize, or
  recap content, or says "TL;DR", "résume", or "give me the gist".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

<!-- Skill d'exemple : sert de référence de format pour les futurs skills. -->

# Structured Summary

Turns any long text or document into a consistent three-part summary, so the reader gets
the essentials in a predictable shape every time.

## When to use this skill

- The user asks for a summary, synthesis, recap, or condensed version of some content.
- The user pastes a long text and wants the essentials extracted.
- Trigger phrases: summarize, summary, synthesize, recap, condense, TL;DR, "résume", "gist".

Do **not** use this skill when the text is under ~100 words, because a summary adds no value
over the original — return the text as-is instead.

## Process

### Step 1 — Read the whole input first

Read the entire text before writing anything. Summarizing from a partial read produces
confident but wrong summaries, which are worse than no summary.

### Step 2 — Extract the three elements

Identify, in this order:

1. **Main idea** — one sentence capturing the core message.
2. **Key points** — three to five bullets with the load-bearing details.
3. **Conclusion** — one or two sentences on the takeaway or recommendation.

### Step 3 — Output in the fixed format

```
## Main idea
[one sentence]

## Key points
- [point 1]
- [point 2]
- [point 3]

## Conclusion
[one or two sentences]
```

## Common mistakes

- Mistake: padding the summary to match the source length. Excuse the agent might make:
  "the original was long, so the summary should be too". Correct behavior: a summary is
  valuable *because* it is shorter — keep it tight.
- Mistake: merging several distinct topics into one blurry summary. Correct behavior: if the
  input covers multiple independent subjects, produce one summary block per subject.

## Verification

The task is done only when:

- [ ] Output uses exactly the three sections in the fixed format.
- [ ] Main idea is a single sentence; key points are 3–5 bullets.
- [ ] No detail in the summary contradicts the source text.
