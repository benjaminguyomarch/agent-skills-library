---
name: n8n-gotchas
description: >
  Surfaces three non-obvious n8n node behaviors that fail silently instead of throwing an error —
  the Merge node's combine-by-position parameter name, where a Basic LLM Chain's system prompt
  actually has to go, and the Code node execution-mode declaration. Use when building or debugging
  an n8n workflow that uses a Merge node, a Basic LLM Chain / AI Agent node, or a Code node — and
  especially when a workflow "runs successfully" but produces wrong, missing, or partial output
  with no error in the execution log. Trigger phrases: "n8n workflow", "Merge node", "combineBy",
  "Basic LLM Chain", "system prompt ignored", "Code node", "runOnceForAllItems", "n8n silently
  wrong output".
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

# n8n Gotchas

n8n's execution log shows a green checkmark for a *successful* run even when a node quietly did
the wrong thing — mis-parsed a parameter, ignored a prompt, or processed only one item out of ten.
These three traps share that shape: no error, no warning, just wrong output that looks plausible
enough to ship. This skill exists so the agent recognizes the shape of "n8n said it worked, but
the output is subtly wrong" and checks these three places first, instead of re-debugging each one
from scratch.

## When to use this skill

- Building or editing a workflow that includes a **Merge** node combining two branches.
- Building or editing a **Basic LLM Chain** or **AI Agent** node that needs a system prompt/message.
- Writing or editing a **Code** node in an n8n workflow (Function/Code, JS or Python).
- A workflow executes without error but the output is wrong, partial, or missing fields — before
  assuming the upstream API or data is at fault, rule out these three node-configuration traps.
- Trigger phrases: "n8n workflow", "Merge node", "combineBy", "combinationMode", "Basic LLM Chain",
  "system prompt ignored", "Code node", "runOnceForAllItems", "runOnceForEachItem".

Do **not** use this skill for generic n8n workflow design (trigger choice, branching strategy,
credential setup) — it covers only these three specific node-level footguns. For workflow-JSON
editing conventions (validation, naming, secrets), see the project's own
`.claude/rules/workflow-json.md` if one exists.

## Process

### Step 1 — Merge node: use `combineBy`, not `combinationMode`

When combining two branches positionally (item 1 of branch A with item 1 of branch B), the
parameter n8n's Merge node (v3) actually reads is:

```json
{ "parameters": { "mode": "combine", "combineBy": "combineByPosition" } }
```

`combinationMode` is not the parameter name — setting it has no effect, and the node silently
falls back to its default "Match Fields" mode, which then either produces wrong pairings or throws
a confusing downstream error demanding match-field configuration. This matters because the failure
surfaces far from the cause: you'll be debugging a downstream node's "unexpected data shape"
instead of the Merge node's silently-ignored parameter. Always verify the actual parameter name in
the node's current JSON (open it in n8n, check "Combine" mode, export, and read the parameter key)
rather than assuming it matches the UI label.

### Step 2 — Basic LLM Chain: the system prompt goes in `messages.messageValues[]`

The system prompt for a **Basic LLM Chain** node belongs in:

```json
{
  "parameters": {
    "messages": {
      "messageValues": [
        { "type": "SystemMessagePromptTemplate", "message": "..." }
      ]
    }
  }
}
```

Not in `options.systemMessage` — that field exists in the UI/schema but is silently ignored by
this node type at execution time, with no error and no warning. The model just runs with no system
prompt, which is easy to miss because the chain still returns a plausible-looking answer; it's
simply not following the instructions you thought you gave it. When debugging a Basic LLM Chain
that seems to ignore its instructions, check `messages.messageValues[]` in the exported JSON before
assuming the model or the prompt wording is at fault.

### Step 3 — Code node: always declare the execution mode explicitly

Every Code node runs in one of two modes, and the default has a silent-data-loss failure mode:

- `runOnceForAllItems` — the code sees every input item at once (`items`/`$input.all()` available).
  Use this whenever the logic needs to compare, deduplicate, or aggregate across items.
- `runOnceForEachItem` — the code runs once per item (`$json` available, no `items`). Use this when
  each item is processed independently; return a single `{ json: {...} }` per execution — n8n
  recomposes these into the output array automatically.

Declare the mode explicitly (`"mode": "runOnceForAllItems"` or `"runOnceForEachItem"` in the node's
parameters) with a one-line comment saying why. The trap: accessing `$json` under the default
`runOnceForAllItems` mode doesn't error — it silently processes only the first item and drops the
rest, with a normal-looking green execution log. This is the single most expensive-to-debug variant
of the three, because a workflow that's supposed to process 50 items will appear to succeed while
quietly only handling 1.

## Common mistakes

- Mistake: trusting the n8n UI label ("Combine by position") and assuming the underlying JSON
  parameter name matches it. Excuse: "the UI says position, so it must be set." Correct behavior:
  open the exported JSON and read the actual parameter key (`combineBy`), because UI labels and
  JSON parameter names diverge without warning in n8n.
- Mistake: putting a Basic LLM Chain's system prompt in `options.systemMessage` because it's the
  first plausible-looking field in the parameter schema. Correct behavior: use
  `messages.messageValues[]` with a `SystemMessagePromptTemplate` entry, and verify by checking the
  actual model output changes when the prompt changes.
- Mistake: writing a Code node without declaring `mode`, relying on n8n's default. Excuse: "it ran
  without an error, so it must be processing everything." Correct behavior: a clean execution log
  proves nothing about item count — explicitly declare the mode and, when in doubt, log
  `items.length` (in `runOnceForAllItems`) to confirm all items were actually seen.

## Verification

The task is done only when:

- [ ] Every Merge node combining by position has `combineBy: "combineByPosition"` in its exported
      JSON (not `combinationMode`), verified by reading the JSON, not just the UI.
- [ ] Every Basic LLM Chain / AI Agent node's system prompt is confirmed present in
      `messages.messageValues[]`, and changing the prompt text visibly changes the model's output
      on a test run.
- [ ] Every Code node has an explicit `mode` declaration with a comment explaining the choice, and
      a test run with more than one input item confirms all items appear in the output (not just
      the first).
