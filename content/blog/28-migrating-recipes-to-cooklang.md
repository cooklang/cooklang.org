---
title: "Migrating Your Recipes to Cooklang (From Any App or Format)"
date: 2026-02-28
weight: 60
summary: "Stuck in a recipe app you can't escape? Here's how to migrate your recipes to plain .cook files from websites, Paprika, Mealie, photos, and Markdown — without doing it all at once."
---

Every recipe app promises to be the last one you'll ever need. Then the company gets acquired, the subscription doubles, or the export feature disappears behind a paywall. You spent years collecting recipes, and now they're locked inside a format only one piece of software can read.

This is the recipe lock-in problem, and it happens constantly. MacGourmet was abandoned. Evernote Food was killed. ChefTap shut down in 2023. Each time, users scrambled to export what they could before the deadline hit.

The good news: getting out is not as hard as you think, and you do not have to do it all at once.

## Why Migrate to Plain Text

Plain `.cook` files are just text. Any editor can open them. Any sync service can store them. No company can take them away from you.

If you want the full case for plain text recipes, [Why Plain Text Recipes Beat Databases Every Time](/blog/12-why-plain-text-recipes/) covers it in depth. The short version: text files from the 1980s still open fine. Most recipe apps from the same era are gone.

Once your recipes are in Cooklang format, you can generate shopping lists from the terminal, serve your whole collection on your local network, scale any recipe to any number of servings, and edit recipes in any text editor. The format is documented, open, and not owned by anyone.

## Migration Path 1: From Recipe Websites

This is the easiest case. If the recipe lives on a website with proper Schema.org markup — which covers most major food blogs and recipe sites — you have two options.

**The cook.md prefix method** requires no installation at all. Take any recipe URL and prefix it with `https://cook.md/`:

```
https://cook.md/https://www.seriouseats.com/the-best-bolognese-sauce
```

Open that in a browser and you get the recipe rendered as a Cooklang file, ready to copy and save as a `.cook` file. It is the fastest way to grab a single recipe.

**The `cook import` command** does the same thing from your terminal and saves the file directly:

```bash
cook import "https://www.seriouseats.com/the-best-bolognese-sauce"
```

This downloads the recipe, uses an AI model to convert it to Cooklang format, and saves the result as a `.cook` file in your current directory. It requires an `OPENAI_API_KEY` environment variable set in your shell.

If you want the raw recipe data without the AI conversion step — useful for scripting or inspection — add the `--skip-conversion` flag:

```bash
cook import --skip-conversion "https://www.seriouseats.com/the-best-bolognese-sauce"
```

For a collection of bookmarks, this turns into a simple loop:

```bash
while IFS= read -r url; do
  cook import "$url"
done < urls.txt
```

Drop your recipe URLs into `urls.txt`, one per line, and run it. Most of your web-saved recipes migrate in a single sitting.

## Migration Path 2: From Paprika, Mealie, or KitchenOwl

These apps all have export features, but they export in different formats that need a conversion step.

### Paprika

Paprika exports as `.paprikarecipes` files, which are ZIP archives of HTML files — one per recipe. To get your recipes out, go to Settings in Paprika, choose Export All Recipes, and save the `.paprikarecipes` file somewhere.

From there, a short Python script can extract and convert each recipe. The HTML files contain standard recipe fields that map directly to Cooklang metadata:

```python
import zipfile, json, os, re

with zipfile.ZipFile("recipes.paprikarecipes") as z:
    for name in z.namelist():
        if name.endswith(".html"):
            recipe = z.read(name).decode("utf-8")
            # parse title, ingredients, directions from HTML
            # write to .cook file
```

The actual parsing depends on your comfort with HTML and Python. Paprika's HTML structure is consistent enough that a basic script handles most recipes. For each recipe, you end up with a `.cook` file you can keep or clean up manually.

### Mealie

Mealie's export format is JSON, which is easier to work with. In your Mealie instance, go to your profile, choose Data Management, and export your recipes. You get a ZIP of JSON files.

The JSON structure is clean — `name`, `recipeIngredient`, `recipeInstructions` are standard fields. A conversion script looks something like this:

```python
import json, pathlib

data = json.load(open("recipe.json"))
title = data["name"]
ingredients = data["recipeIngredient"]
steps = data["recipeInstructions"]

cook = f">> title: {title}\n\n"
# write ingredients and steps as Cooklang
```

The ingredient lines from Mealie are already human-readable strings like "2 cups flour, sifted". You can write them directly into your `.cook` file as-is, then add the `@` and `{}` markup when you cook from the recipe and want the structured version.

### KitchenOwl

KitchenOwl supports JSON export from its settings. The structure is similar to Mealie — clean JSON with ingredients and steps as separate lists. The same approach applies: export, run a conversion script, clean up the output.

For all three apps, the goal of the script is not a perfect conversion. It is to get the recipe text into a file so you can cook from it. The Cooklang markup — `@ingredient{quantity%unit}`, `#cookware`, `~{time%unit}` — can be added gradually as you use each recipe.

## Migration Path 3: From Photos and Handwritten Cards

