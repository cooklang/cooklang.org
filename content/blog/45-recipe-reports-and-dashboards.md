---
title: "Build Custom Recipe Reports with CookCLI and Templates"
date: 2026-03-24
weight: 50
summary: "CookCLI has a template system that turns .cook files into shopping lists with store links, cost breakdowns, aisle-organized lists, and CSV exports. This post walks through the cook report command, the ingredient database, and real working templates."
---

Your `.cook` files already contain structured ingredient data — names, quantities, units. The `cook report` command lets you turn that structured data into anything: a shopping list with product URLs, a cost breakdown per serving, a LaTeX recipe card, a CSV for a spreadsheet. It uses a Jinja2-style template engine called minijinja, so the output format is entirely up to you.

Note: `cook report` is currently a prototype feature. The API may change as it matures, but the core template system is already capable enough to be worth building on.

## The Basics

The simplest thing you can do is render a recipe card. Given a recipe file:

```cooklang
---
title: Pasta Carbonara
servings: 4
time: 30 min
---

Boil @spaghetti{400%g} in salted water until al dente.

Fry @guanciale{150%g} in a #pan{} until crisp.

Whisk @eggs{4}, @pecorino romano{80%g}, and @black pepper{1%tsp} in a bowl.

Combine pasta with guanciale off the heat. Add egg mixture and toss quickly.
```

And a template at `recipe-card.jinja`:

```jinja2
# {{ metadata.title }}
**Servings:** {{ metadata.servings }} | **Time:** {{ metadata.time }}

## Ingredients
{%- for ingredient in ingredients %}
- {{ ingredient.quantity }} {{ ingredient.unit }} {{ ingredient.name }}
{%- endfor %}

## Instructions
{% for section in sections %}
{% for content in section %}
{{ content }}
{%- endfor %}
{%- endfor %}
```

Run:

```bash
cook report -t recipe-card.jinja 'Pasta Carbonara.cook'
```

The template variables available in every template are:

- `metadata` — frontmatter fields (`title`, `servings`, `time`, plus anything you define)
- `ingredients` — list of objects with `name`, `quantity`, and `unit`
- `sections` — recipe sections containing the step content
- `scale` — the scaling factor (1.0 by default)

That is the full data model. Everything else in the template system is about querying and transforming these.

## The Ingredient Database

Shopping list generation requires more than what is inside the recipe file. You need store links, prices, and aisle assignments. The ingredient database handles this.

Create a `config/db/` directory. Each ingredient gets a folder, and YAML files inside it hold whatever data you want attached to that ingredient:

```
config/db/
├── eggs/
│   └── shopping.yml
├── flour/
│   ├── nutrition.yml
│   └── cost.yml
├── guanciale/
│   └── shopping.yml
└── spaghetti/
    ├── cost.yml
    └── shopping.yml
```

A `shopping.yml` for eggs might look like:

```yaml
supervalu:
  opt_1:
    name: SuperValu Large Fresh Irish Eggs 12 Pack
    url: https://shop.supervalu.ie/product/id-1024956000
    price: €2.99
    price_per_unit: €0.25 each
    quantity: 12 Piece
```

Inside a template, access database values with `db(path, default)`. The path uses dot notation with underscore-converted ingredient names:

```jinja2
{{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_1.name') }}
```

The `underscore()` function converts `"canned tomatoes"` to `"canned_tomatoes"` to match filesystem paths. The `db()` function takes an optional default as a second argument, which is useful when not every ingredient has database entries yet.

## Practical Reports

### Smart Shopping List

A shopping list that links to specific products and skips things you already have in your pantry:

```jinja2
# Shopping List: {{ metadata.title }}

{%- for ingredient in excluding_pantry(ingredients) %}
- [ ] {{ ingredient.name | titleize }}: {{ ingredient.quantity }} {{ ingredient.unit }}
  {%- set link = db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_1.url', '') %}
  {%- if link %}
  - [Buy at SuperValu]({{ link }})
  {%- endif %}
{%- endfor %}
```

`excluding_pantry(ingredients)` filters out anything marked as a pantry item in your pantry config. Run with a pantry config file:

```bash
cook report -t shopping-list.jinja 'Pasta Carbonara.cook' -d ./config/db -p ./config/pantry.conf
```

The `from_pantry(ingredients)` function does the inverse — useful if you want to generate a "check your pantry for these items" section.

### Cost Analysis

Track what each recipe actually costs to make:

