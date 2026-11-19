---
title: "Cooklang vs Tandoor: Sharp Tool vs Kitchen ERP"
date: 2026-05-26
lastmod: 2026-11-19
weight: 50
summary: "Tandoor packs every recipe-management feature into one self-hosted app. Cooklang does one thing — structured plain text — and lets you script the rest. Honest comparison."
description: "Tandoor packs every recipe-management feature into one app. Cooklang does one thing — structured plain text — and lets you script the rest. Which fits?"
categories: ["Comparisons"]
---

Tandoor is the most feature-rich self-hosted recipe manager in active development. Cooklang is, by design, one of the most minimalist tools in the same space. The decision between them isn't really about features — it's about your relationship with complexity.

One disclosure: we make Cooklang. We've also covered Tandoor in [Tandoor vs Mealie vs KitchenOwl](/blog/42-tandoor-vs-mealie-vs-kitchenowl/) and in the [recipe-management roundup](/blog/48-best-recipe-management-software/). This post is the direct head-to-head — fair to Tandoor, but with the verdict spelled out per section.

Tandoor wants to be your kitchen ERP: nutrition and prices calculated per recipe, meal plans with calendar export, AI-assisted import, user accounts with roles, and importers for more than twenty other apps and formats. Cooklang wants to be a file format and stay out of your way. Both are coherent designs. They suit different cooks.

## The 30-Second Answer

| You want | Pick |
|---|---|
| Nutrition figures calculated inside the app | **Tandoor** |
| A price on every recipe | **Tandoor** |
| User accounts, roles and private recipes | **Tandoor** |
| Recipes that live as plain text files | **Cooklang** |
| To stop running a database for your cookbook | **Cooklang** |
| Calendar export and detailed meal planning | **Tandoor** |
| Lowest possible maintenance burden | **Cooklang** |
| To script your workflow with shell tools | **Cooklang** |
| Importers for 20+ other recipe apps | **Tandoor** |

If you'd describe your ideal recipe tool as "everything I might ever need, in one place," Tandoor. If you'd describe it as "a sharp small thing I can compose with," Cooklang.

## What Tandoor Is, On Its Own Terms

