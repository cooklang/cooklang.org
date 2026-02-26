---
title: 'Automated Grocery List: Save Time and Money with Meal Planning'
date: 2021-05-20T19:27:37+10:00
weight: 90
summary: Build an automated grocery list from your meal plan using Cooklang. Practical tips for shopping list automation, reducing food waste, and cutting your grocery bill.
---

The single biggest change I made to reduce my grocery spending was switching from "buy what looks good" to "buy what I need." That sounds obvious, but doing it consistently requires a system, not willpower.

Here's the system: plan meals for the week, generate a shopping list from the recipes, check what you already have, buy the rest. Cooklang automates the tedious parts.

## From Recipes to Shopping List

Write your recipes in [Cooklang format](/docs/spec/) — plain text with tagged ingredients:

```cooklang
Heat @olive oil{2%tbsp} in a #pan{}.
Add @onion{1}, diced, and @garlic{3%cloves}, minced.
Cook for ~{5%minutes} until soft.
Add @canned tomatoes{400%g} and @dried oregano{1%tsp}.
Simmer for ~{20%minutes}.
Season with @salt{} and @pepper{} to taste.
```

Organize recipes into directories for your meal plan:

```
this-week/
├── monday-pasta.cook
├── tuesday-stir-fry.cook
├── wednesday-soup.cook
├── thursday-chicken.cook
└── friday-tacos.cook
```

Generate the combined shopping list:

```bash
cook shopping-list ./this-week/*.cook
```

CookCLI extracts every ingredient, combines duplicates, and groups them by store aisle. Five recipes become one list in under a second.

## Why This Saves Money

**You buy exactly what you need.** No "that looks good, I'll figure out what to do with it." Every item on the list exists because a recipe calls for it. Over a month, this cuts 15–20% of impulse purchases.

**You stop buying duplicates.** Before I tracked my pantry, I owned three jars of cumin. With Cooklang's [pantry tracking](/blog/the-pantry-problem/), the shopping list excludes what you already have.

**You use everything you buy.** When every ingredient has a destination recipe, nothing rots in the back of the fridge. Plan leftovers deliberately — Monday's roast chicken becomes Tuesday's chicken salad.

**You shop less often.** One planned trip per week replaces three or four "quick stops" that always cost more than expected. Convenience stores charge a premium. A weekly plan at a regular grocery store avoids it.

## Making a Meal Plan That Works

A few things I've learned from doing this for years:

**Plan snacks, not just meals.** If you only plan breakfast, lunch, and dinner, you'll end up at a vending machine at 3 PM. Add a snack section to your plan — apples, nuts, yogurt — and those items appear on the shopping list too.

**Use leftovers as ingredients.** Make a double batch of soup on Monday, eat it for lunch on Tuesday. Make extra rice with dinner, use it for fried rice the next day. This isn't lazy cooking — it's batch processing. You do the prep work once and amortize it across multiple meals.

**Keep it realistic.** Don't plan seven elaborate dinners. Plan two or three recipes you're excited about, fill the rest with simple meals you can make on autopilot, and leave one night open for leftovers or eating out. A plan you actually follow beats a perfect plan you abandon by Wednesday.

**Use exact quantities.** Vague recipes ("some oil," "a few cloves of garlic") make shopping lists useless. When recipes specify `@olive oil{2%tbsp}` and `@garlic{3%cloves}`, the system can combine quantities across recipes and tell you exactly how much to buy.

## Organize by Aisle

Add an `aisle.conf` file to your recipe directory and shopping lists get sorted by store section:

```
[Produce]
onion|onions
garlic
tomato|tomatoes

[Dairy]
milk
butter
cheese

[Pantry]
olive oil
rice
pasta
```

This turns shopping from "walk every aisle looking for things" into "walk through in order, check items off." A planned shopping trip takes 20–30 minutes instead of an hour.

## The Payoff

After doing this consistently, I spend about 30% less on groceries and throw away almost nothing. The time investment is 15 minutes on Sunday — plan the meals, run `cook shopping-list`, check the pantry, go shopping.

The tools are free and open source. Start with [CookCLI](/cli/) and one week of recipes. The savings compound from there.

[Get started with Cooklang →](/docs/getting-started/)

-Alexey
