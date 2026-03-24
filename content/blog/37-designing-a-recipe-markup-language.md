---
title: "What Goes Into Designing a Recipe Markup Language"
date: 2026-03-24
weight: 50
summary: "Recipes are one of the most structured forms of human writing, yet almost every digital format either loses that structure or buries it in machine syntax. Here's how we designed a markup language that keeps recipes readable and machine-parseable at the same time."
---

Recipes are one of the most structured documents humans produce. They have a preamble (title, yield, timing), a list of typed inputs (ingredients with quantities and units), an ordered list of operations, and tool references throughout. You could almost describe a recipe formally. In fact, you can — and that turns out to be harder than it sounds.

Most recipe formats solve half the problem. Plain text is readable but unstructured. JSON and XML are structured but unreadable. The markup language approach — lightweight annotations inside natural text — is the only approach that actually keeps both properties. This post is about how we designed Cooklang and why we made the choices we did.

## Why Not Just Use an Existing Format

The obvious first question is: why build anything at all? There are existing formats.

**JSON-LD with Schema.org** is what most recipe sites use today. It works well for search engine indexing — Google can extract your cook time and ingredient list and show it in results. But nobody writes JSON-LD by hand. It's generated from a database, or bolted on as a `<script>` tag after the fact. A human sitting down to write a recipe does not want to produce this:

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "recipeIngredient": ["2 cups flour", "1 tsp salt"],
  "recipeInstructions": [{"@type": "HowToStep", "text": "Mix flour and salt."}]
}
```

**RecipeML** tried the XML route around 2000. Same problem: verbose, tag-heavy, written for machines not humans.

**Markdown** is readable and writable, but it has no concept of an ingredient. You could write a recipe in Markdown — people do — but software parsing it can't tell the difference between "flour" mentioned as an ingredient and "flour" mentioned in a note about substitutions. The semantics aren't there.

**YAML frontmatter with Markdown body** gets closer, but breaks down when you try to annotate the instructions themselves. You end up with ingredients in the frontmatter and instructions in prose, and no way to link them. Which mention of "the butter" in step 3 refers to which quantity declared at the top?

The gap these formats leave is the same: you can't annotate structure *within* prose without either abandoning prose (going to XML/JSON) or abandoning structure (staying in plain text). A markup language is the only way to thread the needle.

## The Inline Markup Decision

This is the central design decision, and it has consequences everywhere.

Inline markup means annotations live inside the instruction text, not outside it. Compare these two representations of the same step:

```xml
<!-- Tag-based, structure outside prose -->
<step>
  <action>Sauté</action>
  <ingredient ref="garlic" />
  <ingredient ref="onion" />
  <cookware ref="pan" />
  <duration>5 minutes</duration>
</step>
```

```cooklang
-- Inline markup, structure inside prose
Sauté @garlic{3%cloves} and @onion{1} in the #frying pan for ~{5%minutes}.
```

The XML version is complete. Every element is tagged, nothing is ambiguous. But it's unreadable by a cook standing at the stove. The Cooklang version reads like a sentence — because it is one. The annotations are lightweight enough that your eye skips over them after a few recipes.

The inline approach has a cost: ambiguity at the edges. The tag-based approach never has to ask "where does this ingredient name end?" because the closing tag answers that. Inline markup has to handle it some other way.

## The Symbol Choices

`@` for ingredients, `#` for cookware, `~` for timers.

Why these three? The short answer is frequency and visual weight.

Ingredients are the most frequent element in any recipe. They appear in almost every sentence. The symbol has to be easy to type, visually distinctive, and unobtrusive enough that a paragraph full of them still reads naturally. `@` fits. It's already associated with "address" semantics — this thing is located somewhere, it has an identity. And it's a single character, not two.

`#` for cookware makes sense because cookware is less frequent than ingredients. You reference your pan once per section, not once per sentence. The `#` is familiar from Markdown headers and social media tags — it signals "this is a named thing." That intuition transfers reasonably well.

