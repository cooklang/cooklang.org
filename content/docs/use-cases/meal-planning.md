---
title: 'Meal Planning'
weight: 20
description: 'Transform weekly cooking from chaos to calm with structured meal planning'
---

Meal planning is the cornerstone of efficient home cooking. It transforms the daily question of "what's for dinner?" from a source of stress into an organized system that saves time, money, and mental energy. Cooklang provides the structure to make meal planning both systematic and flexible.

> `*.menu` files support is only in CookCLI at the moment

### A Real-World Menu Example

Here's an actual three-day Cooklang `*.menu` file that shows how meal planning works in practice:

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

This menu demonstrates several powerful concepts:

**Recipe References**: Items like `@./Breakfast/Mexican Style Burrito{2%servings}` reference complete recipes stored elsewhere. The system pulls in all ingredients from these recipes when generating shopping lists.

**Direct Ingredients**: Simple items like `@filter coffee{1%cup}` are listed directly when they don't need a full recipe.

**Scaling Built-In**: The `{2%servings}` notation adjusts recipes for the number of people. The beef stew uses `{1/2}` to indicate using half of a previously prepared batch.

**Organization by Day**: The `==Day 1==` sections create clear temporal structure, making it easy to see what's planned when.

**Comments as Reminders**: Notes like `-- do prep for burrito` and `-- delivery around 4pm` integrate preparation timing and external events into the plan.

**Snacks and Extras**: The separate snacks section ensures these items aren't forgotten when shopping, while batch prep reminds you of cooking for future meals.

### Connecting Meals Across Days

Notice how the menu reuses elements efficiently:
- Mexican Style Burritos appear on multiple mornings, justifying bulk prep
- The Boring Salad accompanies different meals, using up fresh greens
- Slow-cooker beef stew is made in advance and portioned across two meals
- Coffee and tea quantities account for daily consumption patterns

This interconnected planning reduces both prep time and waste while ensuring variety.


## See Also

- [Shopping Lists](../shopping/) - Execute your meal plan efficiently
- [Pantry Management](../pantry/) - Foundation for meal planning
- [CookCLI Commands](/cli/commands/) - Technical tools for meal planning
