---
title: 'Pantry Management'
weight: 14
description: 'Keep a plain-text inventory of what is in your kitchen so shopping lists only contain what you actually need to buy.'
group: everyday
tools: [CookCLI, cook server]
---

A pantry file is a short list of what you have on hand: staples, spices, what is in the fridge and freezer. Once it exists, every shopping list you generate subtracts it, and CookCLI can tell you what is running low, what is about to expire, and which recipes you could cook tonight without going to the shop.

> Pantry tracking currently works in CookCLI and the `cook server` web UI. The mobile app does not read `pantry.conf` yet.

## What you need

- [CookCLI](/cli/) 0.35 or newer
- A recipe folder. `cook seed ~/recipes` gives you a sample collection with a pantry file already in place.

Run everything from inside the recipe folder:

```bash
cd ~/recipes
```

## 1. Create the pantry file

The pantry lives at `config/pantry.conf` next to your recipes and uses [TOML](https://toml.io/). Sections are storage locations; each line is one ingredient. Start small: the staples you never want to see on a shopping list.

```toml
[fridge]
butter = { quantity = "250%g", expire = "2026-10-15" }
eggs = { quantity = "12", bought = "2026-09-07" }
milk = { quantity = "2%l" }

[pantry]
flour = { quantity = "1%kg", low = "200%g" }
"olive oil" = { quantity = "750%ml" }
"tinned tomatoes" = { quantity = "4%tins" }
rice = "2%kg"

["spice rack"]
salt = { quantity = "1%kg" }
"black pepper" = { quantity = "200%g" }
"smoked paprika" = { quantity = "some" }
```

Format rules:

- **Names with spaces need quotes**, both for items (`"olive oil"`) and sections (`["spice rack"]`). Names are matched case-insensitively against recipe ingredients, so use the same wording your recipes do.
- **Quantities use Cooklang notation**: `"250%g"`, `"2%l"`, `"12"` for a plain count. `"some"` and `"unlim"` are accepted for things you never run out of, such as tap water or garden herbs.
- **A bare string is shorthand** for `{ quantity = "..." }`. Use the table form when you want more attributes.
- Optional attributes: `low` (threshold that flags the item as running out), `expire` and `bought` (dates as `YYYY-MM-DD`).

You can also let CookCLI write the file. `cook pantry add` creates `config/pantry.conf` and the section if they are missing:

```bash
cook pantry add fridge milk --quantity "2%l" --low "500%ml"
cook pantry add pantry flour --quantity "1%kg" --low "200%g"
cook pantry add "spice rack" "smoked paprika" --quantity "50%g"
```

## 2. Check what CookCLI sees

```bash
cook pantry list
```

```
Pantry Items:
=============

FRIDGE:
  • butter - 250%g (expires: 2026-10-15)
  • eggs - 12 (bought: 2026-09-07)
  • milk - 2%l

PANTRY:
  • flour - 1%kg
  • olive oil - 750%ml
  • tinned tomatoes - 4%tins
  • rice - 2%kg
...
```

To see how much of your recipe collection the pantry already covers:

```bash
cook doctor pantry
```

```
Scanned 14 recipes, found 76 unique ingredients

28 ingredients from recipes are in your pantry:
  ✓ arborio rice
  ✓ black pepper
  ✓ butter
  ...
```

Ingredients that show up in recipes but not in the pantry are the candidates for step 1.

## 3. Generate a shopping list that skips the pantry

Nothing extra to do. As soon as `config/pantry.conf` exists, `cook shopping-list` subtracts it:

```bash
cook shopping-list "Neapolitan Pizza" "Breakfast/Easy Pancakes"
```

The sample pantry holds water and olive oil, so neither appears in the output even though both recipes need them. The subtraction is quantity-aware: 125 g of flour against 1 kg in the pantry disappears, but 1.5 kg against 1 kg would leave 500 g on the list.

**Units have to match.** A recipe that needs `250%ml` of milk is not compared with a pantry entry of `2%l`; CookCLI prints `Unit mismatch for 'milk'` and leaves the milk on the list to be safe. Write pantry quantities in the unit your recipes use, or use bare counts for things like eggs.

To see the full list regardless of the pantry, or to point at a pantry file kept elsewhere:

```bash
cook shopping-list --ignore-pantry "Neapolitan Pizza"
cook shopping-list --pantry ~/holiday-house.conf "Neapolitan Pizza"
```

## 4. Keep it current

The pantry is only useful if it is roughly right. Two habits keep it that way.

**After shopping, update quantities.** Only the flags you pass change:

```bash
cook pantry update fridge milk --quantity "3%l"
cook pantry update pantry "tinned tomatoes" --quantity "6%tins" --bought 2026-09-09
cook pantry remove fridge "sour cream"
```

**Before shopping, ask what is running out.** Items at or below their `low` threshold, and items with a quantity of zero, are flagged:

```bash
cook pantry depleted
```

```
Depleted or Low Stock Items:
============================

PANTRY:
  • tinned tomatoes (0)

SPICE RACK:
  • ground cumin (50%g)
  • smoked paprika (50%g)
```

Items without a `low` threshold are judged by a heuristic, so set thresholds on the things you care about.

Expiry dates get their own check:

```bash
cook pantry expiring --days 14
```

```
Items Expiring Within 14 Days:
==============================

Expiring Soon:
  • butter - 2026-09-15 (in 6 days) [fridge]
```

## 5. Cook from the pantry

The reverse question is often more useful on a weeknight: what can I make right now?

```bash
cook pantry recipes
```

```
Recipes You Can Make with Pantry Items:
========================================

✓ Complete Matches (all ingredients available):
  • Easy Pancakes
```

Loosen the match to see recipes that are one shop away:

```bash
cook pantry recipes --partial --threshold 60
```

```
⚠ Partial Matches (60%+ ingredients available):
  • Mexican Style Burrito (60% available)
    Missing: tortillas, cheddar cheese, fresh red chilli, lime
  • Pizza Dough (60% available)
    Missing: fresh yeast, oil
```

`cook pantry plan` goes one step further and ranks ingredients by how many of your recipes they unlock, which is a good way to decide what to stock.

## Machine-readable output

Every `cook pantry` command takes `-f json` or `-f yaml` before the subcommand, handy for a home dashboard or a script that nags you about expiring food:

```bash
cook pantry -f json expiring --days 7
```

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Cannot parse pantry quantity for 'x': some` | Harmless. Words like `some` are accepted but cannot be subtracted from; the item still counts as "in stock". |
| Pantry item keeps appearing on shopping lists | Check the name matches the recipe ingredient exactly (spaces, plural) and that the units match. |
| `cook pantry` finds no file | It looks in `./config/pantry.conf` then `~/.config/cook/pantry.conf`. Run from your recipe folder or pass `-b <path>`. |
| TOML parse error | Quote names containing spaces, and put every item under a `[section]` header. |

## See also

- [Shopping Lists](/guides/shopping/): the other half of this workflow
- [Meal Planning](/guides/meal-planning/): plan the week around what needs using up
- [`cook pantry` reference](/cli/commands/pantry/): all subcommands and flags
- [Pantry file format](/docs/conventions/#pantry-configuration) in the conventions
