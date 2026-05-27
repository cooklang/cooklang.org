---
title: "Cooklang vs Tandoor: Sharp Tool vs Kitchen ERP"
date: 2026-05-26
weight: 50
summary: "Tandoor packs every recipe-management feature into one self-hosted app. Cooklang does one thing — structured plain text — and lets you script the rest. Honest comparison."
description: "Tandoor packs every recipe-management feature into one app. Cooklang does one thing — structured plain text — and lets you script the rest. Which fits?"
categories: ["Comparisons"]
---

Tandoor is the most feature-rich self-hosted recipe manager in active development. Cooklang is, by design, one of the most minimalist tools in the same space. The decision between them isn't really about features — it's about your relationship with complexity.

One disclosure: we make Cooklang. We've also covered Tandoor in [Tandoor vs Mealie vs KitchenOwl](/blog/42-tandoor-vs-mealie-vs-kitchenowl/) and in the [recipe-management roundup](/blog/48-best-recipe-management-software/). This post is the direct head-to-head — fair to Tandoor, but with the verdict spelled out per section.

Tandoor wants to be your kitchen ERP: nutrition tracking, meal cost calculation, granular permissions, calendar export, a dozen import formats, a permission system that wouldn't look out of place in enterprise software. Cooklang wants to be a file format and stay out of your way. Both are coherent designs. They suit different cooks.

## The 30-Second Answer

| You want | Pick |
|---|---|
| Built-in nutrition tracking and macros | **Tandoor** |
| Meal cost calculation per portion | **Tandoor** |
| Granular multi-user permissions | **Tandoor** |
| Recipes that live as plain text files | **Cooklang** |
| To stop running PostgreSQL for your cookbook | **Cooklang** |
| Calendar export and detailed meal planning | **Tandoor** |
| Lowest possible maintenance burden | **Cooklang** |
| To script your workflow with shell tools | **Cooklang** |
| Import from a dozen recipe formats | **Tandoor** |

If you'd describe your ideal recipe tool as "everything I might ever need, in one place," Tandoor. If you'd describe it as "a sharp small thing I can compose with," Cooklang.

## What Tandoor Is, On Its Own Terms

