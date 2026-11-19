---
title: "Chef Language vs Cooklang Explained"
date: 2026-02-28
lastmod: 2026-11-19
weight: 60
summary: "Two languages that look like recipes — but only one of them helps you cook dinner. A light-hearted comparison of Chef, the joke programming language, and Cooklang."
description: "The Chef esoteric programming language and Cooklang both look like recipes — but solve opposite problems. A clear comparison with code examples."
categories: ["Comparisons"]
---

If you search for "chef programming language" or "chef coding language," you will find two very different things. One is a weird, wonderful esoteric language from 2002 where programs look like recipes. The other is Cooklang — a practical markup language where recipes actually are recipes.

They are easy to confuse from a search result. They serve completely opposite purposes. Let me sort it out.

## What Is the Chef Programming Language?

Chef was created by David Morgan-Mar in 2002. It is an esoteric programming language — meaning it was designed as a joke, a thought experiment, or a proof of concept rather than as a practical tool.

The joke is this: Chef programs look like recipes. Your variables are ingredient names. Your data structures are mixing bowls and baking dishes. Your operations have names like "Put," "Fold," "Add," "Combine," "Divide," and "Liquefy." You output a result by "Serving" the contents of a baking dish.

You can write real programs in it. People have: the author's own examples include one that prints Fibonacci numbers, under the title "Fibonacci Numbers with Caramel Sauce". That's both impressive and slightly horrifying.

Here is the structure of a Chef program:

```
Recipe Title.

Ingredients.
[quantity] [measure-type] ingredient name
...

Cooking time: [time].

Pre-heat oven to [temp].

Method.
[imperative cooking instructions that are actually stack operations]
...

Serves [number of baking dishes to print].
```

The "Method" section is where the program logic lives. Each instruction maps to a stack operation:

- `Put ingredient into mixing bowl` → push ingredient value onto the stack
- `Fold ingredient into mixing bowl` → pop the top of the stack into an ingredient variable
- `Add ingredient to mixing bowl` → add the ingredient's value to the value on top of the stack
- `Liquefy contents of the mixing bowl` → mark the values as characters rather than numbers
- `Pour contents of mixing bowl into baking dish` → copy the stack to an output buffer
- `Serve with auxiliary-recipe` → call a subroutine

What comes out of your "baking dishes" is printed. Dry ingredients print as numbers and liquid ones as characters. So if you want to print "Hello world", you need ingredients whose values are the right character codes, and you need to liquefy them first.

## What a Chef "Hello World" Looks Like

The canonical Chef Hello World is the author's "Hello World Souffle". It is genuinely unhinged. This is the whole program, from [the Chef site](https://www.dangermouse.net/esoteric/chef_hello.html):

```
Hello World Souffle.

Ingredients.
72 g haricot beans
101 eggs
108 g lard
111 cups oil
32 zucchinis
119 ml water
114 g red salmon
100 g dijon mustard
33 potatoes

Method.
Put potatoes into the mixing bowl. Put dijon mustard into the mixing bowl. Put lard into the mixing bowl. Put red salmon into the mixing bowl.
Put oil into the mixing bowl. Put water into the mixing bowl. Put zucchinis into the mixing bowl.
Put oil into the mixing bowl. Put lard into the mixing bowl. Put lard into the mixing bowl.
Put eggs into the mixing bowl. Put haricot beans into the mixing bowl. Liquefy contents of the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

Those numbers — 72, 101, 108, 111, 32, 119, 114, 100, 33 — are the character codes for H, e, l, o, space, w, r, d and the exclamation mark. Each letter is an ingredient, so lard (l) and oil (o) are used more than once.

The "Method" pushes them onto the stack in reverse order (because stacks are last in, first out), liquefies them so they print as characters, pours the result into a baking dish, and serves it. It outputs exactly "Hello world!"

It reads like a real recipe. It is absolutely not a real recipe. Please do not make this soufflé. 72 grams of haricot beans, 101 eggs, and 108 grams of lard would produce something catastrophic.

## What Is Cooklang?

Cooklang is a plain-text markup language for writing recipes that a computer can parse. Not a programming language. Not a joke. A practical tool for people who want to store recipes as text files and get useful things out of them.

Here is what scrambled eggs looks like in Cooklang:

```cooklang
Crack @eggs{3} into a #bowl and whisk with @salt{1%pinch} and @milk{2%tbsp}.

Melt @butter{1%tsp} in a #pan over low heat.