This is the path that surprises people. [cook.md](https://cook.md/) supports image upload with OCR.

Take a photo of a recipe card, a magazine clipping, or a handwritten recipe. Go to [cook.md/cookifies/new](https://cook.md/cookifies/new), upload the image, and the tool reads the text and converts it to Cooklang format. It handles handwriting reasonably well, and printed recipes very well.

For a box of index cards, this takes a weekend but the result is a digital collection you actually own. Photograph each card, upload, review the output, save the file. A hundred cards becomes a hundred `.cook` files.

The manual converter at cook.md also accepts pasted plain text, which is useful for recipes copied from PDFs, emails, or anywhere else you can get text out.

## Migration Path 4: From Plain Text or Markdown

If you already have recipes in Markdown or plain text files, you are closer than you think. The Cooklang additions are minimal: `@` before ingredients, `{}` around quantities, `#` before cookware, `~{}` for timers.

Here is the same pasta recipe in Markdown versus Cooklang:

**Markdown:**

```markdown
# Garlic Pasta

## Ingredients

- 400g spaghetti
- 4 cloves garlic, minced
- 3 tbsp olive oil
- 1/4 tsp red pepper flakes
- Salt to taste

## Instructions

1. Cook spaghetti in salted water according to package directions. Reserve 1/2 cup pasta water before draining.
2. While pasta cooks, heat olive oil in a large pan over medium heat. Add garlic and pepper flakes, cook until fragrant, about 2 minutes.
3. Add drained pasta to the pan with a splash of pasta water. Toss to coat and serve.
```

**Cooklang:**

```cooklang
>> title: Garlic Pasta
>> servings: 4

Cook @spaghetti{400%g} in salted water according to package directions. Reserve @pasta water{120%ml} before draining.

While pasta cooks, heat @olive oil{3%tbsp} in a #large pan{} over medium heat. Add @garlic{4%cloves}, minced, and @red pepper flakes{1/4%tsp}. Cook until fragrant, about ~{2%minutes}.

Add drained pasta to the pan with a splash of pasta water. Toss to coat and serve.
```

The structure changes from a list of ingredients plus numbered steps to a single flowing text where ingredients appear in context. That is the core of what Cooklang does: keeps ingredients and instructions together so you never have to look two places at once while cooking.

For converting your Markdown collection, you can do it manually, recipe by recipe, or write a script to handle the mechanical parts. Neither approach is wrong. The manual way gives you better results because you end up reading each recipe and improving it as you go.

## Adding Metadata Gradually

You do not need full metadata on every recipe from day one. Start with the minimum that makes the recipe useful:

```cooklang
>> title: Garlic Pasta
>> servings: 4

Cook @spaghetti{400%g}...
```

That is enough to work with. Add more fields as you use the recipe and find yourself wanting them:

```cooklang
>> title: Garlic Pasta
>> servings: 4
>> time: 20 minutes
>> source: https://example.com/garlic-pasta
>> tags: quick, pasta, weeknight
```

The metadata lives in YAML frontmatter at the top of the file. Nothing breaks if fields are missing. Add what is useful for you, skip what is not.

## Batch Migration Tips

A few things that make a large migration easier:

**Name files consistently.** Use lowercase, hyphens between words, no spaces: `garlic-pasta.cook`, `chicken-tikka-masala.cook`. File names become searchable, and consistent naming makes shell commands predictable.

**Use subdirectories.** Flat folders get unwieldy fast. A basic structure like `pasta/`, `chicken/`, `soups/`, `desserts/` keeps things navigable. You can reorganize later without breaking anything — the files are just files.

**Keep the source URL.** Any recipe you imported from a website, add a `>> source:` line with the URL. When you want to check the original for a step you edited, it is right there.

**Do not clean up everything at once.** A recipe file with no Cooklang markup still works for reading. You can cook from it. Add the `@` and `{}` notation to a recipe the next time you actually make it — not all at once during migration.

## The 80/20 Rule for Recipe Migration

Do not try to migrate your entire collection before you start cooking from Cooklang files. It is a trap.

Most people cook 20 recipes regularly. The other 80% of their collection is aspirational — recipes they saved and never made. Migrating all of them before getting started means weeks of work before you see any benefit.

Instead, start with the 20 recipes you actually cook. Get those into `.cook` files. Use [CookCLI](/cli/) to generate shopping lists and serve them from your local network. Once that is working and useful, you will have a feel for what metadata and structure you want. Then you can migrate the rest in the format that actually suits how you cook.

The rest of the collection can live on a shelf until you need it. A recipe you never cook does not need to be perfect. A recipe you cook every week is worth spending ten minutes to do right.

## Start with One Recipe

Migration does not have to be a project. It can be a habit.

The next time you save a recipe from a website, use `cook import` instead of a browser bookmark. The next time you pull out an index card, photograph it and run it through [cook.md](https://cook.md/). The next time you open a recipe in your current app, export it and convert it.

One recipe at a time, your collection moves to a format you control. There is no deadline, no migration weekend, no all-or-nothing decision.

Get started with [CookCLI](/cli/) or explore the [Cooklang specification](/docs/spec/) to see the full syntax. Once your first recipe is a `.cook` file, the rest follows naturally.

-Alex
