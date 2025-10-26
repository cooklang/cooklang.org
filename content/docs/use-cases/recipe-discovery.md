---
title: 'Recipe Discovery'
weight: 15
description: 'Finding tried and true recipes from the Cooklang community'
---

Finding reliable recipes shouldn't mean scrolling through lengthy blog posts filled with ads and questionable modifications. The Cooklang Federation provides a centralized search system for discovering recipes that community members actually use and trust.

## What is the Cooklang Federation?

The [Cooklang Federation](https://recipes.cooklang.org) is a decentralized recipe discovery platform that indexes Cooklang recipes from across the community. Recipe creators maintain their recipes on their own websites, blogs, or GitHub repositories, while the federation makes them all searchable in one place.

Think of it as a search engine specifically for Cooklang recipes, where every result points to actual recipes people cook with, not SEO-optimized content designed to sell ads.

## Searching for Recipes

### Basic Search

The federation supports powerful search capabilities.

You can search by keyword to find recipes containing specific terms:
```
chicken pasta
chocolate cake
vegetarian curry
```

> Metadata is set by recipe authors and coverage is currently sparse. Not all recipes include tags, difficulty ratings, or time estimates. Keyword search across recipe titles and ingredients is often more reliable for finding what you need.

To filter by dietary preferences or meal types, search by tag:
```
tags:vegan
tags:breakfast
tags:italian
```

Find recipes matching your skill level by searching by difficulty:
```
difficulty:easy
difficulty:medium
```

For quick meals or weekend projects, search by time:
```
total_time:[0 TO 30]  # Recipes under 30 minutes
total_time:[60 TO 120]  # Longer weekend cooking
```

### Advanced Search

Combine multiple criteria for precise results:

```
pasta AND tags:italian difficulty:easy
vegan tags:dessert -chocolate  # Vegan desserts without chocolate
chicken total_time:[0 TO 45]  # Quick chicken recipes
```

The search supports Boolean operators (AND, OR, NOT), range queries, and field-specific searches, making it easy to find exactly what you're looking for.

## Exploring Recipe Feeds

Beyond search, you can browse curated feeds to discover new recipes. You can explore all recipes tagged with breakfast, desserts, or any category. You can also find recipe creators whose style you enjoy, and see what recipes the community is publishing.

## From Discovery to Cooking

Once you find a recipe you like:

1. **Download the recipe**: Get the `.cook` file directly
2. **Add to your collection**: Save it to your local recipe directory
3. **Scale and customize**: Adjust serving sizes or modify ingredients
4. **Generate shopping lists**: Use CookCLI to create shopping lists from your chosen recipes

The federation provides recipes in standard Cooklang format, so they work seamlessly with all Cooklang tools and apps.

## Why Federation Works

Traditional recipe websites need to monetize through ads and affiliate links, leading to SEO-optimized content that prioritizes search rankings over recipe quality. The federation takes a different approach. Recipe creators host their own content, maintaining full ownership and decentralized control. Search results aren't influenced by advertising revenue, ensuring an ad-free experience. The system is community-driven, with recipes coming from people who actually cook with Cooklang. It's built on open standards like RSS/Atom feeds and GitHub repositories, not proprietary platforms.

## Finding Quality Recipes

Not all recipes are created equal. When browsing federation results, look for active repositories with recipes that are maintained and updated. Check for detailed metadata including proper tags, times, and difficulty ratings. Prefer recipes with complete instructions, well-documented steps, and thorough ingredient lists. Recipes from known community members are often a good sign of quality.

## See Also

- [Publishing Your Recipes](../publishing-recipes/) - Share your recipes with the community
- [CookCLI Recipe Command](/cli/commands/recipe/) - Working with recipe files
- [Meal Planning](../meal-planning/) - Plan meals using discovered recipes