`~` for timers is the least obvious. Timers are the rarest of the three. They represent duration rather than a physical thing. The tilde has a vaguely wave-like quality — time passing — and it's rarely used in natural prose, so it stands out without competing with common punctuation.

The key constraint was: these symbols cannot appear in ordinary recipe text in contexts that would be mistaken for annotations. At-signs, hash marks, and tildes appear rarely in cooking instructions. Periods, commas, colons, and dashes appear constantly — they were never candidates.

## The Hard Problem: Where Does the Name End?

The biggest parsing challenge in the syntax is multi-word names. Consider:

```
@ground black pepper
```

Is that:
- ingredient: `ground`, with the text ` black pepper` following
- ingredient: `ground black`, with the text ` pepper` following
- ingredient: `ground black pepper`, consuming to the next word boundary

There's no way to know without a delimiter. The rule Cooklang uses: a single-word ingredient needs no braces; a multi-word ingredient requires `{}` to mark its extent.

```cooklang
@salt{}               -- single-word: no braces needed either way
@ground black pepper{} -- multi-word: braces required
```

The braces serve double duty: they mark the end of multi-word names and they contain the quantity/unit specification:

```cooklang
@flour{250%g}
@ground black pepper{1%tsp}
@potato{2}
```

The `%` separator between quantity and unit was chosen because it's not used in normal prose and it's visually clear. You read `250%g` as "250 grams" without much effort once you've seen it a few times. The alternatives — a slash, a space, a colon — all appear in recipe text and would create ambiguity.

What about ingredients with no quantity? The empty braces `{}` is explicit: "I'm an ingredient, I have no specified quantity." Without braces at all, only the first word is captured:

```cooklang
Add @salt to taste.       -- captures "salt" only
Add @salt{} to taste.     -- same result, but explicit
Add @olive oil{} to taste. -- multi-word with no quantity
```

This feels redundant for single-word ingredients, but it establishes a consistent rule: braces always mean "I'm specifying something about this token."

## Scaling and the Locked Ingredient Problem

Scaling is where the design gets genuinely interesting. Double a recipe and you multiply all quantities by 2 — that much is obvious. But not everything scales linearly.

If you're making a cake for 24 instead of 12, you double the flour and butter. But do you double the salt? Maybe. Do you double the baking powder? Definitely not — leavening doesn't scale proportionally, and too much will ruin the texture. Do you double the vanilla? Probably not — flavor extracts often work at a threshold, and twice as much doesn't make it twice as fragrant.

The locked ingredient syntax handles this:

```cooklang
@flour{500%g}              -- scales normally
@baking powder{=2%tsp}     -- locked: always 2 tsp regardless of scale factor
@vanilla extract{=1%tsp}   -- locked
```

The `=` prefix signals "do not scale this." It's an escape hatch, not the default. Most ingredients scale; the ones that don't are explicitly flagged. This puts the decision in the recipe author's hands, which is where it belongs — a parser can't know that baking powder doesn't scale linearly, but a baker does.

## Sections and Recipe Composition

A bolognese has three components: the soffritto, the meat sauce, and the pasta. A mille-feuille has pastry cream, puff pastry, and assembly. Flat-format recipes struggle with this — you either write everything as a single linear sequence or you fragment it into separate files.

Sections solve it:

```cooklang
= Soffritto

Sweat @onion{1%large}, @carrot{1} and @celery{2%stalks} in @olive oil{3%tbsp} for ~{15%minutes}.

= Meat Sauce

Add @ground beef{500%g} and @ground pork{250%g}. Brown completely.

Add @tomato paste{2%tbsp} and @white wine{200%ml}. Simmer for ~{2%hours}.
```

The `=` prefix (with a space) marks a section heading. Sections are not separate recipes — they share the ingredient list and the cookware — they're organizational units. A parser surfaces them as named steps the user can navigate between.

Recipe references go further: a `.cook` file can reference another `.cook` file as an ingredient.

```cooklang
Serve the duck with @./Sauces/Salsa Verde{} spooned over the top.
```

