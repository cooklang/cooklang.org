---
title: "Building with Cooklang: A Parser Integration Guide"
date: 2026-03-24
weight: 50
summary: "You want structured recipe data — ingredients with quantities, steps with inline references, timers, cookware. Here's how to parse Cooklang in your language of choice, with quick-start examples in TypeScript and Python, and a map of the full ecosystem."
---

You want to build something with recipes. A meal planner, a grocery app, a cooking timer, a nutrition calculator. The problem is always the same: recipe data is unstructured. Ingredients buried in prose. Quantities as strings. Steps with no machine-readable references to what ingredient goes in when.

Cooklang solves this at the format level. Every ingredient, timer, and piece of cookware is explicitly annotated in the source text. A parser gives you a complete structured representation — no NLP, no heuristics. This post walks through how to get that data in your language of choice.

## What Parsing Gives You

Start with a `.cook` file:

```cooklang
---
title: Garlic Pasta
servings: 2
time: 20 min
---

Bring a #large pot{} of @water{2%litres} to a boil. Add @salt{1%tbsp}.

Cook @spaghetti{200%g} until al dente, about ~{9%minutes}.

Meanwhile, warm @olive oil{3%tbsp} in a #pan{} over medium heat. Add @garlic{4%cloves}(minced) and cook for ~{1%minute}.

Drain the pasta, toss with the garlic oil, and serve.
```

Run `cook recipe garlic-pasta.cook --format json` and you get:

```json
{
  "name": "Garlic Pasta",
  "metadata": {
    "servings": "2",
    "time": "20 min"
  },
  "ingredients": [
    { "name": "water", "quantity": "2", "units": "litres" },
    { "name": "salt", "quantity": "1", "units": "tbsp" },
    { "name": "spaghetti", "quantity": "200", "units": "g" },
    { "name": "olive oil", "quantity": "3", "units": "tbsp" },
    { "name": "garlic", "quantity": "4", "units": "cloves" }
  ],
  "cookware": [
    { "name": "large pot" },
    { "name": "pan" }
  ],
  "steps": [
    {
      "items": [
        { "type": "text", "value": "Cook " },
        { "type": "ingredient", "name": "spaghetti", "quantity": "200", "units": "g" },
        { "type": "text", "value": " until al dente, about " },
        { "type": "timer", "name": "", "quantity": "9", "units": "minutes" },
        { "type": "text", "value": "." }
      ]
    }
  ]
}
```

Each step is a list of typed tokens. Ingredients appear inline at the point they're used, not just in a separate list. That token-level representation is what lets you render steps with ingredient quantities highlighted in context — something no flat-string format can give you.

## Choosing a Parser

The Cooklang GitHub organization maintains official implementations. Community contributors have added more. Here's the map:

