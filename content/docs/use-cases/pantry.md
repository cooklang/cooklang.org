---
title: 'Pantry Management'
weight: 30
description: 'Transform your pantry from chaos to culinary command center'
---

A well-managed pantry is the foundation of confident cooking. It's the difference between last-minute grocery runs and spontaneous delicious meals. Cooklang transforms pantry management from mental burden to systematic practice, ensuring you always know what you have, what you need, and what you can make.

#### The Pantry Configuration File

> Only works in CookCLI at the moment

Here's how a `pantry.conf` file tracks your inventory using TOML format:

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

#### How Pantry Tracking Works

This configuration serves multiple purposes:

**Simple Tracking**: Items like `rice = "5%kg"` simply note what you have and how much. When a recipe needs rice, the system knows you have it in stock.

**Expiration Management**: Entries like `milk = { expire = "2024-11-15", quantity = "2%L" }` track both amount and freshness. The system can alert you to use items before they spoil and prioritize recipes using soon-to-expire ingredients.

**Frozen Goods Tracking**: The freezer section with dates like `frozen = "2024-10-15"` helps rotate stock properly. First in, first out becomes automatic rather than archaeological.

**Shopping List Integration**: When generating shopping lists, the system automatically excludes items in your pantry. If a recipe needs 500g of flour and you have 5kg, it won't appear on your shopping list. But if you need 6 eggs and have none, they'll be added.

**Leftover Management**: Items like `leftovers_beef_stew` with `made` dates help track what needs using. This prevents the guilty fridge clean-out of mystery containers.

True inventory knowledge goes beyond presence to include quantity and condition. Knowing you have pasta is good; knowing you have 1kg of penne in the pantry is better. This precision enables confident meal planning without kitchen archaeology.

## Categories and Zones

### Physical Organization

Pantry organization reflects cooking patterns. Baking ingredients cluster together - flour, sugar, baking powder within reach of each other. Asian cooking essentials group separately from Mediterranean staples. This physical organization speeds cooking while reducing mental load.

Zones can reflect frequency too. Daily-use items at eye level, weekly ingredients within easy reach, occasional items higher or lower. The pantry layout becomes a heat map of your cooking habits.

### Storage Strategies

Different ingredients demand different storage. Grains need protection from pests, oils from light, potatoes from onions. Understanding these needs prevents waste while maintaining quality.

The freezer extends pantry possibilities. Nuts stay fresh longer frozen. Bread freezes beautifully. That bumper crop of basil becomes frozen pesto. The freezer isn't just for leftovers but strategic ingredient preservation.

## See Also

- [Shopping Lists](../shopping/) - Restocking your pantry efficiently
- [Meal Planning](../meal-planning/) - Planning with pantry awareness
- [CookCLI Commands](/cli/commands/) - Technical tools for pantry tracking
