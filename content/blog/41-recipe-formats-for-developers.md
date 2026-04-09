---
title: "Recipe File Formats Compared: A Developer's Guide to Cooklang, JSON-LD, RecipeML, and MealMaster"
date: 2026-03-24
weight: 50
summary: "A code-level comparison of the four recipe file formats you'll encounter when building recipe software: Cooklang, JSON-LD/Schema.org, RecipeML, and MealMaster. The same recipe in each format, with parser availability, data structures, and honest trade-offs."
---

If you're building a recipe app, a meal planner, a grocery integration, or anything that ingests or stores recipe data, you need to pick a format — or at least understand the formats you'll encounter. There are four that actually matter: Cooklang, JSON-LD with Schema.org vocabulary, RecipeML, and MealMaster. Each one comes from a different era and makes different trade-offs between human readability, machine parseability, and available tooling.

This post shows the same recipe — a simple tomato pasta — in all four formats, then compares them at the code level. No abstractions. Just what the bytes look like and what that means for your parser.

## The Same Recipe in Four Formats

### Cooklang

```cooklang
---
title: Simple Tomato Pasta
servings: 2
time: 25 min
---

Heat @olive oil{2%tbsp} in a #large pan{} over medium heat.

Add @garlic{3%cloves}(minced) and cook for ~{1%minute}.

Add @canned tomatoes{400%g} and @salt{1%tsp}. Simmer for ~{15%minutes}.

Cook @spaghetti{200%g} in salted boiling water. Drain and toss with the sauce.
```

### JSON-LD / Schema.org

```json
{
  "@context": "https://schema.org/",
  "@type": "Recipe",
  "name": "Simple Tomato Pasta",
  "recipeYield": "2 servings",
  "totalTime": "PT25M",
  "recipeIngredient": [
    "2 tbsp olive oil",
    "3 cloves garlic, minced",
    "400g canned tomatoes",
    "1 tsp salt",
    "200g spaghetti"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "text": "Heat olive oil in a large pan over medium heat."
    },
    {
      "@type": "HowToStep",
      "text": "Add garlic and cook for 1 minute."
    },
    {
      "@type": "HowToStep",
      "text": "Add canned tomatoes and salt. Simmer for 15 minutes."
    },
    {
      "@type": "HowToStep",
      "text": "Cook spaghetti in salted boiling water. Drain and toss with the sauce."
    }
  ]
}
```

### MealMaster

```
MMMMM----- Meal-Master X - Formatted by HHH2MMF v1.00

      Title: Simple Tomato Pasta
 Categories: pasta, italian
      Yield: 2 servings

      2 tb Olive oil
      3    Garlic cloves; minced
    400 g  Canned tomatoes
      1 ts Salt
    200 g  Spaghetti

  Heat olive oil in a large pan over medium heat. Add garlic
  and cook for 1 minute. Add canned tomatoes and salt. Simmer
  for 15 minutes. Cook spaghetti in salted boiling water.
  Drain and toss with the sauce.

MMMMM
```

### RecipeML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<recipeml version="0.5">
  <recipe>
    <head>
      <title>Simple Tomato Pasta</title>
      <yield><qty>2</qty><unit>servings</unit></yield>
    </head>
    <ingredients>
      <ing>
        <amt><qty>2</qty><unit>tbsp</unit></amt>
        <item>olive oil</item>
      </ing>
      <ing>
        <amt><qty>3</qty><unit>cloves</unit></amt>
        <item>garlic</item>
        <prep>minced</prep>
      </ing>
      <ing>
        <amt><qty>400</qty><unit>g</unit></amt>
        <item>canned tomatoes</item>
      </ing>
      <ing>
        <amt><qty>1</qty><unit>tsp</unit></amt>
        <item>salt</item>
      </ing>
      <ing>
        <amt><qty>200</qty><unit>g</unit></amt>
        <item>spaghetti</item>
      </ing>
    </ingredients>
    <directions>
      <step>Heat olive oil in a large pan over medium heat.</step>
      <step>Add garlic (minced) and cook for 1 minute.</step>
      <step>Add canned tomatoes and salt. Simmer for 15 minutes.</step>
      <step>Cook spaghetti in salted boiling water. Drain and toss with the sauce.</step>
    </directions>
  </recipe>
