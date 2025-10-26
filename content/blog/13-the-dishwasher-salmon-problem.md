---
title: "The Dishwasher Salmon Problem"
date: 2025-10-26
weight: 60
summary: "Recipe blogs prioritize ads over quality, creating bizarre dishes like dishwasher salmon. Cooklang Federation solves this by connecting you to tried and true community recipes."
---

Blogs or websites you find recipes on exist to make money for their owners. They show ads and write long descriptions to rank higher in search engines. What they also do is modify recipes they copied somewhere to make them unique, hoping people share links (although I'm not confident why they do that).

That's how recipes like dishwasher salmon are born: https://en.wikipedia.org/wiki/Dishwasher_salmon. The race for unique content reverts the progress when people gradually improved recipes over time, creating the ideal golden recipe. Nowadays, despite the abundance of recipes, it's hard to find recipes that are tried and true.

![Dishwasher salmon](/blog/dishwasher-salmon.jpg)
*By I, Wildfeuer, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=4508533*

That's what I call the dishwasher salmon problem.

## Introducing Cooklang Federation

So, welcome a new project in the ecosystem: [**Cooklang Federation**](https://recipes.cooklang.org). If you're in need of finding recipes other community members are using, it's the place to find them.

The federation currently indexes **60+ active feeds** with over **3,500 recipes** from the community—and growing daily.

![Cooklang Federation interface](/blog/federation.png)
*Search across federated recipe collections with powerful filters*

You can search by keyword, tag, or explore feeds for inspiration.

### How It Works

The federation repository https://github.com/cooklang/federation contains a list of Atom/RSS feeds with recipes and public GitHub repositories with Cooklang recipes. These recipes get indexed regularly and are available in search.

Adding your recipes to the federation is straightforward. If you have a blog or website with Cooklang recipes, create an RSS or Atom feed and submit a pull request to add it to the `feeds.yaml` file. If you keep your recipes in a public GitHub repository, you can add that too. The federation crawler will automatically discover and index all your `.cook` files.

The system uses a GitOps approach—all feeds are version-controlled, and changes require pull request reviews. This creates transparency and a full audit trail of what's being indexed. An automated crawler periodically fetches updates from all registered feeds, parses the recipes using the Cooklang library, and indexes them using a full-text search engine. This enables powerful search capabilities across all recipes in the federation.

The beauty of this approach is that it's truly decentralized. You maintain full control of your recipes—host them wherever you want, on your own domain, your own GitHub repository. The federation just makes them discoverable. Think of it as "GitHub Pages for recipes."

### Get Started

**Looking for recipes?** [Browse the federation](https://recipes.cooklang.org) to search across community-curated recipe collections.

**Want to share your recipes?** Add your RSS/Atom feed or GitHub repository to the federation:
1. Visit the [federation repository](https://github.com/cooklang/federation)
2. Add your feed to `feeds.yaml`
3. Submit a pull request

It's still early days for the project, expect changes. I'm planning to integrate API into CookCLI for searching recipes online.

There's a draft specification if you're curious [here](https://github.com/cooklang/federation/blob/main/spec.md).

## Four Years of Cooklang

On the same day, on October 26th four years ago, I released publicly the Cooklang spec and first version of the CLI. It went to the front page of Hacker News. Since then Cooklang has been evolving, the community is growing, and the whole ecosystem now has 30+ repositories on the GitHub organization and many more community projects.

The Cooklang Federation represents the next step in this journey—moving from individual recipe management to community-driven discovery. By building on open standards and decentralized principles, we're creating a sustainable alternative to ad-driven recipe sites.

Whether you're looking to discover new recipes or share your own culinary creations, the federation provides a platform that respects both creators and users. Join us in building a better way to share recipes.

Start exploring at [recipes.cooklang.org](https://recipes.cooklang.org) or contribute your recipes at [github.com/cooklang/federation](https://github.com/cooklang/federation).

-Alex
