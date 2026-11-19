---
title: "Building a Recipe API with Cooklang"
date: 2026-02-28
lastmod: 2026-11-19
weight: 60
summary: "Skip the third-party recipe APIs. With CookCLI, your plain-text .cook files become a structured JSON backend you own and control."
description: "Build a recipe API with CookCLI: turn your plain-text .cook files into a structured JSON backend you own — no third-party recipe API required."
categories: ["Self-Hosting and Integrations"]
---

Most recipe APIs charge per request, lock your data into their schema, and limit what you can do with recipes you own. There's a simpler path: your `.cook` files already contain structured data. CookCLI can expose that data as JSON, run a local server, and give you everything you need to build a recipe app — without signing up for anything.

This post walks through using CookCLI as a recipe API backend, building a minimal frontend, generating a static JSON API, and extending with Schema.org output and the Rust parser library.

## The JSON Output

Every `.cook` file parses to structured JSON with a single command. Given a recipe file like `risotto.cook`:

```bash
cook recipe risotto.cook --format json --pretty
```

The output is a complete structured representation of the recipe. Here it is cut down to one step and one entry in each list:

```json
{
  "metadata": {
    "map": {
      "title": "Risotto",
      "servings": 4,
      "time": "45 minutes",
      "tags": ["italian", "comfort", "vegetarian"]
    }
  },
  "sections": [
    {
      "name": null,
      "content": [
        {
          "type": "step",
          "value": {
            "items": [
              { "type": "text", "value": "Warm " },
              { "type": "ingredient", "index": 0 },
              { "type": "text", "value": " in a " },
              { "type": "cookware", "index": 0 },
              { "type": "text", "value": " over low heat. Keep it at a gentle simmer throughout." }
            ],
            "number": 1
          }
        }
      ]
    }
  ],
  "ingredients": [
    {
      "name": "chicken stock",
      "quantity": {
        "value": { "type": "number", "value": { "type": "regular", "value": 1.0 } },
        "unit": "litre",
        "scalable": true
      }
    }
  ],
  "cookware": [
    { "name": "small saucepan" }
  ],
  "timers": [
    {
      "name": null,
      "quantity": {
        "value": { "type": "number", "value": { "type": "regular", "value": 5.0 } },
        "unit": "minutes",
        "scalable": false
      }
    }
  ]
}
```

Steps live under `sections[].content[]` and keep the inline structure of the original prose: each step is a list of text, ingredient, cookware and timer items, and the last three point by `index` into the top-level lists. This means you can render step text with ingredient quantities highlighted, the same way Cooklang apps do.

Scaling works too. Pass a scale factor with the `:N` syntax (`:2` doubles the recipe):

```bash
cook recipe risotto.cook:2 --format json
```

All ingredient quantities in the JSON output, and the `servings` value, are multiplied by that factor. The API layer is just the command.

## The Built-in Server

`cook server` starts a web interface for browsing your recipe collection:

```bash
cook server ./recipes/
```

This runs at `http://localhost:9080` by default and serves the full web UI. But the server also exposes recipe data as JSON through its API endpoints. You can query individual recipes, browse collections, and pull ingredient data programmatically.

The server is a single Rust binary with no database and no configuration. Point it at a directory of `.cook` files and it works. The server reads files from disk on each request, so adding or editing a recipe is reflected immediately.

For a different port:

```bash
cook server ./recipes/ --port 8888
```

If you're building a frontend that needs live data from your local collection, this is the backend. No setup beyond installing CookCLI.

## Building a Static JSON API

For production deployments, you probably want a static JSON API rather than a running server process. A simple shell script turns a folder of `.cook` files into a directory of JSON files:

```bash
#!/bin/bash
# build-api.sh — generates a static JSON API from a recipes directory

RECIPES_DIR="./recipes"
OUTPUT_DIR="./api"

mkdir -p "$OUTPUT_DIR"

INDEX=""

while IFS= read -r file; do
    # Derive a slug from the filename
    basename=$(basename "$file" .cook)
    slug=$(echo "$basename" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    # Parse the recipe to JSON
    cook recipe "$file" --format json > "$OUTPUT_DIR/${slug}.json"

    INDEX="$INDEX\"$slug\","
    echo "Built: $slug"
done < <(find "$RECIPES_DIR" -name "*.cook" | sort)

# Build an index of all recipes
echo "[${INDEX%,}]" > "$OUTPUT_DIR/index.json"

echo "Done. JSON files written to $OUTPUT_DIR/"
```