</recipeml>
```

## Format-by-Format Analysis

### Cooklang

**Ingredient representation.** Ingredients are annotated inline with `@name{quantity%unit}`. Parsing the ingredient `@canned tomatoes{400%g}` gives you `name: "canned tomatoes"`, `quantity: "400"`, `unit: "g"` — structured and typed, no string parsing required. The ingredient list the parser returns is derived from the prose, not maintained separately.

**Parser availability.** This is where Cooklang stands apart. There are 15+ independent implementations: `cooklang-rs` (Rust, the reference parser), `cooklang-ts` (TypeScript), plus community implementations in Python, Go, Swift, Haskell, Dart, Clojure, Lua, Perl, Ruby, .NET, C, and a Tree-sitter grammar for editor integration. An EBNF grammar and canonical test suite give all of them a shared contract. If your target language isn't on the list, the EBNF is the spec you implement against.

**Output formats.** [CookCLI](/cli/) converts `.cook` files to JSON, YAML, Markdown, HTML, LaTeX, and Schema.org without any code on your part:

```bash
cook recipe pasta.cook --format json
cook recipe pasta.cook --format schema
cook recipe pasta.cook --format markdown
```

The JSON output preserves the inline structure — each step is a list of typed tokens (text, ingredient, cookware, timer) rather than a flat string, so you can render ingredient references highlighted in context:

```json
{
  "steps": [
    {
      "items": [
        { "type": "text", "value": "Heat " },
        { "type": "ingredient", "name": "olive oil", "quantity": "2", "units": "tbsp" },
        { "type": "text", "value": " in a " },
        { "type": "cookware", "name": "large pan" },
        { "type": "text", "value": " over medium heat." }
      ]
    }
  ]
}
```

This token-level representation is what flat-string formats can never give you.

**Ecosystem.** Active development. CookCLI, mobile apps (iOS and Android), LSP for editor integration, a federation protocol for sharing recipe collections, and a playground at [playground.cooklang.org](https://playground.cooklang.org) for testing syntax in-browser.

**Best for.** Apps where you need both human authoring and machine-structured data. Recipe storage, scaling, shopping list generation, editor tooling.

---

### JSON-LD / Schema.org

**Ingredient representation.** This is the critical weakness: `recipeIngredient` is an array of plain strings. `"3 cloves garlic, minced"` is not structured data — it's a human-readable sentence. If you want the quantity (3), unit (cloves), ingredient name (garlic), and preparation (minced) as separate fields, you have to NLP your way to them. Schema.org defines no standard sub-structure for ingredient quantities.

**Parser availability.** Any JSON parser works. The format is JSON with known keys. If you're reading recipe data from the web (food blogs, recipe sites, Google's structured data), you'll encounter this constantly.

**What it's actually for.** JSON-LD Recipe markup is an SEO format, not a storage format. Nobody writes it by hand — CMSs and site generators produce it as a `<script type="application/ld+json">` block embedded in HTML. The consumer is Google, not your code.

**The round-trip problem.** If you use JSON-LD as your source of truth, you can't reliably reconstruct structured ingredients from `recipeIngredient` strings without external parsing. The format is lossy in that direction. The practical pattern is to store recipes in a structured format (Cooklang, a database schema) and generate JSON-LD as an output:

```bash
# Cooklang -> Schema.org JSON-LD
cook recipe pasta.cook --format schema
```

**Best for.** SEO. Generate it from your source format; don't store in it.

---

### MealMaster

**Ingredient representation.** Ingredients are in a fixed-width columnar block before the instructions. The column layout is:

```
[qty  ] [unit] [ingredient name; prep note]
      2 tb Olive oil
    400 g  Canned tomatoes
```

Quantities occupy columns 1-7, unit columns 9-10, ingredient name from column 12 onward. That fixed layout is what makes parsing fragile — any tool that re-wraps lines, changes encoding, or alters spacing silently breaks the format.

**Parser availability.** A handful of converters exist — mostly unmaintained Perl and Python scripts from the early 2000s. There is no canonical parser, no grammar specification, and no test suite. Implementations disagree on edge cases. Column offsets vary slightly between versions of the original MealMaster software. If you're writing a MealMaster parser, expect to handle multiple dialects and write extensive test cases from real-world files.

**Why it matters.** The BBS recipe archives from the 1990s contain hundreds of thousands of recipes in this format. If you're building an import tool for a recipe manager, you will encounter `.mmf` files. The format is read-only for most practical purposes — nobody is authoring new recipes in MealMaster.

**Best for.** Import pipelines for legacy archives. Convert to anything else as soon as possible.

---

### RecipeML

**Ingredient representation.** This is the most structurally complete of the four. Each ingredient is a tree with separate nodes for quantity, unit, item, and preparation:

```xml
<ing>
  <amt><qty>3</qty><unit>cloves</unit></amt>
  <item>garlic</item>
  <prep>minced</prep>
