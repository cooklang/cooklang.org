---
title: "A Plain Text Recipe Database You Already Know How to Use"
date: 2026-03-24
weight: 46
summary: "You don't need Postgres, schemas, or migrations to build a recipe database. Your filesystem already is one — and CookCLI gives you the query layer on top."
---

Everyone wants a recipe database. A real one: searchable, queryable, with structured ingredient data and some way to aggregate across recipes. Most paths to that end up at a web app, a relational database, a schema to design, migrations to write, a server to maintain. Then the app gets abandoned, the database format changes, and you spend a weekend exporting your recipes before the service shuts down.

There is another path. Your filesystem is already a database. Your `.cook` files are already records. And the query language you need is mostly commands you already know.

## Files as Records, Folders as Collections

A Cooklang recipe file is a self-contained record. The YAML frontmatter is metadata — title, source, tags, servings, cooking time. The body is structured instruction text with typed inline data: ingredients declared with `@`, cookware with `#`, timers with `~`. Every field is parseable, every quantity is computable.

```cooklang
---
title: Pasta Carbonara
tags: [italian, pasta, quick]
servings: 2
time: 25 minutes
---

Bring a large #pot of @water{2%L} to a boil and cook @spaghetti{200%g} until al dente.

Meanwhile, fry @guanciale{150%g} in a #pan until crispy, ~{8%minutes}.
```

The file is both human-readable and machine-parseable. Nothing is lost between the two representations.

Folders become collections. Your directory structure is your schema:

```
recipes/
├── breakfast/
│   ├── pancakes.cook
│   └── french-toast.cook
├── dinner/
│   ├── roast-chicken.cook
│   └── pasta-carbonara.cook
└── desserts/
    └── chocolate-cake.cook
```

No table definitions. No foreign keys. No migrations when you add a new category — you create a folder. This is not a limitation, it is the design. The filesystem gives you hierarchical organization for free, and every tool that works on files works on your recipes.

## The Query Layer

[CookCLI](/cli/) is the query engine for this database. Most of its commands map directly to operations you would write in SQL if you had bothered to spin up a database.

**Full-text search** is `cook search`. It scans your entire recipe collection for a term — a `SELECT ... WHERE body LIKE '%keyword%'` across every file:

```bash
cook search "lemon"
# Returns: lemon tart, lemon chicken, preserved lemon pasta...
```

**Aggregation across records** is `cook shopping-list`. Give it a set of recipe files and it unions the ingredient sets, sums matching quantities, and emits a combined list. This is `SUM` and `GROUP BY` applied to structured ingredient data:

```bash
cook shopping-list monday.cook tuesday.cook wednesday.cook
```

Quantities combine automatically. If Monday needs 200g butter and Wednesday needs 150g, the list shows 350g. You never touch a calculator.

**Scaling** works per-record at query time. The `:N` syntax multiplies quantities before aggregation — a computed column applied before the `GROUP BY`:

```bash
cook shopping-list "dinner-party.cook:4" "brunch.cook:2"
```

Each recipe scales independently, then the lists merge.

**Structured export** is `cook recipe -f json`. Every `.cook` file serializes to a clean JSON document with structured `ingredients`, `steps`, `metadata`, and `cookware` arrays. This is `SELECT * AS JSON` — the same record, projected to a different format. YAML, Markdown, and LaTeX output work the same way:

```bash
cook recipe -f json pasta-carbonara.cook
cook recipe -f yaml pasta-carbonara.cook
cook recipe -f latex pasta-carbonara.cook
```

The [shopping list command](/cli/commands/shopping-list/) and [search command](/cli/commands/search/) are documented in full, but the mental model is worth having: every CookCLI command is a query against the file-based database.

## The Ingredient Data Layer

Beyond the recipe files themselves, Cooklang supports a `config/db/` directory — a document store for ingredient metadata. Each ingredient gets a folder, and YAML files inside store whatever enrichment data you care about:

```
config/db/
├── eggs/
│   └── shopping.yml
├── flour/
│   ├── nutrition.yml
│   └── cost.yml
├── butter/
│   ├── nutrition.yml
│   └── alternatives.yml
└── olive oil/
    └── shopping.yml
```

A `shopping.yml` might store store-specific links and prices. A `nutrition.yml` holds macro data per 100g. A `cost.yml` tracks price per unit for budget calculations. The structure is open — you decide what to track.

