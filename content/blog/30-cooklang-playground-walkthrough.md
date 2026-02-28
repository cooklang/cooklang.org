---
title: "Try Cooklang in Your Browser: Playground Walkthrough"
date: 2026-02-28
weight: 60
summary: "The fastest way to try Cooklang requires nothing but a browser tab. This walkthrough shows you exactly what to expect when you open the playground."
---

The fastest way to try Cooklang is to open a browser tab. No download, no setup, no account. Just open [the playground](https://cooklang.github.io/cooklang-rs/) and start writing recipes.

This post walks you through what you will see, starting from a two-line recipe and working up to sections, metadata, and notes. By the end, you will know whether Cooklang fits the way you think about recipes.

## What the Playground Is

The playground is a browser-based editor powered by WebAssembly. Your recipe text goes on the left. The parsed output appears on the right, updating as you type.

The right panel shows everything Cooklang extracts from your text: a clean ingredients list with quantities and units, cookware needed, timers, and step-by-step instructions. Nothing is sent to a server. Everything runs locally in your browser.

## Your First Recipe

Open the playground and clear whatever is already in the editor. Type this:

```cooklang
Crack @eggs{3} into a #bowl{} and whisk.
Melt @butter{1%tbsp} in a #pan{}.
Pour in eggs and cook for ~{3%minutes}.
```

Watch the right panel. You will see:

- **Ingredients:** eggs (3), butter (1 tbsp)
- **Cookware:** bowl, pan
- **Timers:** 3 minutes
- **Steps:** the full instructions, readable as plain text

That is the core idea. You write recipes the way you already think about them. Cooklang reads the `@`, `#`, and `~` markers and pulls out the structured data automatically.

### What the Markers Mean

- `@ingredient{quantity%unit}` marks an ingredient. The `{3}` sets the quantity. The `%` separates quantity from unit.
- `#cookware{}` marks a piece of cookware. The `{}` is optional but makes the marker explicit.
- `~{25%minutes}` marks a timer with a duration.

You do not need to memorize these upfront. The playground gives you instant feedback, so you can experiment freely and see what each marker does.

## Adding Metadata

Cooklang supports YAML frontmatter for recipe metadata. Add it at the top of your file with triple dashes:

```cooklang
---
title: Scrambled Eggs
servings: 2
time: 5 minutes
tags: [breakfast, quick]
---

Crack @eggs{3} into a #bowl{} and whisk with @milk{1%tbsp}.
Melt @butter{1%tbsp} in a #pan{} over medium heat.
Pour in the egg mixture and cook for ~{3%minutes}, stirring gently.
```

The metadata block can hold any key-value pairs you find useful. Apps and tools that support Cooklang can read this data and display it alongside the recipe. In the playground, you will see it reflected in the parsed output on the right.

## Sections, Notes, and Inline Prep

Once you have the basics, try a recipe with multiple sections. Use `=` to start a section heading and `>` to add a note.

```cooklang
---
title: Pasta with Tomato Sauce
servings: 4
time: 30 minutes
---

= Sauce

Heat @olive oil{2%tbsp} in a #large pan{} over medium heat.
Add @garlic{3%cloves}(minced) and cook for ~{1%minute}.
Add @crushed tomatoes{400%g} and simmer for ~{15%minutes}.

> Taste the sauce before adding salt. Canned tomatoes vary a lot in saltiness.

= Pasta

Bring a #large pot{} of water to a boil.
Cook @pasta{400%g} according to package instructions.
Drain and toss with the sauce.
```

A few things to notice here:

- `= Sauce` and `= Pasta` split the recipe into named sections. The parsed output groups steps under each section.
- `@garlic{3%cloves}(minced)` adds an inline preparation note in parentheses. The word "minced" appears in the step text and the ingredients list.
- `> Taste the sauce...` adds a note that appears in the instructions but is visually distinct.

This is where Cooklang starts to feel genuinely useful. A recipe with sections is easier to follow in the kitchen than a wall of text, and the structure makes it easier to build apps and meal planners on top of your recipes.

## What to Try Next

Spend a few minutes in the playground experimenting. Some things worth trying:

- Change a quantity and watch the ingredients list update instantly
- Add a second ingredient to a step and see how the list grows
- Try removing the `{}` from a cookware marker and see what changes
- Add a `-- this is a comment` line anywhere and notice it disappears from the output

Comments use `--` and are stripped from the parsed output. They are useful for notes to yourself that you do not want to appear in the final recipe.

## When You Are Ready for More

The playground is a great place to learn Cooklang syntax, but it is not where most people end up storing their recipes. When you want to keep your recipes, share them, or use them with an app, your next step depends on how you work.

- **Command line:** [CookCLI](/cli/) lets you manage a recipe collection, serve a local web app, and export shopping lists from the terminal.
- **Mobile:** The [mobile apps](/app/) bring your recipe collection to your phone, with offline access and meal planning features.
- **Getting started guide:** The [documentation](/docs/getting-started/) walks through the full Cooklang syntax and explains how to set up a recipe collection from scratch.

The playground stays useful even after you move to local files. It is a fast way to test syntax, debug a recipe that is not parsing the way you expect, or show someone else what Cooklang looks like without asking them to install anything.

## Try It Now

Open [the Cooklang playground](https://cooklang.github.io/cooklang-rs/) and type your first recipe. Start with two or three ingredients and one step. See what the parsed output looks like. Then add a timer, a section, a note.

The whole point of the playground is that there is nothing to lose. You can experiment as much as you want, and nothing gets saved unless you copy it yourself.

-Alex
