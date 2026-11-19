---
title: "Tandoor vs Mealie vs KitchenOwl: Choosing a Self-Hosted Recipe Manager in 2026"
date: 2026-03-24
lastmod: 2026-11-19
weight: 44
summary: "An honest comparison of three popular self-hosted recipe managers — Tandoor, Mealie, and KitchenOwl. Setup complexity, UI, recipe import, meal planning, mobile experience, and data portability."
description: "Tandoor vs Mealie vs KitchenOwl, compared honestly: setup, UI, recipe import, meal planning, mobile, and data portability. Pick the right self-hosted recipe manager."
categories: ["Comparisons"]
---

Three recipe managers you run yourself. All Docker-based. All actively maintained. All free to self-host. And yet they make quite different decisions about what matters. (Mealie and KitchenOwl are AGPL-3.0. Tandoor is AGPL-3.0 with a Commons Clause that forbids selling it, so it is source-available rather than open source in the strict sense.)

Mealie optimizes for polish and ease of use. Tandoor optimizes for features and flexibility. KitchenOwl optimizes for household collaboration and mobile. If you are a developer setting up a home kitchen system and trying to figure out which one to actually run, here is how they compare.

(We make Cooklang, which takes a completely different approach — plain text files rather than a web app. More on that at the end. This comparison focuses on these three web-based managers.)

## Quick Overview