The `cook report` command joins this ingredient database with your recipe files at query time. It runs a minijinja template across your recipes and has access to `db()` — a function that looks up ingredient metadata by name:

```jinja2
{%- for ingredient in get_ingredient_list(recipes) %}
- {{ ingredient.name }}: {{ db(ingredient.name ~ ".cost.per_unit", 0) | float * ingredient.quantity | float | round(2) }}
{%- endfor %}
```

This is a JOIN between recipes and ingredient metadata, expressed as a template. The [report command](/cli/commands/report/) supports output to Markdown, YAML, HTML, LaTeX, and CSV — whatever the downstream consumer needs. The [reports and data management docs](/docs/use-cases/reports/) have worked examples for cost analysis and nutritional summaries.

## Pantry as State Store

A database that only stores static records is half a system. The dynamic half — current inventory — lives in `pantry.conf`, a TOML file that tracks what you actually have on hand:

```toml
[freezer]
chicken_stock = { quantity = "4%cups", frozen = "2024-12-20" }
pizza_dough = { quantity = "2%balls", frozen = "2024-12-28" }

[fridge]
milk = { expire = "2025-01-10", quantity = "1%L" }
eggs = "6"

[pantry]
rice = "5%kg"
flour = "3%kg"

[spices]
cumin = { quantity = "1%jar", bought = "2024-11-01" }
coriander = "50%g"
```

This is a key-value store keyed by ingredient name. The `-p` flag on `cook shopping-list` takes a pantry file and excludes items you already have — a `WHERE NOT IN` clause derived from current inventory:

```bash
cook shopping-list -p config/pantry.conf monday.cook tuesday.cook
```

If you have rice and cumin, they drop off the list. You buy what is missing, not what the recipe calls for in the abstract. The [pantry management docs](/docs/use-cases/pantry/) cover the full format including expiration tracking and low-stock thresholds.

## Aisle Configuration as Index

One more layer: `aisle.conf` groups ingredients by store section, and supports aliases for the same ingredient referred to differently across recipes:

```
[produce]
tomatoes | cherry tomatoes | Roma tomatoes

[dairy]
milk
butter
eggs

[pantry staples]
flour
rice
olive oil
```

Pass it to `cook shopping-list -a` and the output is sorted by store section, with ingredient aliases resolved. This is an index — a structure that reorganizes the data for faster retrieval, except the "retrieval" here is physical navigation through a grocery store without backtracking.

## Federation as Distributed Search

Your local collection is one node. [recipes.cooklang.org](https://recipes.cooklang.org) is the federated index — a distributed recipe database that aggregates across community GitHub repositories.

Creators host their own data. The federation layer indexes it. You search across the whole network with boolean operators, tag filters, difficulty ranges, and cooking time constraints. No one owns the data centrally; each repository is its own self-contained collection with its own files and its own git history.

This is the distributed database model applied to recipes. The [recipe discovery docs](/docs/use-cases/recipe-discovery/) explain how to get your own collection indexed.

## Why This Works

The obvious objection is that a real database has transactions, indexes, foreign keys, and a query planner. True. This system has none of those things. What it has instead:

**No server to run.** The database is a directory. It starts instantly, requires no configuration, and does not crash.

**No migrations.** Add a new metadata field to a recipe — done. It is available immediately. No schema to update, no columns to add, no downtime.

**Works with Git.** Version control is one `git init` away. You get a full history of every recipe change, the ability to diff versions, branches for recipe experiments, and remote backup. A Postgres database gives you none of this by default.

**Survives any app dying.** The files are yours. When a recipe app shuts down, your recipes still exist. They are readable in any text editor. They are importable into any tool that understands Cooklang — and even tools that do not understand Cooklang can at least display them.

**Every Unix tool works.** `grep`, `wc`, `find`, `sort`, `awk` — they all work on `.cook` files. You can build one-liners against your recipe collection that would require a full ORM in a traditional database setup.

The [shopping workflow docs](/docs/use-cases/shopping/) put the pieces together from a practical standpoint — what it looks like to actually run this system week to week, not just in theory.

## Getting Started

If you have recipes already, the path is: install CookCLI, create a `recipes/` folder, move your recipes in, run `cook search` to see them. The database is operational the moment the files exist.

The [CLI download is at /cli/](/cli/). The full command reference covers everything from search to report templating. The [getting started guide](/docs/getting-started/) walks through the initial setup if you are starting from scratch.

The database you need is the filesystem you already have. You just need the query tools.

-Alex
