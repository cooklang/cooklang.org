---
title: "Cooklang for Food Bloggers: Write Once, Publish Everywhere"
date: 2026-02-28
weight: 60
summary: "One .cook file can generate your blog post, Google-ready Schema.org markup, a printable PDF, and a shopping list — without reformatting anything by hand."
---

You've perfected your sourdough recipe. Now you need to format it for your blog (SEO-optimized), your newsletter (clean text), your cookbook PDF (print-ready), and Google (JSON-LD structured data). That's the same recipe, reformatted four different ways — and every time you tweak a hydration percentage or a rise time, you update it in four different places.

This is the food blogger's formatting problem, and it costs real time. Cooklang solves it by separating the recipe from its presentation. You write it once. From that single file, you generate every format you need.

## The Formatting Nightmare

Most food bloggers start with a WordPress recipe plugin. You paste your recipe into a plugin like WP Recipe Maker or Tasty Recipes, fill out dozens of fields, and the plugin generates the SEO markup. It works — until the plugin changes its pricing, until you want to move to a different platform, or until you need your recipes in a format the plugin doesn't support.

The deeper problem is that your recipe lives inside a proprietary database. You can't easily export it to a printable PDF. You can't pull it into a newsletter tool. You can't generate a standalone shopping list. Every new use case requires another manual step.

And when you update the recipe — because you finally figured out that 10-minute autolyse makes a real difference — you update the WordPress entry, the PDF you sent to your Patreon supporters, the markdown draft in your newsletter tool, and the pinned Instagram post caption. Or you don't, and they drift out of sync.

## Write Once in Cooklang

A Cooklang `.cook` file is plain text with a small set of markup rules: `@ingredient{quantity%unit}` for ingredients, `#cookware{}` for equipment, `~{time}` for timers.

Here's a basic sourdough recipe:

```cooklang
---
title: Country Sourdough
servings: 1 loaf
total time: 24 hours
source: My kitchen notes
---

In a large bowl, combine @bread flour{450%g} and @whole wheat flour{50%g}. Add @water{375%g} at 80°F and mix until no dry flour remains. Rest for ~{30%minutes}.

Add @active starter{100%g} and @sea salt{10%g}. Mix until fully incorporated, then perform a series of stretch-and-folds every ~{30%minutes} for the first ~{2%hours} of bulk fermentation.

After bulk fermentation (roughly ~{4%hours} total), shape the dough and place in a floured #banneton{}. Cover and refrigerate overnight.

The next day, preheat your #dutch oven{} to 500°F for ~{1%hour}. Score the dough, bake covered for ~{20%minutes}, then remove the lid and bake for another ~{25%minutes} until deeply browned.
```

That's the whole recipe. Every ingredient, quantity, unit, and time is machine-readable. Every piece of cookware is tagged. The metadata at the top carries the fields that matter for SEO.

You edit this one file. Everything else is generated.

## Publish to Your Blog

[CookCLI](/cli/) reads your `.cook` file and outputs formats you can use directly. For blog content, the markdown format gives you clean, structured text:

```bash
cook recipe "country-sourdough.cook" --format markdown
```

The output includes a formatted ingredient list and numbered method steps — exactly the structure your blog post needs. Paste it into your CMS, add your photos, done.

For Google, you need JSON-LD Schema.org markup. The `schema` format generates it:

```bash
cook recipe "country-sourdough.cook" --format schema
```

This outputs valid structured data that Google can read. Paste it into a `<script type="application/ld+json">` tag in your page and Google's crawlers can index every ingredient, the cook time, and the yield.

## Google Rich Results and Why They Matter

When you search for a recipe on Google, you sometimes see a result with a photo, star rating, cook time, and ingredient count displayed directly in the search results before you click anything. That's a rich snippet, and it's powered by Schema.org Recipe structured data embedded in the page.

Rich snippets increase click-through rates meaningfully. Recipe sites that add structured data consistently report higher organic traffic because their results stand out visually from plain text links.

