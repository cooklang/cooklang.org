---
title: 'Reports and Data Management'
weight: 32
description: 'Write a Jinja template once and turn any recipe into a recipe card, a shopping list with product links, a cost breakdown, or whatever else you need.'
group: power
tools: [CookCLI, Jinja templates, Cook Editor]
---

`cook report` renders a recipe through a template. The template is plain text with [Jinja](https://jinja.palletsprojects.com/) placeholders, so the output can be Markdown, HTML, YAML, CSV, LaTeX, or anything else you can type. With a small data folder alongside, templates can also look up prices, product links and nutrition per ingredient, which is how you get a shopping list that links straight to your supermarket's basket.

> `cook report` is a prototype. Everything below is verified against CookCLI 0.35, but variable names may still change between releases.

## What you need

- [CookCLI](/cli/) 0.35 or newer
- A recipe folder. `cook seed ~/recipes` includes a `reports/` folder with starter templates and a small `db/` to play with.

Run everything from the recipe folder:

```bash
cd ~/recipes
```

## 1. Render a recipe card

Create `reports/recipe-card.md.jinja`:

```jinja2
# {{ metadata.title | default("Untitled recipe") }}
{% if metadata.servings %}**Serves:** {{ metadata.servings }}{% endif %}
{% if metadata.tags %}**Tags:** {{ metadata.tags }}{% endif %}

## Ingredients
{% for ingredient in get_ingredient_list(ingredients) -%}
- **{{ ingredient.name | titleize }}**{% if ingredient.quantities %}: {{ ingredient.quantities }}{% endif %}
{% endfor %}
{% if cookware %}
## Cookware
{% for item in cookware -%}
- {{ item.name | titleize }}
{% endfor %}
{% endif %}
## Method
{% for section in sections -%}
{% if section.name %}### {{ section.name }}{% endif %}
{% for step in section -%}
{{ step }}
{% endfor %}
{% endfor %}
```

Render it:

```bash
cook report -t reports/recipe-card.md.jinja "Breakfast/Easy Pancakes.cook"
```

```markdown
# Untitled recipe
**Serves:** 2
**Tags:** breakfast, quick

## Ingredients
- **Eggs**: 3
- **Flour**: 125 g
- **Milk**: 250 ml
- **Sea Salt**: 1 tbsp, pinch
- **Butter**: knob

## Cookware
- Large Non Stick Frying Pan

## Method
1. Crack the 3 eggs into a blender, then add the 125 g flour, 250 ml milk and pinch sea salt, and blitz until smooth.
2. Pour into a bowl and leave to stand for 15 minutes.
...
```

Two things to notice. The title fell back to the default because the sample recipe has no `title:` in its front matter, so a `default` is always worth adding. And sea salt, which the recipe mentions twice, came out as one line with both amounts: that is what `get_ingredient_list()` does. Plain `ingredients` gives you one entry per mention instead, which is what you want for cost sums but not for a card.

The recipe argument is a file path, so include `.cook` and any sub-folder. Scaling works as everywhere else: `"Breakfast/Easy Pancakes.cook:2"`. Redirect to save the result, and name templates after their output (`.md.jinja`, `.html.jinja`, `.yaml.jinja`) so editors highlight them:

```bash
cook report -t reports/recipe-card.md.jinja "Breakfast/Easy Pancakes.cook" > pancakes.md
```

### What the template can see

| Variable | Contents |
|----------|----------|
| `metadata` | The front matter: `metadata.title`, `metadata.servings`, `metadata.tags`, and any key you wrote. |
| `ingredients` | One entry per mention in the recipe. Each has `name`, `quantity` (prints as `125 g`; `quantity.value` is `125`, `quantity.unit` is `g`), and `note` for text in parentheses. |
| `get_ingredient_list(ingredients)` | The same ingredients merged by name. Each has `name` and `quantities`, a list of the amounts found. |
| `cookware` | A list with `name`, `quantity` and `note`. |
| `sections` | A list of sections; each is a list of steps that print as numbered text. `section.name` is set for `== Named ==` sections. |
| `scale` | The scaling factor applied (`1.0` unless you passed `:N`). |

Standard Jinja filters (`default`, `sort`, `join`, `round`, `format`, `length`) all work. CookCLI adds `titleize`, `underscore` (turns `olive oil` into `olive_oil`), `numeric` (parses the number out of a quantity value, including fractions like `1/2`), and `number_to_currency`.

## 2. Shopping list with aisles and pantry

Pass the same config files `cook shopping-list` uses and two helpers become available: `aisled()` groups ingredients by store section, and `excluding_pantry()` / `from_pantry()` split them by what you already have.

`reports/shopping.md.jinja`:

```jinja2
# Shopping list: {{ metadata.title | default("recipe") }} ({{ scale }}x)

{% for aisle, items in aisled(excluding_pantry(ingredients)) | items %}
## {{ aisle | titleize }}
{% for ingredient in items -%}
- [ ] {{ ingredient.name }}{% if ingredient.quantity %}: {{ ingredient.quantity }}{% endif %}
{% endfor %}
{% endfor %}

## Already at home
{% for ingredient in from_pantry(ingredients) -%}
- {{ ingredient.name }}
{% endfor %}
```

```bash
cook report -t reports/shopping.md.jinja "Neapolitan Pizza.cook:2" \
  -a config/aisle.conf -p config/pantry.conf
```

```markdown
# Shopping list: recipe (2.0x)

## Milk And Dairy
- [ ] mozzarella cheese: 200 grams

## Other
- [ ] semolina
- [ ] Pizza Dough: 12 balls
- [ ] San Marzano tomato sauce: 10 tbsp
- [ ] basil leaves

## Already at home
- flour
```

Without `-a` every ingredient lands under `other`; without `-p` nothing is excluded. Unlike `cook shopping-list`, reports do not expand referenced recipes, which is why the dough appears as a line item.

## 3. Add your own data: prices and product links

The datastore is a folder with one sub-folder per ingredient and YAML files inside. Name the folder the way `underscore(ingredient.name)` would, so `olive oil` becomes `olive_oil`:

```
db/
├── eggs/
│   ├── shopping.yml
│   └── cost.yml
├── flour/
│   └── cost.yml
└── olive_oil/
    └── shopping.yml
```

`db/eggs/shopping.yml`, mapping the ingredient to a real product at a real shop:

```yaml
name: Large Free Range Eggs 12 Pack
url: https://shop.example.com/eggs-12
price: 2.99
```

Templates read the datastore with `db(path)`. The path is `<folder>.<file>.<key>`, with further dots for nested keys. A missing file or key prints a warning and returns an empty value, so wrap lookups in `default("", true)` (the `true` makes empty strings count as missing) and most ingredients can stay undocumented:

```jinja2
# Basket for {{ metadata.title | default("recipe") }}

{% for ingredient in get_ingredient_list(ingredients) -%}
{% set key = underscore(ingredient.name) -%}
{% set link = db(key ~ ".shopping.url") | default("", true) -%}
- {{ ingredient.name }} ({{ ingredient.quantities }}){% if link %}: [{{ db(key ~ ".shopping.name") }}]({{ link }}){% endif %}
{% endfor %}
```

```bash
cook report -t reports/basket.md.jinja "Breakfast/Easy Pancakes.cook" -d db
```

```markdown
# Basket for recipe

- eggs (3): [Large Free Range Eggs 12 Pack](https://shop.example.com/eggs-12)
- flour (125 g)
- milk (250 ml)
...
```

Anything YAML can hold can go in the datastore: nutrition per 100 g, storage life, a preferred brand, an allergen flag.

### A cost estimate

Give each ingredient a `cost.yml` with a price per unit, and state the unit so the template only multiplies when the recipe uses the same one:

```yaml
# db/flour/cost.yml
per_unit: 0.0015   # euro per gram
unit: g
```

```jinja2
{% set ns = namespace(total=0) -%}
| Ingredient | Amount | Cost |
|---|---|---|
{% for ingredient in ingredients -%}
{% set key = underscore(ingredient.name) -%}
{% set unit = db(key ~ ".cost.unit") | default("", true) -%}
{% if unit and ingredient.quantity.unit == unit -%}
{% set price = (db(key ~ ".cost.per_unit") | float) * (ingredient.quantity.value | numeric) -%}
{% set ns.total = ns.total + price -%}
| {{ ingredient.name }} | {{ ingredient.quantity }} | €{{ "%.2f" | format(price) }} |
{% else -%}
| {{ ingredient.name }} | {{ ingredient.quantity }} | – |
{% endif -%}
{% endfor -%}
| **Total** | | **€{{ "%.2f" | format(ns.total) }}** |
| **Per serving** | | €{{ "%.2f" | format(ns.total / (metadata.servings | default(1) | int)) }} |
```

```
| Ingredient | Amount | Cost |
|---|---|---|
| eggs | 3 | – |
| flour | 125 g | €0.19 |
| milk | 250 ml | €0.30 |
| sea salt | pinch | – |
| butter | knob | – |
| sea salt | 1 tbsp | – |
| **Total** | | **€0.49** |
| **Per serving** | | €0.24 |
```

The unit guard matters: `numeric` cannot turn `pinch` or `knob` into a number and stops the render if asked to. Keep recipes and datastore in the same units (grams and millilitres are the easy choice) and the coverage grows with each `cost.yml` you add.

## 4. Use them from the Cook Editor

The [Cook Editor](/editor/) runs the same templates with a live preview that updates as you type, which is a much faster loop for developing a template than re-running the command. See [custom recipe reports in the editor](https://cook.md/blog/custom-recipe-reports).

## Ideas

- **Recipe cards for printing**: an HTML template with your own CSS, then print to PDF from the browser.
- **A weekly menu email**: run a template over a `.menu` file and pipe the Markdown into your mail command.
- **Nutrition labels**: the [nutrition reports](https://github.com/cook-md/cooklang-reports-nutrition) package adds `aggregate_nutrition()` and friends, with per-serving totals and reference-intake percentages.
- **CSV for a spreadsheet**: one line per ingredient with quantity and cost, imported into the household budget.

More templates live in the [cooklang-reports](https://github.com/cooklang/cooklang-reports/tree/main/test/data/reports) repository.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Failed to read recipe file` | Pass the path including `.cook` and the sub-folder, if any. |
| `metadata.title` is empty | The recipe has no `title:` in its front matter. Use `default(...)`. |
| `key '...' not found in datastore` | Check the folder is named like `underscore(ingredient.name)` and the file and key names in the path. Add `default("", true)` to keep the output clean. |
| `aisled` or `excluding_pantry` is undefined | Pass `-a` or `-p`; the helpers only exist when their config is loaded. |
| `could not parse numeric` or `invalid float literal` | A quantity such as `pinch` reached a number filter. Guard with the unit check above, or skip ingredients without a numeric amount. |
| `too many arguments` on `db(...)` | `db` takes one argument. Apply `default(...)` as a filter instead. |

## See also

- [`cook report` reference](/cli/commands/report/)
- [Shopping Lists](/guides/shopping/): the built-in list, if templates are more than you need
- [Pantry Management](/guides/pantry/): the pantry file the helpers read
- [Creating Cookbooks](/guides/cookbook-creation/): the Typst and LaTeX exporters for print
- [Reports and dashboards](/blog/45-recipe-reports-and-dashboards/) on the blog