Run the script after any recipe change and you have a `/api/` directory of static JSON files. Serve it with Nginx, GitHub Pages, Netlify, or any static host. No server process, no database — just files.

For CI, add the script to your pipeline. Every push to your recipe repo rebuilds the API automatically.

## A Minimal Recipe Frontend

With the JSON API in place, rendering a recipe in a browser takes about fifty lines of JavaScript:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Recipe</title>
  <style>
    body { font-family: system-ui, sans-serif; max-width: 680px; margin: 2rem auto; padding: 0 1rem; }
    h1 { margin-bottom: 0.25rem; }
    .meta { color: #666; font-size: 0.9rem; margin-bottom: 1.5rem; }
    .ingredient { font-weight: 600; }
    li { margin-bottom: 0.5rem; }
  </style>
</head>
<body>
  <div id="recipe"></div>

  <script>
    const slug = new URLSearchParams(window.location.search).get("recipe") || "risotto";

    fetch(`/api/${slug}.json`)
      .then(res => res.json())
      .then(recipe => {
        const el = document.getElementById("recipe");

        const meta = Object.entries(recipe.metadata.map || {})
          .map(([k, v]) => `${k}: ${v}`)
          .join(" · ");

        // A quantity is { value, unit }; the value is a number, a fraction or text.
        const num = n => n.type === "fraction"
          ? n.value.whole + n.value.num / n.value.den
          : n.value;
        const amount = q => {
          if (!q) return "";
          const v = q.value;
          const text = v.type === "number" ? num(v.value) : v.value;
          return `${text} ${q.unit || ""}`.trim();
        };

        const ingredients = recipe.ingredients
          .map(i => `<li>${amount(i.quantity)} ${i.name}</li>`)
          .join("");

        const steps = recipe.sections
          .flatMap(section => section.content)
          .filter(block => block.type === "step")
          .map(block => {
            const text = block.value.items.map(item => {
              if (item.type === "text") return item.value;
              if (item.type === "ingredient") {
                return `<span class="ingredient">${recipe.ingredients[item.index].name}</span>`;
              }
              if (item.type === "cookware") return recipe.cookware[item.index].name;
              if (item.type === "timer") return amount(recipe.timers[item.index].quantity);
              return "";
            }).join("");
            return `<li>${text}</li>`;
          }).join("");

        el.innerHTML = `
          <h1>${recipe.metadata.map.title || slug}</h1>
          <p class="meta">${meta}</p>
          <h2>Ingredients</h2>
          <ul>${ingredients}</ul>
          <h2>Method</h2>
          <ol>${steps}</ol>
        `;
      });
  </script>
</body>
</html>
```

Open `recipe.html?recipe=risotto` and it fetches `/api/risotto.json`, renders the ingredient list, and walks through the steps with ingredient names highlighted inline.

This works from any static host. No backend required once you've built the JSON files. Add a second fetch to `/api/index.json` for a recipe list page, and you have a complete browsable recipe site.

## Shopping Lists as JSON

The same JSON flag works for shopping lists:

```bash
cook shopping-list --format json --pretty risotto.cook pasta-sauce.cook roast-chicken.cook
```

The output is a combined, deduplicated ingredient list across all three recipes (two items shown):

```json
[
  {
    "category": "other",
    "items": [
      {
        "name": "olive oil",
        "quantity": [
          {
            "unit": "ml",
            "value": { "type": "number", "value": { "type": "regular", "value": 60.0 } }
          }
        ]
      },
      {
        "name": "garlic",
        "quantity": [
          {
            "unit": "cloves",
            "value": { "type": "number", "value": { "type": "regular", "value": 4.0 } }
          }
        ]
      }
    ]
  }
]
```

Items are grouped by aisle category; without an `aisle.conf` they all land in `other`. Matching ingredients from different recipes are combined and quantities summed. This output pipes directly into any frontend that needs a shopping list, or into a grocery integration if you're building one.

With `:N` scaling per recipe:

```bash
cook shopping-list --format json risotto.cook:2 pasta-sauce.cook:6
```

Each recipe scales independently before the lists merge.

## Schema.org Output for SEO

If you're publishing recipes on a public site, structured data matters. Search engines use Schema.org Recipe markup to display cooking times, ingredients, and ratings in search results.

CookCLI generates this directly:

```bash
cook recipe risotto.cook --format schema --pretty
```

Output (first two steps):

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "keywords": "italian, comfort, vegetarian",
  "name": "Risotto",
  "recipeIngredient": [
    "1 litre chicken stock",
    "30 g butter",
    "2 shallots",
    "320 g arborio rice",
    "150 ml dry white wine",
    "60 g parmesan"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "position": 1,
      "text": "Warm chicken stock in a small saucepan over low heat. Keep it at a gentle simmer throughout."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "text": "Melt butter in a large heavy-bottomed pan and soften shallots, about 5 minutes.",
      "timeRequired": "PT5M"
    }
  ],
  "recipeYield": "4 servings",
  "tool": [
    "small saucepan",
    "large heavy-bottomed pan"
  ],
  "totalTime": "PT45M"
}
```

Drop this into a `<script type="application/ld+json">` tag in your recipe page and search engines can parse the recipe structure directly. Add it to the build script:

```bash
# Add to build-api.sh alongside the regular JSON
cook recipe "$file" --format schema > "$OUTPUT_DIR/${slug}.schema.json"
```

Then include it in your HTML template alongside the regular recipe data.

## Other Output Formats

`cook recipe` supports several other formats you might find useful depending on your use case:

- `--format yaml` — same structure as JSON but YAML, useful if you're feeding into Ansible playbooks or other YAML-native tooling
- `--format markdown` — renders the recipe as formatted Markdown, good for documentation sites or static site generators
- `--format cooklang` — round-trips the recipe back to Cooklang syntax, useful for normalization
- `--format latex` — generates LaTeX output for printable recipe books (see [Creating Cookbooks](/guides/cookbook-creation/))

For an API use case, JSON and schema are the most useful. YAML is handy if you're generating recipe data for a Hugo or Jekyll site where YAML front matter is expected.

## Embedding the Parser Directly

For tighter integration, the `cooklang-rs` Rust library lets you embed the parser in your own application rather than shelling out to CookCLI:

```toml
# Cargo.toml
[dependencies]
cooklang = "0.19"
```

```rust
use cooklang::CooklangParser;

fn main() {
    let parser = CooklangParser::extended();
    let source = std::fs::read_to_string("risotto.cook").unwrap();
    let (recipe, _warnings) = parser.parse(&source).into_result().unwrap();

    for ingredient in &recipe.ingredients {
        match &ingredient.quantity {
            Some(quantity) => println!("{}: {}", ingredient.name, quantity),
            None => println!("{}", ingredient.name),
        }
    }
}
```

This is the same parser CookCLI uses internally. You get full access to the parsed AST — ingredients, steps, metadata, cookware, timers — with no subprocess overhead.

The library also compiles to WebAssembly. The [cooklang-rs playground](https://cooklang.github.io/cooklang-rs/) runs it in-browser, which means you can parse `.cook` files on the client side with zero server round-trips. A recipe editor that parses and validates as you type is a straightforward WASM integration.

For other languages, there are parser libraries in Python, TypeScript, Go, Swift, and others. The full list is at [/docs/for-developers/](/docs/for-developers/).

## What You End Up With

Putting this together, the full stack looks like:

1. `.cook` files as the source of truth — version-controlled, plain text, human-readable
2. A build script that runs `cook recipe --format json` on each file and writes to `/api/`
3. A static frontend that fetches from `/api/` and renders recipe pages
4. Schema.org JSON-LD embedded in each page for search engine structured data
5. The CookCLI server for local development and in-kitchen browsing

No third-party API keys. No rate limits. No data locked in someone else's schema. The files are yours, the API is yours, and the whole stack runs on a $5 VPS or a Raspberry Pi.

The [CookCLI documentation at /cli/](/cli/) covers every flag. If you want to understand the Cooklang format itself before writing recipes programmatically, the [spec at /docs/spec/](/docs/spec/) is the canonical reference.

[Get started with Cooklang →](/docs/getting-started/)

-Alex
