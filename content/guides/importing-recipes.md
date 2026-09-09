---
title: 'Importing Recipes'
weight: 5
description: 'Bring recipes in from websites, pasted text, photos and social videos, and save them as .cook files you own.'
group: everyday
tools: [cook.md converter, CookCLI, Cook Editor]
---

Most people's recipes are scattered across browser bookmarks, screenshots, a cookbook shelf and a family group chat. Bookmarks rot, screenshots cannot be searched, and copied text loses its structure. Importing turns each of those into a `.cook` file: plain text, with the ingredients, quantities and timers marked up, that works in every Cooklang app and is yours to keep.

There are three ways to import, from quickest to most automated:

| Method | Best for | Needs |
|--------|----------|-------|
| [Prefix the URL with `cook.md/`](#1-the-quick-way-prefix-any-url) | A recipe you found on the web right now | Nothing, not even an account |
| [The converter page](#2-convert-text-photos-and-videos) | Pasted text, cookbook photos, handwritten cards, YouTube and Instagram | A free cook.md account for text; Cook Basic for photos and social video |
| [`cook import`](#3-import-from-the-command-line) | Scripts and bulk imports | CookCLI and an OpenAI API key |

## 1. The quick way: prefix any URL

In your browser's address bar, put `cook.md/` in front of the recipe's full address, including the `https://`:

```
https://cook.md/https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta
```

![Prefixing a recipe URL with cook.md/ and getting back a Cooklang recipe](/guide/cookmd-demo.gif)

A few seconds later you get the recipe as Cooklang, with a **Download .cook** button. Recipe-site conversions are free, unlimited and need no sign-up. The converter reads the structured recipe data that most cooking sites publish, so it works on the large majority of them; if a page has no recipe markup, paste the text instead (step 2).

Save the file into your recipe folder and it shows up in the [mobile app](/app/), the [Cook Editor](/editor/) and `cook server` on the next sync.

## 2. Convert text, photos and videos

For anything that is not a recipe web page, open the converter at [cook.md/cookifies/new](https://cook.md/cookifies/new). It has three tabs:

- **URL**, the same as the prefix trick, for sites where the address-bar method is awkward.
- **Text**: paste anything, from a forum comment to a recipe you dictated to your phone. Free with an account.
- **Photos**: upload up to 10 images of one recipe (JPEG, PNG, WebP or GIF, 10 MB in total). Cookbook pages, index cards, handwritten notes and screenshots all work.

YouTube, TikTok and Instagram links go through the URL tab; the converter pulls the transcript and caption and reconstructs the recipe from those.

Photo and social-video imports use a more expensive AI pipeline, so they come with a plan: one free try without an account, then 50 of each per month on Cook Basic (€4.99/month) and 200 on Cook Pro. Conversions that fail do not count. Recipe-site links and pasted text stay free on every plan. Details are on the [cook.md pricing page](https://cook.md/pricing).

## 3. Import from the command line

CookCLI can do the same conversion locally, which is handy for scripting a bulk import of your bookmarks:

```bash
export OPENAI_API_KEY=sk-...
cook import https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta > "Chicken Bacon Pasta.cook"
```

The conversion step calls OpenAI with your own key, so it costs a fraction of a cent per recipe and works offline from cook.md entirely. Without a key, `--skip-conversion` still fetches the structured recipe data from the page as JSON, which you can convert however you like. See the [`cook import` reference](/cli/commands/import/).

The [Cook Editor](/editor/) has a fourth route: ask CookBot to import a URL, and it writes the file straight into your collection for you to review.

## 4. Check what you got

An import from the BBC Good Food link above comes back looking like this:

```cooklang
---
source: https://www.bbcgoodfood.com/recipes/chicken-bacon-pasta
servings: 4
author: BBC Good Food
time: 30 min
---

Heat @olive oil{1%tbsp} in a large frying pan over medium-high heat. Season @chicken breast{2}(diced) with @salt{} and @pepper{} and cook for ~{5%minutes} until golden.

Add @smoked bacon{4%rashers}(chopped) and fry until crisp. Stir in @garlic{2%cloves}(minced) and cook for ~{1%minute}.

Meanwhile, cook @penne pasta{300%g} in a large pot of salted boiling water according to package directions. Reserve @pasta water{1%cup} before draining.

Stir @creme fraiche{200%ml} and @parmesan{50%g}(grated) into the pan. Add the drained pasta and toss, loosening with reserved pasta water as needed. Serve topped with @fresh basil{a handful}(torn).
```

Worth a glance before you file it away:

- **Front matter.** The `source` is filled in automatically so you always know where a recipe came from. Add `tags:` or a `title:` if you want them; the [canonical metadata](/docs/conventions/#canonical-metadata) list has the keys every app understands.
- **Ingredient names.** Conversion keeps the site's wording. Rename `@creme fraiche` to whatever your other recipes and your `aisle.conf` call it, so shopping lists merge properly. `cook doctor aisle` lists anything that does not match.
- **Timers and cookware.** Sites rarely mark these, so the converter infers them. Fix any it missed with `~{10%minutes}` and `#pan{}`.
- **Servings.** If the site did not state servings, set `servings:` yourself so the recipe scales correctly in meal plans.

Run `cook doctor validate` after a batch import to catch syntax slips in one go.

## See also

- [Getting Started](/docs/getting-started/): where to keep the files and how to sync them
- [Shopping Lists](/guides/shopping/): what a good ingredient name buys you
- [Meal Planning](/guides/meal-planning/): put the imported recipes on the calendar
- [`cook import` reference](/cli/commands/import/)
