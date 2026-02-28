---
title: "Building a Recipe API with Cooklang"
date: 2026-02-28
weight: 60
summary: "Skip the third-party recipe APIs. With CookCLI, your plain-text .cook files become a structured JSON backend you own and control."
---

Most recipe APIs charge per request, lock your data into their schema, and limit what you can do with recipes you own. There's a simpler path: your `.cook` files already contain structured data. CookCLI can expose that data as JSON, run a local server, and give you everything you need to build a recipe app — without signing up for anything.

This post walks through using CookCLI as a recipe API backend, building a minimal frontend, generating a static JSON API, and extending with Schema.org output and the Rust parser library.

## The JSON Output

Every `.cook` file parses to structured JSON with a single command. Given a recipe file like `risotto.cook`:

```bash
cook recipe risotto.cook --format json
```

The output is a complete structured representation of the recipe:

```json
{
  "name": "Risotto",
  "metadata": {
    "servings": "4",
    "time": "45 minutes",
    "tags": "italian, comfort, vegetarian"
  },
  "ingredients": [
    { "name": "chicken stock", "quantity": "1", "units": "litre" },
    { "name": "butter", "quantity": "30", "units": "g" },
    { "name": "shallots", "quantity": "2", "units": "" },
    { "name": "arborio rice", "quantity": "320", "units": "g" },
    { "name": "dry white wine", "quantity": "150", "units": "ml" },
    { "name": "parmesan", "quantity": "60", "units": "g" }
  ],
  "cookware": [
    { "name": "small saucepan" },
    { "name": "large heavy-bottomed pan" }
  ],
  "steps": [
    {
      "items": [
        { "type": "text", "value": "Warm " },
        { "type": "ingredient", "name": "chicken stock", "quantity": "1", "units": "litre" },
        { "type": "text", "value": " in a " },
        { "type": "cookware", "name": "small saucepan" },
        { "type": "text", "value": " over low heat." }
      ]
    }
  ]
}
```

The steps array preserves the inline structure of the original prose — ingredients and cookware appear in context, not just as a flat list. This means you can render step text with ingredient quantities highlighted, the same way Cooklang apps do.

Scaling works too. Pass a serving count with the `:N` syntax:

```bash
cook recipe risotto.cook:2 --format json
```

All ingredient quantities in the JSON output adjust to the scaled serving count. The API layer is just the command.

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

# Build an index of all recipes
echo "[]" > "$OUTPUT_DIR/index.json"
INDEX="[]"

for file in "$RECIPES_DIR"/**/*.cook "$RECIPES_DIR"/*.cook; do
    [ -f "$file" ] || continue

    # Derive a slug from the filename
    basename=$(basename "$file" .cook)
    slug=$(echo "$basename" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

    # Parse the recipe to JSON
    cook recipe "$file" --format json > "$OUTPUT_DIR/${slug}.json"

    echo "Built: $slug"
done

echo "Done. JSON files written to $OUTPUT_DIR/"
```

Run the script after any recipe change and you have a `/api/` directory of static JSON files. Serve it with Nginx, GitHub Pages, Netlify, or any static host. No server process, no database — just files.

For CI, add the script to your pipeline. Every push to your recipe repo rebuilds the API automatically.

## A Minimal Recipe Frontend

With the JSON API in place, rendering a recipe in a browser takes about thirty lines of JavaScript:

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

        const meta = Object.entries(recipe.metadata || {})
          .map(([k, v]) => `${k}: ${v}`)
          .join(" · ");

        const ingredients = recipe.ingredients
          .map(i => `<li>${i.quantity} ${i.units} ${i.name}`.trim() + `</li>`)
          .join("");

        const steps = recipe.steps.map((step, idx) => {
          const text = step.items.map(item => {
            if (item.type === "ingredient") {
              return `<span class="ingredient">${item.name}</span>`;
            }
            return item.value || item.name || "";
          }).join("");
          return `<li>${text}</li>`;
        }).join("");

        el.innerHTML = `
          <h1>${recipe.name}</h1>
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
cook shopping-list --format json risotto.cook pasta-sauce.cook roast-chicken.cook
```

The output is a combined, deduplicated ingredient list across all three recipes:

```json
{
  "shopping_list": [
    { "name": "garlic", "quantity": "4", "units": "cloves" },
    { "name": "olive oil", "quantity": "60", "units": "ml" },
    { "name": "arborio rice", "quantity": "320", "units": "g" },
    { "name": "chicken", "quantity": "1.5", "units": "kg" }
  ]
}
```

Matching ingredients from different recipes are combined and quantities summed. This output pipes directly into any frontend that needs a shopping list, or into a grocery integration if you're building one.

With `:N` scaling per recipe:

```bash
cook shopping-list --format json risotto.cook:2 pasta-sauce.cook:6
```

Each recipe scales independently before the lists merge.

## Schema.org Output for SEO

If you're publishing recipes on a public site, structured data matters. Search engines use Schema.org Recipe markup to display cooking times, ingredients, and ratings in search results.

CookCLI generates this directly:

```bash
cook recipe risotto.cook --format schema
```

Output:

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "Risotto",
  "recipeIngredient": [
    "1 litre chicken stock",
    "30 g butter",
    "320 g arborio rice",
    "150 ml dry white wine",
    "60 g parmesan"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "text": "Warm chicken stock in a small saucepan over low heat. Keep it at a gentle simmer throughout."
    }
  ],
  "recipeYield": "4 servings",
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
- `--format latex` — generates LaTeX output for printable recipe books (pairs with the cookbook PDF scripts covered [in the server docs](/docs/))

For an API use case, JSON and schema are the most useful. YAML is handy if you're generating recipe data for a Hugo or Jekyll site where YAML front matter is expected.

## Embedding the Parser Directly

For tighter integration, the `cooklang-rs` Rust library lets you embed the parser in your own application rather than shelling out to CookCLI:

```toml
# Cargo.toml
[dependencies]
cooklang = "0.14"
```

```rust
use cooklang::{CooklangParser, Extensions};

fn main() {
    let parser = CooklangParser::new(Extensions::all());
    let source = std::fs::read_to_string("risotto.cook").unwrap();
    let (recipe, _warnings) = parser.parse(&source).into_result().unwrap();

    for ingredient in &recipe.ingredients {
        println!("{}: {} {}", ingredient.name, ingredient.quantity, ingredient.unit.as_deref().unwrap_or(""));
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
