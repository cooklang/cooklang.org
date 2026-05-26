---
title: "Cooklang vs Mealie: Plain Text vs Self-Hosted Web App"
date: 2026-05-26
weight: 50
summary: "Mealie gives you a polished self-hosted web app for your household. Cooklang gives you plain-text recipes you fully own. Honest fitness-for-purpose comparison."
description: "Mealie gives you a polished web app for your household. Cooklang gives you plain-text recipes you fully own. Here's which fits which kind of cook."
---

If you're looking at Mealie and wondering whether Cooklang might be a better fit, the honest answer depends less on features and more on how you actually want to interact with your recipes.

One disclosure up front: we make Cooklang. We also wrote a [detailed Mealie review](/blog/40-mealie-review/) that tries to be fair to it. This post is the direct head-to-head — same fairness, but with a verdict at the end of each section.

The two tools aren't really competitors in the strict sense. Mealie is a web application. Cooklang is a file format. They overlap in the job they help you do — managing recipes — but the way they ask you to relate to your collection is fundamentally different. That difference is the whole comparison.

## The 30-Second Answer

| You want | Pick |
|---|---|
| A polished web UI your whole household can use | **Mealie** |
| Recipes that live as files you own forever | **Cooklang** |
| To save recipes from any food blog with one click | **Mealie** |
| To version-control your collection in git | **Cooklang** |
| To stop maintaining a server | **Cooklang** |
| Meal planning with a drag-and-drop calendar | **Mealie** |
| To script your shopping list, meal plan, or anything else | **Cooklang** |
| Multi-user accounts and household sharing | **Mealie** |

If you're in a household where non-technical people will use the recipe tool, Mealie wins by a wide margin. If you're a single cook who values data ownership and minimal moving parts, Cooklang wins.

## What Mealie Is, On Its Own Terms

