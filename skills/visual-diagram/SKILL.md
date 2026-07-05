---
name: visual-diagram
description: >
  Generates clean flowcharts and mind maps in Whimsical directly from a
  textual description of a workflow, process, or idea structure.
  Use this skill whenever the user asks to create, update, or improve a
  visual diagram (flowchart or mind map) in Whimsical.
version: 0.1.0
tools: [whimsical]
license: Apache-2.0
metadata:
  author: benjaminguyomarch
---

## Overview

This skill turns a textual workflow or idea description into a clean
Whimsical diagram. It handles flowcharts (sequential processes, decision
branches) and mind maps (hierarchical idea structures).

The output is always a direct Whimsical board — not a prompt to copy-paste.

## When to Use

- User describes a workflow and wants it visualised
- User asks to "make a flowchart / mind map of X"
- User wants to improve or reorganise an existing Whimsical board
- User shares a process in text or chat and says "put this in Whimsical"

Do not use for static image exports, Mermaid diagrams, or draw.io boards.

## Process

### 1. Clarify the output type

If the user has not specified, ask:

- Flowchart (sequential steps, decisions, loops) → `type: flowchart`
- Mind map (hierarchical tree, brainstorm) → `type: mindmap`

### 2. Extract the structure

From the user's description, identify:

- **Nodes**: each distinct step, action, or concept
- **Edges**: connections between nodes (with labels on decisions)
- **Branches**: decision diamonds with exactly two labelled exits
  (e.g. Oui/Non, or descriptive labels like "Approuvé / Révisions")

### 3. Apply diagram constraints

**Always:**

- `direction: left-right` for flowcharts — return arrows route cleanly
  below the main flow; top-down causes diagonal crossing lines
- Use only 3 node colours maximum:
  - No colour (default/grey) for standard action steps
  - `yellow` for decision diamonds only
  - One accent colour (e.g. `green`) for start/end ovals exclusively
- Keep labels short: one line preferred, two lines maximum
  (line 2 = key detail, separated by `\n`)
- Do not add floating note nodes connected with dashed arrows —
  they break layout alignment; embed detail in the node label on line 2

**Never:**

- Use more than 3 colours in a single diagram
- Use `top-down` direction (causes overlapping return arrows)
- Add groups (swimlane sections) when auto_layout will be called —
  Whimsical treats groups as independent frames; auto_layout
  repositions nodes outside their groups, breaking the layout

### 4. Call the Whimsical tool

Use `Whimsical:create` with `type: flowchart` or `type: mindmap`.

For flowcharts, pass:

```json
{
  "type": "flowchart",
  "title": "Workflow — [Subject]",
  "data": {
    "direction": "left-right",
    "nodes": [
      { "id": "start", "label": "Start", "shape": "ellipse", "color": "green" },
      { "id": "step1", "label": "Step label\nKey detail" },
      {
        "id": "decision",
        "label": "Decision ?",
        "shape": "diamond",
        "color": "yellow"
      },
      { "id": "end", "label": "End", "shape": "ellipse", "color": "green" }
    ],
    "edges": [
      { "from": "start", "to": "step1" },
      { "from": "step1", "to": "decision" },
      { "from": "decision", "to": "end", "label": "Oui" },
      { "from": "decision", "to": "step1", "label": "Non" }
    ]
  }
}
```

Do not pass `groups` when auto_layout will be called after creation.

### 5. Call auto_layout immediately after creation

Always call `Whimsical:auto_layout` right after `Whimsical:create`.
This is what produces the clean grid — without it, nodes are placed
in raw coordinates and edges are diagonal.

```json
{
  "board_id": "<returned fileId>",
  "orientation": "lr",
  "spacing": "default"
}
```

Skip auto_layout only when groups (swimlanes) are explicitly required
by the user. In that case, document the trade-off: edges may not align
perfectly.

### 6. Verify visually before returning

Call `Whimsical:fetch` with `image: true` and inspect the screenshot:

- All nodes visible and not overlapping
- Decision diamonds have exactly 2 labelled exits
- Return arrows routed below the main flow (not diagonal)
- No more than 3 colours used

If the result is not clean, delete and recreate with adjusted structure.

### 7. Return the board link

Return only the direct board URL. No post-amble.

## Common Mistakes

**Too many colours.** Each colour adds cognitive load. Limit to: default
for steps, yellow for decisions, one accent for start/end. Sections
already provide responsibility differentiation through labels.

**Floating note nodes.** Whimsical's auto_layout cannot place these
consistently — they float and overlap action nodes. Put the detail in
the node label on a second line instead.

**top-down direction with return loops.** Return arrows span many nodes
and create diagonal crossing lines in top-down mode. left-right keeps
them on the same horizontal plane and Whimsical routes them cleanly
below the main flow.

**Skipping auto_layout.** The create call places nodes in raw
coordinates. auto_layout is what produces the clean grid. Always call
it after creating or editing a flowchart (unless groups are used).

**Mixing groups + auto_layout.** Whimsical treats groups as independent
layout frames. Calling auto_layout after creating groups repositions
nodes outside their group boundaries, breaking the swimlane structure.
Choose one: groups (swimlanes) OR auto_layout — not both.

## Dependencies

| Server | Package | Required env vars |
| --- | --- | --- |
| `whimsical` | Provided by the Whimsical MCP plugin (no npm package — install via Claude Code MCP settings or the Whimsical desktop integration) | None — authentication is handled interactively on first use |

Add to `.claude/settings.json` or `~/.claude/settings.json`:

```json
{
  "permissions": {
    "allow": ["mcp__whimsical__*"]
  }
}
```

## Verification checklist

- [ ] direction: left-right confirmed
- [ ] Max 3 colours: default / yellow / one accent
- [ ] No floating note nodes
- [ ] auto_layout called (unless groups used)
- [ ] Visual fetch confirmed clean output
- [ ] Board link returned
