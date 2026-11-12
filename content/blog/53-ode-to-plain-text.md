---
title: "Ode to Plain Text: Lessons from Launching Cooklang"
date: 2026-11-12
weight: 50
summary: "A budgeting app I gave up on led me to plain text, and plain text led to Cooklang. What the launch got right, why the contributors I expected never came, and why I don't rush the spec."
description: "How plain-text accounting led to Cooklang, what the launch got right, why the contributors I expected never came, and why the spec changes slowly."
categories: ["Format and Design"]
---

## Discovering the plain text world

Once I was looking for a replacement for YNAB (You Need a Budget), a web app for tracking finances. It frustrated me: every time I iterated on my approach, say, by splitting or merging spending categories, I had to click a thousand times. Yes, I was wasting my time trying to make the tracking perfect.

YNAB wasn’t my first finance tracking app, but my third. I left the others for similar reasons: app creators are opinionated about how things should work, and misalignment with the user is bound to happen.

I was on a search... and on Reddit I discovered the world of plain text accounting. It blew my mind.

There’s a Ledger CLI app. The idea is to write your transactions in a structured way, like this:

```
2016/1/1 set opening balance
   assets:checking       $500.00
   equity:opening balances

2016/1/5 farmer's market
   expenses:groceries     $50.00
   assets:checking
```

Then a parser can extract information from it and give it to you for analytics, balances, or any other use.

I was sold on the idea that I could now use “replace all” in any editor, go through all my transactions, and quickly update them to my new way of doing things. Store them in git, build scripts for reports, stay local-first, test different apps without changing the data...

The idea is simple, yet powerful. Having data in plain text, separate from the applications, opens many doors.

I don’t track my finances anymore, because I’m not as poor as I was.

But the idea of going plain text and separating data from applications stuck with me.

## Plain text around us

Since then I’ve started noticing how plain text is conquering the world. (Well, re-conquering: decades ago, in the UNIX world, everything was plain text, even OS processes.)

Obsidian is the first example that comes to mind. You use Markdown to store notes in files on your disk. Period. The rest is a demonstration of the infinite possibilities of storing knowledge.

People have created thousands of plugins. They query structured data, write journals, manage to-do lists, connect notes in a graph...

Apart from Obsidian there are many, many apps: plain-text task managers, diagram builders, screenwriting tools, workout trackers...

## Recipes

Surprisingly, recipes never got an obvious plain text solution. Well, they are plain text from the start, but unstructured and messy.

This messiness makes it hard for computers to use recipes. Unless they can parse natural language (and before LLMs that wasn’t an easy problem), it’s hard to derive information from recipes: ingredient amounts, nutritional values, or even something as simple as scaling them. (I made the longer case for files over apps in [Why Plain Text Recipes Beat Databases Every Time](/blog/12-why-plain-text-recipes/).)

## Plain text recipes

There were a couple of recipe formats before I created Cooklang.

My favourite is RxOL, introduced by David A. Mundie in his Macintosh recipe app in 1985. It was impressively smart; check out [my interview with him](/blog/08-david-a-mundie-interview/) and the syntax examples.

