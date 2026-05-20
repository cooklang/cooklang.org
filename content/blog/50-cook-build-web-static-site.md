---
title: "Publish Your Recipe Collection as a Static Site with `cook build web`"
date: 2026-05-20
weight: 60
summary: "CookCLI can now turn your recipe folder into a self-contained static website — host it on GitHub Pages, Netlify, an S3 bucket, or just open the HTML file directly."
description: "The new `cook build web` command compiles a Cooklang recipe collection into a read-only static site you can host anywhere or browse offline."
---

If you keep your recipes as `.cook` files, you already have something most recipe apps don't: a folder you fully control. The new `cook build web` command does the obvious next thing — turns that folder into a website you can share.

No server. No database. Just HTML, CSS, and JavaScript you can drop on any static host or open straight from disk.

## What it does

`cook build web` walks your recipe directory and generates a self-contained site that mirrors the browsing experience of `cook server`. Recipe pages, menus, directory listings, search — all there, all rendered ahead of time.

```bash
cook build web
```

That writes a complete site to `./_site`. Open `_site/index.html` in a browser and you're done.

Because the output is read-only, a few features from `cook server` are intentionally left out:

- Shopping list and pantry
- The recipe editor and "New recipe" button
- Recipe scaling (output is always 1×)
- Sync and preferences

What you do get: every recipe page, every menu, search across the whole collection (running entirely in the browser via a generated index), images, and the raw `.cook` source linked from each recipe page.

## Publishing to GitHub Pages

The most useful real example. From your recipes directory:

```bash
cook build web

cd _site
git init
git add .
git commit -m "site"
git branch -M gh-pages
git remote add origin git@github.com:yourname/recipes.git
git push -f origin gh-pages
```

Enable Pages on the `gh-pages` branch in the repo settings and your collection is live. Internal links default to page-relative paths, so no base URL configuration is needed — the same `_site/` folder works on Pages, on Netlify, or opened directly from disk.

Re-run `cook build web` whenever you edit recipes. The command is idempotent; commit the diff.

## Other hosts

```bash
# Netlify: drag and drop _site/ into the Netlify UI

# Static S3 bucket
aws s3 sync _site/ s3://my-recipes-bucket --delete

# USB stick / offline / file://
open _site/index.html
```

If you need to host under a subpath (like `example.com/recipes/`), pass `--base-url /recipes/`. Otherwise, leave it off — relative links handle every other case.

## Heads-up: the command name changed

If you were using the very first release of this feature, the command was just `cook build`. It's now `cook build web`.

The reason: `build` is shaping up to be a family of commands. Static site is the first target; printable cookbooks and other artifacts will live alongside it. Nesting under a subcommand now means we won't have to reshape the CLI later.

Update any scripts or aliases:

```bash
# before
cook build _site

# now
cook build web _site
```

`cook build --help` shows the available targets.

## When to use which

`cook server` is still the right tool for daily use on your own machine — editing, shopping list, scaling, sync. It runs locally and gives you the full app.

`cook build web` is for everything that isn't that: putting your recipes on the internet, sharing a snapshot with someone, archiving a collection to a USB stick, or generating a site that survives without any Cooklang software installed.

Both read the same `.cook` files. You don't have to choose one over the other — `server` for cooking, `build web` for publishing.

## Try it

Update CookCLI to the latest release:

```bash
brew install cookcli   # or `brew upgrade cookcli` if you've installed it before
# or grab the latest binary from https://github.com/cooklang/cookcli/releases
```

Then from any folder with `.cook` files:

```bash
cook build web
open _site/index.html
```

That's it. Full reference is in [the docs](https://github.com/cooklang/cookcli/blob/main/docs/build.md).

-Alexey
