---
title: "What Is a Recipe Markup Language? (And Why You'd Want One)"
date: 2026-03-11
weight: 50
summary: "A markup language adds structure to text without making it unreadable. HTML does this for web pages. Cooklang does it for recipes. Here's what that means and why it matters for anyone who cooks."
---

You already use markup languages. When you write `**bold**` in a message, that's markup — plain text with annotations that a renderer interprets. Markdown, HTML, LaTeX — they all work the same way: take readable text, add markers, and let software do something useful with the structure.

Recipes need the same thing. And they don't have it.

## The Problem with Unstructured Recipes

A recipe on a blog or in a notes app is just text. A human can read it and cook from it. A computer cannot do much more than display it.

Ask software to extract the ingredients from a typical recipe and it hits a wall immediately. Is "2 large eggs, beaten" one ingredient or two? Is "salt and pepper to taste" two ingredients with no quantities? Is "one 400g can of crushed tomatoes" 1 can or 400 grams?

Without structure, every recipe is an ambiguous blob of text. That means no automated shopping lists. No reliable scaling. No nutritional calculation. No smart kitchen integration. The recipe is trapped in prose.

## What a Markup Language Does

A markup language solves this by adding lightweight annotations to the text — markers that tell software what each piece of text *is* without making the text unreadable to humans.

HTML does this for web pages. `<h1>Title</h1>` tells a browser "this is a heading." The text is still readable, but now software knows its structure.

[Cooklang](/docs/spec/) does the same thing for recipes. Three symbols — `@`, `#`, `~` — mark ingredients, cookware, and timers within natural recipe text:

```cooklang
Heat @olive oil{2%tbsp} in a #frying pan over medium heat.

Add @garlic{3%cloves}, minced, and cook for ~{1%minute} until fragrant.

Add @cherry tomatoes{200%g}, halved, and @salt{1/4%tsp}. Cook ~{5%minutes}.
```

A human reads: "Heat olive oil in a frying pan over medium heat."

A computer reads: ingredient `olive oil`, quantity `2 tbsp`; cookware `frying pan`; and so on.

Same text, two levels of information.

## Why Recipes Specifically Need This

Most structured data formats — JSON, XML, YAML — are designed for machines. They work, but nobody wants to write a recipe in JSON:

```json
{
  "recipeIngredient": ["2 tbsp olive oil", "3 cloves garlic"],
  "recipeInstructions": [{"text": "Heat olive oil in a pan"}]
}
```

And purely human formats — blog posts, handwritten cards, notes apps — can't be computed on.

Recipes sit in an unusual position: they need to be readable by the cook standing in the kitchen *and* parseable by software that generates shopping lists, scales portions, or runs timers. A recipe markup language bridges both sides.

That's what makes Cooklang different from formats like Schema.org JSON-LD (machine-first) or plain Markdown (human-first). Cooklang is both — a recipe you can read and cook from, with structure that software can extract and use.

## What Structure Enables

Once your recipes have structure, tools can do things that are impossible with plain text:

**Shopping lists.** Parse three recipes, extract all ingredients, merge duplicates, group by store department. What takes 15 minutes by hand takes one command:

```bash
cook shopping-list monday.cook tuesday.cook wednesday.cook
```

**Scaling.** A recipe for 4 servings, scaled to 7? Every ingredient quantity is structured data — multiply by 7/4 and convert units. No manual calculator, no errors.

**Validation.** An ingredient listed but never used in any step? A timer with no associated action? Structured recipes can be checked for consistency the same way a compiler checks code.

**Interoperability.** A `.cook` file can be read by the [mobile app](/app/), rendered by a [web server](/cli/commands/server), processed by [CookCLI](/cli/), or parsed by any tool that implements the [open specification](/docs/spec/). The same file works everywhere because the structure is in the text itself, not in a proprietary database.

## How It Compares

There have been other attempts at recipe formats. [MealMaster](https://en.wikipedia.org/wiki/MealMaster) used column-based formatting from the BBS era. [RecipeML](http://www.formatdata.com/recipeml/) tried XML in 2000. Schema.org's [JSON-LD](https://schema.org/Recipe) powers Google's recipe rich snippets.

Each solved a different problem. MealMaster was for sharing recipes over dial-up. RecipeML was for data interchange between applications. JSON-LD is for SEO.

Cooklang solves the everyday problem: you want to write recipes that you can read, edit, share, and also compute on. You don't want to learn XML or write JSON. You want to write a recipe, add a few annotations, and have software handle the rest.

For a detailed side-by-side comparison, see [Recipe File Formats Compared](/blog/19-recipe-formats-compared/).

## Getting Started

The full syntax has three markers and takes about five minutes to learn:

| Marker | Purpose | Example |
|--------|---------|---------|
| `@` | Ingredient | `@flour{500%g}` |
| `#` | Cookware | `#mixing bowl` |
| `~` | Timer | `~{30%minutes}` |

Convert one recipe you know well. If it reads naturally and you can generate a shopping list from it, you'll probably convert the rest.

- [Beginner's guide to Cooklang](/blog/33-plain-text-recipes-beginners-guide/) — convert your first recipe step by step
- [Language specification](/docs/spec/) — the full syntax reference
- [Try it in the browser](/blog/30-cooklang-playground-walkthrough/) — no install needed

-Alexey
