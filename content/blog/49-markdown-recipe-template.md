---
title: "Markdown Recipe Template: Free Templates & a Better Alternative"
date: 2026-04-09
weight: 60
summary: "Copy-paste Markdown recipe templates that work in any text editor, Obsidian, or static site — plus an honest look at where Markdown falls short and what Cooklang adds."
description: "Free markdown recipe template with YAML frontmatter. Copy-paste and use today — then see why Cooklang does more with the same plain text approach."
---

Markdown is a reasonable place to store recipes. It's readable in any text editor, renders nicely in Obsidian, GitHub, or a Jekyll site, and doesn't require any app to open. If you want your recipes in plain text, starting with Markdown makes sense.

This post gives you the actual templates — no signup, no download. Then I'll show you exactly where the format breaks down and what Cooklang does differently.

## Basic Markdown Recipe Template

Copy this directly. It works anywhere that renders Markdown.

```markdown
# Recipe Name

**Servings:** 4
**Prep time:** 15 minutes
**Cook time:** 30 minutes

## Ingredients

- 400g canned tomatoes
- 2 tbsp olive oil
- 3 cloves garlic, minced
- 1 tsp dried oregano
- 200g pasta
- Salt and pepper to taste

## Instructions

1. Bring a large pot of salted water to a boil.
2. Heat olive oil in a saucepan over medium heat. Add garlic and cook until fragrant, about 1 minute.
3. Add canned tomatoes and oregano. Simmer for 15 minutes, stirring occasionally.
4. Cook pasta according to package directions. Drain and toss with the sauce.
5. Season with salt and pepper. Serve immediately.

## Notes

- Add a pinch of red pepper flakes for heat.
- Sauce keeps in the fridge for up to 4 days.
```

That's the baseline. It works. You can read it, edit it, commit it to Git.

## Extended Markdown Template with YAML Frontmatter

If you're using Obsidian, Jekyll, Hugo, or any static site generator, frontmatter lets you add structured metadata that the tool can use — tags, dates, ratings, source URLs.

```markdown
---
title: Tomato Pasta
servings: 4
prep_time: 15 minutes
cook_time: 30 minutes
tags: [italian, quick, vegetarian]
source: "Family recipe"
rating: 4
last_made: 2026-03-15
---

# Tomato Pasta

## Ingredients

- 400g canned tomatoes
- 2 tbsp olive oil
- 3 cloves garlic, minced
- 1 tsp dried oregano
- 200g pasta
- Salt and pepper to taste

## Instructions

1. Bring a large pot of salted water to a boil.
2. Heat olive oil in a saucepan over medium heat. Add garlic and cook until fragrant, about 1 minute.
3. Add canned tomatoes and oregano. Simmer for 15 minutes, stirring occasionally.
4. Cook pasta according to package directions. Drain and toss with the sauce.
5. Season with salt and pepper. Serve immediately.

## Notes

- Add a pinch of red pepper flakes for heat.
- Sauce keeps in the fridge for up to 4 days.
```

The frontmatter gives you queryable fields in Obsidian (Dataview works well here), and most static site generators can use them to build recipe index pages or filter by tag.

## Where Markdown Falls Short

Here's the honest part.

Markdown treats your ingredient list as text. That's fine for reading. It's a problem the moment you want to do anything programmatic with your recipes.

**You can't generate a shopping list automatically.** To combine ingredients from three recipes into a shopping list, you'd have to parse the ingredient lines yourself — or copy and paste manually. The format gives you no help.

**You can't scale quantities.** "400g canned tomatoes" is a string. If you want to double the recipe, you open the file and manually multiply every number. With 12 ingredients, that's 12 places to change, 12 places to make an error.

**You can't extract structured data.** Want to know how much olive oil you have across all your recipes? Or which recipes use canned tomatoes? You'd need to write a parser that understands your specific formatting conventions — which might differ between files you wrote six months apart.

The problem is that every ingredient line is a different string:

```
- 400g canned tomatoes
- 2 tbsp olive oil
- 3 cloves garlic, minced
```

Is it `400g` or `400 g`? Is the quantity first or last? Is "minced" part of the ingredient name or a preparation note? You wrote it, so you know. A computer doesn't — unless you write a parser.

With Markdown, **you become the parser**. The format stores text; all the intelligence lives in your head.

## Cooklang: Markdown That Understands Recipes

[Cooklang](/docs/spec/) is a plain text format designed specifically for recipes. The core idea is simple: annotate your recipe text so that tools can extract structured data without you having to write a parser.

Here's the same tomato pasta in Cooklang:

```cooklang
---
servings: 4
prep_time: 15 minutes
cook_time: 30 minutes
tags: [italian, quick, vegetarian]
---

Bring a #large pot of salted @water{} to a boil.

Heat @olive oil{2%tbsp} in a #saucepan over medium heat. Add @garlic{3%cloves}, minced, and cook until fragrant, about ~{1%minute}.

Add @canned tomatoes{400%g} and @dried oregano{1%tsp}. Simmer for ~{15%minutes}, stirring occasionally.

Cook @pasta{200%g} according to package directions. Drain and toss with the sauce.

Season with @salt{} and @pepper{} to taste. Serve immediately.
```

The `@` marks ingredients, `#` marks cookware, and `~` marks timers. Quantities go in curly braces: `{400%g}` means 400 grams.

What changes compared to Markdown:

- **Shopping lists are automatic.** Any Cooklang tool can extract `@canned tomatoes{400%g}` and combine it with ingredients from other recipes.
- **Scaling works.** Change the servings number and tools recalculate every `{400%g}` accordingly. No manual math.
- **The text is still readable.** It reads like a recipe. Someone who has never heard of Cooklang can follow it in the kitchen.

It's still plain text. It still works with Git, any sync service, any text editor. But now a computer can do useful things with it. See the [format comparison](/blog/recipe-formats-compared/) for how this stacks up against JSON-LD, MealMaster, and others.

## Using Either Format in Obsidian

Both Markdown and Cooklang work in Obsidian. Markdown renders automatically. Cooklang works too — you just install the [Cooklang Editor plugin](https://github.com/cooklang/cooklang-obsidian) from the community plugins directory.

With the plugin, `.cook` files get:

- Syntax highlighting (ingredients in blue, cookware in green, timers in pink)
- A recipe preview mode that looks like a proper recipe card
- Interactive timers that run directly in the editor
- An ingredient checklist while you cook

The [Obsidian guide](/blog/cooklang-obsidian-guide/) covers setup in detail. It takes about three minutes.

If you're already using Markdown recipes in Obsidian, you can migrate gradually — convert recipes to Cooklang as you use them, or leave old ones as Markdown. There's no conflict.

## Which Should You Use?

If you want simple recipe storage and don't need shopping lists or scaling, Markdown is fine. The templates above will serve you well.

If you want your recipe files to actually do things — generate shopping lists, scale quantities, power a cooking app, or expose a recipe API — Cooklang adds that capability without giving up the plain text properties you're already after. Get started at the [getting started guide](/docs/getting-started/).

If Markdown works for you, use it. If you want your recipe files to do more, try Cooklang.

-Alex
