---
title: 'Pantry Management'
weight: 30
description: 'Track what you have so shopping lists only include what you need'
---

CookCLI uses a `pantry.conf` file to track what's already in your kitchen. When you generate a shopping list, items in your pantry are automatically excluded — so you only buy what you actually need.

> Pantry support is only available in CookCLI at the moment.

### The Pantry Configuration File

The file uses TOML format, organized by storage location:

```toml
[freezer]
ice_cream = "1%L"
frozen_peas = "500%g"
frozen_fruit = "2%kg"
ground_beef = { quantity = "1%kg", frozen = "2024-10-15" }
chicken_stock = { quantity = "4%cups", frozen = "2024-10-20" }
spinach = { bought = "2024-11-05", expire = "2024-12-05", quantity = "1%kg" }

[fridge]
milk = { expire = "2024-11-15", quantity = "2%L" }
eggs = "12"
cheese = { expire = "2024-11-20" }
butter = "250%g"
yogurt = { quantity = "500%g", expire = "2024-11-18" }
leftovers_beef_stew = { quantity = "3%portions", made = "2024-11-10" }

[pantry]
rice = "5%kg"
pasta = "1%kg"
flour = "5%kg"
sugar = "2%kg"
salt = "1%kg"
olive_oil = "1%L"
canned_tomatoes = "4%cans"
dried_beans = "2%kg"

[spices]
cumin = { bought = "2024-06-01" }
paprika = { bought = "2024-03-15" }
cinnamon = "1%jar"
black_pepper = "100%g"
```

### How It Works

**Simple tracking**: `rice = "5%kg"` records what you have. If a recipe calls for rice, it won't appear on your shopping list.

**Quantity awareness**: If a recipe needs 500g of flour and you have 5kg, the system knows you're covered. If you need 6 eggs and have none listed, they'll be added to the list.

**Expiration dates**: `milk = { expire = "2024-11-15", quantity = "2%L" }` tracks freshness alongside quantity.

**Frozen goods**: Dates like `frozen = "2024-10-15"` help with stock rotation.

**Leftovers**: Entries like `leftovers_beef_stew` with `made` dates track what needs using up.

### Shopping List Integration

The pantry file plugs directly into the `cook shopping-list` command:

```bash
cook shopping-list --pantry pantry.conf "Monday Dinner.cook" "Tuesday Dinner.cook"
```

The output includes only the ingredients you need to buy, with pantry items already subtracted.

## See Also

- [Shopping Lists](../shopping/) — Full shopping list workflow
- [Meal Planning](../meal-planning/) — Plan meals with pantry awareness
- [CookCLI Commands](/cli/commands/) — Full command reference
