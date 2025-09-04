---
title: 'Meal Planning'
weight: 20
description: 'Transform weekly cooking from chaos to calm with structured meal planning'
---

Meal planning is the cornerstone of efficient home cooking. It transforms the daily question of "what's for dinner?" from a source of stress into an organized system that saves time, money, and mental energy. Cooklang provides the structure to make meal planning both systematic and flexible.

### Beyond Random Recipes

Instead of choosing meals day by day, meal planning views your week holistically. Monday's roast chicken becomes Tuesday's chicken salad and Wednesday's soup stock. This connected thinking reduces waste while maximizing flavor and efficiency.

The best meal plans balance variety with practicality. While it's tempting to plan seven completely different cuisines for seven days, there's wisdom in choosing recipes that share ingredients, cooking methods, or flavor profiles.

### Time as an Ingredient

Every meal exists in the context of available time. Weeknight dinners need to fit between work and bedtime, while weekend cooking can be more leisurely. By acknowledging time constraints upfront, meal planning becomes realistic rather than aspirational.

This temporal awareness extends to preparation. Sunday's meal prep can chop vegetables for Tuesday's stir-fry, marinate Thursday's chicken, and cook grains for the week. Time invested upfront pays dividends during busy weeknights.

## Weekly Rhythms

### Creating Sustainable Patterns

Successful meal planning often involves creating rhythms - Meatless Mondays, Taco Tuesdays, Pizza Fridays. These anchors provide structure while leaving room for creativity. They simplify decision-making while ensuring variety across the week.

These patterns can be seasonal too. Summer might bring Grill Wednesdays and Salad Saturdays, while winter features Soup Sundays and Slow-Cooker Thursdays. The framework adapts to both weather and lifestyle.

### Flexibility Within Structure

The best meal plans are guides, not dictates. If Tuesday's elaborate dinner becomes impossible due to a late meeting, having a backup plan prevents stress. Perhaps Tuesday's meal shifts to Saturday, replaced by something quicker from the freezer.

This flexibility requires intentional redundancy - keeping ingredients for a quick pasta, stir-fry, or omelet ensures you're never without options. The plan provides direction while life provides surprises.

## Multi-Day Planning

### The Three-Day Sweet Spot

While weekly planning is common, three-day cycles often work better for fresh ingredients and changing schedules. Planning Monday through Wednesday, then reassessing for the rest of the week, balances structure with adaptability.

This shorter cycle reduces food waste from overambitious weekly plans while still providing the benefits of advance planning. It's particularly useful for households with variable schedules or those new to meal planning.

### A Real-World Menu Example

Here's an actual three-day menu file that shows how meal planning works in practice:

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
