---
title: 'Recipe Discovery'
weight: 15
description: 'Search for recipes across the Cooklang community via the federation'
---

The [Cooklang Federation](https://recipes.cooklang.org) indexes Cooklang recipes from community members' repositories and websites, making them searchable in one place. Every result points to a real recipe someone actually cooks — no ads, no SEO filler.

Recipe creators host their own content. The federation just makes it discoverable.

## Searching for Recipes

### Basic Search

Search by keyword across recipe titles and ingredients:

```
chicken pasta
chocolate cake
vegetarian curry
```

### Filtering

Filter by tag:
```
tags:vegan
tags:breakfast
tags:italian
```

By difficulty:
```
difficulty:easy
difficulty:medium
```

By cooking time (in minutes):
```
total_time:[0 TO 30]     # Under 30 minutes
total_time:[60 TO 120]   # Weekend projects
```

### Combining Criteria

```
pasta AND tags:italian difficulty:easy
vegan tags:dessert -chocolate              # Vegan desserts without chocolate
chicken total_time:[0 TO 45]               # Quick chicken recipes
```

The search supports Boolean operators (AND, OR, NOT), range queries, and field-specific searches.

> Metadata coverage is currently sparse — not all recipes include tags, difficulty, or time estimates. Keyword search across titles and ingredients is often the most reliable approach.

## From Discovery to Cooking

Once you find a recipe:

1. Download the `.cook` file
2. Save it to your local recipe directory
3. Scale and customize as needed
4. Generate shopping lists with CookCLI

All federation recipes use standard Cooklang format, so they work with every Cooklang tool and app.

## See Also

- [Publishing Your Recipes](../publishing-recipes/) — add your recipes to the federation
- [CookCLI Recipe Command](/cli/commands/recipe/) — working with recipe files
- [Meal Planning](../meal-planning/) — plan meals with discovered recipes
