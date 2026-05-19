---
title: 'Publishing Your Recipes'
weight: 16
description: 'Share your recipes with the Cooklang community through the federation'
---

The [Cooklang Federation](https://recipes.cooklang.org) indexes recipes from community members' repositories and makes them searchable. You host your recipes wherever you want — GitHub, your own website, a blog — and the federation makes them discoverable.

You keep full control. Update, remove, or modify recipes anytime.

## Publishing via GitHub

The simplest approach. Put your `.cook` files in a public GitHub repository:

```bash
mkdir my-cooklang-recipes
cd my-cooklang-recipes
git init

mkdir breakfast lunch dinner desserts
# Add your .cook files to these folders...

git add .
git commit -m "Initial recipe collection"
git remote add origin https://github.com/yourusername/my-recipes.git
git push -u origin main
```

Then add your repository to the federation:

1. Fork the [federation repository](https://github.com/cooklang/federation)
2. Edit `config/feeds.yaml` and add your entry under `feeds:`:

```yaml
- url: "https://github.com/yourusername/my-recipes"
  title: "My Recipe Collection"
  feed_type: github
  branch: "main"
  enabled: true
  tags: [cookbook, github]
  notes: "Family recipes and weekend experiments"
  added_by: "@yourusername"
  added_at: "2025-10-26"
```

3. Submit a pull request

Once merged, the crawler indexes your recipes automatically and checks for updates periodically.

## Publishing via RSS/Atom Feed

For blog-based sharing, create an Atom feed pointing to your `.cook` files:

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:cooklang="https://cooklang.org/feeds/1.0">
  <title>My Recipe Blog</title>
  <link href="https://yourblog.com/feed.xml" rel="self"/>
  <updated>2025-10-26T00:00:00Z</updated>
  <author>
    <name>Your Name</name>
  </author>

  <entry>
    <title>Perfect Sourdough Bread</title>
    <link href="https://yourblog.com/recipes/sourdough"/>
    <id>https://yourblog.com/recipes/sourdough</id>
    <updated>2025-10-26T00:00:00Z</updated>
    <summary>A simple sourdough recipe with detailed instructions</summary>
    <link rel="enclosure"
          href="https://yourblog.com/recipes/sourdough.cook"
          type="text/plain"/>
    <cooklang:tags>bread,baking,sourdough</cooklang:tags>
    <cooklang:difficulty>medium</cooklang:difficulty>
    <cooklang:time total="24h" active="2h"/>
    <cooklang:servings>1 loaf</cooklang:servings>
  </entry>
</feed>
```

Host both the feed and your `.cook` files, then add the feed URL to `config/feeds.yaml` with `feed_type: web`.

## Publishing as a Static Website

The fastest way to publish your collection as a browsable website is `cook build web`. It generates a complete static site — HTML, CSS, search, and all — from your `.cook` files in one command:

```bash
cook build web
# Site written to ./_site — open _site/index.html or upload anywhere
```

Push the output to GitHub Pages, drop it into Netlify, sync it to S3, or copy it to a USB stick. No server, no build pipeline, no extra tools. See [Hosting Recipes as a Static Website](../static-website/) for the full walkthrough including hosting options and a GitHub Actions workflow.

## Integrating with Existing Static Site Generators

If you already run a Hugo, Jekyll, or similar site and want recipes alongside other content, export each recipe to Markdown and let your existing pipeline render it:

```bash
#!/bin/bash
# build-recipes.sh

# Export to Markdown for site pages
for recipe in recipes-source/*.cook; do
  basename=$(basename "$recipe" .cook)
  cook recipe -f markdown "$recipe" > "content/recipes/${basename}.md"
done

# Copy raw .cook files for federation access
cp recipes-source/*.cook static/recipes/

# Build site
hugo  # or jekyll build, etc.
```

For a standalone recipe site, prefer `cook build web` — it ships the same template the federation uses and handles search automatically.

## Recipe Metadata

Include metadata in your `.cook` files to improve discoverability:

```cooklang
---
title: Classic Carbonara
description: An authentic Roman pasta dish
tags: [italian, pasta, quick, dinner]
servings: 4
prep time: 10 minutes
cook time: 15 minutes
difficulty: easy
---
```

## Updating and Removing Recipes

**GitHub**: Edit your `.cook` files, commit, and push. The federation picks up changes on the next crawl.

**RSS/Atom**: Update your `.cook` files and the `<updated>` timestamp in your feed.

**Leaving the federation**: Remove your entry from `feeds.yaml` via pull request, or make your repository private.

## See Also

- [Hosting Recipes as a Static Website](../static-website/) — generate a browsable site with `cook build web`
- [Recipe Discovery](../recipe-discovery/) — how users find your recipes
- [Federation Repository](https://github.com/cooklang/federation) — submit your feed
- [Creating Cookbooks](../cookbook-creation/) — turn recipes into a PDF cookbook
