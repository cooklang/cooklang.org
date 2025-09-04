---
title: 'Reports and Data Management'
weight: 40
description: 'Generate custom recipe reports and manage ingredient data with templates'
---

Cooklang's report system transforms recipes into any format you need through powerful templates and data management. Whether you're creating shopping lists, nutrition labels, recipe cards, or custom exports, the report command combined with the database system provides complete control over your recipe data.

## The Report System

The `cook report` command uses Jinja2 templates to generate custom outputs from your recipes. This flexibility means you can create anything from simple ingredient lists to complex meal planning documents.

### Basic Report Generation

Start with a simple template to create a recipe card:

```bash
cook report -t recipe-card.jinja 'Pasta Carbonara.cook'
```

The template receives comprehensive recipe data including ingredients, steps, metadata, and more. You can format this data however you need:

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

The database (`db`) system enriches your recipes with additional data like nutritional information, costs, and shopping details. This data lives in a structured directory that the report system can access.

### Database Structure

Your database is organized as a directory tree where each ingredient has its own folder containing various data files:

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

The shopping data connects ingredients to real products at specific stores:

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

Combine reports and database to create intelligent shopping lists that link to actual products:

### The Template

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

### Using the Template

```bash
cook report \
  -t shopping-list.yaml.jinja \
  'Weekly Meals/*.cook' \
  -d ./config/db \
  -p ./config/pantry.conf
```

This generates a YAML shopping list with direct links to products, excluding items already in your pantry.

## Pantry Management

The pantry configuration tracks what you already have, preventing duplicate purchases:

```toml
# config/pantry.conf
[pantry]
flour = '5%kg'
salt = '1%kg'
olive_oil = '1%L'

[fridge]
milk = { quantity = '2%L', expire = '10.05.2024' }
eggs = '12'
butter = '200%g'

[freezer]
frozen_peas = '500%g'
ground_beef = { quantity = '1%kg', expire = '05.06.2024' }
```

## Advanced Report Examples

### Cost Analysis Report

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

### Nutrition Label

Generate nutrition facts from your database:

```jinja2
## Nutrition Facts
Servings: {{ metadata.servings }}

| Nutrient | Per Serving | % Daily Value |
|----------|-------------|---------------|
{%- for ingredient in ingredients %}
{%- set nutrition = db(underscore(ingredient.name) ~ '.nutrition', {}) %}
{%- if nutrition %}
| Calories | {{ nutrition.calories / metadata.servings }} | {{ (nutrition.calories / 2000 * 100) | round }}% |
| Protein | {{ nutrition.protein / metadata.servings }}g | {{ (nutrition.protein / 50 * 100) | round }}% |
| Carbs | {{ nutrition.carbs / metadata.servings }}g | {{ (nutrition.carbs / 300 * 100) | round }}% |
{%- endif %}
{%- endfor %}
```

### Smart Shopping with Aisles

Organize by store layout for efficient shopping:

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
- ✓ {{ ingredient.name }}: {{ ingredient.quantity }}
{%- endfor %}
```

## Template Functions

The report system provides powerful functions for recipe manipulation:

### Pantry Functions
- `excluding_pantry(ingredients)` - Filter out pantry items
- `from_pantry(ingredients)` - Get only pantry items
- `get_ingredient_list(ingredients)` - Normalize ingredient list

### Organization Functions
- `aisled(ingredients)` - Group by store aisle
- `db(path, default)` - Access database values
- `underscore(text)` - Convert to underscore format

### Formatting Filters
- `titleize` - Convert to title case
- `format` - Python string formatting
- `round` - Round numbers
- `default` - Provide fallback values

## Practical Workflows

### Weekly Meal Planning

1. Create templates for different views:
   - Shopping list with links
   - Cost breakdown
   - Prep schedule
   - Nutrition summary

2. Generate all reports at once:
```bash
for recipe in Weekly/*.cook; do
  cook report -t shopping.jinja "$recipe" -d ./db >> weekly-shopping.md
  cook report -t cost.jinja "$recipe" -d ./db >> weekly-cost.md
  cook report -t nutrition.jinja "$recipe" -d ./db >> weekly-nutrition.md
done
```

### Recipe Scaling with Data

Scale recipes while maintaining data connections:

```bash
# Double recipe with smart shopping list
cook report -t smart-shopping.jinja 'Dinner.cook:2' -d ./db -p ./pantry.conf

# Scale to 10 servings with cost analysis
cook report -t cost-analysis.jinja 'Party Food.cook:10' -d ./db
```

### Export Formats

Create templates for different export formats:

- **YAML**: For automation and APIs
- **Markdown**: For documentation and sharing
- **HTML**: For web display
- **LaTeX**: For cookbook publishing
- **CSV**: For spreadsheet import

## Building Your Database

Start simple and grow your database over time:

1. **Begin with essentials**: Add shopping links for frequently used ingredients
2. **Add nutrition data**: Include calories, macros for meal planning
3. **Track costs**: Monitor recipe expenses and budget
4. **Store alternatives**: List substitute ingredients
5. **Include metadata**: Add tags, categories, dietary info

## Tips and Best Practices

### Database Organization
- Use consistent naming (underscore format)
- Group related data in subdirectories
- Version control your database
- Share databases with others

### Template Development
- Start with simple templates
- Test with various recipes
- Use default values for missing data
- Create reusable template components

### Workflow Integration
- Automate report generation
- Chain multiple reports together
- Export to different formats
- Integrate with other tools

## See Also

* [CLI Report Command](/cli/report) – Detailed command reference
* [Shopping Lists](shopping) – Focused shopping list workflows
* [Meal Planning](meal-planning) – Planning multiple meals
* [Pantry Management](pantry) – Managing your ingredient inventory
