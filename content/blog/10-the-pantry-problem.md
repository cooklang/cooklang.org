---
title: "The Pantry Problem"
date: 2025-09-04
lastmod: 2026-11-19
weight: 75
description: "Why your kitchen is a distributed database problem, and how treating it like one changes everything"
categories: ["Recipe Workflows"]
---

I realised something was wrong with how I manage food when I opened my third jar of cumin. I don't love cumin that much. I had forgotten about the other two.

A pantry is an inventory spread over a cupboard, a fridge and a freezer, and the only index is in your head. Human memory is bad at this. You remember that you made a chickpea curry last month. You don't remember whether you replaced the chickpeas afterwards. So you buy another can to be safe, and later find two behind the rice.

Trying harder to remember doesn't fix it. Writing it down does, as long as the list is in a form a program can read. In Cooklang that is one text file.

## The file

The pantry lives in `config/pantry.conf` inside your recipe folder. Here is an example:

```toml
[pantry]
rice = "2%kg"
"tin tomatoes" = { quantity = "2%tins", low = "1%tins" }
"olive oil" = { quantity = "100%ml", low = "200%ml" }
flour = { quantity = "1000%g", low = "200%g" }
"coconut milk" = "400%ml"

["spice rack"]
"ground cumin" = { quantity = "3%jars", bought = "2026-09-12" }
salt = "1%kg"

[fridge]
milk = { quantity = "1%l", expire = "2026-11-22" }
eggs = { quantity = "12", bought = "2026-11-15" }

[freezer]
"chicken stock" = { quantity = "1%l", bought = "2026-10-04" }
pesto = { quantity = "200%g", bought = "2026-09-20" }
```

Sections are the places where food is kept, and you name them as you like. Each line is one item. A bare string is the amount. The longer form takes four attributes: `quantity`, `low` (the level at which you want to be warned), `bought` and `expire`. CookCLI warns about any other attribute, so stick to these four.

## Shopping lists that know what you have

This is the part that pays for the typing. Once the file exists, `cook shopping-list` takes it into account. Here are a Thai green curry and pancakes without a pantry:

```
$ cook shopping-list --plain --ignore-pantry "Thai Green Curry" "Breakfast/Easy Pancakes"
coconut oil       1 tbsp
green curry paste 3 tbsp
coconut milk      400 ml
vegetable stock   100 ml
...
egg               3
flour             125 g
milk              250 ml
salt              pinch, 1 tbsp
butter            knob
```

And with the example pantry:

```
$ cook shopping-list --plain "Thai Green Curry" "Breakfast/Easy Pancakes"
 WARN Unit mismatch for 'milk': recipe needs 'ml', pantry has 'l'
 WARN Unit mismatch for 'salt': recipe needs 'tbsp', pantry has 'kg'
 WARN Unit mismatch for 'salt': recipe needs '', pantry has 'kg'
coconut oil       1 tbsp
green curry paste 3 tbsp
vegetable stock   100 ml
...
egg               3
milk              250 ml
salt              pinch, 1 tbsp
butter            knob
```

Coconut milk and flour are gone from the list, because the pantry has enough of both. The rest of the output shows where it is strict:

- **Names have to match.** The recipe says `egg` and the pantry says `eggs`, so eggs stay on the list. Use the same words your recipes use.
- **Units have to match.** The recipe wants milk in `ml` and the pantry has it in `l`. CookCLI does not convert between them. It prints a warning and leaves milk on the list to be safe. Salt stays for the same reason: a kilo in the pantry cannot be compared with a tablespoon or a pinch. That is also why flour is written as `1000%g` in the example and not `1%kg`.
- **It is quantity-aware.** 125 g of flour against 1000 g disappears. 1500 g against 1000 g leaves 500 g to buy.

## What needs using first

Printed dates are one thing. The date that matters is the one after which you will throw the food out, and you can write that in `expire`:

```
$ cook pantry expiring --days 7
Items Expiring Within 7 Days:
================================

Expiring Soon:
  • milk - 2026-11-22 (expires in 3 days) [fridge]
```

The opposite question is what you can cook tonight without going to the shop:

```
$ cook pantry recipes --partial --threshold 50
Recipes You Can Make with Pantry Items:
========================================

⚠ Partial Matches (50%+ ingredients available):
  • Easy Pancakes (60% available)
    Missing: butter, sea salt
```

CookCLI does not yet put the two together. It will not tell you "the spinach expires on Friday, here are three recipes that use it". You read the first list and decide yourself.

## Running low

Give an item a `low` level and it is flagged before it runs out:

```
$ cook pantry depleted
Depleted or Low Stock Items:
============================

PANTRY:
  • olive oil (100%ml) [low when < 200%ml]
```

It is worth running before you write the shopping list.

## The freezer

The freezer is where food goes to be forgotten. A foil parcel with no label might be fish and might be cake.

There is no special attribute for the day something was frozen, and `bought` does the job. The pesto in the example went in on 2026-09-20, and `cook pantry list` shows that date next to it, so the oldest things are easy to spot and get used first.

## What it does not do

Nothing updates the file when you cook. If you use two tins of tomatoes, the pantry still says two until you change it:

```bash
cook pantry update pantry "tin tomatoes" --quantity "0"
```

So the file is only as good as your habit of keeping it. The moment that works is while you put the shopping away, when everything is already in your hands.

Two more limits. The mobile app does not read `pantry.conf` yet, so this works in CookCLI and in the `cook server` web page. And as the milk shows, units are compared as written.

## Start small

My own `pantry.conf` is short. It lists staples: rice, oats, pasta, tins, oil, flour. Almost nothing from the fridge is in it.

That is the level I would start at. Put in the things you always have and don't want to see on every shopping list. Add dates only for food you have actually thrown away before. Then look after a month at whether you kept it up to date.

The tool matters less than the habit. You can use Cooklang's pantry.conf (the [Pantry](https://plugins.cook.md/cooklang/pantry) plugin for [Cook Editor](/editor/) gives it a proper view), a spreadsheet, or a notebook. The [Pantry Management guide](/guides/pantry/) has every command.

None of this stops you picking up a third jar of cumin in the shop. But if the jars are in the file, the shopping list knows about them, and cumin stays off it.

-Alexey
