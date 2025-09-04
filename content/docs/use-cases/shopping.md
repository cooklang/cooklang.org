---
title: 'Shopping Lists'
weight: 10
description: 'Smart grocery shopping with automated list generation'
---

One of the most practical applications of Cooklang is transforming meal planning into efficient shopping trips. Instead of manually writing lists or trying to remember what you need, Cooklang tools automatically generate comprehensive shopping lists from your planned meals.

### From Recipes to Shopping Cart

When you select recipes for the week, Cooklang understands every ingredient needed and combines them intelligently. If Monday's pasta and Thursday's pizza both need mozzarella, your shopping list shows the total amount needed, not separate entries.

This intelligent combining extends to understanding that "olive oil" for sautéing and "extra virgin olive oil" for salad dressing might be the same item in your pantry, depending on your preferences when using ingredient aliases.

### Store Layout Organization

Shopping becomes more efficient when your list matches your store's layout. By organizing ingredients into categories like produce, dairy, and pantry items, you can navigate the store systematically without backtracking.

#### The Aisle Configuration File

Here's how you can organize your shopping list to match your store's layout using an `aisle.conf` file:

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

#### How Aisle Configuration Works

This configuration file maps ingredients to store sections. When generating shopping lists, the system groups items according to these categories, creating a list that follows your natural path through the store.

**Smart Matching**: The system understands variations - "cherry tomatoes" and "Roma tomatoes" both map to the tomatoes entry in produce. "Cheddar" and "mozzarella" both fall under cheese in dairy.

**Unknown Items**: Ingredients not in your configuration appear in an "other" category, reminding you to add them to your aisle map for future efficiency.

**Multiple Store Layouts**: You can maintain different configurations for different stores - one for your regular supermarket, another for the farmer's market, a third for the bulk store. This flexibility accommodates varied shopping patterns.

Some people prefer organizing by store entirely - separating items for the farmers market, bulk store, and regular supermarket. This approach optimizes both time and budget, letting you buy fresh produce at the market while getting bulk grains at warehouse stores.

## Scaling and Portion Management

### Cooking for Different Occasions

The same recipe that feeds your family of four on Tuesday can be scaled up for Saturday's dinner party of twelve. Cooklang handles the math, adjusting every ingredient proportionally while maintaining the recipe's balance.

This scaling intelligence understands context - doubling a soup recipe doubles the salt, but experienced cooks might want to adjust seasonings more conservatively. The system provides the math while leaving room for cook's judgment.

Ingredients can be locked from scaling with `=` sign like that `@salt{=1%tbsp}`.

## Pantry Awareness

### What You Already Have

The most efficient shopping list knows what's already in your pantry. By maintaining a pantry inventory, your shopping lists automatically exclude items you already have, showing only what you need to buy.

This system can track quantities too - if a recipe needs 500g of flour and you have 2kg in the pantry, it doesn't appear on your shopping list. But if you only have 200g, the list might suggest buying more.


## See Also

- [Meal Planning](../meal-planning/) - Plan before you shop
- [Pantry Management](../pantry/) - Track what you have
- [CookCLI Shopping List Command](/cli/commands/shopping-list/) - Technical implementation details
