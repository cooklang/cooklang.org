---
title: 'Examples'
date: 2021-05-20T19:27:37+10:00
weight: 6
summary: Cooklang examples covering recipes, metadata, meal planning, shopping lists, and federation.
---

## A Simple Recipe

A recipe with ingredients, cookware, timers, and comments:

```cooklang
---
source: https://www.jamieoliver.com/recipes/eggs-recipes/easy-pancakes/
tags: fun, quick
---

Crack the @eggs{3} into a blender, then add the @flour{125%g},
@milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.

Pour into a #bowl and leave to stand for ~{15%minutes}.

Melt the @butter in a #large non-stick frying pan{} on
a medium heat, then tilt the pan so the butter coats the surface.

Pour in 1 ladle of batter and tilt again, so that the batter
spreads all over the base, then cook for 1 to 2 minutes,
or until it starts to come away from the sides.

Once golden underneath, flip the pancake over and cook for 1 further
minute, or until cooked through.

Serve straightaway with your favourite topping. -- Add your favorite
-- topping here to make sure it's included in your meal plan!
```

## Sections, Notes, and Recipe References

A more complex recipe using sections to organise components, notes for tips, and references to other recipes:

```cooklang
---
title: Stuffed Peppers
tags: [dinner, vegetarian]
servings: 4
prep time: 20 minutes
cook time: 35 minutes
---

> These freeze well. Double the batch and freeze half for a quick weeknight dinner.

= Filling

Cook @rice{200%g} according to package directions.

Sauté @onion{1}(diced) and @garlic{3%cloves}(minced) in @olive oil{2%tbsp}
in a #large skillet{} until softened, about ~{5%minutes}.

Add @canned tomatoes{400%g}, @black beans{240%g}(drained),
@cumin{1%tsp}, and @smoked paprika{1%tsp}. Stir in the cooked rice.

= Assembly

Cut the tops off @bell peppers{4} and remove seeds.
Stuff with the filling and place in a #baking dish{}.

Top each pepper with @cheddar{100%g}(grated).

Bake in a preheated #oven{} at 190°C for ~{30%minutes} until peppers
are tender and cheese is bubbling.

Serve with @./Sauces/Salsa Verde{}.
```

The `@./Sauces/Salsa Verde{}` line references another `.cook` file in your collection — its ingredients are included in shopping lists automatically.

## Meal Planning

A `.menu` file plans meals across multiple days, referencing recipes from your collection:

```cooklang
---
servings: 2
---

== Day 1 ==

Breakfast:
- @./Breakfast/Mexican Style Burrito{2%servings}
- @filter coffee{1%cup} and @tea{1%cup}

Lunch:
- @./Lunches/Spaghetti Bolognese{}
- @./Salads/Boring{2%servings}

Dinner:
- @./Salads/Caprese{2}

== Day 2 ==

-- delivery arrives around 4pm

Breakfast:
- @./Breakfast/Granola{2%servings} with @yogurt{200%g}

Lunch:
- @./Slowcooker/Slow-cooker beef stew{1/2} with @rice{1%cup}(boiled)

Dinner:
- @hake fillet{2}(baked) with @./Sides/Mashed Potatoes{2%servings}

== Snacks ==
- @kefir{2}
- @dates
- @apples

== Batch Prep ==
- @./Freezable/Kotletter{}
```

Generate a combined shopping list for the entire plan:

```bash
cook shopping-list "Plans/Week 1.menu"
```

See [Meal Planning]({{< ref "use-cases/meal-planning" >}}) for the full workflow.

## Shopping Lists

Shopping lists are generated from any recipe or menu file. An `aisle.conf` organises items by store section:

```
[produce]
onions
garlic
bell peppers
tomatoes | cherry tomatoes

[dairy]
milk
cheese | cheddar
yogurt
butter

[pantry]
rice
flour
olive oil | extra virgin olive oil
canned tomatoes
```

```bash
# List for a single recipe
cook shopping-list "Stuffed Peppers.cook"

# Scaled to 8 servings, excluding pantry items
cook shopping-list -a aisle.conf -p pantry.conf "Stuffed Peppers.cook:8"

# Combined list for a whole week
cook shopping-list -a aisle.conf "Plans/Week 1.menu"
```

See [Shopping Lists]({{< ref "use-cases/shopping" >}}) and [Pantry Management]({{< ref "use-cases/pantry" >}}) for details.

## Federation: Discovering and Sharing Recipes

The [Cooklang Federation](https://recipes.cooklang.org) indexes recipes from community members' repositories and makes them searchable. Creators host their own content — the federation just makes it discoverable.

### Discovering recipes

Search by keyword, tag, difficulty, or cooking time:

```
pasta AND tags:italian difficulty:easy
vegan tags:dessert -chocolate
chicken total_time:[0 TO 45]
```

### Publishing your recipes

Put your `.cook` files in a public GitHub repository, then add your repo to the federation:

1. Fork the [federation repository](https://github.com/cooklang/federation)
2. Add your entry to `config/feeds.yaml`:

```yaml
- url: "https://github.com/yourusername/my-recipes"
  title: "My Recipe Collection"
  feed_type: github
  branch: "main"
  enabled: true
  tags: [cookbook, github]
  notes: "Family recipes and weekend experiments"
  added_by: "@yourusername"
```

3. Submit a pull request

The crawler indexes your recipes automatically and checks for updates periodically. You can also publish via [RSS/Atom feeds]({{< ref "use-cases/publishing-recipes" >}}) or any static site.

See [Recipe Discovery]({{< ref "use-cases/recipe-discovery" >}}) and [Publishing Your Recipes]({{< ref "use-cases/publishing-recipes" >}}).

## More

- [Creating Cookbooks]({{< ref "use-cases/cookbook-creation" >}}) — export recipes as LaTeX for PDF cookbooks
- [Reports]({{< ref "use-cases/reports" >}}) — custom template-based exports for cost analysis, nutrition, and more
- [Raspberry Pi Kitchen Server]({{< ref "use-cases/raspberry-pi" >}}) — serve recipes to every device on your network
- [Importing Recipes]({{< ref "use-cases/importing-recipes" >}}) — convert recipes from websites and photos via [cook.md](https://cook.md)
- [Awesome Cooklang Recipes](https://github.com/cooklang/awesome-cooklang-recipes) — community recipe collection
