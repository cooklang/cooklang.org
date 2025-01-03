---
title: 'Cooklang – Recipe Markup Language'
date: 2021-05-20T15:14:39+10:00
---

![Recipes](/example.png)

Cooklang and the tools we've built to use it, you can:

* simplify your personal recipe management;
* streamline your shopping routine;
* make cooking more fun.

Here's how the Cooklang ecosystem makes that happen:

* All recipes are human-readable text files.
* Everything is a file. No databases. And you have complete control over your information.
* All the tools are simple, focused, and efficient; the UNIX way.

## Getting Started

**Create a recipe file**, where each line is a step in the recipe. Tag your ingredients with `@` and `{}`, then save your file. For a complete reference on Cooklang, see the [language specification page](/docs/spec).

**Install a recipe viewer.** We support a few tools for viewing Cooklang recipes:
* [The CookCLI program for Mac, Windows, and Linux](/cli/) provides a webserver for presenting your recipes, viewable with any web browser.
* [Native apps for iOS and Android](/app/) allows you to read your recipe files from your device's file system.

**Cook something!** Open a recipe on your viewer of choice, whip out the ingredients, and make something tasty.

## CookCLI

The [Cook CLI](/cli/) command line program provides a suite of tools to create shopping lists and maintain recipes. We've built it to be simple and useful for automating your cooking and shopping routine with existing UNIX command line and scripting tools. It can also function as a webserver for your recipes, making them browsable on any device with a web browser.

Add sample recipes:

```
$ cook seed
$ tree .
.
├── Baked Potato Soup.cook
...
├── Neapolitan Pizza.cook
...
├── README.md
├── Root Vegetable Tray Bake.cook
...
└── config
    └── aisle.conf

3 directories, 15 files
```

Check "Neapolitan Pizza":
```
$ cook recipe read "Neapolitan Pizza.cook"
Metadata:
    servings: 6

Ingredients:
    chopped tomato                3 cans
    dried oregano                 3 tbsp
    fresh basil                   18 leaves
    fresh yeast                   1.6 g
    garlic                        3 cloves
    mozzarella                    3 packs
    parma ham                     3 packs
    salt                          25 g
    tipo zero flour               820 g
    water                         530 ml

Steps:
     1. Make 6 pizza balls using tipo zero flour, water, salt and fresh yeast. Put in a fridge for 2 days.
        [fresh yeast: 1.6 g; salt: 25 g; tipo zero flour: 820 g; water: 530 ml]
     2. Set oven to max temperature and heat pizza stone for about 40 minutes.
        [–]
     3. Make some tomato sauce with chopped tomato and garlic and dried oregano. Put on a pan and leave for 15 minutes occasionally stirring.
        [chopped tomato: 3 cans; dried oregano: 3 tbsp; garlic: 3 cloves]
     4. Make pizzas putting some tomato sauce with spoon on top of flattened dough. Add fresh basil, parma ham and mozzarella.
        [fresh basil: 18 leaves; mozzarella: 3 packs; parma ham: 3 packs]
     5. Put in an oven for 4 minutes.
        [–]

```

Create a shopping list:
```
$ cook shopping-list \
> Neapolitan\ Pizza.cook \
> Root\ Vegetable\ Tray\ Bake.cook
BREADS AND BAKED GOODS
    breadcrumbs                   150 g

DRIED HERBS AND SPICES
    dried oregano                 3 tbsp
    dried sage                    1 tsp
    pepper                        1 pinch
    salt                          25 g, 2 pinches

FRUIT AND VEG
    beetroots                     300 g
    carrots                       300 g
    celeriac                      300 g
    fresh basil                   18 leaves
    garlic                        3 cloves
    lemon                         1 item
    onion                         1 large
    red onion                     2 items
    thyme                         2 springs

MEAT AND SEAFOOD
    parma ham                     3 packs

MILK AND DAIRY
    butter                        15 g
    egg                           1 item
    mozzarella                    3 packs

OILS AND DRESSINGS
    Dijon mustard                 1 tsp
    Marmite                       1 tsp
    cider                         150 ml
    olive oil                     3 tbsp

OTHER (add new items into aisle.conf)
    tipo zero flour               820 g

PACKAGED GOODS, PASTA AND SAUCES
    vegetable stock               150 ml
    water                         530 ml

TINNED GOODS AND BAKING
    cannellini beans              400 g
    chopped tomato                3 cans
    fresh yeast                   1.6 g
    redcurrant jelly              1 tsp
```

Run a web-server:

    $ cook server
    Started server on http://127.0.0.1:9080, serving cook files from /Users/pochho/recipes.

![server](https://user-images.githubusercontent.com/4168619/148116974-7010e265-5aa8-4990-a4b9-f85abe3eafb0.png)

## Mobile apps

While it's convinient to manage recipes on your computer, it's more convinient to use them on your phone while cooking. We created mobile [apps](/app/) for iOS and Android to assist you while cooking and shopping. Simply connect the app to your recipe storage, open a recipe, and start cooking.

![Recipes](/app/recipes.png)
![Recipe](/app/recipe-ingredients.png)
![Shopping list](/app/shopping-list.png)

## Get updates

{{< newsletter-form >}}

## Get involved

We're always looking for help with the project. If you're interested in contributing, please [join our Discord server](https://discord.gg/fUVVvUzEEK) and say hello.