```jinja2
# Cost Report: {{ metadata.title }}

## Ingredient Costs
{%- set total_cost = namespace(value=0) %}
{%- for ingredient in ingredients %}
{%- set item_cost = db(underscore(ingredient.name) ~ ".cost.per_unit", 0) * ingredient.quantity %}
* {{ ingredient.name }}: ${{ "%.2f"|format(item_cost) }}
{%- set total_cost.value = total_cost.value + item_cost %}
{%- endfor %}

**Total Cost:** ${{ "%.2f"|format(total_cost.value) }}
**Cost per Serving:** ${{ "%.2f"|format(total_cost.value / metadata.servings) }}
```

This reads from `cost.yml` files in your database. A `cost.yml` might be:

```yaml
per_unit: 0.08
unit: g
```

Run with the database path:

```bash
cook report -t cost-analysis.jinja 'Pasta Carbonara.cook' -d ./config/db
```

### Aisle-Organized Shopping List

If you always shop the same store in the same order, an aisle-organized list saves significant time. The `aisled()` function groups ingredients by the aisle assignment in your database:

```jinja2
{%- for aisle, items in aisled(excluding_pantry(ingredients)) | items %}

## {{ aisle | titleize }}
{%- for ingredient in items %}
- [ ] {{ ingredient.name | titleize }}: {{ ingredient.quantity }}
  - Primary: {{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_1.name') }}
{%- endfor %}
{%- endfor %}
```

The `| items` filter converts the grouped dictionary to a list of `(aisle, items)` pairs. The result is a list organized by your actual path through the store — produce, then dairy, then dry goods — rather than alphabetical or recipe order.

Process a whole week of recipes at once:

```bash
cook report -t shopping-list-aisled.jinja 'Weekly Meals/*.cook' -d ./config/db -p ./config/pantry.conf
```

`get_ingredient_list(ingredients)` normalizes and deduplicates the combined ingredient list across multiple recipes, so you get one entry for "spaghetti 800g" rather than two separate entries from two pasta recipes.

## Scaling

The `cook report` command accepts the same scaling syntax as other cook commands. Append `:N` to the filename to scale by a factor of N:

```bash
cook report -t cost-analysis.jinja 'Party Food.cook:10' -d ./db
```

The `scale` variable in the template reflects the multiplier. Ingredient quantities are already scaled when the template receives them — you do not need to multiply manually. This means a cost report for a party of 40 is a single command, and the per-serving cost stays accurate.

## Output Formats

The template engine outputs whatever text the template produces. The format is entirely determined by your template — there is no built-in output format.

**Markdown for sharing:**
```bash
cook report -t recipe-card.jinja 'Carbonara.cook' > Carbonara.md
```

**YAML for programmatic use:**
```bash
cook report -t ingredients.yaml.jinja 'Carbonara.cook' > ingredients.yaml
```

**CSV for spreadsheets:**

```jinja2
name,quantity,unit,cost
{%- for ingredient in ingredients %}
{{ ingredient.name }},{{ ingredient.quantity }},{{ ingredient.unit }},{{ db(underscore(ingredient.name) ~ ".cost.per_unit", 0) * ingredient.quantity }}
{%- endfor %}
```

**HTML for display:**

```jinja2
<article>
  <h1>{{ metadata.title }}</h1>
  <ul>
  {%- for ingredient in ingredients %}
    <li>{{ ingredient.quantity }} {{ ingredient.unit }} {{ ingredient.name }}</li>
  {%- endfor %}
  </ul>
</article>
```

The available template filters help with formatting across output types: `titleize` for title case, `format` for number formatting (Python-style `"%.2f"|format(n)`), `round` for rounding, and `default` for fallback values when database entries are missing.

## Where to Go From Here

The `cook report` command is a prototype — expect the function signatures and template API to evolve. But the core idea is stable: structured recipe data plus a template engine produces whatever output your workflow needs.

The existing community templates at [github.com/cooklang/cooklang-reports](https://github.com/cooklang/cooklang-reports/tree/main/test/data/reports) are worth reading before writing your own. They cover more edge cases than a blog post can.

Further reading:

- [report command reference](/cli/commands/report/) — full flag reference and current template API
- [reports use case](/docs/use-cases/reports/) — full documentation with more template examples
- [shopping workflow](/docs/use-cases/shopping/) — how the pantry config and shopping workflow fits together
- [pantry management](/docs/use-cases/pantry/) — pantry configuration reference

-Alex
