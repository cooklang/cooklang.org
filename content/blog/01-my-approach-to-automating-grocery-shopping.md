---
title: 'How to Automate Grocery Shopping with Plain Text Recipes'
date: 2021-05-20T19:27:37+10:00
weight: 100
summary: How I automated my grocery shopping by creating Cooklang — a markup language that turns recipe files into shopping lists. From sticky notes to command-line automation.
---

I used to buy groceries by wandering through the store, picking things up as I went. It worked when I could physically walk the aisles. When I switched to online ordering, I couldn't do that anymore. I had to know exactly what I needed before I started.

So I began writing meal plans on sticky notes, listing ingredients by hand, then combining them into an order. After a few weeks of this, the developer in me couldn't take it anymore. The process was repetitive and mechanical — exactly the kind of thing a computer should handle.

That's how [Cooklang](/) was born.

## The Idea

What if recipes were plain text files where ingredients were tagged with `@`? Like this:

```cooklang
Then add @salt and @ground black pepper{} to taste.
Poke holes in @potato{2}.
Place @bacon strips{1%kg} on a baking sheet and glaze with @syrup{1/2%tbsp}.
```

The recipe stays readable — you can follow it as-is. But a computer can also parse it, extract every ingredient with its quantity, and build a shopping list automatically.

Because it's plain text, I can store recipes in Git, edit them in any text editor, and sync them across devices with whatever I already use. No database, no app subscription, no vendor lock-in.

## The Tools

A markup language alone isn't useful without tools to process it. I built [CookCLI](/cli/) — a command-line program that reads `.cook` files and does practical things with them.

The one I use most is `shopping-list`. Point it at a few recipe files and it combines all ingredients, grouped by store aisle:

```
$ cook shopping-list Neapolitan\ Pizza.cook Root\ Vegetable\ Tray\ Bake.cook

DRIED HERBS AND SPICES
    dried oregano                 3 tbsp
    dried sage                    1 tsp
    pepper                        1 pinch
    salt                          25 g, 2 pinches

FRUIT AND VEG
    beetroots                     300 g
    carrots                       300 g
    fresh basil                   18 leaves
    garlic                        3 cloves
    onion                         1 large

MILK AND DAIRY
    butter                        15 g
    mozzarella                    3 packs

TINNED GOODS AND BAKING
    chopped tomato                3 cans
    fresh yeast                   1.6 g
```

Output can be JSON or YAML for piping into other programs. CookCLI also includes a [web server](/cli/commands/server/) for browsing recipes from a phone or tablet, and a [search command](/cli/commands/search/) for finding recipes by ingredient.

## My Workflow

I organize recipes into directories that represent meal plans. Generating a shopping list for the week is one command:

```bash
cook shopping-list ./this-week/*.cook
```

I cross off what I already have, then order the rest. The process takes about five minutes instead of the thirty-plus it used to take with sticky notes. More importantly, I buy exactly what I need — no forgotten ingredients, no impulse purchases.

I keep all my recipes in a [Git repository](https://github.com/dubadub/cookbook). They've been evolving for years — adjusting quantities, adding notes, trying variations. Git tracks every change.

**Update (2025):** I've since built a [Rust script](https://github.com/dubadub/cookbook/tree/main/shop-automation) that maps recipe ingredients to products on my grocery store's website, making the ordering process almost fully automatic. The ecosystem has also grown — there are now [mobile apps](/app/), an [Obsidian plugin](/blog/how-to-manage-recipes-in-obsidian-with-cooklang/), a [VS Code extension](https://marketplace.visualstudio.com/items?itemName=nicholasglazer.cooklang-vscode-support), and a [community recipe index](https://recipes.cooklang.org). Check the [getting started guide](/docs/getting-started/) to try it yourself.

-Alexey
