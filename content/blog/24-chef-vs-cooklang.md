---
title: "Chef (the Esoteric Programming Language) vs Cooklang: What's the Difference?"
date: 2026-02-28
weight: 60
summary: "Two languages that look like recipes — but only one of them helps you cook dinner. A light-hearted comparison of Chef, the joke programming language, and Cooklang."
---

If you search for "chef programming language" or "chef coding language," you will find two very different things. One is a weird, wonderful esoteric language from 2002 where programs look like recipes. The other is Cooklang — a practical markup language where recipes actually are recipes.

They are easy to confuse from a search result. They serve completely opposite purposes. Let me sort it out.

## What Is the Chef Programming Language?

Chef was created by David Morgan-Mar in 2002. It is an esoteric programming language — meaning it was designed as a joke, a thought experiment, or a proof of concept rather than as a practical tool.

The joke is this: Chef programs look like recipes. Your variables are ingredient names. Your data structures are mixing bowls and baking dishes. Your operations have names like "Put," "Fold," "Add," "Combine," "Divide," and "Liquefy." You output a result by "Serving" the contents of a baking dish.

Chef is Turing-complete. You can write real programs in it. People have. That's both impressive and slightly horrifying.

Here is the structure of a Chef program:

```
Recipe Title

Ingredients.
[quantity] [measure-type] ingredient name
...

Cooking time: [time].

Pre-heat oven to [temp].

Method.
[imperative cooking instructions that are actually stack operations]
...

Serves [number of output streams].
```

The "Method" section is where the program logic lives. Each instruction maps to a stack operation:

- `Put ingredient into mixing bowl` → push ingredient value onto the stack
- `Fold ingredient into mixing bowl` → pop the top of the stack into an ingredient variable
- `Add ingredient to mixing bowl` → pop and add
- `Pour contents of mixing bowl into baking dish` → copy the stack to an output buffer
- `Serve with auxiliary-recipe` → call a subroutine

The outputs — the numbers that come out of your "baking dishes" — are decoded as ASCII characters to produce the final output. So if you want to print "Hello World," you need ingredients whose values correspond to the right ASCII codes.

## What a Chef "Hello World" Looks Like

The canonical Chef Hello World is a chocolate cake recipe. It is genuinely unhinged. The ingredients list looks like:

```
Ingredients.
72 g haricot beans
101 eggs
108 g lard
111 cups oil
32 zucchinis
87 g cornflour
111 ml water
114 g batter
100 g sugar
33 passion fruits
10 oranges
```

Those numbers — 72, 101, 108, 111, 32, 87, 111, 114, 108, 100, 33, 10 — are the ASCII codes for "Hello World!\n".

The "Method" then pushes them onto the stack in reverse order (because stacks are LIFO), pours the result into a baking dish, and serves it. The "recipe" compiles and runs correctly. It outputs exactly "Hello World!"

It reads like a real recipe. It is absolutely not a real recipe. Please do not make this cake. 72 grams of haricot beans, 101 eggs, and 108 grams of lard would produce something catastrophic.

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
- eggs: 3
- salt: 1 pinch
- milk: 2 tbsp
- butter: 1 tsp
```

The `@ingredient{quantity%unit}` syntax marks up ingredients so a parser knows what to extract. The `#cookware` syntax marks tools. The `~{time%unit}` syntax marks timers. Everything else is just prose — readable by humans without any special knowledge.

The point of Cooklang is not computation. The point is that your recipe files stay readable, portable, and useful for the things you actually want to do with recipes: scale servings, generate shopping lists, build meal plans, display cooking timers.

## The Same Dish, Two Approaches

Let me show scrambled eggs in both languages side by side. In Chef, to keep it simple, let me show a tiny program that outputs a number — not a full recipe, because a proper Chef program for scrambled eggs would be hundreds of lines of absurdist fiction.

**Chef version** (outputs the number 3, representing "3 eggs"):

```
Three Egg Program

Ingredients.
3 eggs

Method.
Put eggs into mixing bowl.
Pour contents of mixing bowl into baking dish.

Serves 1.
```

That program pushes 3 onto a stack and outputs it. The "recipe" contains no cooking instructions because there are no cooking instructions — only stack operations dressed up in kitchen language.

**Cooklang version** (actual scrambled eggs):

```cooklang
>> servings: 2

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

Chef programs run on computers and produce ASCII output. Cooklang recipes run in kitchens and produce dinner.

---

If you are looking for a language that helps you actually cook dinner, Cooklang is the one. If you want to compute Fibonacci numbers with chocolate cake, Chef's got you covered.

-Alex
