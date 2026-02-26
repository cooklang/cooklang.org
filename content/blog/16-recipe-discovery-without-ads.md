---
title: "Recipe Discovery Without the Ads and Life Stories"
date: 2026-02-25
weight: 60
summary: "Modern recipe sites bury recipes under ads, pop-ups, and SEO filler. Cooklang Federation offers a different approach — a searchable index of community-tested recipes with no ads, no tracking, and no stories about someone's trip to Tuscany."
---

You search for "chicken parmesan recipe." The first result has a 2,000-word story about the author's childhood in New Jersey, three video ads, a newsletter popup, and a cookie consent banner. Somewhere below the fold, there's a recipe — but it's been modified to be "unique" enough to avoid duplicate content penalties.

This is recipe discovery in 2026.

## How We Got Here

Recipe sites are advertising businesses that happen to contain recipes. The economics are straightforward: more time on page means more ad impressions. A recipe that takes 30 seconds to read doesn't generate much revenue. A recipe preceded by eight paragraphs of filler, interrupted by video ads, and followed by "you might also like" carousels does.

Search engines reward length and engagement, so recipe authors pad their posts. They also modify recipes to avoid duplication — swapping ingredients, changing ratios, inventing variations. The result is a race to the bottom where the recipes themselves get worse while the content around them gets longer.

This is what we called [the Dishwasher Salmon problem](/blog/the-dishwasher-salmon-problem/) — the pressure to create "unique" content produces recipes nobody asked for, like cooking salmon in a dishwasher.

## What Good Recipe Discovery Looks Like

Good recipe discovery means finding recipes that people actually cook, written by people who actually cook them. No SEO padding, no ad incentives distorting the content, no modifications for uniqueness.

It looks like asking a friend, "What do you make for a weeknight dinner?" and getting a straight answer.

## Cooklang Federation

[Cooklang Federation](https://recipes.cooklang.org) is a searchable index of recipes from the Cooklang community. It works differently from recipe sites:

- **No ads.** The federation is open source and community-run.
- **No filler.** Recipes are stored in [Cooklang format](/docs/spec/) — structured plain text with ingredients, quantities, and steps. Nothing else.
- **Real recipes from real people.** Every recipe in the federation comes from someone's personal collection — their GitHub repository or blog feed. These are recipes people actually cook.

The federation currently indexes **62 active feeds** with recipes from community members worldwide — personal cookbooks, specialized collections (vegetarian, molecular gastronomy, international cuisines), and everything in between.

### How Search Works

Search by keyword, ingredient, tag, or combine them:

- `breakfast` — find breakfast recipes
- `ingredients:tomato` — recipes that use tomatoes
- `tags:italian` — tagged Italian recipes
- `pasta AND tags:italian AND total_time:[0 TO 30]` — Italian pasta dishes under 30 minutes

You can filter by difficulty, servings, and cooking time. Results link directly to the recipe source — the actual `.cook` file — so you see exactly what the author wrote, no wrapper content.

### How It Works Under the Hood

The federation maintains a list of [Atom/RSS feeds and GitHub repositories](https://github.com/cooklang/federation) containing Cooklang recipes. A crawler periodically fetches updates, parses the recipes, and indexes them for full-text search using [Tantivy](https://github.com/quickwit-oss/tantivy).

The architecture is intentionally decentralized. Recipe authors host their own recipes wherever they want — a GitHub repo, their own website, any platform. The federation just makes them discoverable. If the federation disappeared tomorrow, every recipe would still exist at its source.

All configuration is version-controlled. Adding or removing feeds requires a pull request, which creates transparency and an audit trail.

### Add Your Recipes

If you keep your recipes in Cooklang format, you can add them to the federation:

1. **GitHub repository**: Add your repo to [`feeds.yaml`](https://github.com/cooklang/federation) with a pull request. The crawler will index all `.cook` files automatically.
2. **Blog or website**: Generate an Atom feed from your recipes and submit the feed URL.

The pull request goes through CI validation — checking for duplicates, verifying accessibility, and confirming the feed format — before a maintainer merges it.

## The Alternative to Algorithm-Driven Discovery

Recipe recommendation algorithms optimize for engagement, not for cooking. They surface recipes that get clicks, not recipes that produce good food. The federation takes the opposite approach: it surfaces recipes from people who cook, indexed without ranking manipulation.

No recipe in the federation was written to game search rankings. No recipe was padded with filler to increase time on page. Every recipe exists because someone wanted to cook it and chose to share it.

Browse the federation at [recipes.cooklang.org](https://recipes.cooklang.org) or contribute your recipes at [github.com/cooklang/federation](https://github.com/cooklang/federation).

-Alex
