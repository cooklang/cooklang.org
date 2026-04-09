---
title: "Cooking Timers That Live Inside Your Recipes"
date: 2026-04-09
weight: 80
summary: "Most cooking timers are separate from the recipe. Cooklang embeds timers directly in your instructions — tap a step and the timer starts. Run multiple timers at once, get lock-screen notifications, and set timers up to 999 hours for fermentation and slow processes."
description: "Embed cooking timers directly in your recipe text. Tap a step to start the timer, run multiple timers at once, and set long timers up to 999 hours for fermentation. Works on iOS and Android."
---

You're halfway through a recipe. Three things are happening: pasta is boiling, garlic bread is in the oven, and the sauce needs to simmer for ten more minutes. You set three separate timers on your phone, but now you can't remember which timer is which. Was the 12-minute one the pasta or the bread?

This is a solved problem. It just requires putting the timer where it belongs — inside the recipe step.

## Timers as Part of the Recipe

In Cooklang, a timer is part of the instruction text, not a separate app:

```cooklang
Bring @water{2%l} to a boil in a #pot{} and cook @pasta{500%g} for ~{8%minutes}.
```

The `~{8%minutes}` isn't just a notation — it's a timer your app can start. When you're reading the recipe on your phone, you tap "8 minutes" and a countdown begins. The timer is contextual. You know exactly what it's for because it's embedded in the step that needs it.

![Tap a time in any recipe step to start a timer](/blog/cooking-timers/tap-to-start-timer.webp)

Named timers make this even clearer:

```cooklang
Place @sourdough loaf{} in the #dutch oven{} and bake for ~bread{30%minutes} with the lid on, then remove the lid and bake for another ~bread crust{15%minutes}.
```

Two timers, two names. When the notification fires, it says "bread" or "bread crust" — not "Timer 1" or "Timer 2."

## Multiple Timers, No Confusion

Real cooking is concurrent. You're not doing one thing at a time. A Sunday roast might have:

- Beef resting for `~beef{15%minutes}`
- Yorkshire puddings in the oven for `~yorkshires{20%minutes}`
- Gravy reducing for `~gravy{10%minutes}`

The [Cook app](/app/) runs all of these simultaneously. Each timer has its own circular progress indicator and name. You can pause, restart, or add a minute to any timer independently. When each one completes, you get a notification with a sound — even if your phone is locked or the app is in the background.

![A named timer running with circular progress](/blog/cooking-timers/timer-running.webp)

![Multiple timers running simultaneously](/blog/cooking-timers/multiple-timers.webp)

No more asking "which timer was that?"

## Long Timers: Fermentation, Brining, and Slow Processes

Most timer apps max out at a few hours. They're built for stovetop cooking where ten minutes is a long time. But cooking doesn't stop at the stovetop.

Cooklang timers go up to 999 hours. That's over 41 days. This opens up a whole class of recipes that other tools can't handle:

```cooklang
Mix @flour{500%g}, @water{350%ml}, and @salt{10%g}. Add @sourdough starter{100%g}
and fold until combined. Cover and ferment at room temperature for ~bulk ferment{12%hours}.
```

```cooklang
Submerge @cucumbers{1%kg} in the brine. Seal the #jar{} and ferment at room
temperature for ~fermentation{72%hours}, burping daily.
```

```cooklang
Combine @cabbage{1%kg} with @salt{20%g}, massage until liquid releases.
Pack tightly into a #fermentation crock{}, weigh down, and ferment for
~kimchi{168%hours}.
```

A week-long kimchi ferment. A three-day pickle. A 24-hour braise. These are all real recipes with real timers. You set it when you start the process and get a notification when it's time to check.

This works particularly well for:

- **Sourdough bread** — bulk ferment, cold retard, proofing stages
- **Kimchi, sauerkraut, and lacto-fermented pickles** — days to weeks
- **Kombucha and kefir** — first and second fermentation stages
- **Brining and curing** — overnight to multi-day
- **Slow-cooked stocks** — 12 to 48 hours
- **Yogurt making** — 8 to 24 hours incubation

## How It Works in the App

When you open a recipe in the Cook app ([iOS](/app/) or Android), timer steps are highlighted and tappable. Here's the flow:

1. **Tap the time** in any cooking step — a timer starts immediately
2. **Watch the progress** — circular countdown with the timer name and remaining time
3. **Run multiple timers** — each runs independently with its own controls
4. **Get notified** — sound alert and notification on your lock screen when time is up
5. **Adjust on the fly** — pause, restart, or add a minute with a tap

Timers keep running in the background. Lock your phone, switch to another app, put it in your pocket — the timer stays active and will alert you when it's done.

![Timer notification on the lock screen](/blog/cooking-timers/lockscreen-notification.webp)

## Timers in Other Cooklang Tools

The timer syntax works everywhere in the Cooklang ecosystem, not just the mobile app:

- **[Obsidian plugin](/blog/cooklang-obsidian-guide/)** — interactive countdown timers right in your note, with notification sounds
- **[CookCLI](/cli/)** — the web server displays timers in recipe steps
- **Custom integrations** — any parser that reads Cooklang can extract timer data and build UI around it

Because timers are part of the recipe text, they're preserved when you share, export, or sync your recipes. They're not app-specific data locked in a database — they're right there in the plain text.

## Writing Timer Syntax

The full timer syntax is simple:

```
~{time%unit}           -- anonymous timer
~name{time%unit}       -- named timer
```

Units can be anything that makes sense — `minutes`, `hours`, `seconds`, `min`, `hrs`. Some examples:

| Syntax | What it means |
|--------|--------------|
| `~{25%minutes}` | 25-minute anonymous timer |
| `~eggs{7%minutes}` | 7-minute timer named "eggs" |
| `~dough{2%hours}` | 2-hour timer named "dough" |
| `~cold retard{12%hours}` | 12-hour overnight retard |
| `~first ferment{7%days}` | 7-day first fermentation |

## Why This Matters

Standalone timer apps solve the wrong problem. They give you a countdown, but they don't tell you *what* you're counting down. The context lives in the recipe, and the timer lives somewhere else. You become the bridge between them, and bridges fail under pressure — especially when you're juggling a hot pan and a screaming smoke detector.

Embedding timers in recipe text eliminates this gap. The timer *is* the instruction. You don't need to remember what 12 minutes was for. You don't need to set up timers before you start cooking. You just follow the recipe, tap when you get to a timed step, and keep going.

And for fermentation — a process where "check back in three days" is a real instruction — having a timer that actually runs for three days and notifies you is the difference between a successful batch and a forgotten jar at the back of the counter.

[Try writing a recipe with timers →](/docs/spec/#timer)

-Alex
