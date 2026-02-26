---
title: 'Shopping Lists'
weight: 10
description: 'Generate grocery lists from recipes, organized by store aisle'
---

CookCLI generates shopping lists directly from your `.cook` files. If multiple recipes share ingredients, quantities are combined automatically — two recipes that each need mozzarella produce a single entry with the total amount.

```bash
cook shopping-list "Monday Dinner.cook" "Tuesday Dinner.cook" "Wednesday Dinner.cook"
```

### Organizing by Store Aisle

An `aisle.conf` file maps ingredients to store sections so your shopping list follows your natural path through the store:

```
[produce]
potatoes
tomatoes | cherry tomatoes | Roma tomatoes
onions
garlic
lettuce
carrots
apples
bananas

[dairy]
milk
cheese
yogurt
butter
eggs
Cheddar
cream

[meat & seafood]
chicken
beef
pork
fish
shrimp

[bakery]
bread
bagels
croissants

[pantry]
flour
sugar
rice
pasta
canned tomatoes
beans
olive oil | extra virgin olive oil

[spices & condiments]
salt | sea salt
pepper | black pepper
cumin
paprika
soy sauce
vinegar

[frozen]
frozen vegetables
ice cream
frozen fruit
```

Use it with the shopping list command:

```bash
cook shopping-list -a aisle.conf "Dinner.cook"
```

**Ingredient aliases**: The pipe syntax (`tomatoes | cherry tomatoes | Roma tomatoes`) groups variations under one aisle entry. Similarly, `olive oil | extra virgin olive oil` maps both to the same section.

**Unknown items**: Ingredients not in your config appear in an "other" category — a reminder to update your aisle map.

**Multiple stores**: You can maintain separate configs for different stores — one for the supermarket, another for the farmers market.

### Scaling

Recipes can be scaled when generating lists:

```bash
# Double recipe
cook shopping-list "Dinner.cook:2"

# Scale to 10 servings
cook shopping-list "Party Food.cook:10"
```

Individual ingredients can be locked from scaling with `=`:

```cooklang
Add @salt{=1%tbsp} and @flour{2%cups}.
```

Here, flour scales but salt stays at 1 tbsp regardless of the multiplier.

### Pantry Awareness

With a `pantry.conf` file, shopping lists automatically exclude items you already have:

```bash
cook shopping-list -a aisle.conf -p pantry.conf "Weekly Plan/*.cook"
```

If a recipe needs 500g of flour and your pantry shows 5kg, flour won't appear on the list.

See [Pantry Management](../pantry/) for the full pantry.conf format.

## See Also

- [Meal Planning](../meal-planning/) — plan meals and generate combined lists
- [Pantry Management](../pantry/) — track what you already have
- [CookCLI Shopping List Command](/cli/commands/shopping-list/) — full command reference
