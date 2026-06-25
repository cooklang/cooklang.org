---
title: 'Frequently Asked Questions'
date: 2021-05-20T19:30:08+10:00
draft: false
weight: 3
summary: The questions we're pretty sure you want to know the answers to.
layout: "blank"
blank: true
---

## Recipes

{{< detail-tag
    "How do I create a new recipe?"
    "A recipe is just a text file using the Cooklang markup language and the .cook file extension. To create a new recipe, just open a text editor and write out the steps! For details on how to use the Cooklang markup language, see the [Cooklang github specification page](/docs/spec/)."
>}}

{{< detail-tag
    "Where do I put a recipe file after I've created it?"
    "When you first install the app, a folder will be created at the root of your iCloud called "Cook". All Cook apps and programs will search that folder (and any sub-folders) for files related to the Cook app."
>}}

{{< detail-tag
    "How do I add pictures to my recipes?"
    `You can add images to your recipe by including a supported image file (.png or .jpg) matching the name of the recipe recipe in the same directory.

    Baked Potato.cook
    Baked Potato.jpg

You can also add images for specific steps by including a step number before the file extension. Step numbers are 1-based, so the first step's image ends in .1.

    Chicken French.cook
    Chicken French.1.jpg
    Chicken French.3.jpg

    `
>}}


{{< detail-tag
    "Can I change the folder that the app uses for recipes?"
    "This feature is not yet supported."
>}}

{{< detail-tag
    "Can I put recipes inside folders, will the app still find it?"
    "Yep. You can bury that .cook file in as many layers of folders as you'd like."
>}}

{{< detail-tag
    "How do I enable Cooklang syntax highlighting in my text editor?"
    "We have instructions for that on our [Docs page](/docs/syntax-highlighting/)."
>}}

{{< detail-tag
    "How do I add community-made recipes?"
    "When you first install the app, you will be given the option to import a few sample recipes. If you would like to add more, check out our [Community page](/cli/help/#fetch) or go directly to our [Community recipes GitHub repository](https://github.com/Cooklang/recipes)."
>}}

{{< detail-tag
    "What are the best-practices when creating a recipe?"
    "Check out our [best-practices page](/docs/best-practices/)."
>}}

{{< detail-tag
    "Can I import a recipe from a link?"
    "This feature is not yet supported."
>}}

{{< detail-tag
    "Do I have to manually create every recipe I want to cook?"
    "No! You can add any recipe you find online in the .cook format to your Cook folder and it will be automatically imported when you open the app."
>}}

{{< detail-tag
    "How do I share recipes I've made with the community?"
    "If you're handy with Git, you can open a pull request to the community recipe repository and we'll add it!"
>}}

{{< detail-tag
    "How do I remove a recipe?"
    "You can remove a recipe by deleting the file from your .cook folder."
>}}

## Shopping lists

{{< detail-tag
    "How do I create a shopping list?"
    "Go to a recipe you plan to cook, and at the top of the ingredients tab will be a button labeled "Add to shopping list". This  will add all of the ingredients for that recipe (and their quantities) to your shopping list."
>}}

{{< detail-tag
    "Can I export a shopping list to another app or format?"
    "In CookApp, it is possible to export a shopping list as an email. Using the CookCLI command line tool, it is possible to export to other data formats (such as Json)."
>}}

{{< detail-tag
    "How do I remove something from the shopping list?"
    "Easy! Just tap and hold on the item in the shopping list, then tap "Remove"."
>}}

{{< detail-tag
    "How do I change the default categories in the shopping list?"
    "The categorization of the shopping list is configured by a simple configuration file."
>}}
