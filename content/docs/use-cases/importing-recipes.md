---
title: 'Importing Recipes'
weight: 5
description: 'Convert recipes from websites and other formats into Cooklang'
---

Building your recipe collection doesn't mean starting from scratch. Cooklang provides multiple ways to import recipes from websites, PDFs, and other formats, automatically converting them into structured `.cook` files that you can edit, organize, and use across all your devices.

### Why Import to Cooklang?

When you save recipes from websites, you often end up with bookmarks that can disappear, screenshots that are hard to search, or copied text that loses structure.

### Quick Web Import

The fastest way to import any recipe from the web is using the cook.md converter. Simply prepend `cook.md/` to any recipe URL:

```
https://cook.md/https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta
```

![Cook.md Demo](/guide/cookmd-demo.gif)

This instantly converts the recipe to Cooklang format, extracting:
- Ingredients with quantities
- Step-by-step instructions
- Cooking times and servings
- Original source attribution

You can then copy the converted recipe and save it to your collection.

### Plain text convertion

If you have recipe text handy, you can use [this form](https://cook.md/cookifies/new) to convert it into Cooklang format.

### Command Line Import

For batch importing or automation, the Cook CLI provides powerful import capabilities:

```bash
# Import a single recipe
cook import https://www.allrecipes.com/recipe/23600/worlds-best-lasagna/

# Save directly to a file
cook import https://www.bbcgoodfood.com/recipes/easy-pancakes > pancakes.cook

# Import without AI conversion (raw extraction)
cook import https://example.com/recipe --skip-conversion
```

The CLI importer works with hundreds of recipe websites including AllRecipes, BBC Good Food, Serious Eats, Food Network, and any site using Recipe Schema.org markup. Requires OpenAI API key configured:

```bash
# Set your API key
export OPENAI_API_KEY="your-key-here"

# Import with automatic Cooklang conversion
cook import https://www.seriouseats.com/perfect-chocolate-chip-cookies
```

### Building Your Collection

Start with your most-used recipes and gradually expand:

1. **Week 1**: Import your 5-10 go-to recipes
2. **Week 2**: Add recipes you want to try soon
3. **Month 1**: Import seasonal favorites
4. **Ongoing**: Add new discoveries as you find them

Remember, the goal isn't to import everything at once, but to build a curated collection of recipes you'll actually use. Each imported recipe becomes part of your permanent, searchable, and shareable cookbook that works everywhere.