[Tandoor](https://docs.tandoor.dev/) is a self-hosted recipe manager designed for people who want depth. The stack is Python (Django) on the backend with PostgreSQL required from the start — SQLite isn't supported in production. Deployment is Docker compose, but the canonical setup involves PostgreSQL, the Django app, optionally a reverse proxy, and frequently a separate worker container.

The feature list is unusually long:

- **Nutritional tracking.** Per-ingredient nutrient values that aggregate to recipe and meal totals.
- **Meal cost calculation.** Per-ingredient pricing that produces a cost per portion.
- **Multi-format import.** Schema.org scraping plus support for Mealie JSON, Paprika, Chowdown, RecipeKeeper, and several others.
- **Multi-format export.** Many of the same.
- **Calendar export.** ICS feeds you can subscribe to from any calendar app.
- **Granular permissions.** Per-recipe and per-collection sharing with read/write/admin roles, designed for households or even small commercial setups.
- **Meal planning** with shopping list generation.
- **Full REST API** with API key authentication.
- **Sophisticated tagging, categorization, supermarket categories, and ingredient substitution rules.**

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

The "application" layer is composable. [CookCLI](/cli/) handles shopping lists, scaling, a local web UI, and shell-friendly output. [Mobile apps](/app/) read from your recipe folder. Editor plugins give you syntax highlighting. The [`.menu` format](/docs/spec/) handles meal planning at the file level.

Cooklang deliberately does not have built-in nutrition tracking, meal cost calculation, or a permission system. Those things exist as separate concerns you wire together if you need them — or skip if you don't. The surface area is small on purpose.

## Maximalist vs Minimalist

This is the real axis of the comparison, and it deserves its own section.

Tandoor's philosophy is **bundle everything**. Recipes, meal plans, nutrition, costs, permissions, and import/export all live in one application, sharing one data model, presented through one consistent UI. The benefit is integration — your nutrition data automatically aggregates into your meal plan, which automatically generates a costed shopping list, which automatically respects your sharing permissions. Nothing has to be wired up because everything is already wired together.

Cooklang's philosophy is **do one thing well, compose the rest**. The format defines structured recipes. Everything else — nutrition calculation, cost tracking, meal planning, sharing — is a separate tool you add if you need it. The benefit is that each piece is independently understandable and replaceable.

Take nutrition as the concrete example. In Tandoor, you fill in nutrient values per ingredient (or import them from a database), and nutrition information appears across the app — on recipes, on meal plans, on shopping lists. It works because Tandoor's data model includes nutrition as a first-class field.

In Cooklang, nutrition isn't built in. Your `.cook` files contain typed ingredients with quantities (`@spinach{200%g}`), which is the *data* a nutrition calculation needs. But the calculation itself is something you'd add: a script that reads the recipe, looks up nutrients from USDA FoodData Central or similar, and outputs the result. That gives you flexibility (use any database, any cooking-method modifiers, any output format) but costs you the integration Tandoor provides out of the box.

Neither philosophy is wrong. Tandoor says "you should not have to wire anything up." Cooklang says "you should be able to wire things up your way." The right choice depends on whether you'd rather configure software or program around it.

## Side-by-Side: Where Each Wins

**Nutrition tracking.** Tandoor has it built in. Cooklang has the structured data but you build the analysis yourself. *Tandoor wins.*

**Meal cost calculation.** Same shape: Tandoor built-in, Cooklang scriptable but not bundled. *Tandoor wins.*

**Multi-user permissions.** Tandoor's permission model is genuinely sophisticated. Cooklang relies on whatever filesystem permissions or git access controls you already use. *Tandoor wins.*

**Import variety.** Tandoor reads Schema.org, Mealie, Paprika, Chowdown, RecipeKeeper, and others. Cooklang has community converters but the ecosystem is smaller. *Tandoor wins.*

**Calendar and meal planning.** Tandoor has a full UI with ICS export. Cooklang has `.menu` files and CLI tooling. *Tandoor wins on UX; Cooklang wins if you'd rather script.*

**Mobile.** Tandoor's web UI works on phones; some community mobile apps exist. Cooklang has [native iOS and Android apps](/app/). *Tie, different shapes.*

**Automation and scripting.** Tandoor has a REST API and webhooks. Cooklang has structured text you can pipe through any tool. *Cooklang wins for shell-level automation; Tandoor wins for HTTP-based integrations.*

**Plain-text portability.** Cooklang recipes are text files you already understand. Tandoor recipes are PostgreSQL rows you query through Django. *Cooklang wins decisively.*

**Maintenance burden.** This is the killer category. Tandoor wants Docker compose, PostgreSQL, periodic backups, schema migrations on upgrades, log monitoring, and the general overhead of a self-hosted web app. Cooklang wants a folder. *Cooklang wins by an order of magnitude.*

Add it up and Tandoor wins on features; Cooklang wins on simplicity and durability. The question is which axis matters more to you.

## When Tandoor Is the Right Choice

Tandoor fits if:

- **You track macros seriously.** If you log nutrition daily, having it tied directly to recipes and meal plans is a real workflow gain. Cooklang gives you the data; Tandoor gives you the dashboards.
- **You run a small catering or meal-prep operation.** Per-portion cost calculation, granular permissions, and multi-user support are designed for this. Cooklang isn't.
- **You have a real household with different access needs.** Roommates who can edit some recipes but not others, kids who can view but not delete — Tandoor's permission system maps to this cleanly.
- **You want extensive import support.** If most of your collection comes from other tools (Mealie, Paprika, Chowdown), Tandoor's import variety reduces the migration tax.
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

Tandoor's import variety actually makes a hybrid setup more practical here than with Mealie.

The pattern: keep your recipes as Cooklang files in git (durable, version-controlled, future-proof). When you want Tandoor's nutrition or planning features for a specific subset, convert that subset to Tandoor's format and import it. You're not trying to keep both in sync continuously — Cooklang is your source of truth, Tandoor is the analytical frontend for the cases where you need it.

A converter from Cooklang to Tandoor's JSON import format is a hundred lines of code. If you have a strong preference for plain-text storage but occasionally need Tandoor's depth, this is a reasonable shape.

## The Real Choice

Tandoor is the deepest self-hosted recipe tool available. Cooklang is the most durable recipe storage format available. Those are different things, and the right answer depends on which one you actually need.

If you want a kitchen ERP — Tandoor.

If you want recipes as files you fully own — Cooklang.

[Try Cooklang →](/docs/getting-started/)

-Alex
