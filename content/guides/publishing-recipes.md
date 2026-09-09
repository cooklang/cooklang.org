---
title: 'Publishing Your Recipes'
weight: 20
description: 'Register your recipe collection with the Cooklang Federation so anyone can find it, while the files stay on your GitHub or your own site.'
group: share
tools: [GitHub, Cooklang Federation]
---

The [Cooklang Federation](https://recipes.cooklang.org) is a search index, not a host. You keep your `.cook` files wherever you already keep them; the federation's crawler reads them from there and makes them searchable alongside everyone else's. Nothing is copied that you cannot take back: remove the registration, or make the repository private, and your recipes drop out on the next crawl.

There are two ways to register. Pick the one that matches where your recipes live.

| Your recipes are… | Use |
|-------------------|-----|
| In a GitHub repository (or you are happy to put them in one) | [A GitHub feed](#option-a-publish-from-a-github-repository). Nothing to generate; the crawler reads the repo directly. |
| On your own website or blog | [An Atom feed](#option-b-publish-from-your-own-website) that links to each `.cook` file. |

Either way the recipes are also served as a normal website if you want them to be; see [Hosting Recipes as a Static Website](/guides/static-website/).

## Before you start: metadata that helps people find you

The federation reads each recipe's front matter and indexes it, so the ten seconds spent on metadata is what makes a recipe show up for `tags:italian` or `total_time:[0 TO 30]`. Use the [canonical keys](/docs/conventions/#canonical-metadata):

```cooklang
---
title: Classic Carbonara
description: The Roman original, with guanciale and no cream.
tags: [italian, pasta, quick, dinner]
servings: 4
prep time: 10 minutes
cook time: 15 minutes
difficulty: easy
locale: en
---
```

`locale` lets the search filter by language. Run `cook doctor validate` before publishing so a syntax error does not turn into an empty search result.

## Option A: publish from a GitHub repository

### 1. Put the recipes in a public repository

If they are not there yet:

```bash
cd ~/recipes
git init
git add .
git commit -m "Initial recipe collection"
git remote add origin https://github.com/yourusername/recipes.git
git push -u origin main
```

Sub-folders are fine; the crawler walks the whole tree for `.cook` files. To show a picture in search results, put a public URL in the recipe's `image:` front-matter key.

### 2. Register the repository

Registration is a pull request, so there is a review step and a public record of who added what.

1. Fork [github.com/cooklang/federation](https://github.com/cooklang/federation).
2. Open `config/feeds.yaml` and add an entry under `feeds:`:

   ```yaml
   - url: "https://github.com/yourusername/recipes"
     title: "Your Name's Recipes"
     feed_type: github
     branch: "main"
     enabled: true
     tags:
       - cookbook
       - github
     notes: "Family recipes and weekend experiments"
     added_by: "@yourusername"
     added_at: "2026-09-09"
   ```

   `branch` is optional and defaults to the repository's default branch. `tags` describe the collection as a whole and show up on the [Feeds](https://recipes.cooklang.org/feeds) page.

3. Open a pull request. CI validates the YAML and checks the repository is reachable; a maintainer merges it.

After the merge, the crawler indexes the repository on its next run and re-checks GitHub repositories every six hours. You do not need to tell it about new recipes.

## Option B: publish from your own website

If your recipes already live on a site you run, give the federation an Atom feed listing them. The crawler needs three things per recipe: a title, a link to the page, and an `enclosure` link to the raw `.cook` file. Everything else it reads from the file itself.

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:cooklang="https://cooklang.org/feeds/1.0">
  <title>My Recipe Blog</title>
  <link href="https://example.com/"/>
  <link rel="self" href="https://example.com/feed.xml"/>
  <id>https://example.com/</id>
  <updated>2026-09-09T00:00:00Z</updated>
  <author><name>Your Name</name></author>

  <entry>
    <title>Perfect Sourdough Bread</title>
    <id>https://example.com/recipes/sourdough</id>
    <link rel="alternate" href="https://example.com/recipes/sourdough"/>
    <link rel="enclosure" type="text/plain"
          href="https://example.com/recipes/sourdough.cook"/>
    <updated>2026-09-09T00:00:00Z</updated>
    <summary>A weekend loaf with an overnight rise.</summary>
    <cooklang:recipe>
      <cooklang:image>https://example.com/recipes/sourdough.jpg</cooklang:image>
    </cooklang:recipe>
  </entry>
</feed>
```

Notes on the format:

- **The enclosure is the important part.** It must point at the raw Cooklang text with a `text/plain` type. Entries without one are skipped.
- **`<updated>` drives re-indexing.** Bump it when a recipe changes; the crawler only refetches entries whose timestamp moved.
- **`<cooklang:image>`** is optional and overrides any `image` key in the file's front matter. Tags, times, servings and difficulty are read from the `.cook` file, not the feed.
- Static site generators can emit this feed from a template. Hugo, Jekyll, Eleventy and Astro all have Atom examples that need only the enclosure line added. If you generate the site with `cook build web`, the recipe pages already expose the raw file at `recipe/<path>.cook`, so point the enclosure there.

Check the feed with the federation's [validator](https://recipes.cooklang.org/validate), then register it the same way as a GitHub repository, with `feed_type: web`:

```yaml
- url: "https://example.com/feed.xml"
  title: "My Recipe Blog"
  feed_type: web
  enabled: true
  tags:
    - cookbook
  notes: "Bread, mostly"
  added_by: "@yourusername"
  added_at: "2026-09-09"
```

## Updating and unpublishing

- **Change a recipe**: commit and push (GitHub), or update the file and its `<updated>` timestamp (feed). Feeds are re-read hourly and GitHub repositories every six hours.
- **Add a recipe**: same thing. New files in the repository or new entries in the feed are found automatically.
- **Pause**: set `enabled: false` on your entry via a pull request.
- **Leave**: remove the entry, or make the repository private. Indexed copies are dropped when the source disappears.

## See also

- [Recipe Discovery](/guides/recipe-discovery/): what readers see on the other side
- [Hosting Recipes as a Static Website](/guides/static-website/): a browsable site from the same files
- [Federation repository](https://github.com/cooklang/federation): the feed registry and crawler source
- [Version control recipes with Git](/blog/43-version-control-recipes-with-git/): why a repository is a good home for a cookbook