[Mealie](https://github.com/mealie-recipes/mealie) is a free, open-source, self-hosted web application for recipe management. The stack is Python (FastAPI) on the backend and Vue.js on the frontend, deployed via Docker with either SQLite or PostgreSQL behind it. The standard install is a `docker-compose.yml` you spin up on a home server or VPS.

Once it's running, you get a mobile-friendly web UI from any browser on your network. Core features:

- Recipe import from URLs — point it at a food blog, it scrapes the structured data and pulls in title, ingredients, instructions, and photo
- Meal planning with a calendar view, drag and drop
- Shopping lists generated from meal plans
- Multi-user support with household groups
- A full REST API
- Recipe categorization, tags, ratings, cooking notes

The UI is polished. The cooking mode is readable on a phone propped against a kitchen backsplash. The meal planner actually feels like a meal planner. Mealie does not feel like a project someone put on GitHub and forgot — it feels like a real consumer product. The community is large (11,000+ stars), issues get fixed, and the live demo at [demo.mealie.io](https://demo.mealie.io) is enough to evaluate it before committing.

The price is your time and your hosting. The features are real.

## What Cooklang Is, On Its Own Terms

[Cooklang](/docs/spec/) is not an app. It's a plain-text markup format for recipes, plus an ecosystem of tools built around the format.

A Cooklang recipe is a `.cook` file you write in any text editor:

```cooklang
---
servings: 2
---

Crack @eggs{3} into a #bowl and whisk with @salt{1%pinch} and @milk{2%tbsp}.

Melt @butter{1%tsp} in a #pan over low heat. Pour in the egg mixture and stir gently every ~{20%seconds} until just set.
```

The `@`, `#`, and `~` annotations mark ingredients, cookware, and timers so software can parse the recipe. Strip them out and you have a normal recipe in plain English. The format is small enough to learn in ten minutes.

The "app" layer is whatever you want it to be. [CookCLI](/cli/) gives you a command line for generating shopping lists, scaling recipes, and running a local web UI. There are [iOS and Android apps](/app/), a VS Code extension, syntax highlighting for editors, and a growing list of community tools. Your recipes sync via whatever you already use — git, Dropbox, iCloud, a USB stick.

There is no server to maintain unless you choose to run one. There is no database. The recipes are just files.

## Side-by-Side: Where Each Wins

**Setup and hosting.** Mealie wants Docker, a place to run it, and the maintenance overhead of a self-hosted web app — updates, backups, occasional schema migrations. Cooklang wants a folder. *Cooklang wins on simplicity; Mealie wins if you want a real frontend and are happy hosting it.*

**Recipe entry from the web.** Mealie's URL scraper is excellent — paste a blog link, get a clean recipe. Cooklang has no equivalent. You'd write or import recipes manually, or use a third-party converter. *Mealie wins decisively.*

**Mobile access.** Mealie's web UI works on phones; you bookmark the URL. Cooklang has native [iOS and Android apps](/app/) that sync from your recipe folder. *Tie, with a different shape — Mealie is web-everywhere, Cooklang is native-on-mobile.*

**Sharing with a household.** Mealie has user accounts, household groups, and permissions. Cooklang has files in a shared folder. If your household includes non-technical people, the gap is large. *Mealie wins.*

**Data ownership and portability.** Mealie's recipes live in a database inside a Docker volume. Export works, but it's a process. Cooklang recipes are plain text files you already own — `grep`, version-control, copy to another machine, edit in any tool. *Cooklang wins decisively.*

**Search.** Mealie has UI-level search across your recipe collection. Cooklang gives you ripgrep across a folder of text files, which is faster and more flexible but requires comfort with a terminal. *Tie, different shapes.*

**Offline access.** Mealie requires the server to be reachable. Cooklang files are on whatever device you have them on. *Cooklang wins.*

**Automation and scripting.** Mealie has a REST API. Cooklang has structured text you can pipe through any tool. Both are scriptable; Cooklang's surface area is smaller and the data is closer to hand. *Tie, with Cooklang easier for shell-level automation and Mealie better for HTTP-based integrations.*

**Meal planning.** Mealie has a calendar UI with drag and drop. Cooklang has `.menu` files and CLI tooling. *Mealie wins on UX; Cooklang wins if you'd rather script your week than drag cards.*

## When Mealie Is the Right Choice

Mealie fits your life if:

- **Your household includes people who will not edit text files.** A partner who wants to find tonight's dinner in three taps doesn't want a folder of `.cook` files. Mealie's web UI is what they expect.
- **You already self-host things.** If Docker compose is in your vocabulary and you have a Synology, a Raspberry Pi, or a home server running other services, the marginal cost of one more service is small.
- **You import recipes from the web constantly.** The scraper is genuinely the best feature. If most of your collection comes from food blogs, this single capability is worth the rest of the trade-offs.
- **You want the meal planner.** Drag-and-drop calendar planning with auto-generated shopping lists is a real workflow that Cooklang's CLI doesn't match.
- **You're comfortable with the data shape.** Recipes in a database are fine if you're not planning to leave. Most people don't.

If three or more of those apply, stop reading. Install Mealie. It will serve you well.

## When Cooklang Is the Right Choice

Cooklang fits your life if:

- **You want your recipes to outlive any one tool.** Plain text means a recipe you write today will be readable in 30 years without an emulator. Database-backed recipes can't promise that.
- **You're the primary cook and you don't need a household UI.** A single cook who values control over surface area wins more from Cooklang than from Mealie.
- **You'd rather script than click.** If your instinct on hearing "I want a shopping list for next week's dinners" is to write a small shell pipeline rather than open a UI, Cooklang's shape fits your brain.
- **You're tired of maintaining one more thing.** Servers need updates, backups, troubleshooting. Cooklang has none of that. It's files.
- **You're a developer.** Recipes-as-code lets you treat your cookbook like a project — pull requests for new recipes, branches for experiments, diffs when you tweak a baseline.

The shape of Cooklang asks more of you upfront (you write recipes manually, you don't get a pretty calendar). It gives more back over time (your files keep working forever, no matter what we do).

## Can You Use Both?

Yes, but the friction is real.

The clean version of "both" is using each for what it's best at: Cooklang as your personal source-of-truth archive in git, Mealie as the household-facing frontend running in Docker. You write recipes in Cooklang because the files are durable. You import or sync a subset into Mealie because your partner wants to tap a card on the iPad.

The synchronization between the two is the hard part. Cooklang and Mealie don't share a recipe format. You'd be exporting Cooklang recipes to JSON, importing into Mealie, and accepting that the two views drift over time unless you build sync tooling. For most people, that's more maintenance than they want.

Pick one. If you can't, run Cooklang as your archive and only use Mealie selectively for shared meals.

## Migration Notes

If you're moving from Mealie to Cooklang, the path is:

1. Use Mealie's export to dump your recipes as JSON.
2. Run a converter — there's [community tooling](https://github.com/cooklang) for common formats, or write a small script (the JSON-to-Cooklang transform is straightforward).
3. Drop the resulting `.cook` files in a folder and put it in git.
4. Decide what you want for mobile access: the [Cooklang apps](/app/), or a [self-hosted CookCLI server](/cli/commands/server/).

Going the other direction (Cooklang to Mealie) is similar — Mealie's import supports several formats, so a Cooklang → JSON converter gets you there.

The migration isn't free, but it isn't rare either. Most people who move have a clear reason: data ownership concerns, server fatigue, or wanting recipes in git. Those reasons are the same ones that should drive the choice in the first place.

## The Real Choice

Mealie is the best self-hosted recipe web app most people will encounter. Cooklang is the best way to keep recipes as files you fully own. They're both right answers to slightly different questions.

If you want a web app for your household — Mealie.

If you want files you can read in 30 years — Cooklang.

[Try Cooklang →](/docs/getting-started/)

-Alex