Pour in the egg mixture. Stir gently with a #spatula every ~{20%seconds} until just set.

Serve immediately.
```

That is a real recipe. You can cook from it. You can also run it through the [Cooklang CLI](/cli/) and get a shopping list:

```
$ cook shopping-list --plain "Scrambled Eggs"
eggs   3
salt   1 pinch
milk   2 tbsp
butter 1 tsp
```

The `@ingredient{quantity%unit}` syntax marks up ingredients so a parser knows what to extract. The `#cookware` syntax marks tools. The `~{time%unit}` syntax marks timers. Everything else is just prose — readable by humans without any special knowledge.

The point of Cooklang is not computation. The point is that your recipe files stay readable, portable, and useful for the things you actually want to do with recipes: scale servings, generate shopping lists, build meal plans, display cooking timers.

## The Same Dish, Two Approaches

Let me show scrambled eggs in both languages side by side. In Chef, to keep it simple, let me show a tiny program that outputs a number — not a full recipe, because a proper Chef program for scrambled eggs would be hundreds of lines of absurdist fiction.

**Chef version** (outputs the number 3, representing "3 eggs"):

```
Three Egg Program.

Ingredients.
3 eggs

Method.
Put eggs into the mixing bowl.
Pour contents of the mixing bowl into the baking dish.

Serves 1.
```

That program pushes 3 onto a stack and outputs it. The "recipe" contains no cooking instructions because there are no cooking instructions — only stack operations dressed up in kitchen language.

**Cooklang version** (actual scrambled eggs):

```cooklang
---
servings: 2
---

Crack @eggs{3} into a #bowl.
Add @salt{1%pinch} and @milk{2%tbsp} and whisk until combined.

Heat a #pan{} over low heat. Add @butter{1%tsp} and let it melt.

Pour in the eggs. Drag a #spatula{} slowly across the pan every ~{20%seconds}.
Remove from heat while still slightly underdone — residual heat finishes them.

Season with @black pepper{} and serve.
```

You can cook from this. It generates a shopping list. Scale it to 4 servings and every quantity doubles. The metadata at the top can carry prep time, tags, source links.

The difference in purpose is total. Chef uses recipe structure as a metaphor for computation. Cooklang uses minimal markup to make recipes computable without changing what they are.

## Why Cooklang Chose a Different Path

Chef is clever precisely because it inverts the relationship: the program is primary, the recipe-ness is cosmetic. You write code. The code happens to look like food.

Cooklang starts from the opposite direction. The recipe is primary. The markup is minimal and unobtrusive. A Cooklang file with all the special characters removed — no `@`, no `#`, no `~`, no `{}` — reads almost exactly like a recipe typed in plain English. That is by design.

This matters for practical reasons. Recipes are social objects. People share them, print them, read them aloud, annotate them. If your markup is heavy or technical, it creates friction. Nobody wants to send their grandmother a file full of stack push operations.

The computational properties of recipes are real — we wrote about this in depth in [Understanding Recipes as Stack Machines](/blog/05-recipes-as-stack-machines/). Ingredients go in, transformations are applied, a dish comes out. That structure is genuinely useful for building tools. But those tools should serve cooking, not the other way around.

## Why People Mix These Two Up

The confusion is understandable. Both involve the words "recipe" and "language" and "ingredients." Both are obscure enough that searching for one sometimes surfaces the other.

Chef gets mentioned in articles about weird programming languages, esoteric languages, code jokes, and CS curiosities. Cooklang gets mentioned in articles about recipe management, plain text workflows, and cooking automation.

If you found this post by searching "chef cooklang" or "chef language cooking" — you probably wanted one or the other. Here is a quick rule: if you want to compute Fibonacci numbers or sort a list using the metaphor of a kitchen, you want Chef. If you want to manage actual recipes, generate shopping lists, and build tools around your cooking, you want Cooklang.

## Both Get Something Right

I want to give Chef its due. It is a genuinely creative piece of work. The insight that recipe structure — a list of named quantities, a sequence of operations on containers, a final serving step — maps cleanly onto a computational model is not trivial. It is the same insight behind Cooklang, arrived at from a completely different direction.

Chef says: computation can be dressed as cooking. Cooklang says: cooking can be parsed as computation. Both are true. The applications are just different.

Chef programs run on computers and produce text. Cooklang recipes run in kitchens and produce dinner.

---

If you are looking for a language that helps you actually cook dinner, Cooklang is the one. If you want to compute Fibonacci numbers with chocolate cake, Chef's got you covered.

-Alex
