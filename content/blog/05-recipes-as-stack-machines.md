---
title: "Understanding Recipes as Stack Machines"
date: 2024-11-29
weight: 80
summary: "Recipes push ingredients onto a workspace, transform them through operations, and produce a finished dish — the same way a stack machine pushes data, applies functions, and returns results."
---

I keep finding computer science in the kitchen.

Last month I was making a vinaigrette and noticed something: I added vinegar to a bowl, then oil, then whisked. Each step consumed what was on top and produced something new. Vinegar goes in. Oil goes in. Whisk operates on both and produces emulsion. That's a stack.

```
push(vinegar)         → [vinegar]
push(oil)             → [vinegar, oil]
whisk()               → [emulsion]
```

Once I saw it, I couldn't unsee it. Every recipe is a stack machine.

## The Model

A stack machine has three operations: push data onto the stack, apply a function that consumes items from the top and pushes a result, and the final value on the stack is the output.

In cooking:
- **Push** = add an ingredient or tool to the workspace
- **Apply** = perform a cooking action (chop, sauté, fold, bake)
- **Output** = the finished dish sitting on the stack when all operations are done

A simple pasta sauce:

```
push(olive oil)       → [oil]
push(garlic)          → [oil, garlic]
sauté()               → [aromatic base]
push(tomatoes)        → [aromatic base, tomatoes]
push(salt)            → [aromatic base, tomatoes, salt]
simmer(20min)         → [sauce]
```

Six operations. Each one is unambiguous. The state of the "stack" at any point tells you exactly what's on the stove.

## Why This Is Useful

This isn't just a cute analogy. It solves real problems.

**Validation.** A well-formed recipe should leave exactly one item on the stack: the finished dish. If you have leftover ingredients that were never used in any operation, that's a bug. An egg was declared but never cracked. Parsley was listed but never added. A stack-based validator could catch these errors automatically.

In Cooklang terms, this means checking that every `@ingredient` is consumed by a step. If it isn't, the recipe has an unused ingredient — either a mistake or a missing instruction.

**Type checking.** Not every operation works on every ingredient. You can whisk liquids together. You can't whisk two solids. You can fold egg whites into batter. You can't fold flour into water (that's mixing, different operation, different result).

A type system for cooking operations could flag nonsensical steps:

```
push(water)           → [water]         : liquid
push(flour)           → [water, flour]  : liquid, dry
fold()                → ERROR: fold requires a foam/batter and a dry, got liquid and dry
mix()                 → [batter]        : semi-solid  ✓
```

This is theoretical for now, but it's the kind of validation that would make recipe authoring tools genuinely smarter.

**Dependency graphs.** When you flatten the stack operations into a graph — each operation as a node, each ingredient as an input edge — you get a directed acyclic graph that reveals the recipe's structure. Parallel operations become visible. Critical paths become clear.

A Thanksgiving turkey dinner has dozens of parallel stacks that converge at plating. The turkey stack, the gravy stack, the mashed potatoes stack, the cranberry sauce stack — each independent, each with its own timeline, all synchronizing at the end. A graph representation makes this structure explicit instead of hiding it in a wall of sequential text.

## Recipes in Forth

If you squint, cooking instructions look like Forth — the original stack-oriented programming language:

```forth
: vinaigrette
  1 tbsp vinegar
  3 tbsp oil
  whisk
  pinch salt
  stir ;

: salad
  lettuce wash chop
  tomato dice
  vinaigrette
  toss ;
```

The `: vinaigrette` defines a reusable word (a subroutine). `salad` calls it. The stack manages data flow implicitly.

This is absurd and impractical for actual cooking, but it illustrates why the stack model fits. In Forth, you don't name intermediate variables — data flows through the stack. In cooking, you don't name intermediate states either. The stuff in the pan is just "the stuff in the pan" until it becomes the dish.

## Where Cooklang Fits

Cooklang doesn't use the stack model explicitly — it's designed for humans, not for formal computation. But the annotations provide enough structure to build a stack-based analysis on top of it.

Every `@ingredient` is a push. Every step that transforms ingredients is an operation. A recipe validator could walk through a `.cook` file, model it as stack operations, and report:

- Unused ingredients (pushed but never consumed)
- Missing ingredients (operation expects something that was never pushed)
- Impossible operations (type mismatches)
- Parallel opportunities (independent stacks that could run concurrently)

This is where [recipe graphs](/blog/generating-a-recipe-graph-with-chatgpt/) connect — a graph is what you get when you lay a stack machine's execution trace out spatially instead of temporally.

## The Point

Recipes are instructions meant to produce consistent results from defined inputs. So are programs. The more formally we think about recipes, the better tools we can build — validators that catch errors before you waste ingredients, schedulers that optimize cooking time, scaling systems that adjust quantities correctly.

The stack machine model isn't the only way to formalize recipes, but it's a natural one. It matches how cooking actually works: you assemble components, transform them, combine results, and end up with a dish.

The best recipes, like the best code, are both elegant and robust.

-Alexey
