---
title: 'Generating a Recipe Graph with ChatGPT'
date: 2023-05-26T19:27:37+10:00
weight: 80
summary: "Using GPT-4 to trace ingredients through cooking steps and generate a recipe graph — a visual representation of how raw ingredients transform into a finished dish."
---

![](/blog/part-recipe-graph.png)

Cooklang tells you what ingredients go into a recipe and what steps to follow. But it doesn't capture the connections between them — which ingredients combine at which step, what intermediate results form along the way, how the whole process flows from raw inputs to finished dish.

A recipe graph does. It's a directed graph where nodes are ingredients, actions, and intermediate results, and edges show how they connect. It makes the structure of a recipe visible in a way that linear text can't.

The problem: building these graphs by hand is tedious. I wanted to see if GPT-4 could do it automatically.

## Why Recipe Graphs Matter

A written recipe is sequential — step 1, step 2, step 3. But cooking often isn't. You're working on the sauce while the pasta boils. The marinade started an hour ago. Three ingredients combine into a mixture that later gets added to something else.

A graph captures this structure. It shows parallel processes, merge points, and dependencies. For a recipe app, this means you could display each step with only the ingredients relevant to that step, highlight what's happening in parallel, and flag where timing matters.

People have been [discussing structured recipe representations](https://github.com/cooklang/spec/discussions/62) for a while. The graph format is particularly useful for computers that need to understand recipe flow — whether for step-by-step cooking apps, kitchen robotics, or smart displays.

## Using GPT-4 for Entity Recognition

GPT-4 is good at entity recognition and relationship extraction — exactly what we need. Given a recipe, it can identify ingredients, actions, and the relationships between them.

I started by looking at [GraphGPT](https://graphgpt.vercel.app), which uses direct prompting to extract graph structures from text. Adapting that approach to recipes, I built a prompt that asks GPT-4 to:

1. Identify all ingredients and cooking actions
2. Trace each ingredient through the recipe steps
3. Name intermediate results (e.g., "sauce base," "seasoned chicken")
4. Output the relationships in a structured format

The first attempt extracted entities but missed relationships. After a few iterations of prompt refinement, the results improved significantly:

{{< gist dubadub 244d3ea113565cae3817d89ebe9101ec>}}

Further fine-tuning produced output in Ruby syntax that could directly generate a graph image:

{{< gist dubadub 9da2fbe493a72e3090fefd9e5123dc45>}}

What's notable is how GPT-4 creates meaningful names for intermediate states. When onions and garlic are sautéed together, it labels the result "aromatic base" rather than "onion-garlic mixture." It understands cooking semantics.

![](/blog/part-recipe-graph.png)

[Open full graph](/blog/full-recipe-graph.png)

## What This Enables

If this approach works reliably at scale, it changes how recipe tools can work. You wouldn't need a specialized syntax for graph-based recipes — you'd write recipes however you want (including in Cooklang), and the AI extracts the graph structure automatically.

This means:
- Step-by-step cooking apps could show exactly which ingredients are needed for the current step
- Shopping lists could be generated with context about how each ingredient is used
- Recipe scaling could account for which steps are affected by quantity changes
- Cooking timelines could be built showing parallel processes and critical paths

The approach could be integrated into CookCLI and the mobile apps, parsing existing recipe collections into graph form without requiring users to learn any new syntax.

-Alexey
