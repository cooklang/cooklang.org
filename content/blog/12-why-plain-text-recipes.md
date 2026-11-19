---
title: "Why Plain Text Recipes Beat Databases Every Time"
date: 2025-01-20
lastmod: 2026-11-19
weight: 70
summary: "After years of building recipe apps with databases, I discovered that plain text files solve the real problems better. Here's why the future of digital recipes isn't in the cloud - it's in your text editor."
description: "After years building database recipe apps, why plain-text .cook files solve the real problems better — the case for recipes in a text editor, not the cloud."
categories: ["Format and Design"]
---

Plain text has been readable since the 1960s. Recipe apps do not last that long.

Yummly is the example I keep coming back to. Whirlpool bought it in 2017, laid off the team in spring 2024, and switched the site and the app off that December. Evernote closed its Food app in September 2015. In both cases people had spent years saving recipes into an app that then went away.

Recipes are a bad thing to lose. They are small, you collect them over decades, and you want to pass them on. So the question I ask of any recipe tool is: what is left when the tool is gone? With a database app the answer is whatever the export button gave you, if there was one. With plain text the answer is everything, because the recipes were never inside the tool in the first place.

That is the whole argument. The rest of this post is what it looks like in practice and what you give up. (For the wider case, see [the plain-text canon — why recipes belong in it](https://cook.md/blog/plain-text-canon).)

## What a database does to a recipe

A typical recipe app stores one recipe as rows spread over several tables:

```sql
recipes_table: id, title, prep_time, cook_time...
ingredients_table: id, recipe_id, name, quantity, unit...
instructions_table: id, recipe_id, step_number, text...
recipe_tags_table: recipe_id, tag_id...
```

That layout is good for the app. It can filter by tag and sort by cooking time. But you never see those tables. You see the screens the app built on top of them, and you can do what those screens allow and nothing else.

Here is the same recipe as a Cooklang file:

```cooklang
---
title: Simple Pasta
servings: 2
prep time: 5 minutes
cook time: 15 minutes
tags: [italian, quick, vegetarian]
---

Boil @water{2%l} with @salt{1%tsp} in a large #pot.

Add @spaghetti{200%g} and cook for ~{12%minutes}.

Drain and toss with @olive oil{2%tbsp} and @parmesan{50%g}.
```

This is the whole recipe. No part of it lives anywhere else. You can read it without any software, and a parser can still pull out the ingredients, amounts, cookware and timers, which is where shopping lists and scaling come from.

## What you get from files

### You own them without an export step

The files sit in a folder on your disk. Any editor opens them: VS Code, Notepad, vim. Switching to a different app means pointing it at the same folder.

My own recipes have been files in one folder since 2021. The tools around them changed a lot in that time. The first Cooklang command-line tool was written in Swift and the current one is in Rust. The recipes didn't notice.

### History comes for free

Put the folder in Git and every change to every recipe is recorded. If somebody "improves" the carbonara with cream, the diff shows it:

```diff
-Take the pan off the heat and pour in the @eggs{3}, beaten.
+Take the pan off the heat and pour in the @eggs{3}, beaten, and @double cream{100%ml}.
```

You can see what changed and when, take it back with one command, or keep both versions as two files. There is more on this in [Version Control Your Recipes with Git](/blog/43-version-control-recipes-with-git/).

### Sharing needs no account

A recipe is a piece of text. Paste it into an email or a message and the other person can cook from it, because the markup still reads as ordinary sentences. Nobody has to install anything.

My own collection is a public repository. This is [the carbonara](https://github.com/dubadub/cookbook/blob/main/Dinners/Carbonara.cook). Open the link and you have the recipe.

### Ordinary tools work on them

Every tool that works on text works on your recipes. To find everything that mentions tomatoes:

```bash
grep -rli --include='*.cook' tomato .
```

My collection is about 200 recipes, more than I have published, and about 250 KB in total. On my laptop that command goes through all of it in about a tenth of a second. A database would not be slower. The point is that at this size speed stops being a reason to need one.

When you want search that understands recipes, [CookCLI](/cli/) has it:

```bash
cook search chicken rice
```

That lists the recipes that mention both, best matches first.

### Two people can edit the same collection

With the folder in Git, two people can change different recipes, or different lines of the same recipe, and both sets of changes are kept. If you both change the same line, Git stops and shows you the two versions next to each other, and you choose.

## What you give up

Plain text is not free, and it would be dishonest to pretend otherwise.

**There is no form to fill in.** You type the recipe and add the `@` marks yourself. It takes a few recipes to get used to. For recipes that already exist on a website there are importers that do the conversion, and the [importing guide](/guides/importing-recipes/) goes through them.

**Photos live next to the file, not in it.** Save `Carbonara.jpg` beside `Carbonara.cook` and the Cooklang apps show the picture with the recipe. It works, but it is one more file to keep track of.

**Text search finds words, not facts.** `grep` can find "tomato". It cannot answer "vegetarian and under 30 minutes" unless you were consistent with your tags and times. Tools that read the metadata can.

**Scaling needs a tool.** A text file does not multiply itself. `cook recipe "Simple Pasta:2"` prints the recipe doubled, and the apps have a servings control.

**The files do not sync themselves.** Dropbox, iCloud Drive, Syncthing and Git all work, because to them these are ordinary files. I also run a paid sync service for the Cooklang apps, and I hold it to the same rule: it moves files around, and if you stop paying, the files are still yours. I wrote about that in [recipe sync without the lock-in](https://cook.md/blog/recipe-sync-without-lock-in).

## Meal plans are files too

Once recipes are files, a meal plan is one more file that points at them:

```cooklang
==Monday==

Dinner: \
- @./Dinners/Carbonara{}

==Tuesday==

Dinner: \
- @./Asian/Pad Thai{2} -- guests coming
```

Save it as `this-week.menu`, run `cook shopping-list this-week.menu`, and you get one shopping list for everything in it. The [Meal Planning guide](/guides/meal-planning/) covers the format.

## Making the switch

1. **Export what you can** from the app you use now. [Migrating Your Recipes to Cooklang](/blog/28-migrating-recipes-to-cooklang/) covers the common apps and formats.
2. **Write new recipes in Cooklang.** Don't convert the whole collection first.
3. **Convert old ones when you next cook them.** There is no deadline.
4. **Use any text editor.** Notepad is fine.
5. **Sync however you already sync files.**

New to the format? The [beginner's guide to plain-text recipes](/blog/33-plain-text-recipes-beginners-guide/) walks through converting your first recipe in five minutes. If you want the technical framing — your filesystem *as* a queryable database — see [a plain text recipe database you already know how to use](/blog/38-plain-text-recipe-database/).

## The ten-year test

Pick the recipe app you use now and imagine the next ten years. The company is sold. The price goes up. The app stops getting updates and one day no longer opens on a new phone. All of these have happened to recipe apps.

Now imagine the same ten years with a folder of text files. Every one of those events can happen to any Cooklang tool, mine included, and the folder is still there and still opens.

That is why I keep recipes in plain text. I don't think files are clever. I think they are the only place where a recipe I write today is likely to still open in thirty years.

-Alexey
