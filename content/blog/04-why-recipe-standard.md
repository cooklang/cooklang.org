---
title: "Why Recipes Don't Have a Standard Format (And Why That's a Problem)"
date: 2024-11-09T21:27:37+00:00
weight: 80
summary: "Music has notation. Code has formal grammar. Recipes — something humans share daily — still don't have a standard format. Here's why that matters and what a real recipe standard looks like."
description: "Music has notation. Code has formal grammar. Recipes — something humans share daily — still don't have a standard format. Here's why that matters."
categories: ["Format and Design"]
---

Recipes fail for a stupid reason: ambiguity. "A generous amount of oil." "Cook until done." "Season to taste." These instructions work when you already know how to make the dish. For everyone else, they're guesswork.

We've standardized nearly every other form of instruction. Musical notation lets someone in Tokyo perform a piece written in Vienna two centuries ago. Programming languages compile the same way on every machine. Building codes ensure that a wall is a wall, everywhere. But recipes — something humans share and reproduce daily — still have no standard format.

The cost isn't just failed dinners. Without structure, recipes can't be processed by software. A computer can't generate a shopping list from "a few cloves of garlic." It can't scale "some butter" by 1.5x. It can't calculate nutrition from "a handful of spinach." Every vague measurement is a dead end for automation.

## What Standardization Enables

A recipe with precise, structured data unlocks capabilities that unstructured recipes can't:

**Consistent reproduction.** When a recipe specifies `@flour{250%g}` instead of "about 2 cups of flour," anyone with a kitchen scale gets the same result. Weight is universal; cup measurements vary by how you scoop.

**Automated shopping lists.** If ingredients are tagged and quantified, software can extract them, combine duplicates across recipes, and produce a list grouped by store aisle. No manual work, no forgotten items.

**Recipe scaling.** Double the recipe? Multiply every quantity by 2. This is trivial when quantities are structured data. It's impossible when they're prose.

**Nutritional calculation.** Structured ingredients with precise quantities can be mapped to nutritional databases. "400g chicken breast" has a known calorie count. "Some chicken" does not.

**Smart kitchen integration.** An oven that knows the recipe calls for 200°C for 25 minutes could set itself. A kitchen display could show timers for each step. None of this works without structured data.

## Why It Hasn't Happened

Recipes resist standardization for cultural reasons, not technical ones. Cooking feels like art, and standards feel like constraints. People associate precision with sterility — as if measuring flour by weight somehow removes the soul from bread.

But standards don't constrain creativity. They constrain ambiguity. Music notation didn't make music less creative — it made it shareable. Standardized recipes would do the same for cooking: free people to focus on flavor and technique instead of guessing what "medium heat" means on someone else's stove.

The other barrier is fragmentation. There's no incentive for recipe websites to adopt a standard format. Their business model depends on keeping you on their page, scrolling past ads. Structured recipes that could be extracted and used elsewhere work against that model.

## A Practical Standard

[Cooklang](/docs/spec/) is our answer to this. It's a markup language that adds structure to natural recipe text:

```cooklang
Preheat the #oven to 200°C.

Season @chicken thighs{4} with @salt{1%tsp} and @smoked paprika{1%tsp}.

Roast for ~{35%minutes} until the internal temperature reaches 75°C.
```

The recipe reads naturally. The `@`, `#`, and `~` annotations make it machine-parseable. Tools can extract ingredients, generate shopping lists, run timers, and scale quantities — all from the same file a human reads while cooking.

This isn't the only possible standard. But it's a working one, with an [ecosystem of tools](/cli/) that demonstrate what structured recipes make possible.

-Alexey
