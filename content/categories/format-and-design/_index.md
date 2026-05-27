---
title: "Recipe Format and Design: Why Cooklang Looks the Way It Does"
slug: "format-and-design"
description: "Design decisions, language history, and format philosophy behind Cooklang — why plain text, why this syntax, and what a recipe format should optimise for."
date: 2026-05-27
---

Cooklang is a deliberate design, not a happy accident. This hub collects the posts about how and why the language ended up the way it did — the decisions that went into the syntax, the format choices behind plain-text recipes, and the broader history of structured recipe data going back decades before Cooklang existed.

If you're new to the philosophy, start with [Why Plain Text Recipes](/blog/12-why-plain-text-recipes/) and [Why a Recipe Standard](/blog/04-why-recipe-standard/). They cover the two foundational arguments: that plain text outlives applications, and that a shared format unlocks tooling that nobody would build for a proprietary one.

For the language design itself, [Designing a Recipe Markup Language](/blog/37-designing-a-recipe-markup-language/) walks through the syntax choices, and [The Recipe Markup Language](/blog/35-recipe-markup-language/) is the high-level pitch. [Recipes as Stack Machines](/blog/05-recipes-as-stack-machines/) is the conceptual deep dive — what a recipe really is from a computer-science perspective. [Cooking for Programmers](/blog/22-cooking-for-programmers/) covers the recipes-as-code framing.

Historical context: [The David A. Mundie Interview](/blog/08-david-a-mundie-interview/) covers a pioneer of structured recipe formats — a person most cooks have never heard of, but whose ideas underpin a lot of what came later. [AI and the Evolution of Recipe Formats](/blog/03-ai-and-the-evolution-of-recipe-formats/) looks at how LLMs change the equation.

Two more design-adjacent posts: [What Recipe Software Should Tell You About Nutrition](/blog/07-nutrients-during-cooking/) on the data-model gaps in current apps, and [Cooking Timers in Recipes](/blog/46-cooking-timers-in-recipes/) on modelling time as a first-class concept.

The throughline: every "small" decision in the syntax has consequences that show up years later — in what tools can be built, in how easy it is to write a parser, in whether your recipes are still readable in 2050. We try to make those consequences explicit.
