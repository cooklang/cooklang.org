# Blog Category Hubs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add five topic-cluster hub pages under `/blog/<topic>/` with editorial intro content, plus breadcrumb and related-posts internal linking from each post, to give Cooklang's 51 blog posts targeted SEO hubs without restructuring the existing flat `/blog/` index.

**Architecture:** Hugo `categories` taxonomy with a `[permalinks]` override that flattens term URLs from `/categories/<slug>/` to `/blog/<slug>/`. Term content lives at `content/categories/<slug>/_index.md` (Hugo's standard location). The auto-generated `/categories/` listing is disabled via `disableKinds = ["taxonomy"]`. Each hub combines its `_index.md` editorial intro with an auto-generated post grid below. Posts get a breadcrumb (with `BreadcrumbList` JSON-LD) at the top and a related-posts footer at the bottom.

**Tech Stack:** Hugo (static site), TOML config, YAML frontmatter, Go templates, Tailwind CSS via theme `cooklang-tw`.

**Spec:** `docs/superpowers/specs/2026-05-27-blog-category-hubs-design.md`

---

## Pre-flight

Before starting, verify the working tree is clean and Hugo builds successfully today:

```bash
git status              # expect: clean
hugo --quiet            # expect: no errors, public/ populated
ls public/blog/         # expect: 51 numbered post directories + index.html
```

If Hugo isn't installed locally: `brew install hugo` on macOS.

---

## Task 1: Configure taxonomy, permalink override, and disable taxonomy list

**Files:**
- Modify: `config.toml`

- [ ] **Step 1: Read current config.toml to find the right insertion point**

The file uses TOML top-level sections. We'll insert the new keys near the existing top-level settings (above `[markup]`), and at the end add `disableKinds`.

- [ ] **Step 2: Add taxonomy block + permalinks block + disableKinds**

After the existing `title = "Cooklang"` / `theme = "cooklang-tw"` block at the top, append before `pygmentsCodeFences = true`:

```toml
disableKinds = ["taxonomy"]

[taxonomies]
  category = "categories"

[permalinks]
  categories = "/blog/:slug/"

```

Notes:
- `disableKinds = ["taxonomy"]` suppresses the auto-generated `/categories/` landing page (which would otherwise list all five term names — thin content for SEO). Term pages (kind: `term`) still generate.
- `category = "categories"` declares a single taxonomy with singular form `category` (used in template paths) and plural form `categories` (used in URL and frontmatter).
- `[permalinks] categories = "/blog/:slug/"` rewrites term URLs from `/categories/<slug>/` to `/blog/<slug>/`. The content path Hugo reads from is unaffected by this — that's still `content/categories/<slug>/_index.md`.

- [ ] **Step 3: Verify Hugo builds with no errors**

Run:
```bash
hugo --quiet
```
Expected: exit code 0, no warnings.

- [ ] **Step 4: Verify the existing blog index still renders**

Run:
```bash
test -f public/blog/index.html && echo OK
```
Expected: `OK`.

- [ ] **Step 5: Verify no `/categories/` index page was generated**

Run:
```bash
test ! -f public/categories/index.html && echo "categories list disabled OK"
```
Expected: `categories list disabled OK`.

- [ ] **Step 6: Commit**

```bash
git add config.toml
git commit -m "blog: configure categories taxonomy with /blog/<slug>/ permalinks"
```

---

## Task 2: Create the hub category template

**Files:**
- Create: `layouts/taxonomy/category.html`

This template renders each term page. It echoes the `_index.md` content (intro) at the top, then a grid of all posts assigned to this category, sorted by date desc.

- [ ] **Step 1: Read the existing blog list template for visual consistency**

```bash
cat layouts/blog/list.html
```
Note the card markup and Tailwind classes — we mirror them in this template.

- [ ] **Step 2: Create the template file**

Create `layouts/taxonomy/category.html` with:

```html
{{ define "main" }}
<div class="bg-white">
  <div class="container mx-auto px-4 py-8 max-w-6xl">
    <header class="mb-8">
      <nav class="text-sm text-cooklang-gray-600 mb-4" aria-label="Breadcrumb">
        <ol class="flex items-center space-x-2">
          <li><a href="/blog/" class="hover:text-cooklang-orange">Blog</a></li>
          <li class="text-cooklang-gray-400">›</li>
          <li class="text-cooklang-gray-900" aria-current="page">{{ .Title }}</li>
        </ol>
      </nav>
      <h1 class="text-4xl font-bold text-cooklang-gray-900 mb-4">{{ .Title }}</h1>
      {{ if .Content }}
      <div class="prose prose-lg max-w-none text-cooklang-gray-700 mb-8">
        {{ .Content }}
      </div>
      {{ end }}
    </header>

    <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
      {{ range (.Pages.ByDate.Reverse) }}
      <article class="bg-white border border-cooklang-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow">
        <h2 class="text-xl font-semibold mb-2">
          <a href="{{ .RelPermalink }}" class="text-cooklang-gray-900 hover:text-cooklang-orange transition-colors">
            {{ .LinkTitle }}
          </a>
        </h2>
        {{ if .Summary }}
        <p class="text-cooklang-gray-600 mb-4">{{ .Summary | truncate 150 }}</p>
        {{ end }}
        <a href="{{ .RelPermalink }}" class="text-cooklang-orange hover:text-orange-600 font-medium">
          Read more →
        </a>
      </article>
      {{ end }}
    </div>
  </div>
</div>
{{ end }}
```

Notes:
- `.Pages.ByDate.Reverse` gives date-desc order without manual sorting.
- Includes a small breadcrumb at the top of the hub (Blog › Category) for navigation.
- The `{{ if .Content }}` guard means a missing `_index.md` won't break rendering — the grid alone still shows.

- [ ] **Step 3: Run hugo and verify build succeeds**

Run:
```bash
hugo --quiet
```
Expected: exit code 0. No category pages will exist yet (no posts have categories assigned, no `_index.md` files exist) — that's expected for this step.

- [ ] **Step 4: Commit**

```bash
git add layouts/taxonomy/category.html
git commit -m "blog: add category taxonomy term template"
```

---

## Task 3: Create five hub `_index.md` files with editorial content

**Files:**
- Create: `content/categories/comparisons/_index.md`
- Create: `content/categories/guides-and-tutorials/_index.md`
- Create: `content/categories/self-hosting-and-integrations/_index.md`
- Create: `content/categories/recipe-workflows/_index.md`
- Create: `content/categories/format-and-design/_index.md`

Each file uses YAML frontmatter (never the deprecated `>>` syntax). All five are created in this single task so the hub pages exist together before posts are assigned.

**Note on the `slug:` field:** Each frontmatter explicitly sets `slug:` to the short slug. Hugo's `:slug` token in `[permalinks] categories = "/blog/:slug/"` resolves from the page's `Slug` property, which for taxonomy terms defaults to a slugified `.Title` — not the directory name. Without an explicit `slug:`, the long marketing titles would produce ugly URLs like `/blog/cooklang-comparisons-how-we-stack-up-against-other-recipe-tools/`.

- [ ] **Step 1: Create `content/categories/comparisons/_index.md`**

```markdown
---
title: "Cooklang Comparisons: How We Stack Up Against Other Recipe Tools"
slug: "comparisons"
description: "Honest head-to-heads between Cooklang and other recipe managers — Mealie, Tandoor, Paprika, KitchenOwl, and more. Where Cooklang fits, where it doesn't."
date: 2026-05-27
---

Comparing recipe tools is hard because they're not all trying to do the same thing. A web-based recipe manager like Mealie or Tandoor solves a different problem than a markup language like Cooklang. This hub collects our head-to-heads, roundups, and format-level comparisons, so you can make the trade-offs explicit before picking a tool.

We make Cooklang, so we're not pretending these comparisons are neutral. What we can promise is that they're honest: where another tool is better for your needs, we say so. The single criterion we apply is whether someone who reads the comparison can make a confident choice afterwards.

Across this hub you'll find direct head-to-heads — [Cooklang vs Tandoor](/blog/52-cooklang-vs-tandoor/), [Cooklang vs Mealie](/blog/51-cooklang-vs-mealie/), [Cooklang vs Chef](/blog/24-chef-vs-cooklang/) — multi-tool roundups like [Open-Source Recipe Managers in 2026](/blog/18-open-source-recipe-managers-2026/) and [Best Recipe Management Software](/blog/48-best-recipe-management-software/), and format-level comparisons such as [6 Recipe File Formats Compared](/blog/19-recipe-formats-compared/) and [Recipe Formats for Developers](/blog/41-recipe-formats-for-developers/).

A short summary of how to read these: Cooklang is a file format and a small toolchain. Tools like Mealie and Tandoor are full applications — server, database, web UI, the works. They're optimised for different relationships with your recipe data. If you want a single hosted app with everything in it, you'll generally prefer those. If you want recipes that live as files you control and scripts you can compose, Cooklang.

The comparisons here go feature by feature, but the question they all return to is the same: where do you want the complexity to live — in the application, or in the format?

Start with the comparison closest to your shortlist, or read [Best Recipe Management Software](/blog/48-best-recipe-management-software/) for the broadest survey.
```

- [ ] **Step 2: Create `content/categories/guides-and-tutorials/_index.md`**

```markdown
---
title: "Cooklang Guides and Tutorials: From Zero to Working Recipes"
slug: "guides-and-tutorials"
description: "Step-by-step guides for Cooklang — beginners, CLI usage, editor integrations, migration paths, parser embedding, and publishing your collection."
date: 2026-05-27
---

Cooklang's surface area is small by design: a file format and a CLI. The depth comes from how you compose those pieces with the tools you already use. The guides in this hub take you from "I have a plain text file" to a working recipe pipeline, whether that means an Obsidian vault, a published website, or a parser embedded in your own app.

If you're new, start with the [Plain Text Recipes Beginner's Guide](/blog/33-plain-text-recipes-beginners-guide/) and the [Recipe Format Guide](/blog/47-recipe-format-guide/). These cover the syntax and the mental model. From there, pick your environment: the [Complete CookCLI Guide](/blog/23-complete-cookcli-guide/) for the command line, the [Cooklang Obsidian Guide](/blog/15-cooklang-obsidian-guide/) for note-takers, or the [Cooklang Editor Setup](/blog/39-cooklang-editor-setup/) for VS Code and others.

Bringing recipes from somewhere else? [Migrating Recipes to Cooklang](/blog/28-migrating-recipes-to-cooklang/) covers conversion from common formats. Publishing your collection? [Publishing Your Recipe Collection as a Website](/blog/25-publishing-recipe-collection-as-website/) and [Cook Build Web](/blog/50-cook-build-web-static-site/) get you from files to a live site.

For developers, the [Cooklang Parser Integration Guide](/blog/44-cooklang-parser-integration-guide/) covers embedding parsers in your own applications, and the [Markdown Recipe Template](/blog/49-markdown-recipe-template/) bridges Cooklang with Markdown-based note systems. [Recipe Reports and Dashboards](/blog/45-recipe-reports-and-dashboards/) covers the `cook report` template system for custom outputs.

Two design notes about these guides: we try to keep each one runnable end-to-end — you should be able to follow the steps and have something working at the end, not just understand the concept. And we lean on real recipe files as examples wherever possible, because Cooklang's value is most obvious when you see the same recipe in different tools, not when you read about abstractions.

If you're stuck somewhere in the middle of one, the [CookCLI guide](/blog/23-complete-cookcli-guide/) is usually the right place to back up to.
```

- [ ] **Step 3: Create `content/categories/self-hosting-and-integrations/_index.md`**

```markdown
---
title: "Self-Hosting Cooklang and Integrations with Other Tools"
slug: "self-hosting-and-integrations"
description: "Docker, Home Assistant, Raspberry Pi, mobile and desktop apps, sync agents, parser APIs — running Cooklang in your own infrastructure."
date: 2026-05-27
---

Because Cooklang is files plus a CLI, self-hosting it is mostly trivial: a folder, a git repo, and any web server is already a deployment. The interesting work is in the integrations — connecting Cooklang to the rest of your kitchen-tech stack: a Home Assistant dashboard, a Raspberry Pi mounted on the fridge, a mobile app that syncs your recipes between devices, or a programmatic API in another application.

For the simple setup, [Self-Hosting Recipes with Docker](/blog/21-self-hosting-recipes-with-docker/) walks through a containerised CookCLI server. For something more ambitious, [Raspberry Pi Kitchen Display](/blog/17-raspberry-pi-kitchen-display/) covers wall-mounted recipe screens, and [Cooklang Home Assistant Smart Kitchen](/blog/32-cooklang-home-assistant-smart-kitchen/) integrates recipes into an existing home-automation setup.

On the application side, [Cooklang Mobile App](/blog/34-cooklang-mobile-app/) covers the official iOS/Android client, while [Desktop App Replaced by Sync Agent](/blog/36-desktop-app-replaced-by-sync-agent/) explains why we moved away from a desktop app and what the sync agent does instead. The [File Sync Library](/blog/06-developing-file-sync-library/) post is the technical story behind that move.

For developers, [Building a Recipe API with Cooklang](/blog/29-building-recipe-api-with-cooklang/) walks through embedding Cooklang in your own backend, and [A Plain Text Recipe Database](/blog/38-plain-text-recipe-database/) explains how the filesystem itself acts as the database layer — no Postgres required.

A common pattern across all of these: the integration is usually a thin shim. CookCLI does the parsing and the data shaping; the integration is just a script or a small service that hands files in and gets structured output back. If you find yourself building anything elaborate to hold Cooklang together, it's usually a sign there's a simpler path.
```

- [ ] **Step 4: Create `content/categories/recipe-workflows/_index.md`**

```markdown
---
title: "Recipe Workflows: Meal Planning, Shopping, and Cooking with Cooklang"
slug: "recipe-workflows"
description: "How Cooklang fits the practical work of cooking — meal planning, grocery shopping, scaling, pantry management, and version-controlling your recipes."
date: 2026-05-27
---

A file format only matters if it makes the daily work of cooking easier. This hub collects the workflow-oriented posts: how Cooklang fits into the things you actually do — planning meals, building shopping lists, scaling recipes for different group sizes, managing what's in your pantry, and keeping a history of changes to your favourite recipes.

The two posts that anchor the hub are [Automating Grocery Shopping](/blog/01-my-approach-to-automating-grocery-shopping/), which walks through the end-to-end shopping pipeline, and [Meal Planning as Compilation](/blog/11-meal-planning-as-compilation/), which frames meal planning as a build step. Together they cover the two largest workflow categories.

Other practical posts: [How to Scale a Recipe Without Mistakes](/blog/26-how-to-scale-recipes-without-mistakes/) on the subtleties of multiplication (salt and pan size don't scale linearly), [The Pantry Problem](/blog/10-the-pantry-problem/) and [Greedy Coverage](/blog/14-greedy-coverage-blog/) on managing what's on the shelf, and [Practical Savings on Groceries](/blog/02-practical-savings-on-groceries-with-cooklang/) on cost reduction through structured shopping lists.

A few posts cover discovery and capture: [Recipe Discovery Without the Ads](/blog/16-recipe-discovery-without-ads/), [The Dishwasher Salmon Problem](/blog/13-the-dishwasher-salmon-problem/), and [Save Recipes from Social Media](/blog/20-save-recipes-from-social-media/). [Version Control Recipes with Git](/blog/43-version-control-recipes-with-git/) covers history and collaboration. [Cooklang for Food Bloggers](/blog/31-cooklang-for-food-bloggers/) is for the publishing side.

The thread that runs through all of these is that the value of structured recipes shows up at the seams — at the points where one workflow connects to another. Plain text recipes can feel underwhelming if you only look at them as a single file. They start to feel obviously correct when you generate a shopping list from a week of plans, or scale a recipe for guests, or roll back to last month's version because the new one didn't work.
```

- [ ] **Step 5: Create `content/categories/format-and-design/_index.md`**

```markdown
---
title: "Recipe Format and Design: Why Cooklang Looks the Way It Does"
slug: "format-and-design"
description: "Design decisions, language history, and format philosophy behind Cooklang — why plain text, why this syntax, and what a recipe format should optimise for."
date: 2026-05-27
---

Cooklang is a deliberate design, not a happy accident. This hub collects the posts about how and why the language ended up the way it did — the decisions that went into the syntax, the format choices behind plain-text recipes, and the broader history of structured recipe data going back decades before Cooklang existed.

If you're new to the philosophy, start with [Why Plain Text Recipes](/blog/12-why-plain-text-recipes/) and [Why a Recipe Standard](/blog/04-why-recipe-standard/). They cover the two foundational arguments: that plain text outlives applications, and that a shared format unlocks tooling that nobody would build for a proprietary one.

For the language design itself, [Designing a Recipe Markup Language](/blog/37-designing-a-recipe-markup-language/) walks through the syntax choices, and [The Recipe Markup Language](/blog/35-recipe-markup-language/) is the high-level pitch. [Recipes as Stack Machines](/blog/05-recipes-as-stack-machines/) is the conceptual deep dive — what a recipe really is from a computer-science perspective. [Cooking for Programmers](/blog/22-cooking-for-programmers/) covers the recipes-as-code framing.

Historical context: [The David A. Mundie Interview](/blog/08-david-a-mundie-interview/) covers a pioneer of structured recipe formats — a person most cooks have never heard of, but whose ideas underpin a lot of what came later. [AI and the Evolution of Recipe Formats](/blog/03-ai-and-the-evolution-of-recipe-formats/) looks at how LLMs change the equation.

Two more design-adjacent posts: [What Recipe Software Should Tell You About Nutrition](/blog/07-nutrients-during-cooking/) on the data-model gaps in current apps, and [Cooking Timers in Recipes](/blog/46-cooking-timers-in-recipes/) on modelling time as a first-class concept.

The throughline: every "small" decision in the syntax has consequences that show up years later — in what tools can be built, in how easy it is to write a parser, in whether your recipes are still readable in 2050. We try to make those consequences explicit.
```

- [ ] **Step 6: Verify all five hubs build**

```bash
hugo --quiet
ls public/blog/comparisons/index.html public/blog/guides-and-tutorials/index.html public/blog/self-hosting-and-integrations/index.html public/blog/recipe-workflows/index.html public/blog/format-and-design/index.html
```

Expected: all five files exist. Each will contain the H1 + intro paragraphs but no post cards (no posts have categories assigned yet — that's the next task).

- [ ] **Step 7: Spot-check rendered content of one hub**

```bash
grep -c "Comparing recipe tools is hard" public/blog/comparisons/index.html
```
Expected: `1` (the intro paragraph rendered).

- [ ] **Step 8: Commit**

```bash
git add content/categories/
git commit -m "blog: add five category hub _index.md files with editorial intros"
```

---

## Task 4: Add `categories` frontmatter to all 51 posts

**Files:**
- Modify: `content/blog/01-*.md` through `content/blog/52-*.md` (51 files; no post 27)

We use a Python script that takes the explicit post-number → category mapping (from the spec) and inserts a `categories: ["..."]` line into each post's YAML frontmatter, immediately before the closing `---`. The script is idempotent (skips files that already have `categories:`).

- [ ] **Step 1: Create the assignment script**

Create `scripts/assign-blog-categories.py`:

```python
#!/usr/bin/env python3
"""Add `categories:` frontmatter to blog posts based on the spec mapping.

Idempotent: skips posts that already have a `categories:` line.
Run from the repo root.
"""
import pathlib
import sys

ASSIGNMENTS = {
    "01": "Recipe Workflows",
    "02": "Recipe Workflows",
    "03": "Format and Design",
    "04": "Format and Design",
    "05": "Format and Design",
    "06": "Self-Hosting and Integrations",
    "07": "Format and Design",
    "08": "Format and Design",
    "09": "Comparisons",
    "10": "Recipe Workflows",
    "11": "Recipe Workflows",
    "12": "Format and Design",
    "13": "Recipe Workflows",
    "14": "Recipe Workflows",
    "15": "Guides and Tutorials",
    "16": "Recipe Workflows",
    "17": "Self-Hosting and Integrations",
    "18": "Comparisons",
    "19": "Comparisons",
    "20": "Recipe Workflows",
    "21": "Self-Hosting and Integrations",
    "22": "Format and Design",
    "23": "Guides and Tutorials",
    "24": "Comparisons",
    "25": "Guides and Tutorials",
    "26": "Recipe Workflows",
    "28": "Guides and Tutorials",
    "29": "Self-Hosting and Integrations",
    "30": "Guides and Tutorials",
    "31": "Recipe Workflows",
    "32": "Self-Hosting and Integrations",
    "33": "Guides and Tutorials",
    "34": "Self-Hosting and Integrations",
    "35": "Format and Design",
    "36": "Self-Hosting and Integrations",
    "37": "Format and Design",
    "38": "Self-Hosting and Integrations",
    "39": "Guides and Tutorials",
    "40": "Comparisons",
    "41": "Comparisons",
    "42": "Comparisons",
    "43": "Recipe Workflows",
    "44": "Guides and Tutorials",
    "45": "Guides and Tutorials",
    "46": "Format and Design",
    "47": "Guides and Tutorials",
    "48": "Comparisons",
    "49": "Guides and Tutorials",
    "50": "Guides and Tutorials",
    "51": "Comparisons",
    "52": "Comparisons",
}

BLOG_DIR = pathlib.Path("content/blog")
if not BLOG_DIR.is_dir():
    sys.exit("Run from the repo root (content/blog/ not found)")

added = 0
skipped_existing = 0
skipped_no_mapping = 0

for md_path in sorted(BLOG_DIR.glob("[0-9][0-9]-*.md")):
    num = md_path.name[:2]
    if num not in ASSIGNMENTS:
        print(f"SKIP {md_path.name}: no category assigned")
        skipped_no_mapping += 1
        continue

    text = md_path.read_text()
    lines = text.splitlines(keepends=True)

    if not lines or lines[0].strip() != "---":
        print(f"WARN {md_path.name}: no YAML frontmatter, skipping")
        continue

    # Find the closing --- of frontmatter (second occurrence).
    frontmatter_block = []
    closing_idx = None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            closing_idx = i
            break
        frontmatter_block.append(line)

    if closing_idx is None:
        print(f"WARN {md_path.name}: unterminated frontmatter, skipping")
        continue

    if any(line.lstrip().startswith("categories:") for line in frontmatter_block):
        print(f"SKIP {md_path.name}: already has categories")
        skipped_existing += 1
        continue

    cat = ASSIGNMENTS[num]
    new_line = f'categories: ["{cat}"]\n'
    lines.insert(closing_idx, new_line)
    md_path.write_text("".join(lines))
    print(f"ADD  {md_path.name}: {cat}")
    added += 1

print(f"\nSummary: added={added} skipped_existing={skipped_existing} skipped_no_mapping={skipped_no_mapping}")
```

- [ ] **Step 2: Run the script**

```bash
python3 scripts/assign-blog-categories.py
```

Expected output: 51 `ADD` lines, ending with `Summary: added=51 skipped_existing=0 skipped_no_mapping=0`.

- [ ] **Step 3: Spot-check three posts to confirm frontmatter is well-formed**

```bash
head -8 content/blog/09-cooklang-vs-paprika-vs-mealie.md
head -8 content/blog/01-my-approach-to-automating-grocery-shopping.md
head -8 content/blog/52-cooklang-vs-tandoor.md
```
Expected: each shows a valid YAML frontmatter block with `categories: ["..."]` inside the `---` delimiters.

- [ ] **Step 4: Run the script a second time to confirm idempotency**

```bash
python3 scripts/assign-blog-categories.py
```
Expected: 51 `SKIP ... already has categories` lines, `Summary: added=0 skipped_existing=51 skipped_no_mapping=0`.

- [ ] **Step 5: Build Hugo and verify hubs now list their posts**

```bash
hugo --quiet
grep -c '<article class="bg-white border' public/blog/comparisons/index.html
```
Expected: `10` (number of posts in Comparisons).

```bash
grep -c '<article class="bg-white border' public/blog/guides-and-tutorials/index.html
```
Expected: `12`.

```bash
grep -c '<article class="bg-white border' public/blog/self-hosting-and-integrations/index.html
```
Expected: `8`.

```bash
grep -c '<article class="bg-white border' public/blog/recipe-workflows/index.html
```
Expected: `11`.

```bash
grep -c '<article class="bg-white border' public/blog/format-and-design/index.html
```
Expected: `10`.

Total across hubs: `51`. If any count is off, recheck the corresponding posts' frontmatter.

- [ ] **Step 6: Commit**

```bash
git add scripts/assign-blog-categories.py content/blog/
git commit -m "blog: assign categories to all 51 posts"
```

---

## Task 5: Create breadcrumb partial with BreadcrumbList JSON-LD

**Files:**
- Create: `layouts/partials/breadcrumb.html`

The partial renders a visible breadcrumb (`Blog › <Category> › <Post>`) plus matching `BreadcrumbList` JSON-LD that Google reads for SERP display. It's a no-op for pages without a category — graceful degradation.

- [ ] **Step 1: Create the partial**

Create `layouts/partials/breadcrumb.html`:

```html
{{ with .Params.categories }}
{{ $category := index . 0 }}
{{ $categorySlug := urlize $category }}
{{ $categoryURL := printf "/blog/%s/" $categorySlug }}
<nav class="text-sm text-cooklang-gray-600 mb-4" aria-label="Breadcrumb">
  <ol class="flex flex-wrap items-center gap-x-2">
    <li><a href="/blog/" class="hover:text-cooklang-orange">Blog</a></li>
    <li class="text-cooklang-gray-400" aria-hidden="true">›</li>
    <li><a href="{{ $categoryURL }}" class="hover:text-cooklang-orange">{{ $category }}</a></li>
    <li class="text-cooklang-gray-400" aria-hidden="true">›</li>
    <li class="text-cooklang-gray-900 truncate max-w-xs" aria-current="page">{{ $.Title }}</li>
  </ol>
</nav>
{{ $ld := dict
  "@context" "https://schema.org"
  "@type" "BreadcrumbList"
  "itemListElement" (slice
    (dict "@type" "ListItem" "position" 1 "name" "Blog" "item" ("/blog/" | absURL))
    (dict "@type" "ListItem" "position" 2 "name" $category "item" ($categoryURL | absURL))
    (dict "@type" "ListItem" "position" 3 "name" $.Title)
  )
}}
<script type="application/ld+json">
{{ $ld | jsonify (dict "indent" "  ") | safeJS }}
</script>
{{ end }}
```

Notes:
- `urlize` converts the category name to its URL slug (matching how Hugo computes the term permalink: e.g., `"Self-Hosting and Integrations"` → `"self-hosting-and-integrations"`). Category names use the word `and` rather than `&` because Hugo's slug derivation collapses `&` characters, which would mismatch our content path.
- The third `ListItem` deliberately omits `item` (current page, per Google's BreadcrumbList guidance).
- **JSON-LD construction**: Hugo's html/template applies JS-context escaping inside `<script>` tags, which would double-escape string interpolations like `{{ $title | jsonify }}` (producing `"\"Title\""` instead of `"Title"`). To avoid this, we build the structured-data object as a Hugo `dict`/`slice`, then emit it via `jsonify | safeJS` so the template engine treats the output as already-safe JSON.
- `with` block means posts without `categories` render nothing — no breadcrumb, no schema, no build error.

- [ ] **Step 2: Smoke-test the partial standalone**

The partial isn't included anywhere yet, so building Hugo at this step won't render it. We test it once it's wired in Task 7.

```bash
hugo --quiet
```
Expected: exit code 0, no template errors.

- [ ] **Step 3: Commit**

```bash
git add layouts/partials/breadcrumb.html
git commit -m "blog: add breadcrumb partial with BreadcrumbList JSON-LD"
```

---

## Task 6: Create related-posts footer partial

**Files:**
- Create: `layouts/partials/related-posts-footer.html`

The partial renders a "Part of the <Category> series" link followed by up to 3 sibling posts (same category, excluding current, sorted by date desc).

- [ ] **Step 1: Create the partial**

Create `layouts/partials/related-posts-footer.html`:

```html
{{ with .Params.categories }}
{{ $category := index . 0 }}
{{ $categorySlug := urlize $category }}
{{ $categoryURL := printf "/blog/%s/" $categorySlug }}
{{ $current := $ }}
{{ $blogPages := where site.RegularPages "Section" "blog" }}
{{ $sameCategory := where $blogPages ".Params.categories" "intersect" (slice $category) }}
{{ $siblings := where $sameCategory "Permalink" "!=" $current.Permalink }}
{{ $siblings = first 3 ($siblings.ByDate.Reverse) }}
{{ if $siblings }}
<aside class="mt-12 pt-8 border-t border-cooklang-gray-200">
  <h3 class="text-lg font-semibold text-cooklang-gray-900 mb-4">
    Part of the <a href="{{ $categoryURL }}" class="text-cooklang-orange hover:text-orange-600">{{ $category }}</a> series →
  </h3>
  <div class="grid gap-4 md:grid-cols-3">
    {{ range $siblings }}
    <article class="bg-white border border-cooklang-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
      <h4 class="text-base font-semibold mb-1">
        <a href="{{ .RelPermalink }}" class="text-cooklang-gray-900 hover:text-cooklang-orange">{{ .LinkTitle }}</a>
      </h4>
      {{ if .Summary }}
      <p class="text-sm text-cooklang-gray-600">{{ .Summary | truncate 100 }}</p>
      {{ end }}
    </article>
    {{ end }}
  </div>
</aside>
{{ end }}
{{ end }}
```

Notes:
- `where ... "intersect" (slice $category)` matches pages whose `categories` slice contains the current category value.
- `Section "blog"` restricts to blog posts (excludes hubs and any other content).
- The outer `with` guards on `.Params.categories`, and the inner `if $siblings` guards on the case of a category with only one post (no siblings to show).

- [ ] **Step 2: Verify Hugo still builds**

```bash
hugo --quiet
```
Expected: exit code 0.

- [ ] **Step 3: Commit**

```bash
git add layouts/partials/related-posts-footer.html
git commit -m "blog: add related-posts footer partial"
```

---

## Task 7: Shadow theme `single.html` and wire in both partials

**Files:**
- Create: `layouts/_default/single.html` (shadows `themes/cooklang-tw/layouts/_default/single.html`)

Hugo's template lookup checks `layouts/` before `themes/<theme>/layouts/`, so creating a local file with the same path overrides the theme. We copy the theme's current `single.html`, then add the two partial includes.

- [ ] **Step 1: Read the theme's current single.html**

```bash
cat themes/cooklang-tw/layouts/_default/single.html
```

Expected content (current at time of writing — confirm before editing):

```html
{{ define "main" }}
<article class="bg-white">
  <div class="container mx-auto px-4 py-8 overflow-x-auto">
    <header class="mb-8">
      <h1 class="text-4xl font-bold text-cooklang-gray-900 mb-4">{{ .Title }}</h1>
      {{ if .Date }}
      <div class="text-cooklang-gray-600">
        {{ $dateMachine := .Date | time.Format "2006-01-02T15:04:05-07:00" }}
        {{ $dateHuman := .Date | time.Format ":date_long" }}
        <time datetime="{{ $dateMachine }}">{{ $dateHuman }}</time>
      </div>
      {{ end }}
    </header>

    <div class="prose prose-lg max-w-none text-cooklang-gray-700 overflow-x-auto">
      {{ .Content }}
    </div>
  </div>
</article>
{{ end }}
```

If the theme's template has diverged, base the local override on the current theme version and apply the same two additions (breadcrumb at top of `<article>`, related-posts at bottom).

- [ ] **Step 2: Create `layouts/_default/single.html` with both partials wired in**

```html
{{ define "main" }}
<article class="bg-white">
  <div class="container mx-auto px-4 py-8 overflow-x-auto">
    {{ partial "breadcrumb.html" . }}
    <header class="mb-8">
      <h1 class="text-4xl font-bold text-cooklang-gray-900 mb-4">{{ .Title }}</h1>
      {{ if .Date }}
      <div class="text-cooklang-gray-600">
        {{ $dateMachine := .Date | time.Format "2006-01-02T15:04:05-07:00" }}
        {{ $dateHuman := .Date | time.Format ":date_long" }}
        <time datetime="{{ $dateMachine }}">{{ $dateHuman }}</time>
      </div>
      {{ end }}
    </header>

    <div class="prose prose-lg max-w-none text-cooklang-gray-700 overflow-x-auto">
      {{ .Content }}
    </div>

    {{ partial "related-posts-footer.html" . }}
  </div>
</article>
{{ end }}
```

- [ ] **Step 3: Build Hugo**

```bash
hugo --quiet
```
Expected: exit code 0.

- [ ] **Step 4: Verify breadcrumb is rendered on a post**

```bash
grep -c 'aria-label="Breadcrumb"' public/blog/52-cooklang-vs-tandoor/index.html
```
Expected: `1`.

- [ ] **Step 5: Verify BreadcrumbList JSON-LD is present and valid JSON**

```bash
python3 -c "
import json, re, pathlib
html = pathlib.Path('public/blog/52-cooklang-vs-tandoor/index.html').read_text()
m = re.search(r'<script type=\"application/ld\+json\">\s*(\{[^<]*\"BreadcrumbList\"[^<]*\})\s*</script>', html, re.DOTALL)
assert m, 'BreadcrumbList JSON-LD not found'
data = json.loads(m.group(1))
assert data['@type'] == 'BreadcrumbList'
assert len(data['itemListElement']) == 3
assert data['itemListElement'][1]['name'] == 'Comparisons'
assert data['itemListElement'][2]['name'] == 'Cooklang vs Tandoor: Sharp Tool vs Kitchen ERP'
print('BreadcrumbList JSON-LD OK')
"
```
Expected: `BreadcrumbList JSON-LD OK`.

- [ ] **Step 6: Verify related-posts footer is rendered**

```bash
grep -c 'Part of the' public/blog/52-cooklang-vs-tandoor/index.html
```
Expected: `1`.

```bash
grep -A2 'Part of the' public/blog/52-cooklang-vs-tandoor/index.html | head -10
```
Expected: the line includes a link to `/blog/comparisons/`.

- [ ] **Step 7: Confirm 3 sibling cards are rendered in the footer**

```bash
python3 -c "
import pathlib, re
html = pathlib.Path('public/blog/52-cooklang-vs-tandoor/index.html').read_text()
# Look at the <aside> block containing the related-posts footer
m = re.search(r'<aside class=\"mt-12 pt-8 border-t.*?</aside>', html, re.DOTALL)
assert m, 'related-posts footer not found'
articles = re.findall(r'<article class=\"bg-white border', m.group())
print(f'sibling cards: {len(articles)}')
assert len(articles) == 3, f'expected 3 sibling cards, got {len(articles)}'
"
```
Expected: `sibling cards: 3`.

- [ ] **Step 8: Verify a post without categories (none should exist now, but the template must still be safe) — pick a non-post page**

Confirm that non-blog pages (e.g., `/docs/`) build without rendering breadcrumb/footer (their `single.html` isn't this template, but we check no errors):

```bash
grep -c 'aria-label="Breadcrumb"' public/index.html 2>/dev/null
```
Expected: `0` (home page has no categories; the partial guards correctly).

- [ ] **Step 9: Commit**

```bash
git add layouts/_default/single.html
git commit -m "blog: shadow single.html, wire in breadcrumb and related-posts partials"
```

---

## Task 8: Add topic-nav row to `/blog/` list page

**Files:**
- Modify: `layouts/blog/list.html`

Insert a row of five pill-style links to the hubs between the header and the existing post grid. The flat 51-post grid below remains unchanged.

- [ ] **Step 1: Read the current file**

```bash
cat layouts/blog/list.html
```

- [ ] **Step 2: Insert the topic-nav row**

Replace the existing content of `layouts/blog/list.html` with:

```html
{{ define "main" }}
<div class="bg-white">
  <div class="container mx-auto px-4 py-8 max-w-6xl">
    <header class="mb-8">
      <h1 class="text-4xl font-bold text-cooklang-gray-900 mb-4">{{ .Title }}</h1>
      {{ if .Content }}
      <div class="prose prose-lg max-w-none text-cooklang-gray-700 mb-8">
        {{ .Content }}
      </div>
      {{ end }}
    </header>

    <nav class="mb-10" aria-label="Browse by topic">
      <h2 class="text-sm uppercase tracking-wide text-cooklang-gray-500 mb-3">Browse by topic</h2>
      <ul class="flex flex-wrap gap-2">
        <li><a href="/blog/comparisons/" class="inline-block px-4 py-2 rounded-full border border-cooklang-gray-200 text-cooklang-gray-700 hover:border-cooklang-orange hover:text-cooklang-orange transition-colors">Comparisons</a></li>
        <li><a href="/blog/guides-and-tutorials/" class="inline-block px-4 py-2 rounded-full border border-cooklang-gray-200 text-cooklang-gray-700 hover:border-cooklang-orange hover:text-cooklang-orange transition-colors">Guides and Tutorials</a></li>
        <li><a href="/blog/self-hosting-and-integrations/" class="inline-block px-4 py-2 rounded-full border border-cooklang-gray-200 text-cooklang-gray-700 hover:border-cooklang-orange hover:text-cooklang-orange transition-colors">Self-Hosting and Integrations</a></li>
        <li><a href="/blog/recipe-workflows/" class="inline-block px-4 py-2 rounded-full border border-cooklang-gray-200 text-cooklang-gray-700 hover:border-cooklang-orange hover:text-cooklang-orange transition-colors">Recipe Workflows</a></li>
        <li><a href="/blog/format-and-design/" class="inline-block px-4 py-2 rounded-full border border-cooklang-gray-200 text-cooklang-gray-700 hover:border-cooklang-orange hover:text-cooklang-orange transition-colors">Format and Design</a></li>
      </ul>
    </nav>

    <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
      {{ $pages := .Pages }}
      {{ $sortedPages := sort $pages ".Weight" }}
      {{ range $sortedPages }}
      <article class="bg-white border border-cooklang-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow">
        <h2 class="text-xl font-semibold mb-2">
          <a href="{{ .RelPermalink }}" class="text-cooklang-gray-900 hover:text-cooklang-orange transition-colors">
            {{ .LinkTitle }}
          </a>
        </h2>
        {{ if .Summary }}
        <p class="text-cooklang-gray-600 mb-4">{{ .Summary | truncate 150 }}</p>
        {{ end }}
        <a href="{{ .RelPermalink }}" class="text-cooklang-orange hover:text-orange-600 font-medium">
          Read more →
        </a>
      </article>
      {{ end }}
    </div>
  </div>
</div>
{{ end }}
```

The post grid below is byte-for-byte identical to the previous version. Only the `<nav class="mb-10">` block is new.

- [ ] **Step 3: Build Hugo**

```bash
hugo --quiet
```
Expected: exit code 0.

- [ ] **Step 4: Verify the topic-nav row renders and all 5 links are present**

```bash
python3 -c "
import re, pathlib
html = pathlib.Path('public/blog/index.html').read_text()
m = re.search(r'<nav class=\"mb-10\".*?</nav>', html, re.DOTALL)
assert m, 'topic-nav row not found'
links = re.findall(r'href=\"(/blog/[a-z-]+/)\"', m.group())
expected = ['/blog/comparisons/', '/blog/guides-and-tutorials/', '/blog/self-hosting-and-integrations/', '/blog/recipe-workflows/', '/blog/format-and-design/']
assert sorted(links) == sorted(expected), f'wrong links: {links}'
print('topic-nav row OK with all 5 links')
"
```
Expected: `topic-nav row OK with all 5 links`.

- [ ] **Step 5: Verify the flat post grid still shows all 51 posts**

```bash
grep -c '<article class="bg-white border' public/blog/index.html
```
Expected: `51` (the 51 post cards; the topic-nav uses `<a>` pills, not `<article>`).

- [ ] **Step 6: Commit**

```bash
git add layouts/blog/list.html
git commit -m "blog: add 'Browse by topic' nav row above post grid"
```

---

## Task 9: Final verification pass

No file changes in this task — purely verification.

- [ ] **Step 1: Clean build from scratch**

```bash
rm -rf public/ resources/
hugo --quiet
```
Expected: exit code 0, no warnings.

- [ ] **Step 2: Verify all 51 posts have categories and resulting permalinks**

```bash
python3 -c "
import pathlib, re
blog_dir = pathlib.Path('content/blog')
posts = sorted(blog_dir.glob('[0-9][0-9]-*.md'))
missing = []
for p in posts:
    text = p.read_text()
    fm_match = re.search(r'^---\n(.*?)\n---', text, re.DOTALL)
    if not fm_match or 'categories:' not in fm_match.group(1):
        missing.append(p.name)
print(f'{len(posts)} posts checked')
if missing:
    print(f'MISSING categories on: {missing}')
    raise SystemExit(1)
print('All posts have categories assigned')
"
```
Expected: `51 posts checked` then `All posts have categories assigned`.

- [ ] **Step 3: Verify each hub URL serves a page**

```bash
for slug in comparisons guides-and-tutorials self-hosting-and-integrations recipe-workflows format-and-design; do
  test -f "public/blog/${slug}/index.html" && echo "OK: /blog/${slug}/" || echo "MISSING: /blog/${slug}/"
done
```
Expected: 5 `OK` lines.

- [ ] **Step 4: Verify the `/categories/` listing was NOT generated**

```bash
test ! -f public/categories/index.html && echo "categories list correctly suppressed"
```
Expected: `categories list correctly suppressed`.

- [ ] **Step 5: Verify the original `/blog/` index still has all 51 post cards plus topic nav**

```bash
python3 -c "
import re, pathlib
html = pathlib.Path('public/blog/index.html').read_text()
post_cards = len(re.findall(r'<article class=\"bg-white border', html))
topic_links = len(re.findall(r'<nav class=\"mb-10\".*?</nav>', html, re.DOTALL))
print(f'post_cards={post_cards} topic_nav_present={bool(topic_links)}')
assert post_cards == 51 and topic_links == 1
print('OK')
"
```
Expected: `post_cards=51 topic_nav_present=True` then `OK`.

- [ ] **Step 6: Spot-check three random posts to confirm breadcrumb + related-posts render**

```bash
for post in 09-cooklang-vs-paprika-vs-mealie 22-cooking-for-programmers 32-cooklang-home-assistant-smart-kitchen; do
  echo "=== $post ==="
  breadcrumb=$(grep -c 'aria-label="Breadcrumb"' "public/blog/${post}/index.html")
  jsonld=$(grep -c 'BreadcrumbList' "public/blog/${post}/index.html")
  footer=$(grep -c 'Part of the' "public/blog/${post}/index.html")
  echo "breadcrumb=$breadcrumb jsonld=$jsonld footer=$footer"
done
```
Expected: each post shows `breadcrumb=1 jsonld=1 footer=1`.

- [ ] **Step 7: Verify the BreadcrumbList JSON-LD passes Google Rich Results Test (manual)**

The Rich Results Test is an online tool that can only be run after deployment to a publicly reachable URL. Document as a post-deploy QA step:

After pushing the change and Netlify rebuilds, paste any post URL (e.g., `https://cooklang.org/blog/52-cooklang-vs-tandoor/`) into:
- https://search.google.com/test/rich-results

Expected: "Page is eligible for rich results" with `Breadcrumbs` detected, 0 errors.

- [ ] **Step 8: Local browser sanity check**

```bash
hugo server --quiet
```

Then in a browser:
- `http://localhost:1313/blog/` — topic-nav row visible, 51 post cards below.
- `http://localhost:1313/blog/comparisons/` — intro text, 10 post cards.
- `http://localhost:1313/blog/52-cooklang-vs-tandoor/` — breadcrumb at top, related-posts footer with 3 cards at bottom.

Stop the server with Ctrl-C when done.

- [ ] **Step 9: Confirm git tree is clean and the commits are stacked sensibly**

```bash
git status
git log --oneline -10
```
Expected: clean tree; the last 8 commits cover the work in this plan in the order: config → template → hubs → frontmatter → breadcrumb partial → footer partial → single.html → list.html.

---

## Done

The blog now has five SEO-targeted topic hubs at `/blog/<topic>/` with editorial intros and auto-listed posts, each post links back to its hub via breadcrumb (with schema) and a related-posts footer, and the existing `/blog/` index still shows the full flat post grid plus a new topic-nav row.

No URLs were changed; the work is purely additive. Push to deploy.
