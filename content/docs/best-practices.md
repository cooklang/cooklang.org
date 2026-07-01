---
title: 'Tips, Tricks, and Best Practices'
date: 2026-07-01
draft: false
weight: 4
summary: A collection of practical ideas to help you get the most out of writing recipes and planning meals with Cooklang.
---

This is a collection of practical ideas we think will help you get the most out of Cooklang, whether you're writing your first recipe or organising a whole cookbook.

## Organise your recipes into folders

If you have more than a few dozen recipes, it can be very helpful to organise them into folders like `Dinners`, `Lunches`, `Breakfasts`, and `Desserts`. Because Cooklang recipes are just plain-text files, they behave exactly like any other files on your computer — move them, rename them, and version-control them however you like.

## Only `@mention` each ingredient once

When you're writing a recipe, only tag each ingredient with `@` the first time it appears. After that, you can simply refer to the ingredient by name and relative quantity — for example, "then put half the remaining bacon in the oven to crispen." This keeps your shopping lists accurate, since a repeated `@mention` would otherwise add the ingredient twice.

## Aim for scalable recipes

Use Cooklang's [quantity scaling](/docs/spec/) features so a recipe adjusts cleanly to different serving sizes. We usually aim to support three different serving sizes in our sample recipes. Some recipes just don't scale up or down well, and that's okay! A soup scales far more gracefully than a cake or a pie.

## Start with a meal plan, then iterate

You don't need to build every meal plan from scratch. Take a `.menu` plan you've used before and add or remove recipes, or adjust servings to suit the coming week. See [Meal Planning](/docs/use-cases/meal-planning/) for a full walkthrough.

## Put no-prep foods on your meal plans

It's nice to have an apple or a banana sometimes, but it doesn't make sense to write a whole "recipe" for them. Add these to your meal plan and shopping list directly so nothing gets forgotten on shopping day.

## Keep metadata in YAML frontmatter

Store recipe metadata — servings, source, tags, and so on — in a YAML frontmatter block at the top of the file. See [Conventions](/docs/conventions/) for the full list of supported keys.

## Send us your tips and tricks

We love hearing good ideas about how people use Cooklang, the apps, and CookCLI. Share yours through any of the channels on our [contact page](/contact/).