Here's what the Schema.org output from CookCLI looks like:

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "Country Sourdough",
  "recipeYield": "1 loaf",
  "totalTime": "PT24H",
  "recipeIngredient": [
    "450g bread flour",
    "50g whole wheat flour",
    "375g water",
    "100g active starter",
    "10g sea salt"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "text": "In a large bowl, combine bread flour and whole wheat flour. Add water at 80°F and mix until no dry flour remains. Rest for 30 minutes."
    },
    {
      "@type": "HowToStep",
      "text": "Add active starter and sea salt. Mix until fully incorporated, then perform a series of stretch-and-folds every 30 minutes for the first 2 hours of bulk fermentation."
    }
  ]
}
```

This is exactly what Google expects. You didn't write it by hand — CookCLI derived it from the same `.cook` file you use for everything else. The ingredient list is already formatted as strings, the times are in ISO 8601 duration format (`PT24H` means 24 hours), and the instructions map to the `HowToStep` type Google wants to see.

Add this to your recipe pages inside a `<script type="application/ld+json">` block and you're eligible for rich results. You can verify it works with [Google's Rich Results Test](https://search.google.com/test/rich-results).

## Print-Ready Output

PDF cookbooks and printable recipe cards are a real product for food bloggers. Selling a PDF cookbook on your own site keeps 100% of the revenue. Offering printable recipe cards as a newsletter perk builds your list.

CookCLI generates output for typesetting systems that produce professional-quality PDFs:

```bash
cook recipe "country-sourdough.cook" --format typst
cook recipe "country-sourdough.cook" --format latex
```

The Typst output is easier to work with if you're not familiar with LaTeX. Both produce print-quality documents from the same source recipe. Change the recipe, regenerate the file, and the PDF reflects the update.

This means your print product stays in sync with your website automatically — you're not maintaining two separate versions of each recipe.

## Shopping Lists for Your Readers

A practical thing readers want that most blogs don't offer: a shopping list they can take to the store. CookCLI's shopping list generation aggregates ingredients across multiple recipes, which is useful for meal plan posts.

```bash
cook shopping-list "country-sourdough.cook"
```

For a meal planning blog post that features five weeknight dinners, you can generate a combined shopping list from all five recipes at once:

```bash
cook shopping-list monday-pasta.cook tuesday-soup.cook wednesday-salmon.cook thursday-stir-fry.cook friday-pizza.cook
```

The output consolidates duplicate ingredients — if three recipes use garlic, it adds them up. You can offer this as a downloadable file, render it in your post, or send it in your newsletter. The reader gets something genuinely useful that takes you seconds to generate.

## Keeping Everything in Sync

This is the part that matters most over time. Recipes change. You improve a technique, adjust a ratio, catch a mistake. With Cooklang, the update path is:

1. Edit the `.cook` file
2. Regenerate the formats you need

That's it. The blog markdown, the Schema.org markup, the PDF, the shopping list — all come from the same source. You can't accidentally have a version mismatch between your printed cookbook and your website if they're both generated from the same file.

Compare this to the manual workflow: edit the WordPress plugin entry, update the PDF in InDesign, fix the newsletter draft, update the pinned post. Each step introduces a chance for the versions to diverge. With a single source of truth, that problem disappears.

## A Practical Starting Workflow

If you have existing recipes in WordPress or another CMS, you don't have to migrate everything at once. Start with your next new recipe. Write it as a `.cook` file first, then generate the formats you need.

Install CookCLI, then convert one recipe:

```bash
# Install (macOS)
brew install cooklang/tap/cook

# Parse your recipe and see what's there
cook recipe "country-sourdough.cook" --format human

# Generate Schema.org markup for Google
cook recipe "country-sourdough.cook" --format schema

# Generate markdown for your blog post
cook recipe "country-sourdough.cook" --format markdown
```

The `--format human` output is a readable summary that confirms your recipe parsed correctly before you generate anything else. It's a good sanity check.

For your existing recipes, conversion is straightforward. The Cooklang markup is minimal — you're mostly adding `@` before ingredient names and `{}` around quantities. A recipe you already have in a text editor takes ten minutes to convert.

## What This Changes

The practical shift is this: your recipe becomes a document, not a database entry. You own it in a format you can read, version-control, and open in any text editor. The formatted outputs — SEO markup, print documents, shopping lists — are derived artifacts you regenerate as needed.

This is exactly how software development handles the problem of one piece of content needing multiple representations. The source is the truth. Everything else is generated from it.

For food bloggers, the payoff is time saved on maintenance and formatting, and formats you couldn't easily produce before (print-quality PDFs, consolidated shopping lists) without a separate tool.

---

Start with the [CookCLI documentation](/cli/) to get the tool installed. The [Cooklang spec](/docs/spec/) explains the full recipe format. If you want to see how other bloggers are publishing their recipe collections, the [publishing guide](/blog/25-publishing-recipe-collection-as-website/) covers static site options in detail.

If you write food and you're tired of reformatting the same recipe for every platform, give it one recipe's worth of time. The workflow change is worth it.

-Alex
