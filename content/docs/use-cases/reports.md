---
title: 'Reports and Data Management'
weight: 40
description: 'Generate custom recipe reports and manage ingredient data with templates'
---

The `cook report` command uses [minijinja](https://github.com/mitsuhiko/minijinja) templates to transform your recipes into any output format — shopping lists with product links, cost breakdowns, nutrition labels, recipe cards, or anything else you can template.

> The report command is currently a prototype feature.

## Basic Usage

```bash
cook report -t recipe-card.jinja 'Pasta Carbonara.cook'
```

A simple recipe card template:

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

## The Database System

The database (`-d` flag) enriches recipes with external data — nutrition, cost, shopping links. It's organized as a directory tree where each ingredient has its own folder:

```
config/db/
├── eggs/
│   └── shopping.yml
├── flour/
│   ├── nutrition.yml
│   └── cost.yml
├── milk/
│   └── shopping.yml
└── butter/
    ├── nutrition.yml
    └── alternatives.yml
```

### Shopping Data Example

Connect ingredients to actual products at specific stores:

```yaml
# config/db/eggs/shopping.yml
supervalu:
  opt_1:
    name: SuperValu Large Fresh Irish Eggs 12 Pack
    url: https://shop.supervalu.ie/product/id-1024956000
    price: €2.99
    price_per_unit: €0.25 each
    quantity: 12 Piece
  opt_2:
    name: Free Range Eggs 6 Pack
    url: https://shop.supervalu.ie/product/id-1024957000
    price: €2.49
```

## Smart Shopping Lists

Combine templates and database to generate shopping lists with product links, excluding pantry items:

```jinja2
# Shopping List for {{ metadata.title }}

items:
{% for ingredient in excluding_pantry(get_ingredient_list(ingredients)) %}
  - name: {{ ingredient.name }}
    amount: {{ ingredient.quantities }}
    link: {{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_1.url') }}
    backup: {{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_2.url') }}
{%- endfor %}
```

Run it:

```bash
cook report \
  -t shopping-list.yaml.jinja \
  'Weekly Meals/*.cook' \
  -d ./config/db \
  -p ./config/pantry.conf
```

## Aisle-Organized Shopping

Group items by store section for efficient shopping:

```jinja2
# Shopping List - {{ scale }}x Recipe

{%- for aisle, items in aisled(excluding_pantry(ingredients)) | items %}

## {{ aisle | titleize }}
{%- for ingredient in items %}
- [ ] {{ ingredient.name | titleize }}: {{ ingredient.quantity }}
  - Primary: {{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_1.name') }}
  - Alternative: {{ db(underscore(ingredient.name) ~ '.shopping.supervalu.opt_2.name') }}
{%- endfor %}
{%- endfor %}

---
### Already in Pantry
{%- for ingredient in from_pantry(ingredients) %}
- {{ ingredient.name }}: {{ ingredient.quantity }}
{%- endfor %}
```

## Cost Analysis

Track recipe costs using database pricing:

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

## Scaling

Scale recipes before processing:

```bash
# Double recipe with smart shopping list
cook report -t smart-shopping.jinja 'Dinner.cook:2' -d ./db -p ./pantry.conf

# Scale to 10 servings with cost analysis
cook report -t cost-analysis.jinja 'Party Food.cook:10' -d ./db
```

## Template Functions

### Pantry Functions
- `excluding_pantry(ingredients)` — filter out pantry items
- `from_pantry(ingredients)` — get only pantry items
- `get_ingredient_list(ingredients)` — normalize ingredient list

### Organization Functions
- `aisled(ingredients)` — group by store aisle
- `db(path, default)` — access database values
- `underscore(text)` — convert to underscore format

### Formatting Filters
- `titleize` — convert to title case
- `format` — Python string formatting
- `round` — round numbers
- `default` — provide fallback values

## Output Formats

Templates can generate any text format:

- **YAML** — for automation and APIs
- **Markdown** — for documentation and sharing
- **HTML** — for web display
- **LaTeX** — for cookbook publishing (see [Creating Cookbooks](../cookbook-creation/))
- **CSV** — for spreadsheet import

Find more example reports [in the repository](https://github.com/cooklang/cooklang-reports/tree/main/test/data/reports).

## See Also

* [CLI Report Command](/cli/commands/report/) — full command reference
* [Shopping Lists](../shopping/) — focused shopping list workflows
* [Pantry Management](../pantry/) — managing your ingredient inventory
