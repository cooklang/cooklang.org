---
title: 'Hosting Recipes as a Static Website'
weight: 17
description: 'Generate a self-contained static website from your recipe collection with one command'
---

`cook build` turns a folder of `.cook` files into a complete static website — HTML, CSS, JavaScript, and a client-side search index — that you can host anywhere or open straight from disk. No server, no database, no build pipeline.

The output is the same browsing experience as [`cook server`](/cli/commands/server/), with dynamic features (shopping list, pantry, editor, scaling) stripped out.

## Quick Start

```bash
cd ~/my-recipes
cook build
open _site/index.html
```

That's it. Your browser opens a fully functional recipe site — including search — running entirely off the local filesystem.

To rebuild after editing recipes, just re-run `cook build`. The command is idempotent.

## When to Use This vs. `cook server`

| Use `cook build` when… | Use `cook server` when… |
|------------------------|--------------------------|
| You want to publish recipes for others to read | You're cooking and want a live, editable site |
| You want zero-cost hosting (GitHub Pages, Netlify) | You're on a single machine or LAN |
| You need offline access on a tablet or phone | You want the shopping-list and pantry features |
| Your recipes change occasionally, not constantly | You want to edit recipes in the browser |

The two commands share the same templates, so a site you serve at home with `cook server` looks identical when published with `cook build`.

## Hosting Options

### GitHub Pages

The most popular free option. Push the generated site to a `gh-pages` branch:

```bash
cook build
cd _site
git init
git add .
git commit -m "Publish recipes"
git remote add origin git@github.com:yourname/recipes.git
git push -f origin main:gh-pages
```

Enable Pages in the repository settings, choose the `gh-pages` branch, and your recipes are live at `https://yourname.github.io/recipes/`.

If the site lives under a subpath (anything other than the domain root), build with `--base-url` so internal links resolve correctly:

```bash
cook build --base-url /recipes/
```

### Netlify or Vercel

Drag and drop the `_site/` folder into Netlify Drop, or wire it up to your Git repo with a build command:

```bash
cook build && mv _site dist
```

Set the publish directory to `dist`.

### Cloudflare Pages, S3, any CDN

Any host that serves static files works:

```bash
aws s3 sync _site/ s3://my-recipes-bucket --delete
```

### USB Stick or Local File

Because internal links are page-relative by default, the site runs straight from `file://`:

```bash
cook build
open _site/index.html
```

Copy `_site/` onto a USB stick, sync it to a tablet, attach it to an email — it just works. No web server needed.

## Automating with GitHub Actions

Publish on every push to `main`:

```yaml
# .github/workflows/publish.yml
name: Publish Recipes

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install CookCLI
        run: |
          curl -L https://github.com/cooklang/cookcli/releases/latest/download/cook-x86_64-unknown-linux-gnu.tar.gz \
            | tar xz
          sudo mv cook /usr/local/bin/

      - name: Build site
        run: cook build --base-url /recipes/

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

## What's Included

The generated site has everything readers need to browse a recipe collection:

- A home page listing recipes and sub-folders
- One page per recipe with ingredients, cookware, timers, and steps
- Recipe images alongside `.cook` files (`.jpg`, `.png`, `.webp`, etc.)
- Menu (`.menu`) pages for meal plans
- Client-side search across all recipes — no server roundtrip
- The same keyboard shortcuts as `cook server` (read-only ones)

## What's Excluded

The static site is read-only. The following dynamic features from `cook server` are intentionally left out:

- Shopping list and pantry pages
- Preferences and sync
- Recipe editor and "New recipe" button
- Recipe scaling controls (output is always 1×)
- "Add to shopping list" buttons

If you need any of these, host the same recipes with `cook server` on a [Raspberry Pi](/docs/use-cases/raspberry-pi/) or another always-on machine.

## Sharing with the Federation

Static sites pair well with the [Cooklang Federation](https://recipes.cooklang.org). Build your site for human readers, and keep the raw `.cook` files in a public Git repository so the federation crawler can pick them up. See [Publishing Your Recipes](/docs/use-cases/publishing-recipes/) for the federation submission process.

## See Also

- [`cook build` command reference](/cli/commands/build/) — all options and outputs
- [`cook server`](/cli/commands/server/) — the live, editable counterpart
- [Publishing Your Recipes](/docs/use-cases/publishing-recipes/) — share via the federation
- [Raspberry Pi Kitchen Server](/docs/use-cases/raspberry-pi/) — host a live server at home
