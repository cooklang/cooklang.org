---
title: "Meal Planning as Compilation"
date: 2025-09-05
lastmod: 2026-11-19
description: "Why planning meals is like compiling code, and why most people are still using interpreters"
weight: 70
categories: ["Recipe Workflows"]
---

I used to think meal planning was for people with too much time. Then I noticed that not planning takes longer.

Without a plan, every dinner is decided at the moment you are hungry. You look in the fridge, pick something, find out one ingredient is missing, and either adapt or give up. In programming terms this is an interpreter: each meal is parsed and executed at run time, and every error shows up at run time too, when you are tired and the shop is closed.

The other way is to compile. You write the week down once, a program checks it and turns it into a shopping list, and during the week you only execute.

When I first wrote this post, a lot of it described how I wanted this to work. This version sticks to what the tools do today, and says where they stop. (One thing that has become real since: [planning a week of dinners with AI from your own collection](https://cook.md/blog/plan-a-week-of-dinners-with-ai).)

## The source file

In Cooklang a meal plan is a `.menu` file. It is plain text, like a recipe, and it points at your recipes:

```cooklang
---
servings: 2
---

==Monday==

Breakfast: \
- @oats{1%cup} with @milk{1/2%cup} and @honey{1%tbsp}

Lunch: \
- @./Risotto{4%servings} -- double batch, half is Tuesday's lunch

Dinner: \
- @./Thai Green Curry{}

==Tuesday==

Breakfast: \
- @./Breakfast/Easy Pancakes{}

Lunch: \
- leftover risotto from Monday

Dinner: \
- @./Neapolitan Pizza{} with @./Salads/Caprese{}

==Wednesday==

Breakfast: \
- @oats{1%cup} with @milk{1/2%cup} and @honey{1%tbsp}

Lunch: \
- @./Breakfast/Mexican Style Burrito{}

Dinner: \
- @./lamb-chops{}

==Snacks==

- @apples{6} \
- @almonds{200%g} \
- @dark chocolate{1%bar}
```

Each `==Day==` line starts a section. `@./Risotto{4%servings}` is a reference to the file `Risotto.cook`, scaled to four servings. `@oats{1%cup}` is an ordinary ingredient, for things that don't need a recipe. The `\` at the end of a line joins it to the next one, so a meal and its bullet points stay together.

The text after `--` is a comment. It is a note to me, and the tools ignore it, the same as a compiler ignores comments. "Leftover risotto from Monday" is plain text for the same reason: there is nothing to buy for it.

The recipes in this plan come from the sample collection that `cook seed` creates, so you can save the file into that folder as `Plans/Three Days.menu` and try it.

## The compile step

One command turns the plan into a shopping list:

```
$ cook shopping-list "Plans/Three Days.menu"
[fruit and veg]
apples                   6
lemon                    
lime                     3 1/2
avocado                  2
onion                    1
red onion                1
...
[meat and seafood]
lamb chops               8 large
firm tofu                200 g
...
[packaged goods, pasta and sauces]
arborio rice             320 g
oats                     2 cup
green curry paste        3 tbsp
vegetable stock          100 ml
...
```

Every referenced recipe is opened and scaled, and the ingredients are added up across the three days. Then they are grouped by the aisles in `config/aisle.conf`, and whatever `config/pantry.conf` says is already at home is taken off. (The pantry file has [its own post](/blog/10-the-pantry-problem/).) Oats appear once with the total for both breakfasts.

Guests for the whole three days? Scale the plan:

```bash
cook shopping-list "Plans/Three Days.menu:2"
```

## Compile errors

The main reason to compile is that errors show up early. Say Wednesday's dinner points at a recipe I have not written yet:

```cooklang
Dinner: \
- @./Mains/Sheet Pan Chicken{}
```

The list refuses to build:

```
$ cook shopping-list "Plans/Three Days.menu"
Error: Recipe not found: Mains/Sheet Pan Chicken
```

`cook doctor validate` checks every plan and recipe in the folder in one go:

```
=== Recipe References ===

📄 Plans/Three Days.menu
  ❌ Missing reference: ./Mains/Sheet Pan Chicken
```

I would rather learn this on Sunday at my desk than on Wednesday at six.

There are warnings too, as with any compiler. On the plan above, CookCLI prints lines like this:

```
WARN Unit mismatch for 'milk': recipe needs 'ml', pantry has 'l'
```

And the list has a salt line that reads `pinch, pinch, 24.6 g, 1 tbsp, 1 1/8 tsp`, because the recipes measure salt in different ways. The list still builds. It tells you which recipes and pantry entries to tidy up when you have a spare ten minutes.

## Snacks are part of the program

A plan with only breakfast, lunch and dinner misses what people eat in between. Those things still have to be bought, and if they are not in the plan they are bought one at a time, in a hurry.

So snacks get their own section. It is not tied to a day. It exists so that six apples and a bar of chocolate end up on the same shopping list as everything else. Nearly all of my own plans have one.

## Batches and leftovers

Monday's risotto is `{4%servings}` in a plan for two people. That is a double batch on purpose: half is Tuesday's lunch. The plan buys for four servings once, and Tuesday's line costs nothing.

The braces take other forms as well. `{2}` means twice the recipe as written, and `{1/2}` means half of it.

This is the cheapest optimisation in the kitchen. Chopping for four takes barely longer than chopping for two, and the pot gets washed once.

## What the compiler does not do

Here I have to be honest about the metaphor. The earlier version of this post talked about a prep schedule, defrost reminders, leftovers that get flagged when they are too old, and budget and variety rules that fail the build. CookCLI does none of that today.

- **Timing.** A `.menu` file knows the day and the meal. It does not know that the chicken has to come out of the freezer the night before. Write that as a comment or as a line of plain text.
- **Leftover safety.** Nothing counts the days since the soup was made.
- **Budget.** `cook report` can price a single recipe from a datastore of ingredient costs, and the [Reports guide](/guides/reports/) shows how. Run over a `.menu` file, the template sees the recipe references but not the ingredients inside them, so a budget for the whole week needs more than a template.
- **Nutrition.** This one exists, but not in the CLI: the [Core Vitals](https://plugins.cook.md/cooklang/corevitals) plugin for [Cook Editor](/editor/) checks a whole menu against daily nutrient targets. It uses the cook.md nutrition service, so it needs a Cook Basic plan.

What is real is the part that mattered most to me: one file for the week, one command for the list, and broken references caught before I am standing in the kitchen.

## When a day fails

Some Tuesday you will be too tired and order pizza. The plan survives that. Wednesday's ingredients are still in the fridge, and Tuesday's dinner moves to Thursday or goes in the freezer. Each day stands mostly on its own, so one skipped day does not break the rest.

## How to start

Plan three days, not seven. My own plans are three days long, and there are more than forty of them by now. [A few are in my public cookbook](https://github.com/dubadub/cookbook/tree/main/Plans). Three days is short enough that the plan survives contact with real life, and fresh food bought for it is still fresh on the last day.

Use recipes you already cook. A simple plan you follow is worth more than an ambitious one you drop on the second day.

Keep the old files. A folder of past plans is the fastest way to write the next one: copy a plan, change two dinners, compile.

The [Meal Planning guide](/guides/meal-planning/) has the full format, and the plan can also be opened in `cook server` or in Cook Editor, which show it day by day.

The dinners are going to happen either way. You can decide them once, with the fridge full and your head clear, or seven times at the worst moment of the day. I prefer to compile.

-Alexey
