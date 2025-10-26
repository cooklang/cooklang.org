---
title: 'Publishing Your Recipes'
weight: 16
description: 'Share your recipes with the Cooklang community through the federation'
---

Once you've built a collection of recipes you love, sharing them with the Cooklang community helps others discover tried-and-true recipes while maintaining full control of your content. The Cooklang Federation provides a decentralized platform for recipe publishing without requiring you to give up ownership or host on a specific platform.

## How Federation Publishing Works

Unlike traditional recipe platforms where you upload content to their servers, the federation uses a fundamentally different approach:

1. **You host your recipes** on your own website, blog, or GitHub repository
2. **You create a feed** (RSS/Atom or GitHub repository)
3. **The federation indexes** your recipes, making them searchable
4. **Users discover** your recipes through federation search
5. **They download** directly from your source

You maintain complete control. You can update, remove, or modify recipes anytime. The federation just makes them discoverable.

## Publishing via GitHub Repository

The simplest way to share recipes is through a public GitHub repository.

### Step 1: Create a Recipe Repository

```bash
# Create a new repository for your recipes
mkdir my-cooklang-recipes
cd my-cooklang-recipes
git init

# Add your .cook files
mkdir breakfast lunch dinner desserts
# ... add your recipes to these folders ...

# Commit and push to GitHub
git add .
git commit -m "Initial recipe collection"
git remote add origin https://github.com/yourusername/my-recipes.git
git push -u origin main
```

### Step 2: Add to Federation