Another one I love is [Pesto](https://6xq.net/pesto/).

What they have in common is that they let users write the recipe algorithm in full. It might not be obvious, but [recipes are algorithms](/blog/05-recipes-as-stack-machines/) we follow to get from the input (ingredients, cookware) to the output (yum yum).

You can express a recipe as a graph, and it will contain all the information a computer needs to understand the recipe in full.

There are Markdown-based formats, but they are limited in what they can express. And there are JSON/XML-based ones, which I wouldn’t consider plain text, since they aren’t usable by humans.

## Cooklang

Here is what it looks like:

```cooklang
Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
@milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
```

It still reads as a recipe, and a parser can pull out the ingredients, the amounts and the cookware.

### Idea

Of course, I didn’t research the available recipe formats when I decided to try creating a simple markup language for recipes. I tend to get discouraged when I can’t quickly redo someone else’s work, and the boring initial part of repeating what exists burns my enthusiasm.

I’m glad I went for it. Otherwise I wouldn’t have learned other things: how a language parser works, how to build an ecosystem, how to evolve a language specification. I even became a different person. It makes sense not to do the things that are logical. Do what is not logical but brings you joy and excitement.

Advice: choose non-optimal solutions, don’t research other people’s stuff, do stupid things. Then you’ll have something done behind you.

### Launch

> The right balance: Simple <> Complete

When the first version of Cooklang was presented to the public, it was basic, but still enough for people to get value from it. I didn’t stop at shipping the specification. I had a parser library, a prebuilt CLI for scripting, a web server inside the CLI to manage recipes in a UI, syntax highlighting for the most popular editors, and sample seed recipes. That let people quickly set it up and play with the language.

There were a few recipe markup languages before Cooklang, but they didn’t offer that. That small completeness helped demonstrate the value and created a wave of publications across the internet. It made the Hacker News front page, got a generous amount of comments on social media, and led to a few podcast appearances.

But at the same time, it wasn’t complete. Because it was basic, people shared many ways to improve it and engaged in conversations, and that is worth a lot. The discussions on Hacker News and in the GitHub spec repo are pure gold in terms of people’s ideas, and they gave me a field to develop for many years.

It was a simple format, and other people who had an itch to try writing a parser went all in. In a short time there were parsers in 15 languages. Along the way I needed to hone the specification, as good questions and edge cases were brought to my attention.

This principle works even if you post something that is bad quality. It happened to me when I published a rough draft of a plain text database and templates that used this data to make calculations on top of recipe information. A community member stepped in and rewrote all the code with all the beauty a human can produce.

## After launch

At the same time, I thought I could get people involved in building new features for the CLI, rather than talking or creating their own libraries.

At least that was my understanding of how open source works: your project gets core contributors, and they regularly work on it, contributing a few hours a week for years.

Nope, nope, nope. I was wrong.

People prefer not to fix yours, but to create their own thing. Their own flavour of Cooklang, apps, CLI. They didn’t come and fix my thing.

I tried the obvious fixes: I wrote developer documentation and created GitHub tickets with feature ideas.

None of that worked.

Sometimes I got sporadic contributors who were active for a few weeks, but that was because they were between jobs and working on their résumé.

You’re on your own here. Plan your time accordingly.

You get a lot of value from the feedback people give, but you do the work yourself.

The way I explain it to myself is that people need a big motivation to spend their free time contributing to something. People want to learn a new language or have something to show on their résumé. They don’t want to fix someone’s broken project for the sake of it.

It changed at later stages, though. When the CLI feature set grew big enough to cover people’s needs, I started to get contributions, with people adding small features on their own. But still not from my backlog; rather, they were back-porting what they had built in their own setup.

There’s a difference between a small consumer-focused project and a big enterprise-focused project, and they follow different mechanics.

I don’t worry about this these days. The help I get from AI in development is substantial, and I don’t need other contributors. It could even be that in other projects people now contribute garbage written with AI, and the maintainers have more problems than they would with no contributors at all.

I think it’s a perfect combo now: I apply my taste to things, and AI takes all the mundane work off my plate.

In terms of developing the language specification itself, I decided to go down the path of evolving the whole ecosystem, not just the specification.

That means if I add new syntax, people can use it in the CLI and mobile apps as soon as it’s released. That frustrates some people, because they want to add things to the language just for the sake of completeness in describing recipes, without actually comprehending how it will be used in the apps.

So things like ingredient alternatives are still an unsolved problem. I have a bunch of variants for how to express that in the language, but it’s hard to make a great UI flow for them, and I don’t rush.

That’s another thing worth talking about. When you don’t rush, a good solution will eventually come up. It’s hard to remove bad ideas from the spec; it’s much easier not to rush and do things right from the beginning.

You need to learn to say no, big time, to make this approach work.

I deeply feel the asymmetry: for me, the project is a big part of my life, and I’ve invested a lot of effort into it. But for people it’s one of many apps they have. They want it to be small, practical, and as invisible as possible.

I think the general opinion is that Cooklang is an over-engineered solution for a non-existent, or unimportant, problem. But I would argue with that. It [automated my grocery shopping](/blog/01-my-approach-to-automating-grocery-shopping/), and understanding what we eat, down to [what cooking does to the nutrients](/blog/07-nutrients-during-cooking/), can improve our day-to-day life and make us live longer and happier.

I’m working on that on behalf of the open-source community with the next generation of Cooklang, which can express how ingredients are transformed during cooking and allows attaching data points to each step of the recipe algorithm.

## Back to the ledger

Looking back, I never left that Reddit thread. Plain text format is a basic ask for me from the apps. And Cooklang serves that purpose. Your recipes in files you can open in any editor, and the apps come and go around them. I stopped tracking my finances, but I cook every day, and I would like the recipes I write today to be readable in 1985 software and in whatever we have in 2055. Plain text is the only format I trust to make that promise.

*If you want to try it, [start here](/docs/getting-started/).*
