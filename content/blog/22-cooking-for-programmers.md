---
title: "Cooking for Programmers: Why Recipes Are Just Algorithms"
date: 2026-02-25
weight: 60
summary: "Recipes are algorithms. Ingredients are variables. Techniques are functions. If you can read code, you can cook — and if you think about cooking like programming, your food gets better."
---

If you've ever followed a recipe, you've executed an algorithm. The pan is your runtime environment. Ingredients are input data. The finished dish is the output. And that moment when the recipe says "season to taste"? That's an untyped parameter with no validation.

This isn't a metaphor. The structural parallels between cooking and programming are real, and thinking about them makes you better at both.

## Recipes Are Sequential Programs

A recipe is a list of instructions executed in order, transforming input (raw ingredients) into output (a meal). Most recipes are strictly sequential — you can't frost a cake before you bake it.

```
function tomatoPasta(ingredients) {
    pan = heat(oil, "medium")
    pan = add(pan, dice(garlic))       // sauté 1 min
    pan = add(pan, tomatoes, salt)     // simmer 10 min
    pasta = boil(spaghetti, water)     // parallel process
    return combine(pasta, pan)
}
```

Every step takes the previous state and transforms it. That's a pipeline. Functional programmers would recognize this as a composition of pure-ish functions (ignoring the mutable pan state).

## Ingredients Are Variables

When a recipe says "400g canned tomatoes," that's a typed variable declaration with a value:

```
@canned tomatoes{400%g}
```

In [Cooklang](/docs/spec/), this is literal syntax. The `@` declares an ingredient, `400` is the quantity, `g` is the unit (the type). Your recipe file is source code that a parser can read.

The advantage of treating ingredients as typed variables: you can compute with them. Scale the recipe by 1.5x? Multiply all quantities. Generate a shopping list from three recipes? Union the ingredient sets and sum matching items. Calculate cost? Map ingredient names to price-per-unit data.

None of this works when ingredients are unstructured text in a blog post.

## Techniques Are Functions

"Dice," "sauté," "deglaze," "fold" — these are functions. Each takes inputs and produces outputs with side effects:

```
dice(onion) → diced_onion          // pure transformation
sauté(pan, garlic, oil) → pan'     // mutates the pan
deglaze(pan, wine) → pan''         // same
fold(batter, egg_whites) → batter' // careful: order matters
```

Professional cooks learn a library of these functions. Once you know `sauté`, you can apply it to anything — it's the same operation whether you're sautéing garlic, mushrooms, or shrimp. That's code reuse.

**Mise en place** — the practice of preparing all ingredients before cooking — is the culinary equivalent of initializing your variables before entering a hot loop. You don't want to be parsing garlic while your pan burns.

## Error Handling Is Underdeveloped

Recipes have terrible error handling. Most assume the happy path:

```
// Recipe says:
"Cook until golden brown"

// What happens:
if (color === "golden brown") continue
else if (color === "black") throw new BurntException() // not caught
else if (color === "still pale") ???  // no guidance
```

Good recipes handle edge cases. They tell you what "done" looks like, what to do if something goes wrong, and how to recover. Bad recipes assume everything works perfectly — like code with no error handling.

## Cooking Is Concurrent, Not Just Sequential

Simple recipes are sequential. Real cooking involves concurrency:

- Boil pasta **while** making the sauce
- Marinate the chicken **while** preparing the vegetables
- Preheat the oven **while** assembling the dish

This is parallel execution with synchronization points. The pasta and sauce are independent threads that join at the "combine" step. If the sauce finishes before the pasta, it waits (you keep it warm). If the pasta finishes first, it also waits (you drain it and toss with oil). The synchronization point is plating.

[Meal planning takes this further](/blog/meal-planning-as-compilation/) — planning a week of meals is like compiling a program. You're optimizing for resource usage (fridge space), dependency resolution (Monday's roast chicken becomes Tuesday's chicken salad), and scheduling (batch cook on Sunday, reheat Wednesday).

## Recipes Need a Type System

Most recipe formats don't distinguish between "1 cup flour" and "1 cup water." Structurally, they're the same — a quantity, a unit, and a name. But any cook knows they behave completely differently. Flour absorbs, water dissolves. You can substitute almond flour for wheat flour with adjustments. You can't substitute milk for water without changing the dish.

A proper recipe type system would encode these relationships. [Cooklang](/) takes the first step — separating ingredients (`@`), cookware (`#`), and timers (`~`) gives tools enough structure to generate shopping lists, track cookware, and run timers. The full ingredient taxonomy (substitution rules, dietary flags, allergen data) is a harder problem and an active area of development.

## Version Control Your Recipes

Recipes evolve. You try a dish, adjust the seasoning, change a technique, add a note. Most recipe apps don't track these changes. If you edit a recipe in Paprika or Mealie, the old version is gone.

If your recipes are text files, you can use Git:

```bash
git log --oneline recipes/pasta-sauce.cook
a3f2d1 reduce salt, add basil at the end
8b4c92 try san marzano tomatoes instead of regular
1e5f7a initial recipe from mom
```

Every change is tracked. You can diff versions, revert experiments that didn't work, and branch to try variations. This is recipe development with proper tooling.

## Start Cooking Like a Programmer

If any of this resonates, here's where to start:

1. **Try Cooklang.** Write one recipe in [Cooklang format](/docs/spec/). It takes 5 minutes. You'll immediately see how having structured ingredients changes what's possible.

2. **Use the CLI.** [CookCLI](/cli/) generates shopping lists, runs a recipe server, and searches your collection. It's the command-line tool you'd expect.

3. **Version control your recipes.** Put them in a Git repo. Start tracking changes. You'll never wonder "didn't this used to have more garlic?" again.

4. **Read the deep dives.** If you want the full CS theory, we've written about [recipes as stack machines](/blog/understanding-recipes-as-stack-machines/) and [meal planning as compilation](/blog/meal-planning-as-compilation/). They go much further than this introduction.

Cooking is one of the few activities that translates directly from programming concepts. The skills transfer in both directions. The more systematically you think about cooking, the better your food gets — and the more you appreciate that algorithms are everywhere, not just on screens.

[Get started with Cooklang →](/docs/getting-started/)

-Alex