**JavaScript / TypeScript**
For web apps and Node.js: [cooklang-ts](https://github.com/cooklang/cooklang-ts) is the official TypeScript implementation. A second implementation at [github.com/tmlmt/cooklang-parser](https://github.com/tmlmt/cooklang-parser) provides an alternative if you need different output shape. For older JavaScript projects: [cooklang-js](https://github.com/deathau/cooklang-js).

**Python**
[py-cooklang](https://github.com/luizribeiro/py-cooklang) — straightforward to install and use for scripts, data pipelines, and notebooks.

**Rust**
[cooklang-rs](https://github.com/cooklang/cooklang-rs) — the reference parser. Rich error reporting, optional extensions, unit conversion, and recipe scaling built in. This is what [CookCLI](/cli/) uses internally. The [online playground](https://cooklang.github.io/cooklang-rs/) runs it compiled to WebAssembly.

**Swift**
[CookInSwift](https://github.com/cooklang/CookInSwift) — the official Swift implementation, used by the iOS app.

**Go**
[cooklang-go](https://github.com/aquilax/cooklang-go) for server-side services.

**Others**
.NET ([cooklangnet](https://github.com/heytherewill/cooklangnet)), C ([cook-in-c](https://github.com/cooklang/cook-in-c)), Clojure ([cooklang-clj](https://github.com/kiranshila/cooklang-clj)), Dart ([cooklang-dart](https://github.com/aquilax/cooklang-dart)), Haskell ([cooklang-hs](https://github.com/isaacvando/cooklang-hs)), Lua ([cooklang-lua](https://github.com/michal-h21/cooklang-lua)), Perl ([CookLang on CPAN](https://metacpan.org/pod/CookLang)), Ruby ([cooklang_rb](https://github.com/drbragg/cooklang_rb)).

If your target language is missing, the [EBNF grammar](https://github.com/cooklang/spec/blob/main/EBNF.md) is the spec to implement against.

## Quick Start: TypeScript

```bash
npm install @cooklang/cooklang-ts
```

```typescript
import { Recipe } from "@cooklang/cooklang-ts";

const source = `
---
title: Garlic Pasta
servings: 2
---

Cook @spaghetti{200%g} in a #large pot{} of boiling @water{2%litres}.

Warm @olive oil{3%tbsp} and @garlic{4%cloves} in a #pan{} for ~{1%minute}.
`;

const recipe = new Recipe(source);

console.log("Ingredients:");
for (const ing of recipe.ingredients) {
  console.log(`  ${ing.quantity} ${ing.units} ${ing.name}`);
}

console.log("\nSteps:");
for (const step of recipe.steps) {
  const text = step.map(item => {
    if (item.type === "ingredient") return `[${item.name}]`;
    if (item.type === "cookware") return `(${item.name})`;
    if (item.type === "timer") return `~${item.quantity}${item.units}`;
    return item.value;
  }).join("");
  console.log(`  ${text}`);
}
```

Output:

```
Ingredients:
  200 g spaghetti
  2 litres water
  3 tbsp olive oil
  4 cloves garlic

Steps:
  Cook [spaghetti] in a (large pot) of boiling [water].
  Warm [olive oil] and [garlic] in a (pan) for ~1minute.
```

## Quick Start: Python

```bash
pip install cooklang
```

```python
from cooklang import Recipe

source = """
---
title: Garlic Pasta
servings: 2
---

Cook @spaghetti{200%g} in a #large pot{} of boiling @water{2%litres}.

Warm @olive oil{3%tbsp} and @garlic{4%cloves} in a #pan{} for ~{1%minute}.
"""

recipe = Recipe(source)

print("Ingredients:")
for ing in recipe.ingredients:
    print(f"  {ing['quantity']} {ing['units']} {ing['name']}")

print("\nCookware:")
for cw in recipe.cookware:
    print(f"  {cw['name']}")

print("\nMetadata:")
for key, value in recipe.metadata.items():
    print(f"  {key}: {value}")
```

Both parsers follow the same logical structure: `recipe.ingredients`, `recipe.steps`, `recipe.cookware`, `recipe.metadata`. The field names differ slightly between implementations — check the README for the exact shape — but the data model is consistent with the spec.

## Beyond Parsing: The Higher-Level Libraries

Parsing a single recipe is the starting point. The Cooklang ecosystem has Rust libraries for the things you'll need next:

**cooklang-find** ([github.com/cooklang/cooklang-find](https://github.com/cooklang/cooklang-find))
Search and manage a recipe collection on the filesystem. Builds a recipe tree from a directory, parses metadata without parsing full recipes, associates images with recipe files. Useful when you're building a recipe browser or search interface.

**cooklang-reports** ([github.com/cooklang/cooklang-reports](https://github.com/cooklang/cooklang-reports))
Generate custom output from recipes using Jinja2-style templates. Supports recipe scaling, metadata access, and a YAML datastore for supplementary data. The right tool when you want formatted output that isn't one of the built-in formats — a custom HTML template, a PDF ingredient sheet, a weekly meal card.

**cooklang-import** ([github.com/cooklang/cooklang-import](https://github.com/cooklang/cooklang-import))
Takes a recipe URL and outputs a `.cook` file. Uses the OpenAI API to handle the messy reality of recipe web pages. Useful for an import flow in a recipe app — let users paste a URL, get back structured Cooklang.

## Validating Against the Canonical Test Suite

The [spec repository](https://github.com/cooklang/spec/tree/main/tests) contains a canonical test suite. Each test is a pair: a `.cook` input and a JSON file with the expected parser output. If you're writing a new parser or wrapping an existing one, run it against this suite.

```bash
git clone https://github.com/cooklang/spec
ls spec/tests/
```

The test cases cover edge cases for ingredient parsing, multiword names, unitless quantities, inline cookware and timers, sections, and comments. Passing the full suite is what it means to be a conforming parser.

## Real-World Integration Ideas

**Recipe web app with search.** Parse a directory of `.cook` files with `cooklang-find`, index the metadata into a search index (SQLite FTS, Meilisearch, or just an in-memory array for small collections). The metadata block — `tags`, `cuisine`, `time`, `servings` — gives you everything you need for faceted search without touching the full recipe text.

**Grocery list generator.** Parse multiple recipes, collect all ingredients, sum quantities by unit. The `cook shopping-list` command does this from the CLI. To do it in code, walk `recipe.ingredients` across recipes and accumulate. Handle unit normalization (grams vs. kilograms, millilitres vs. litres) for clean output.

**Nutrition calculator.** The ingredient list gives you structured name, quantity, and unit. Map ingredient names to a nutrition database (USDA FoodData Central has a free API) and multiply by quantity. The hard part is name matching — `"cherry tomatoes"` vs `"tomatoes, cherry"` — which is a fuzzy matching problem, not a parsing problem.

**Recipe API.** CookCLI's `cook server` command already does this: it serves a REST-like JSON API over a directory of `.cook` files. If you need a custom API shape, parse the files with a library and wrap them in whatever framework you're using. The [building a recipe API post](/blog/29-building-recipe-api-with-cooklang/) covers this in detail.

## Editor and Tooling Integration

If you're building a recipe editor:

- `cook lsp` starts a Language Server Protocol server. Any editor with LSP support gets syntax highlighting, diagnostics, and hover information for `.cook` files.
- The [Tree-sitter grammar](https://github.com/addcninblue/tree-sitter-cooklang) integrates Cooklang into editors that use Tree-sitter (Neovim, Helix, Zed).
- The [playground](https://cooklang.github.io/cooklang-rs/) shows the raw parser output as you type, which is the fastest way to understand what your parser will receive for any given input.

---

The [for-developers page](/docs/for-developers/) is the canonical list of all parser implementations and higher-level libraries. The [spec](/docs/spec/) has the EBNF grammar and links to the canonical test suite. The [playground](https://cooklang.github.io/cooklang-rs/) shows live parser output. Start there.

-Alex