[Tandoor](https://docs.tandoor.dev/) is a self-hosted recipe manager designed for people who want depth. The stack is Python (Django) on the backend and Vue on the frontend, rewritten for the 2.x line in 2025. SQLite works, but the docs say production should always use PostgreSQL, and that is what the official setup ships. Deployment is Docker compose: PostgreSQL, the Django app, and optionally a reverse proxy.

Two things are worth knowing before the feature list. The licence is AGPL v3 with a Commons Clause that forbids selling the software, hosting and support included, so it is not open source in the strict sense. And if you don't want to run it, the project sells a hosted version: a free tier with 10 recipes, paid plans from €1.99 a month.

The feature list is unusually long:

- **Calculated properties.** Give foods their values (nutrients, a price, allergens, anything you define) and Tandoor adds them up per recipe. Nutrient values can be loaded from the USDA FoodData Central database.
- **Import from almost anywhere.** Schema.org scraping from websites, AI import from text, photos and PDFs, and importers for more than twenty apps and formats: Mealie, Paprika, Chowdown, Recipe Keeper, Nextcloud Cookbook and others. It reads single Cooklang files too.
- **Narrow export.** The docs list Tandoor's own format, Saffron and RecipeSage as working exports, and say importing is prioritised over exporting.
- **Calendar export.** An iCal feed of the meal plan.
- **Accounts and sharing.** Four roles (guest, user, admin, superuser), private recipes, and share links for single recipes. The docs call this a basic permission system and advise against giving accounts to people you don't trust.
- **Meal planning** with shopping list generation, and a search for what you can make from the food you have marked as on hand.
- **A REST API** with token authentication.
- **Keywords, supermarket categories and food substitutes.**

This is real depth. If you genuinely use these features, Tandoor pays for itself in capability. If you don't, you're maintaining infrastructure for software you don't fully use.

## What Cooklang Is, On Its Own Terms

[Cooklang](/docs/spec/) is a plain-text recipe format and an ecosystem of small tools around it. Not an application — a format.

A Cooklang recipe is a `.cook` file:

```cooklang
---
servings: 4
---

Heat @olive oil{2%tbsp} in a #large skillet. Add @garlic{3%cloves}, minced, and cook for ~{1%minute}.

Stir in @canned tomatoes{800%g} and @salt{=1%tsp}. Simmer for ~{20%minutes}.
```

The `@`, `#`, and `~` annotations make ingredients, cookware, and timers machine-readable. The rest is normal English. The format takes ten minutes to learn.

The "application" layer is composable. [CookCLI](/cli/) handles shopping lists, scaling, a local web UI, and shell-friendly output. [Mobile apps](/app/) read from your recipe folder. Editor plugins give you syntax highlighting, and [Cook Editor](/editor/) runs [plugins](https://plugins.cook.md) of its own. The [`.menu` format](/docs/spec/) handles meal planning at the file level.

Cooklang deliberately does not have built-in nutrition tracking, meal cost calculation, or a permission system. Those things exist as separate concerns you wire together if you need them — or skip if you don't. The surface area is small on purpose.

## Maximalist vs Minimalist

This is the real axis of the comparison, and it deserves its own section.

Tandoor's philosophy is **bundle everything**. Recipes, meal plans, nutrition, costs, permissions, and import/export all live in one application, sharing one data model, presented through one consistent UI. The benefit is integration — the values you give a food show up as totals on every recipe that uses it, the meal plan feeds the shopping list, and the same accounts apply everywhere. Nothing has to be wired up because everything is already wired together.

Cooklang's philosophy is **do one thing well, compose the rest**. The format defines structured recipes. Everything else — nutrition calculation, cost tracking, meal planning, sharing — is a separate tool you add if you need it. The benefit is that each piece is independently understandable and replaceable.

Take nutrition as the concrete example. In Tandoor, you fill in nutrient values per food (or load them from the USDA database), and each recipe shows the totals. It works because properties are part of Tandoor's data model.

In Cooklang, nutrition isn't built in. Your `.cook` files contain typed ingredients with quantities (`@spinach{200%g}`), which is the *data* a nutrition calculation needs. But the calculation itself is something you add: the [nutrition reports](https://github.com/cook-md/cooklang-reports-nutrition) package for CookCLI, or your own script that reads the recipe and looks up nutrients from USDA FoodData Central or similar. That gives you flexibility (use any database, any output format) but costs you the integration Tandoor provides out of the box. The middle ground is a plugin: [Core Vitals](https://plugins.cook.md/cooklang/corevitals) and [Nutri-Score](https://plugins.cook.md/cooklang/nutriscore) for Cook Editor do that lookup through the hosted cook.md nutrition service (Cook Basic), and your recipes stay plain `.cook` files either way.

Neither philosophy is wrong. Tandoor says "you should not have to wire anything up." Cooklang says "you should be able to wire things up your way." The right choice depends on whether you'd rather configure software or program around it.

## Side-by-Side: Where Each Wins

**Nutrition.** Tandoor has it built in, once your foods have values. Cooklang has the structured data and add-ons that do the sums. *Tandoor wins.*

**Recipe cost.** Same shape: in Tandoor, price is one more property that is added up per recipe. In Cooklang it is a report template over a file of prices. *Tandoor wins.*

**Multi-user.** Tandoor has accounts, four roles, private recipes and share links. Cooklang relies on whatever filesystem permissions or git access controls you already use. *Tandoor wins.*

**Import variety.** Tandoor reads Schema.org, Mealie, Paprika, Chowdown, Recipe Keeper, and about twenty others. Cooklang has a hosted converter for web pages and a paid batch import for ten apps. *Tandoor wins on the way in. On the way out it is the other way round: Tandoor's export is narrow, and Cooklang has nothing to export because the files are already yours.*

**Calendar and meal planning.** Tandoor has a full UI with ICS export. Cooklang has `.menu` files and CLI tooling. *Tandoor wins on UX; Cooklang wins if you'd rather script.*

**Mobile.** Tandoor's web UI installs as a web app that keeps recently opened recipes for offline use; there is no official native app, though unofficial ones exist. Cooklang has [native iOS and Android apps](/app/). *Tie, different shapes.*

**Automation and scripting.** Tandoor has a REST API. Cooklang has structured text you can pipe through any tool. *Cooklang wins for shell-level automation; Tandoor wins for HTTP-based integrations.*

**Plain-text portability.** Cooklang recipes are text files you already understand. Tandoor recipes are PostgreSQL rows you query through Django. *Cooklang wins decisively.*

**Maintenance burden.** This is the killer category. Tandoor wants Docker compose, PostgreSQL, periodic backups, and upgrades you cannot skip for long: release 2.7.0 in October 2026 fixed eight security advisories. Cooklang wants a folder. *Cooklang wins by a wide margin, unless you pay for Tandoor's hosted version and let them do it.*

Add it up and Tandoor wins on features; Cooklang wins on simplicity and durability. The question is which axis matters more to you.

## When Tandoor Is the Right Choice

Tandoor fits if:

- **You track macros seriously.** If you log nutrition daily, having it tied directly to recipes and meal plans is a real workflow gain. Cooklang gives you the data; Tandoor gives you the dashboards.
- **You want a price on every recipe.** Enter what foods cost once and each recipe shows its total. In Cooklang you would build that from a report template.
- **You have a real household with different access needs.** People who should only read get the guest role, and a recipe you are still working on can stay private until you share it.
- **You want extensive import support.** If most of your collection comes from other tools (Mealie, Paprika, Chowdown), Tandoor's importers reduce the migration tax.
- **You're comfortable maintaining PostgreSQL.** Tandoor is more demanding than Mealie. If you already run Postgres for other services and have backup tooling in place, this is fine. If you don't, it's a real cost.

If three or more of those apply, Tandoor is the answer. The feature depth pays off when you actually use it.

## When Cooklang Is the Right Choice

Cooklang fits if:

- **You want recipes you can read in 30 years.** Plain text outlives any specific tool. Tandoor's data lives in a database schema that may not be migratable to whatever comes next.
- **You don't need nutrition or cost tracking built in.** Most home cooks don't. If you don't track macros and you don't price portions, you're maintaining infrastructure for features you ignore.
- **You'd rather script than configure.** If your instinct is to write a small Python or shell tool when you need something new, Cooklang's data shape gives you everything to work with.
- **You want minimum maintenance.** No server, no database, no Docker compose, no PostgreSQL upgrade announcements to read. A folder of files that backs up with everything else you have.
- **You value Unix philosophy.** Small tools that do one thing well. Cooklang is a format; CookCLI is a CLI; mobile apps are mobile apps. Each piece replaceable.

Cooklang asks you to want less software. It rewards that with files that just keep working.

## Hybrid Use

Tandoor's importers actually make a hybrid setup more practical here than with Mealie, because one of them reads Cooklang.

The pattern: keep your recipes as Cooklang files in git (durable, version-controlled, future-proof). When you want Tandoor's nutrition or planning features for a specific subset, import those `.cook` files into Tandoor. You're not trying to keep both in sync continuously — Cooklang is your source of truth, Tandoor is the analytical frontend for the cases where you need it.

The importer takes one `.cook` file at a time and no pictures, so this suits a handful of recipes, not a whole library. If you have a strong preference for plain-text storage but occasionally need Tandoor's depth, this is a reasonable shape.

## The Real Choice

Tandoor is the deepest self-hosted recipe tool available. Cooklang is the most durable recipe storage format available. Those are different things, and the right answer depends on which one you actually need.

If you want a kitchen ERP — Tandoor.

If you want recipes as files you fully own — Cooklang.

[Try Cooklang →](/docs/getting-started/)

-Alex