</ing>
```

Quantity, unit, name, and prep are unambiguously separated. No string parsing required. XML validation catches malformed documents. On paper, this is good format design.

**Parser availability.** Any XML parser works for the basic structure. The problem is the ecosystem is dead. RecipeML 0.5 was the last release, published in 2002. There is no active development, no community, no tooling beyond what was built in the early 2000s. The domain `formatdata.com` where the spec was hosted no longer resolves. You can find the spec mirrored in various places, but no one is maintaining implementations.

**The verbosity problem.** The XML sample above uses 47 lines to represent 5 ingredients and 4 steps. The same recipe in Cooklang is 8 lines. That verbosity was tolerable in 2002 when XML was considered the future of everything. It is not tolerable now.

**Best for.** Maintaining legacy systems that already use it. If you're starting fresh, the ingredient structure RecipeML provides (separate qty/unit/name/prep fields) is exactly what Cooklang's parser gives you from inline annotations — without the XML tax.

---

## Comparison Table

| Feature | Cooklang | JSON-LD | MealMaster | RecipeML |
|---------|----------|---------|------------|----------|
| Human-readable | Yes | No | Somewhat | No |
| Structured ingredients | Yes (inline) | No (strings) | Yes (columns) | Yes (XML nodes) |
| Parser ecosystem | 15+ languages | Every JSON parser | Few, unmaintained | Dead |
| Active development | Yes | Google-backed | No | No |
| Inline markup | Yes | N/A | No | No |
| Formal grammar / spec | Yes (EBNF + test suite) | Yes (Schema.org) | No | Yes (XSD, archived) |
| Best for | Authoring + tooling | SEO output | Legacy import | Legacy maintenance |

## When to Use What

**Building a recipe app from scratch.** Use Cooklang as your source format. You get human-editable plain text files, a structured JSON representation from the parser, and a path to generate Schema.org output for any recipes you publish on the web. The 15+ parser implementations mean you're not betting on a single library.

**Publishing recipes on a website that needs Google rich snippets.** Generate JSON-LD from whatever you store internally. `cook recipe --format schema` does this if your source is Cooklang. If your source is a database, generate the JSON-LD at render time from your schema. Do not use JSON-LD as your canonical storage format.

**Importing an existing recipe archive.** If the archive is MealMaster, you're writing a conversion script. Parse the fixed-width columns, extract qty/unit/name, output to whatever format you actually want to work with. Do it once, carefully, and move on.

**Maintaining an existing codebase that uses RecipeML.** Keep it running. If you have the opportunity to migrate, Cooklang's ingredient structure (separate name, quantity, unit, and notes) maps cleanly to RecipeML's `<item>`, `<qty>`, `<unit>`, and `<prep>` fields. The migration is mechanical.

**Need to understand the format before writing code.** The [Cooklang spec](/docs/spec/) has the EBNF grammar and the canonical test suite. The [playground](/blog/30-cooklang-playground-walkthrough/) lets you experiment in-browser. For Schema.org, the [Recipe type reference](https://schema.org/Recipe) is the authoritative source. For MealMaster, you'll need to read archived documentation and cross-reference with real `.mmf` files — there is no clean spec.

## What the Parser Returns

If you're evaluating formats for a new project, the most useful comparison is what the parser hands you when parsing is done. Here's what you can reliably extract from each format:

| Field | Cooklang | JSON-LD | MealMaster | RecipeML |
|-------|----------|---------|------------|----------|
| Ingredient name | Yes | String parsing required | Yes (with correct columns) | Yes |
| Ingredient quantity | Yes | String parsing required | Yes (with correct columns) | Yes |
| Ingredient unit | Yes | String parsing required | Yes (two-char abbreviation) | Yes |
| Prep note | Yes (parenthetical) | Embedded in string | After semicolon | Yes (`<prep>`) |
| Cookware references | Yes | No | No | No |
| Timer values | Yes | No | No | No |
| Step-level ingredient refs | Yes | No | No | No |
| Metadata (title, yield) | Yes (YAML frontmatter) | Yes | Yes (fixed fields) | Yes |

The step-level ingredient reference column is the meaningful differentiator. Only Cooklang knows that the `olive oil` in step one is the same entity as the `olive oil` entry in the ingredient list — because they're the same token in the source text, not two separate data points that you have to correlate by string matching.

---

The [Cooklang spec](/docs/spec/) is the starting point if you want to understand the grammar before writing a parser or integrating the library. The [for-developers page](/docs/for-developers/) has the full list of parser implementations by language. If you want to see the parser output interactively, the [playground](https://playground.cooklang.org) shows the JSON AST in real time as you edit.

-Alex