1. Fork the [federation repository](https://github.com/cooklang/federation)
2. Edit `config/feeds.yaml` and add your repository:

```yaml
- url: "https://github.com/yourusername/my-recipes"
  title: "My Recipe Collection"
  feed_type: github
  branch: "main"
  enabled: true
  tags: [homecooking, italian, baking]
  notes: "Family recipes and weekend experiments"
  added_by: "@yourusername"
  added_at: "2025-10-26"
```

3. Submit a pull request
4. Once merged, the crawler will automatically discover and index your recipes

The federation will periodically check your repository for new or updated recipes.

## Publishing via RSS/Atom Feed

For blog-based recipe sharing, create an RSS or Atom feed.

### Step 1: Create Your Feed

Your feed should list your recipes with links to the raw `.cook` files. Here's a basic Atom feed example:

```xml
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
      xmlns:cooklang="https://cooklang.org/feeds/1.0">
  <title>My Recipe Blog</title>
  <link href="https://yourblog.com/feed.xml" rel="self"/>
  <updated>2025-10-26T00:00:00Z</updated>
  <author>
    <name>Your Name</name>
  </author>

  <entry>
    <title>Perfect Sourdough Bread</title>
    <link href="https://yourblog.com/recipes/sourdough"/>
    <id>https://yourblog.com/recipes/sourdough</id>
    <updated>2025-10-26T00:00:00Z</updated>
    <summary>A simple sourdough recipe with detailed instructions</summary>

    <!-- Link to the actual .cook file -->
    <link rel="enclosure"
          href="https://yourblog.com/recipes/sourdough.cook"
          type="text/plain"/>

    <!-- Cooklang-specific metadata -->
    <cooklang:tags>bread,baking,sourdough</cooklang:tags>
    <cooklang:difficulty>medium</cooklang:difficulty>
    <cooklang:time total="24h" active="2h"/>
    <cooklang:servings>1 loaf</cooklang:servings>
  </entry>

  <!-- More recipe entries... -->
</feed>
```

### Step 2: Host Your Feed and Recipes

Host both the feed XML file and your `.cook` files on your website:

```
yourblog.com/
├── feed.xml              # Your Atom feed
└── recipes/
    ├── sourdough.cook
    ├── pasta-carbonara.cook
    └── chocolate-cake.cook
```

### Step 3: Register Your Feed

Add your feed to the federation's `config/feeds.yaml`:

```yaml
- url: "https://yourblog.com/feed.xml"
  title: "Your Recipe Blog"
  feed_type: web
  enabled: true
  tags: [baking, italian, desserts]
  notes: "Recipes from my cooking blog"
  added_by: "@yourusername"
  added_at: "2025-10-26"
```

Submit a pull request to the [federation repository](https://github.com/cooklang/federation).

## Publishing with Static Site Generators

If you run a blog or website built with static site generators like Hugo, Jekyll, Eleventy, or Gatsby, you can publish recipes alongside your regular content while making them available to the federation.

### Using CookCLI to Export Markdown

CookCLI can convert your `.cook` files to Markdown format, which works perfectly with static site generators:

```bash
# Export a single recipe to markdown
cook recipe -f markdown recipes/carbonara.cook > content/recipes/carbonara.md

# Export all recipes in a directory
for recipe in recipes/*.cook; do
  basename=$(basename "$recipe" .cook)
  cook recipe -f markdown "$recipe" > "content/recipes/${basename}.md"
done
```

The generated Markdown includes YAML frontmatter with recipe metadata, formatted ingredient lists, step-by-step instructions, and equipment and cookware needed.

### Hugo Example

Here's a typical Hugo workflow:

**Directory structure:**
```
my-blog/
├── content/
│   ├── posts/          # Regular blog posts
│   └── recipes/        # Recipe pages
│       ├── _index.md
│       └── carbonara.md
├── recipes-source/     # Your .cook files
│   ├── carbonara.cook
│   └── sourdough.cook
└── static/
    └── recipes/        # Raw .cook files for federation
        ├── carbonara.cook
        └── sourdough.cook
```

**Build script** (`build-recipes.sh`):
```bash
#!/bin/bash

# Export all .cook files to markdown for Hugo
for recipe in recipes-source/*.cook; do
  basename=$(basename "$recipe" .cook)
  cook recipe -f markdown "$recipe" > "content/recipes/${basename}.md"
done

# Copy raw .cook files to static directory for federation
cp recipes-source/*.cook static/recipes/

# Build the Hugo site
hugo
```

**Generate RSS feed** in `config.toml`:
```toml
[outputs]
  home = ["HTML", "RSS"]
  section = ["HTML", "RSS"]

[[params.feeds]]
  title = "My Recipes"
  url = "/recipes/feed.xml"
```

Now your recipes are viewable as HTML pages on your blog (from Markdown), downloadable as `.cook` files from `/recipes/` (for federation), and syndicated via RSS feed (for federation indexing).

### Jekyll Example

**Directory structure:**
```
my-blog/
├── _posts/
├── _recipes/          # Recipe collection
│   └── carbonara.md
├── recipes-source/
│   └── carbonara.cook
└── recipes/           # Raw .cook files
    └── carbonara.cook
```

**Jekyll collection** in `_config.yml`:
```yaml
collections:
  recipes:
    output: true
    permalink: /recipes/:name/

defaults:
  - scope:
      path: ""
      type: "recipes"
    values:
      layout: "recipe"
```

**Build script**:
```bash
#!/bin/bash

# Export recipes to Jekyll collection
for recipe in recipes-source/*.cook; do
  basename=$(basename "$recipe" .cook)
  cook recipe -f markdown "$recipe" > "_recipes/${basename}.md"
done

# Copy raw .cook files
cp recipes-source/*.cook recipes/

# Build Jekyll site
jekyll build
```

### Automated Workflow with GitHub Actions

Automate recipe conversion and deployment:

```yaml
# .github/workflows/publish-recipes.yml
name: Publish Recipes

on:
  push:
    branches: [main]
    paths:
      - 'recipes-source/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install CookCLI
        run: |
          curl -L https://github.com/cooklang/cookcli/releases/latest/download/cook-linux-amd64 -o cook
          chmod +x cook
          sudo mv cook /usr/local/bin/

      - name: Convert recipes to markdown
        run: |
          mkdir -p content/recipes
          for recipe in recipes-source/*.cook; do
            basename=$(basename "$recipe" .cook)
            cook recipe -f markdown "$recipe" > "content/recipes/${basename}.md"
          done

      - name: Copy raw .cook files
        run: |
          mkdir -p static/recipes
          cp recipes-source/*.cook static/recipes/

      - name: Build and deploy
        run: |
          # Your static site generator build command
          hugo
          # Or jekyll build, npm run build, etc.
```

### Benefits of This Approach

For readers, this approach provides beautiful recipe pages with your site's design that are easy to browse and search on your website, plus printable, shareable web pages.

For the federation, raw `.cook` files remain accessible for download, RSS/Atom feeds are automatically generated, and recipes are indexed and searchable.

For you as the author, you maintain a single source of truth with your `.cook` files, benefit from automated conversion to web format, keep recipes version controlled with your blog content, and avoid manual HTML writing or duplication.

## Recipe Metadata Best Practices

Help users find your recipes by including rich metadata in your `.cook` files using YAML frontmatter:

```cooklang
---
title: Classic Carbonara
description: An authentic Roman pasta dish
tags: [italian, pasta, quick, dinner]
servings: 4
prep time: 10 minutes
cook time: 15 minutes
difficulty: easy
---

...
```

Good metadata makes your recipes more discoverable and useful. Use consistent, descriptive tags like vegan, glutenfree, italian, or breakfast. Be honest about the skill level required. Include both prep and total time. Write clear, concise summaries in the description field. Specify serving size or yield clearly.

## The Federation Specification

The federation uses a formal specification for recipe feeds. While basic RSS/Atom works, the [Cooklang feed specification](https://github.com/cooklang/federation/blob/main/spec.md) defines optional extensions for richer metadata. These include `<cooklang:servings>` for number of servings, `<cooklang:time>` for prep and total cooking time, `<cooklang:tags>` for category tags, `<cooklang:difficulty>` for recipe difficulty, `<cooklang:image>` for recipe images, and `<cooklang:nutrition>` for nutritional information.

These extensions help the federation provide better search and filtering capabilities.

## Updating Your Recipes

One of the federation's key advantages is that you can update recipes anytime.

For GitHub repositories, simply edit your `.cook` files locally, commit and push changes, and the federation automatically picks up updates on the next crawl.

For RSS/Atom feeds, update your `.cook` files on your server, update the `<updated>` timestamp in your feed, and the federation detects changes via conditional HTTP requests.

## Privacy and Control

The federation respects your autonomy. You can host anywhere—your website, GitHub, GitLab, or anywhere public. You control when and how recipes change, and can update them anytime. You can remove recipes anytime by deleting them from your source and updating your feed. You can license your recipes as you wish, choosing your own license (MIT, CC-BY, proprietary, etc.). There's no platform lock-in, so you're not dependent on a single service.

If you want to leave the federation, simply remove your feed from `feeds.yaml` or make your repository private.

## GitOps Workflow

The federation uses a transparent GitOps approach for feed management. All changes happen via pull requests, so feed additions require community review. CI validation ensures automated checks verify that feeds are valid and accessible. Everything is version controlled, providing a full audit trail of all feeds in Git history. The process is community governed, with changes reviewed by maintainers and community members.

This ensures quality control while keeping the process open and transparent.

## Benefits of Publishing

Sharing your recipes through the federation offers several advantages.

For you, it provides increased visibility for your recipes and blog, community feedback and engagement, the satisfaction of contributing to the Cooklang ecosystem, and full control over your content.

For the community, it means more recipes to discover, diverse cooking styles and cuisines, real recipes from real cooks, and a growing ecosystem of Cooklang content.

## Getting Started

Ready to share your recipes?

1. **Organize your recipes**: Collect your `.cook` files in a repository or website
2. **Add metadata**: Ensure recipes have proper tags, times, and descriptions
3. **Create a feed**: GitHub repository or RSS/Atom feed
4. **Submit to federation**: Pull request to add your feed to `feeds.yaml`
5. **Wait for indexing**: The crawler will discover and index your recipes

## See Also

- [Recipe Discovery](../recipe-discovery/) - How users will find your recipes
- [Federation Repository](https://github.com/cooklang/federation) - Submit your feed here
- [Federation Specification](https://github.com/cooklang/federation/blob/main/spec.md) - Technical details
- [Creating Cookbooks](../cookbook-creation/) - Turn your recipes into a PDF cookbook
