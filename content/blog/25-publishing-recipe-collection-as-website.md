---
title: "Publishing Your Recipe Collection as a Website"
date: 2026-02-28
lastmod: 2026-11-19
weight: 60
summary: "Your .cook files are already structured data. Here's how to turn them into a real website — static, fast, free to host, and readable by Google's recipe search."
description: "Your .cook files are already structured data. How to turn them into a real recipe website — static, fast, free to host, and readable by Google's recipe search."
categories: ["Guides and Tutorials"]
---

Your recipe collection is sitting in a folder on your laptop. Maybe it's a hundred `.cook` files organized by cuisine, maybe it's twenty files you actually use. Either way, it deserves better than being invisible.

Publishing your recipes as a website means you can share a link instead of an attachment, access your collection from any device, and let others discover your cooking. With Cooklang, your recipes are already structured — every ingredient, quantity, and step is machine-readable. That's the hard part done. This guide covers the full path from raw `.cook` files to a live website.

## Option 1: The Built-In Server (Five Minutes)

The fastest path is [CookCLI's](/cli/) built-in web server. It's not a static site — it's a live server you can expose to the internet — but for many people it's exactly enough.

```bash
cook server --host
```

That's it. Open `http://localhost:9080` and you have a browsable recipe collection. The `--host` flag makes it accessible from other devices on your network.

To expose it publicly, put it behind a reverse proxy like Nginx or Caddy, add a domain, and start the server with `--cors-origin https://recipes.example.com` (it refuses host names it hasn't been told about). Add Let's Encrypt for HTTPS, and run `cook server user add <name>` so only you can edit. You now have a recipe website that you can share with family.

The limitation: the server needs to keep running. It's not a static file you can drop on any CDN. If you want something you can push to GitHub and forget about, read on.

The shortest route to that is built in: `cook build web` writes a complete static site (an index, one page per recipe, search) to `_site/`, ready for any static host. [Publish Your Recipe Collection as a Static Site](/blog/50-cook-build-web-static-site/) and the [static website guide](/guides/static-website/) cover it. The options below are for when you want full control over the HTML.

## Option 2: Static HTML from a Bash Script

If you want maximum simplicity with no build system, you can write a short script that converts every `.cook` file to an HTML page using `cook recipe`.

CookCLI can output a recipe as markdown:

```bash
cook recipe "pasta-sauce" -f markdown
```

Or as JSON with every field parsed:

```bash
cook recipe "pasta-sauce" -f json --pretty
```

Here's a script that generates a minimal static site from your entire recipe collection:

```bash
#!/usr/bin/env bash
# build.sh — convert all .cook files to HTML pages

set -euo pipefail

RECIPES_DIR="./recipes"
OUTPUT_DIR="./site"
mkdir -p "$OUTPUT_DIR"

# Generate index page
echo "<html><head><title>My Recipes</title></head><body>" > "$OUTPUT_DIR/index.html"
echo "<h1>Recipes</h1><ul>" >> "$OUTPUT_DIR/index.html"

find "$RECIPES_DIR" -name "*.cook" | sort | while read -r cookfile; do
  name=$(basename "$cookfile" .cook)
  slug=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  outfile="$OUTPUT_DIR/$slug.html"

  # Get recipe as markdown, wrap in minimal HTML
  markdown=$(cook recipe "$cookfile" -f markdown)

  cat > "$outfile" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${name}</title>
  <link rel="stylesheet" href="/style.css">
</head>
<body>
  <main>
    <a href="/">← All recipes</a>
    $(echo "$markdown" | pandoc -f markdown -t html)
  </main>
</body>
</html>
HTML

  echo "<li><a href=\"/${slug}.html\">${name}</a></li>" >> "$OUTPUT_DIR/index.html"
done

echo "</ul></body></html>" >> "$OUTPUT_DIR/index.html"
echo "Built $(find "$OUTPUT_DIR" -name "*.html" | wc -l) pages."
```

This requires `pandoc` for the markdown-to-HTML conversion step. The output is a flat directory of HTML files you can host anywhere.

## Option 3: Hugo with JSON Data

[Hugo](https://gohugo.io/) is fast and has a useful feature for this: data templates. You can feed it JSON files and generate pages from them.

Generate a Schema.org JSON file and a content page for every recipe. The Schema.org output is the easiest to template, because ingredients and steps are already plain strings:

```bash
mkdir -p data/recipes content/recipes
find recipes/ -name "*.cook" | while read -r f; do
  slug=$(basename "$f" .cook | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  cook recipe "$f" -f schema > "data/recipes/${slug}.json"
  printf -- '---\ntitle: "%s"\n---\n' "$(basename "$f" .cook)" > "content/recipes/${slug}.md"
done
```

Then create a Hugo layout, `layouts/recipes/single.html`, that reads from `data/recipes/`:

```html
{{ define "main" }}
  {{ $recipe := index .Site.Data.recipes .File.BaseFileName }}
  <h1>{{ .Title }}</h1>

  <section class="metadata">
    {{ with $recipe.recipeYield }}<span>Yield: {{ . }}</span>{{ end }}
    {{ with $recipe.totalTime }}<span>Time: {{ . }}</span>{{ end }}
  </section>

  <section class="ingredients">
    <h2>Ingredients</h2>
    <ul>
      {{ range $recipe.recipeIngredient }}<li>{{ . }}</li>{{ end }}
    </ul>
  </section>

  <section class="method">
    <h2>Method</h2>
    <ol>
      {{ range $recipe.recipeInstructions }}<li>{{ .text }}</li>{{ end }}
    </ol>
  </section>

  <script type="application/ld+json">{{ $recipe | jsonify | safeJS }}</script>
{{ end }}
```

`totalTime` is an ISO duration such as `PT20M`, and the last line embeds the structured data search engines read. Hugo builds the site in milliseconds. The generated files are static HTML that works on any host.

## Option 4: Astro

[Astro](https://astro.build/) handles the JSON approach cleanly and gives you more flexibility in the component layer. Install the Cooklang parser for Node (`@cooklang/cooklang`) and read `.cook` files directly at build time:

```bash
npm create astro@latest my-cookbook
cd my-cookbook
npm install @cooklang/cooklang
```

Then in a content collection or page component, parse your `.cook` files and render them. Astro's island architecture means you can add interactive elements (a scaling widget, a timer) without making the whole site heavier.

The [Cooklang VS Code extension](https://marketplace.visualstudio.com/items?itemName=dubadub.cook) helps while you're writing recipes — syntax highlighting, auto-completion and error checking.

## Making It Look Good

A few things matter more than the visual design:

**Typography first.** Recipes are read on phones in a kitchen with wet hands. Use large body text (18px+), high contrast, and generous line height. Sans-serif for ingredients, serif for the method — or just pick one font and use it consistently.

**Responsive from the start.** A two-column layout on desktop (ingredients left, method right) works well. On mobile, stack them: ingredients above, then method. CSS Grid handles this in ten lines.

**Step numbers.** Numbered method steps let someone quickly say "I'm on step 4." Use an ordered list, not paragraphs.

**Recipe images.** Store them alongside the `.cook` files with the same base name (`pasta-sauce.jpg` next to `pasta-sauce.cook`). Your build script can check for a matching image and include it automatically.

## Free Hosting

**GitHub Pages** is the path of least resistance. Push your site to a repository, enable Pages in the settings, and it's live at `yourusername.github.io/cookbook`. Add a custom domain in the same settings screen if you have one.

**Netlify** adds auto-deploy: every push to your repository triggers a build. For a Hugo or Astro site, configure the build command and publish directory, and it handles the rest:

```yaml
# netlify.toml
[build]
  command = "hugo"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.143.0"
```

**Cloudflare Pages** works the same way and has generous free tier limits. It also puts your site on Cloudflare's CDN automatically, which makes global load times fast.

All three options are free for personal recipe sites. The main difference is deployment workflow. Pick whichever fits your existing tools.

## Automating Builds with GitHub Actions

If you keep your `.cook` files in a Git repository, you can automate the build-and-publish step. Push a new recipe, and the site rebuilds and deploys automatically:

```yaml
# .github/workflows/deploy.yml
name: Build and Deploy

on:
  push:
    branches: [main]

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install CookCLI
        run: |
          VERSION=$(curl -sIL -o /dev/null -w '%{url_effective}' https://github.com/cooklang/cookcli/releases/latest | sed 's|.*/tag/v||')
          curl -L "https://github.com/cooklang/cookcli/releases/download/v$VERSION/cook-$VERSION-linux-x86_64-gnu.tar.gz" | tar xz
          sudo install -m 755 cook /usr/local/bin/cook

      - name: Install Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: "0.143.0"

      - name: Generate recipe JSON
        run: |
          mkdir -p data/recipes content/recipes
          find recipes/ -name "*.cook" | while read -r f; do
            slug=$(basename "$f" .cook | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            cook recipe "$f" -f schema > "data/recipes/${slug}.json"
            printf -- '---\ntitle: "%s"\n---\n' "$(basename "$f" .cook)" > "content/recipes/${slug}.md"
          done

      - name: Build Hugo site
        run: hugo --minify

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

The workflow installs CookCLI, converts your recipes to JSON, builds the site with Hugo, and pushes the output to the `gh-pages` branch. After the first run, every commit to `main` publishes automatically.

## SEO for Recipe Websites

Google has a dedicated recipe search experience with rich results — cooking time, ingredients, star ratings, and photos appearing directly in search. To qualify, your pages need structured data in JSON-LD format.

CookCLI generates this directly:

```bash
cook recipe "pasta-sauce" -f schema --pretty
```

The output is valid JSON-LD using the [Schema.org Recipe type](https://schema.org/Recipe):

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "pasta-sauce",
  "recipeIngredient": [
    "1 tbsp olive oil",
    "3 cloves garlic",
    "400 g canned tomatoes"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "position": 1,
      "text": "Heat the olive oil in a pan over medium heat."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "text": "Add garlic and canned tomatoes. Simmer for 15 minutes.",
      "timeRequired": "PT15M"
    }
  ],
  "recipeYield": "4 servings",
  "tool": [
    "pan"
  ],
  "totalTime": "PT30M"
}
```

`name` is the file name unless the recipe has a `title:` in its front matter. Embed the output in each recipe page inside a `<script type="application/ld+json">` tag. The Hugo layout above already does that in its last line; note the `safeJS`, without which Hugo escapes the JSON into a quoted string that search engines cannot read.

Beyond structured data, the basics apply: descriptive page titles, meta descriptions, a clean URL structure (`/recipes/pasta-sauce/` not `/recipes/pasta-sauce-23847.html`), and images with descriptive alt text.

## Join the Cooklang Federation

The [Cooklang Federation](https://recipes.cooklang.org) indexes public recipe collections so others can discover them. If your site is public, you can add it to the index.

The Federation's crawler reads your recipes either straight from a GitHub repository of `.cook` files, or from an Atom feed on your site that links each raw `.cook` file. You register by opening a pull request against [cooklang/federation](https://github.com/cooklang/federation); the [publishing guide](/guides/publishing-recipes/) has the steps. Once you're in the index, your recipes are discoverable from the Federation's search.

This is what transforms a personal recipe archive into something that participates in an open network of shared cooking knowledge — no platform lock-in, no algorithm deciding who sees your recipes.

## Where to Start

The fastest path: install CookCLI, run `cook server --host`, and see your recipes in a browser. That works in five minutes.

If you want a real public site, the Hugo approach is solid and maintainable. Generate JSON once per recipe, build with Hugo, deploy to Netlify or GitHub Pages. The GitHub Actions workflow handles the publishing automatically.

Either way, your recipes stop being private files and start being something you can link to, share, and cook from anywhere.

[Get started with CookCLI →](/cli/) | [Read the Cooklang spec →](/docs/spec/)

-Alex