The parser follows that path, finds `Salsa Verde.cook`, and includes its ingredients in the aggregate shopping list. You don't have to copy-paste the salsa verde ingredients into the main recipe — the reference does it. This is [recipe composition](/blog/recipe-programming-language-write-and-manage-recipes-as-code/), and it changes how you organize a cookbook.

## Metadata and the YAML Frontmatter Decision

Early in the design we considered various approaches to recipe metadata: title, servings, timing, tags, source URL. The candidates were:

1. Key-value pairs with a custom syntax at the top of the file
2. YAML frontmatter (the Hugo/Jekyll convention)
3. No built-in metadata, leave it to convention

We went with YAML frontmatter. The reasoning: developers already know it, parsers for it already exist in every language, and it keeps the metadata visually separate from the instructions. A recipe file with frontmatter looks like this:

```cooklang
---
title: Classic Carbonara
tags: [italian, pasta, quick]
servings: 4
prep time: 10 minutes
cook time: 15 minutes
difficulty: easy
source: https://example.com/carbonara
---

Cook @spaghetti{400%g} in well-salted water until al dente.

In a bowl, whisk @egg yolks{4} with @pecorino{80%g}.
```

The `---` delimiters are unambiguous. A parser can extract the YAML block, parse it with any standard YAML library, and hand the rest to the Cooklang parser. No custom metadata syntax to maintain.

## The Grammar and the Parser Ecosystem

A markup language without a formal grammar is a format — something that works until implementations disagree. We wanted implementations to agree, so we published an [EBNF grammar](https://github.com/cooklang/spec/blob/main/EBNF.md) and a [canonical test suite](https://github.com/cooklang/spec/tree/main/tests).

The test suite is the real anchor. It defines behavior for edge cases: what happens with nested braces, empty ingredient names, unusual Unicode, timer syntax variations. An implementation that passes the test suite is compatible; one that doesn't, isn't.

This matters because the ecosystem now has [15+ independent implementations](/docs/for-developers/): Rust, TypeScript, JavaScript, Swift, Python, Go, Haskell, Dart, Clojure, Lua, Perl, Ruby, .NET, C, and a Tree-sitter grammar for editor integration. The official Rust parser (`cooklang-rs`) handles unit conversion, scaling, and aisle configuration. The TypeScript and JavaScript parsers run in browsers and Node. Each community implemented the language they needed, and the spec gave them a contract to implement against.

That's what a grammar buys you: a single source of truth that decouples the language from any one implementation.

## What We Got Wrong (or Left Open)

No design survives contact with real users without revealing its gaps.

The multi-word name rule (braces required) trips up new users constantly. The single-word shorthand (`@salt` without braces) is convenient but creates an inconsistency — most ingredients need braces, but single-word ones don't. We considered requiring braces always. The tradeoff was verbosity versus consistency; we chose convenience and accepted the inconsistency.

Timers have an awkward syntax when they have no associated description — `~{15%minutes}` looks strange compared to how naturally ingredients read. There have been proposals for labeled timers (`~{preheat%15%minutes}`) but that hasn't been standardized.

Nutritional data is entirely out of scope. The format captures what you use and in what quantities, but it doesn't encode nutritional values — that's left to external databases and tool implementations. Some parsers look up values from USDA data; others leave it to the user. The right call for the language, but it means nutrition features are never quite standard across tools.

## A Markup Language Is a Bet

Designing a markup language is a bet that the structure you're capturing actually matters — that encoding the difference between an ingredient and a piece of prose, between a timer and a duration mentioned in passing, is worth the annotation overhead.

With Cooklang, we think it is. A recipe markup language that keeps text readable and machine-parseable unlocks things that neither plain prose nor machine-native formats can: shopping lists from multiple recipes, automatic scaling with locked exceptions, recipe composition and reference, editor tooling with ingredient highlighting, and a parser ecosystem that speaks the same language across every platform.

The [specification](/docs/spec/) is the starting point if you want to understand the grammar in full. The [playground](/blog/30-cooklang-playground-walkthrough/) lets you experiment without installing anything. And if you want to go deeper on what the structure enables, [recipes as stack machines](/blog/05-recipes-as-stack-machines/) takes the formal model further than this post does.

-Alex