**Mealie** ([github.com/mealie-recipes/mealie](https://github.com/mealie-recipes/mealie)) is a Python/FastAPI backend with a Vue.js frontend. It is probably the most approachable of the three — the UI is clean, web scraping works well, and the API is documented via OpenAPI. SQLite by default, PostgreSQL if you need it. Large community, a release roughly every ten days. (See our full [Mealie review](/blog/40-mealie-review/) for a closer look.)

**Tandoor Recipes** ([github.com/TandoorRecipes/recipes](https://github.com/TandoorRecipes/recipes)) is a Django + Vue.js application, on its 2.x line since mid-2025 with a rewritten frontend. Its official setup uses PostgreSQL. It is the most feature-rich option here: keywords, importers for more than twenty other apps and formats, private recipes and share links, and nutrition and price figures calculated from the foods in a recipe. The trade-off is complexity — more to configure, more to learn.

**KitchenOwl** ([github.com/TomBursch/kitchenowl](https://github.com/TomBursch/kitchenowl)) is built differently — Flutter for the frontend, a Flask (Python) backend, native apps on iOS and Android and desktop builds as well. It is focused on the household: shared shopping lists, meal planning, and expense tracking together. Simpler than the other two on the recipe management side, but the best mobile experience by a significant margin.

## Comparison by Category

### Setup and Deployment

All three deploy via Docker, so the baseline is the same: a `docker-compose.yml`, a few environment variables, a reverse proxy if you want HTTPS.

KitchenOwl and Mealie are the simplest. Both use SQLite by default, so there is no separate database to run, and both support PostgreSQL if you want it. Mealie documents how to move from one to the other through its backup and restore.

Tandoor's official Docker setup runs PostgreSQL next to the app. SQLite is supported, but the docs say production should always use PostgreSQL, and some search features need it. Tandoor also has more configuration surface — environment variables for features, AI providers, the nutrition database — and more moving parts overall. Not difficult for someone comfortable with Docker, but noticeably more involved than the other two.

### UI and User Experience

Mealie has the most polished web interface. Responsive, visually clean, with a cook mode that puts each step next to the ingredients it uses. If someone in your household is not particularly technical, Mealie is the easiest to hand them.

Tandoor's interface is functional and dense. You can tell it is built for power users — there is a lot visible on screen and a lot of configuration accessible. The recipe editor is detailed and flexible, but the learning curve is real.

KitchenOwl's web UI is intentionally simpler, because the web UI is not the primary interface. The native mobile apps are. On mobile, KitchenOwl is noticeably better than the other two.

### Recipe Import

All three import from a URL — paste a link to a recipe page, and the app parses the title, ingredients, steps, and an image. All three build on the same open source `recipe-scrapers` library, so they handle most major cooking sites reasonably well, though no scraper is perfect, and you will occasionally need to clean up results. Each also has some form of AI-assisted import if you configure a provider.

The difference is in moving a collection from another app. Tandoor has importers for more than twenty apps and formats, including Mealie, Paprika, Nextcloud Cookbook and Cooklang. Mealie has a shorter list of migrations from other apps. KitchenOwl only imports its own JSON export.

### Meal Planning

All three include a calendar-based meal planner. You assign recipes to days, generate a shopping list from the plan.

Tandoor is the most flexible here — it supports calendar export (iCal) and has more options for how meal plans are structured. If you want to integrate your meal plan with a calendar application, Tandoor is the only one that makes this straightforward.

Mealie's meal planner is clean and easy to use, with automatic shopping list generation from the plan. Good enough for most households.

KitchenOwl covers the basics. Not the selling point, but it works.

### Shopping Lists

KitchenOwl is genuinely strong here, and it shows — this is what the app was designed around. Shopping lists sync in real time across all household members. Everyone sees the same list, updates propagate immediately, and the app works partially offline which matters when you are in a store with spotty cell coverage.

Mealie generates shopping lists from meal plans and allows manual additions. Other people's changes appear within a few seconds, and the list keeps working without a connection. Solid implementation, gets the job done.

Tandoor supports shopping lists ordered by supermarket category, synced automatically between everyone who has the list open (it checks every few seconds; the interval is a setting). More configurable than Mealie's but requires more setup to get the aisle groupings right.

### Multi-User and Household Support

All three support multiple users. The design emphasis differs.

KitchenOwl is built around the household concept from the ground up. Shared lists, collaborative shopping, expense tracking — the whole model assumes multiple people interacting with the same data in real time.

Mealie has groups with households inside them, and permissions set per user (administrator, invite, manage the household and so on). Well-suited for a family where different people have different levels of access.

Tandoor has four roles (guest, user, admin, superuser), private recipes that only you and the people you share them with can see, and share links for single recipes. Its own docs call the permission system basic and advise against giving accounts to people you don't trust.

### Mobile Experience

KitchenOwl wins clearly. Native apps on both iOS and Android mean the interface is built for touch from the ground up, and the shopping list keeps working, in part, without a signal. The gap between a native app and a responsive web app is noticeable when you are in the kitchen with wet hands.

Mealie and Tandoor are both responsive web applications that can be installed as progressive web apps. Tandoor's keeps recently opened recipes on the device for offline use; Mealie's keeps the shopping list usable offline. Neither has an official native app, and it shows at the margins.

### API and Integrations

Mealie has the best developer story here. The OpenAPI documentation is complete, the REST API is well-structured, and there is an active community building integrations. If you want to script against your recipe collection or build something on top of the API, Mealie is the easiest starting point.

Tandoor has an API as well. Like Mealie, each instance serves its own generated API reference; there is no API guide on the docs site beyond authentication.

KitchenOwl documents a REST API with an OpenAPI spec and has its own Home Assistant integration, installed through HACS. Mealie's Home Assistant integration is part of Home Assistant itself.

### Data Portability

This is worth taking seriously before you commit. All three store your recipes in their database, not in files you own directly.

Mealie exports a recipe as JSON, as a ZIP with its images, or as a PDF, and an admin can download a full backup. Tandoor is generous on the way in and narrow on the way out: its docs list its own format, Saffron and RecipeSage as working exports, and say importing is prioritised over exporting. KitchenOwl exports a household as JSON, with recipes, items and expenses.

In all three cases, your data lives in a database that the application manages. Backups mean running the application's export or backup, not just copying recipe files. This is a reasonable trade-off for the features you get — just go in with eyes open.

### Resource Usage

None of the three publishes minimum requirements for running it, so I won't rank them on numbers I don't have. What the projects do say: all three publish 64-bit ARM images, so a recent Raspberry Pi works. Mealie and Tandoor no longer build 32-bit ARM images, which rules out older Pis. Tandoor's standard setup runs a PostgreSQL container next to the app, where the other two can run on SQLite alone.

## Summary

| | Mealie | Tandoor | KitchenOwl |
|---|---|---|---|
| **Backend** | FastAPI (Python) | Django (Python) | Flask (Python) |
| **Database** | SQLite or PostgreSQL | PostgreSQL recommended, SQLite possible | SQLite or PostgreSQL |
| **Setup complexity** | Low | High | Low |
| **Web UI polish** | High | Medium | Medium |
| **Recipe import (URL)** | Yes | Yes, plus 20+ app importers | Yes |
| **Meal planning** | Calendar UI | Calendar UI + export | Basic |
| **Shopping lists** | Synced, usable offline | Category-sorted, synced | Real-time, partly offline |
| **Multi-user** | Groups + households | Roles, private recipes, share links | Household-first |
| **Mobile** | Web app (PWA) | Web app (PWA) | Native apps |
| **API** | OpenAPI | OpenAPI | OpenAPI |
| **Data export** | JSON, ZIP, PDF, full backup | Own format and a few others | Household JSON |
| **Licence** | AGPL-3.0 | AGPL-3.0 + Commons Clause | AGPL-3.0 |
| **Hosted option** | No (a separate paid product from its creator) | Yes, from the project | No |

## Recommendations by Use Case

**Household with shared shopping lists and mobile-first use:** KitchenOwl. The native apps and real-time sync are the right call here, and the household model fits naturally.

**Solo developer who wants maximum features:** Tandoor. Calculated nutrition and prices, calendar export, the widest set of importers, and the deepest meal planning implementation. Worth the setup complexity if you will actually use the features.

**Best balance of polish and simplicity:** Mealie. Clean interface, good web scraping, solid API, active community. The easiest to recommend to someone who does not want to spend a weekend configuring things.

## Or Skip the Server Entirely

If you are a developer and you want control over your recipe data, there is a different path worth knowing about: plain text files.

Cooklang is a markup language for recipes. You write `.cook` files in any text editor, store them wherever you like — a Git repository, iCloud, Dropbox — and use [CookCLI](/cli/) for shopping lists, scaling, and a local web server. No database, no server, no Docker container to maintain. (Though if you *want* a browsable server for your household, [self-hosting your recipes with Docker and CookCLI](/blog/21-self-hosting-recipes-with-docker/) takes minutes.) In the kitchen, the free [Cook recipe app](/app/) for iPhone and Android reads the same files — with shopping lists and a step-by-step cooking mode.

The trade-off is real: no multi-user dashboard, no polished web interface for non-technical household members. But your recipes are text files. They open in any editor, diff cleanly in Git, survive any app going offline, and never require a migration.

Already have a library in Mealie or Tandoor? [Batch import on cook.md](https://cook.md/imports/new?from=batch_import) converts either app's ZIP export into `.cook` files in one go. It is a paid feature, part of Cook Basic; converting recipes one at a time from a link stays free.

For a broader comparison that includes Cooklang alongside Mealie, KitchenOwl, and Paprika, see the [full recipe manager comparison](/blog/09-cooklang-vs-paprika-vs-mealie/). If Cooklang's approach sounds interesting, the [getting started guide](/docs/getting-started/) is a five-minute read.

-Alex
