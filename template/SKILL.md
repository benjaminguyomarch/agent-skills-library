---
name: skill-name
description: >
  [What the skill does, third person, present tense]. Use when [specific triggers,
  contexts, or phrases the user might say]. Keep it specific and include key terms —
  this is the only signal used to select the skill.
license: Apache-2.0
metadata:
  author: benjaminguyomarch
  version: "1.0"
---

<!--
  description rules (voir docs/skill-anatomy.md) :
  - Toujours à la 3e personne ("Generates…", jamais "You can…" / "I can…").
  - Dire CE QUE fait le skill ET QUAND l'utiliser, avec des mots-clés déclencheurs.
  - Une description un peu "insistante" aide : Claude a tendance à sous-déclencher.
-->

# Skill Title

One or two sentences: what this skill accomplishes and the value it provides.

## When to use this skill

<!-- Conditions de déclenchement concrètes, pas du vague. -->

- Trigger 1: [specific situation]
- Trigger 2: [specific situation]
- Trigger phrases: [word1, word2, word3]

Do **not** use this skill when [counter-example], because [reason].

## Process

<!-- Étapes actionnables. Expliquer le POURQUOI, pas seulement le COMMENT. -->

### Step 1 — [Name]

[Instruction]. This matters because [reason], which lets the agent handle cases this
skill did not spell out.

### Step 2 — [Name]

[Instruction].

### Step 3 — [Name]

[Instruction].

## Common mistakes

<!-- Erreurs fréquentes + l'excuse que l'agent pourrait se donner. -->

- Mistake: [what goes wrong]. Excuse the agent might make: "[rationalization]".
  Correct behavior: [what to do instead].
- Mistake: [what goes wrong]. Correct behavior: [what to do instead].

## Verification

<!-- Critères de sortie basés sur des preuves : "ça semble correct" ne suffit pas. -->

The task is done only when:

- [ ] [Concrete, checkable outcome — e.g. output matches the required format]
- [ ] [Evidence, not impression — e.g. example ran and produced expected result]

## References

<!-- Décommenter si des fichiers de support existent (chargés à la demande). -->
<!-- - See [reference.md](reference.md) for detailed material. -->
<!-- - Main script: [scripts/main.sh](scripts/main.sh) -->
