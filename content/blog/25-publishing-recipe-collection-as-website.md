---
title: "Publishing Your Recipe Collection as a Website"
date: 2026-02-28
weight: 60
summary: "Your .cook files are already structured data. Here's how to turn them into a real website — static, fast, free to host, and readable by Google's recipe search."
---

Your recipe collection is sitting in a folder on your laptop. Maybe it's a hundred `.cook` files organized by cuisine, maybe it's twenty files you actually use. Either way, it deserves better than being invisible.

Publishing your recipes as a website means you can share a link instead of an attachment, access your collection from any device, and let others discover your cooking. With Cooklang, your recipes are already structured — every ingredient, quantity, and step is machine-readable. That's the hard part done. This guide covers the full path from raw `.cook` files to a live website.

## Option 1: The Built-In Server (Five Minutes)

The fastest path is [CookCLI's](/cli/) built-in web server. It's not a static site — it's a live server you can expose to the internet — but for many people it's exactly enough.

```bash
cook server --host
```

That's it. Open `http://localhost:9080` and you have a browsable recipe collection. The `--host` flag makes it accessible from other devices on your network.

To expose it publicly, put it behind a reverse proxy like Nginx or Caddy and add a domain. Add Let's Encrypt for HTTPS. You now have a private recipe website that you can share with family.

The limitation: the server needs to keep running. It's not a static file you can drop on any CDN. If you want something you can push to GitHub and forget about, read on.

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

Generate JSON for every recipe:

```bash
mkdir -p data/recipes
find recipes/ -name "*.cook" | while read -r f; do
  slug=$(basename "$f" .cook | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  cook recipe "$f" -f json --pretty > "data/recipes/${slug}.json"
done
```

Then create a Hugo layout that reads from `data/recipes/`:

```html
<!-- layouts/recipes/single.html -->
{{ define "main" }}
  {{ $recipe := index .Site.Data.recipes .File.BaseFileName }}
  <h1>{{ $recipe.name }}</h1>

  <section class="metadata">
    {{ with $recipe.metadata.servings }}
      <span>Serves {{ . }}</span>
    {{ end }}
    {{ with $recipe.metadata.time }}
      <span>Time: {{ . }}</span>
    {{ end }}
  </section>

  <section class="ingredients">
    <h2>Ingredients</h2>
    <ul>
      {{ range $recipe.ingredients }}
        <li>
          {{ with .quantity }}{{ . }}{{ end }}
          {{ with .units }}{{ . }}{{ end }}
          {{ .name }}
        </li>
      {{ end }}
    </ul>
  </section>

  <section class="method">
    <h2>Method</h2>
    {{ range $recipe.sections }}
      {{ range .content }}
        {{ if eq .type "step" }}
          <p>{{ .value }}</p>
        {{ end }}
      {{ end }}
    {{ end }}
  </section>
{{ end }}
```

Hugo builds the site in milliseconds. The generated files are static HTML that works on any host.

## Option 4: Astro

[Astro](https://astro.build/) handles the JSON approach cleanly and gives you more flexibility in the component layer. Install the Cooklang parser for Node (`@cooklang/cooklang`) and read `.cook` files directly at build time:

```bash
npm create astro@latest my-cookbook
cd my-cookbook
npm install @cooklang/cooklang
```

Then in a content collection or page component, parse your `.cook` files and render them. Astro's island architecture means you can add interactive elements (a scaling widget, a timer) without making the whole site heavier.

The [Cooklang VS Code extension](https://marketplace.visualstudio.com/items?itemName=cooklang.vscode-cooklang) helps while you're writing recipes — syntax highlighting and a live preview of how the recipe will render.

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

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install CookCLI
        run: |
          curl -fsSL https://raw.githubusercontent.com/cooklang/CookCLI/main/install.sh | sh
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Install Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: "0.143.0"

      - name: Generate recipe JSON
        run: |
          mkdir -p data/recipes
          find recipes/ -name "*.cook" | while read -r f; do
            slug=$(basename "$f" .cook | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
            cook recipe "$f" -f json --pretty > "data/recipes/${slug}.json"
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
cook recipe "pasta-sauce" -f schema
```

The output is valid JSON-LD using the [Schema.org Recipe type](https://schema.org/Recipe):

```json
{
  "@context": "https://schema.org",
  "@type": "Recipe",
  "name": "Pasta Sauce",
  "recipeIngredient": [
    "400g canned tomatoes",
    "3 cloves garlic",
    "1 tbsp olive oil"
  ],
  "recipeInstructions": [
    {
      "@type": "HowToStep",
      "text": "Heat the olive oil in a pan over medium heat."
    }
  ]
}
```

Embed this in each recipe page inside a `<script type="application/ld+json">` tag. For Hugo, you can generate the schema output alongside the JSON data file and inject it in the recipe template:

```html
<!-- In your recipe layout -->
<script type="application/ld+json">
  {{ $schema := index .Site.Data.schema .File.BaseFileName }}
  {{ $schema | jsonify }}
</script>
```

Beyond structured data, the basics apply: descriptive page titles, meta descriptions, a clean URL structure (`/recipes/pasta-sauce/` not `/recipes/pasta-sauce-23847.html`), and images with descriptive alt text.

## Join the Cooklang Federation

The [Cooklang Federation](https://recipes.cooklang.org) indexes public recipe collections so others can discover them. If your site is public, you can add it to the index.

Your site needs to expose a feed — a JSON endpoint listing your recipes. The format is documented at the Federation site. Once you're in the index, your recipes are discoverable from the Federation's search, and people using the ecosystem's apps can subscribe to your collection.

This is what transforms a personal recipe archive into something that participates in an open network of shared cooking knowledge — no platform lock-in, no algorithm deciding who sees your recipes.

## Where to Start

The fastest path: install CookCLI, run `cook server --host`, and see your recipes in a browser. That works in five minutes.

If you want a real public site, the Hugo approach is solid and maintainable. Generate JSON once per recipe, build with Hugo, deploy to Netlify or GitHub Pages. The GitHub Actions workflow handles the publishing automatically.

Either way, your recipes stop being private files and start being something you can link to, share, and cook from anywhere.

[Get started with CookCLI →](/cli/) | [Read the Cooklang spec →](/docs/spec/)

-Alex
