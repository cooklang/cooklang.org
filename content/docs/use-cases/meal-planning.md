---
title: 'Meal Planning'
weight: 20
description: 'Plan weekly meals with .menu files and generate combined shopping lists'
---

CookCLI supports `.menu` files that let you plan meals across multiple days, reference recipes from your collection, and generate a combined shopping list for the entire plan.

> `.menu` file support is only available in CookCLI at the moment.

### Example Menu File

Here's a real three-day plan from an actual Cooklang cookbook:

```cooklang
---
servings: 2
---

==Day 0==

-- delivery around 4pm

Dinner:
- @hake fillet{2}(baked) with @./Sides/Mashed Potatoes{2%servings}
- @./Salads/Boring{2%servings}

-- do prep for burrito

==Day 1==

Breakfast:
- @./Breakfast/Mexican Style Burrito{2%servings}
- @filter coffee{1%cup} and @tea{1%cup}

Lunch:
- @./Lunches/Spaghetti Bolognese{}
- @./Salads/Boring{2%servings}

Dinner:
- @./Salads/Caprese{2}

==Day 2==

Breakfast:
- @./Breakfast/Mexican Style Burrito{2%servings}
- @filter coffee{1%cup} and @tea{1%cup}

Lunch:
- @./Slowcooker/Slow-cooker beef stew{1/2} with @rice{1%cup}(boiled)

Dinner:
- @./Salads/Prawn Evening Salad{2} + @sourdough bread{1%slice}

== Snacks ==
- @kefir{2}
- @dates
- @apples
- @yogurt biscuits{3}

== Batch Prep ==
- @./Freezable/Kotletter{}
```

[source](https://github.com/dubadub/cookbook/blob/main/Plans/3%20Day%20Plan%20I.menu)

### How Menu Files Work

**Recipe references** like `@./Breakfast/Mexican Style Burrito{2%servings}` point to `.cook` files in your recipe directory. When generating a shopping list, the system pulls all ingredients from the referenced recipes.

**Direct ingredients** like `@filter coffee{1%cup}` work for simple items that don't need a full recipe.

**Scaling** is built in. `{2%servings}` adjusts recipe quantities for the number of people. `{1/2}` means half of a batch recipe.

**Day sections** (`==Day 1==`) organize meals chronologically.

**Comments** (`-- do prep for burrito`) add reminders about timing and logistics.

**Snacks and batch prep** sections ensure these items appear on the shopping list too.

### Reusing Ingredients Across Days

Notice how this plan reuses elements efficiently:
- Mexican Style Burritos appear on two mornings — worth prepping in bulk
- The Boring Salad accompanies different mains, using up fresh greens
- Beef stew is made in advance and portioned across meals
- Coffee and tea quantities reflect daily consumption

This reduces both prep time and waste.

## See Also

- [Shopping Lists](../shopping/) — Generate lists from your meal plan
- [Pantry Management](../pantry/) — Exclude items you already have
- [CookCLI Commands](/cli/commands/) — Full command reference
