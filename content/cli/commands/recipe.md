---
title: 'Recipe'
weight: 10
description: 'CookCLI Recipe command documentation'
date: 2025-09-04T17:51:42+00:00
---


The `recipe` command parses and displays Cooklang recipe files. It's your primary tool for viewing recipes, validating syntax, and converting between formats.

## Basic Usage

```bash
cook recipe "Neapolitan Pizza.cook"
```

File extension is optional, that works too:

```bash
cook recipe "Neapolitan Pizza"
```

This displays the recipe in a human-readable format with ingredients, steps, and metadata clearly organized.

## Menu Files

CookCLI also supports `.menu` files for meal planning. Menu files can reference multiple recipes and organize them by meals or days:

```bash
# View a menu file
cook recipe "2 Day Plan.menu"

# Scale entire menu (scales all referenced recipes)
cook recipe "2 Day Plan.menu:2"
```

Menu files use the same scaling notation as regular recipes, and the scaling applies to all recipe references within the menu.

## Reading Recipes

The simplest way to view a recipe:

```bash
# View a recipe file
cook recipe "Pasta Carbonara.cook"

# Read from stdin
cat recipe.cook | cook recipe

# View with explicit path
cook recipe ./recipes/italian/Pizza.cook
```

## Scaling Recipes

Scale recipes on the fly using the `:` notation or the `--scale` flag:

```bash
# Double a recipe
cook recipe "Pizza.cook:2"

# Scale to 1.5x
cook recipe "Cake.cook" --scale 1.5

# Quarter a recipe
cook recipe "Soup.cook:0.25"
```

All ingredient quantities are automatically adjusted:

```
Original:                    Scaled x2:
flour         500 g    →     flour         1 kg
water         300 ml   →     water         600 ml
```

## Output Formats

Export recipes in different formats for various uses:

### Human-Readable (Default)

```bash
cook recipe "Neapolitan Pizza"
```

Output:
```
 Neapolitan Pizza

source: https://www.stadlermade.com/how-to-pizza-dough/neapolitan/
servings: 6

Ingredients:
  semolina
  Pizza Dough              (recipe: Shared/Pizza Dough)     6 balls
  flour
  semolina
  San Marzano tomato sauce                                  5 tbsp
  basil leaves
  mozzarella cheese                                         100 grams

Cookware:
  outdoor oven
  spatula

Steps:
 1. Preheat your outdoor oven so it’s around 450/500°C (842/932°F).
     [-]
 2. Prepare your pizza toppings because from now on you wanna work fast.
    Sprinkle some semolina on your work surface.
     [semolina]
...
```

### JSON Format

Perfect for processing with other tools:

```bash
cook recipe "Neapolitan Pizza" -f json | jq '.ingredients'
```

Output:
```json
[
  {
    "name": "semolina",
    "alias": null,
    "quantity": null,
    "note": null,
    "reference": null,
    "relation": {
      "relation": {
        "type": "definition",
        "referenced_from": [],
        "defined_in_step": true
      },
      "reference_target": null
    },
    "modifiers": ""
  },
  ...
```

### YAML Format

```bash
cook recipe "Neapolitan Pizza" -f yaml
```

### Markdown Format

Great for documentation or sharing:

```bash
cook recipe "Neapolitan Pizza" -f markdown > recipe.md
```

### Cooklang Format

Regenerate clean Cooklang markup:

```bash
cook recipe "Neapolitan Pizza" -f cooklang
```

## Saving Output

Write the output to a file:

```bash
# Save as JSON
cook recipe "Neapolitan Pizza" -f json -o pizza.json

# Save as Markdown
cook recipe "Neapolitan Pizza" -f markdown -o pizza.md

# Format is inferred from extension
cook recipe "Neapolitan Pizza" -o pizza.yaml
```

## Pretty Printing

For JSON and YAML outputs, use `--pretty` for formatted output:

```bash
cook recipe "Neapolitan Pizza" -f json --pretty
```

## Recipe Discovery

CookCLI can find recipes by name without the full path:

```bash
# Searches in current directory and subdirectories
cook recipe "Pizza"

# Automatically adds .cook extension
cook recipe "Pasta Carbonara"

# Searches in recipe directories
cook recipe "Neapolitan Pizza"
```

## Advanced Examples

### Recipe Analysis Pipeline

Combine with UNIX tools for analysis:

```bash
# Count total ingredients across all recipes
for recipe in *.cook; do
  cook recipe "$recipe" -f json
done | jq -s '[.[].ingredients[].name] | group_by(.) | map({name: .[0], count: length})'
```

### Batch Processing

Process multiple recipes:

```bash
# Convert all recipes to Markdown
for recipe in *.cook; do
  name=$(basename "$recipe" .cook)
  cook recipe "$recipe" -f markdown -o "docs/${name}.md"
done

# Validate all recipes
for recipe in *.cook; do
  echo "Checking $recipe..."
  cook -vvv recipe "$recipe" > /dev/null || echo "Error in $recipe"
done
```

### Recipe Comparison

Compare scaled versions:

```bash
# Compare original and doubled recipe
diff <(cook recipe "Neapolitan Pizza") <(cook recipe "Neapolitan Pizza:2")
```

## Common Issues

### Recipe Not Found

If a recipe isn't found by name, try:

1. Escaping whitespaces
2. Checking you're in the right directory

## See Also

* [Shopping List](shopping-list.md) – Create shopping lists from recipes
* [Doctor](doctor.md) – Validate recipe syntax and references
* [Search](search.md) – Find recipes by content
