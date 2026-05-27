# Blog Category Hubs — Design

**Date:** 2026-05-27
**Status:** Approved — ready for implementation planning

## Problem

The blog has 51 posts on a single flat `/blog/` index page. Pagination would not help SEO at this scale (it pushes older posts deeper, dilutes link equity, and Google deprecated `rel="next/prev"` signals in 2019). The real SEO opportunity is **topic clusters**: hub pages that target distinct search intents, with each hub containing real editorial content and tight internal linking to its member posts.

## Goal

Create five topic-cluster hub pages under `/blog/<topic>/`, each acting as a rankable page in its own right (real intro content, not just an auto-list), with internal linking from member posts back to the hub. Preserve the existing flat `/blog/` index to avoid SEO regression on direct-link equity.

## Out of scope

- Pagination of `/blog/`.
- Multi-category posts. Each post belongs to exactly one category.
- Author or tag taxonomies.
- Restructuring the main `/blog/` index beyond adding a single "Browse by topic" row.
- Editorial rewriting of existing posts.

## Architecture

### Hugo configuration

Two additions to `config.toml`:

```toml
[taxonomies]
  category = "categories"

[permalinks]
  categories = "/blog/:slug/"
```

The `permalinks` override flattens the category URL from Hugo's default `/categories/<slug>/` to `/blog/<slug>/`, putting the hub at the same depth as posts and keeping the keyword in the URL.

### Content structure

**Per-post frontmatter** — every post gets exactly one category:

```yaml
categories: ["Comparisons"]
```

YAML frontmatter is mandatory (per global convention — never the deprecated `>>` metadata syntax).

**Five new hub index files** at `content/blog/<slug>/_index.md`:

| Slug | Title | Category value |
|---|---|---|
| `comparisons` | Comparisons | `Comparisons` |
| `guides-and-tutorials` | Guides & Tutorials | `Guides & Tutorials` |
| `self-hosting-and-integrations` | Self-Hosting & Integrations | `Self-Hosting & Integrations` |
| `recipe-workflows` | Recipe Workflows | `Recipe Workflows` |
| `format-and-design` | Format & Design | `Format & Design` |

Each `_index.md` contains:
- `title`, `description` (SEO meta, ≤155 chars), `date`
- 300–500 words of editorial intro framing the topic, what readers will find, and pointers to 3–4 anchor posts
- No explicit post listing — the template auto-renders posts below the intro

### Templates

Three new template files, two modified.

**New: `layouts/taxonomy/category.html`** — the hub page.
Renders the `_index.md` `.Content` at the top, then a grid of all posts in the category sorted by `date` desc. Reuses the card styling from `layouts/blog/list.html` for visual consistency.

**New: `layouts/partials/breadcrumb.html`** — top-of-post breadcrumb.
Renders `Blog › <Category> › <Post title>` as visible navigation, and emits matching `BreadcrumbList` JSON-LD schema in the same partial. Guards with `with .Params.categories` so posts without a category render no breadcrumb and no schema (graceful degradation).

**New: `layouts/partials/related-posts-footer.html`** — bottom-of-post related cluster.
Renders "Part of the **<Category>** series →" linking to the hub, plus a card list of 3 sibling posts (same category, excluding current, sorted by date desc). Same guard as breadcrumb.

**Modified: `layouts/blog/list.html`** — add a "Browse by topic" row above the existing post grid: five pill-style links to the hubs. The 51-post grid below remains unchanged, preserving direct internal links to every post.

**Modified: post `single.html`** — the current single-post template lives at `themes/cooklang-tw/layouts/_default/single.html`. To avoid editing the theme directly, shadow it at `layouts/_default/single.html` (Hugo's lookup order takes the local copy first) and add `{{ partial "breadcrumb.html" . }}` at top of the content area and `{{ partial "related-posts-footer.html" . }}` at the bottom.

### URL structure

| Path | What it is |
|---|---|
| `/blog/` | Flat index — 51 posts + topic-nav row |
| `/blog/comparisons/` | Hub page (auto-generated from taxonomy + `_index.md`) |
| `/blog/guides-and-tutorials/` | Hub page |
| `/blog/self-hosting-and-integrations/` | Hub page |
| `/blog/recipe-workflows/` | Hub page |
| `/blog/format-and-design/` | Hub page |
| `/blog/<NN>-<post-slug>/` | Individual post (unchanged) |

### Sort order

- Hub pages: posts sorted by `date` desc (freshness signal, standard for editorial hubs).
- Main `/blog/` index: keeps current `weight`-based sort (unchanged).

### Internal-linking model

The topic-cluster SEO mechanism relies on three link types working together:

1. **Hub → post** — auto-generated post cards on the hub page.
2. **Post → hub** — breadcrumb at top, "Part of the <Category> series →" in footer.
3. **Post → sibling posts** — 3 same-category related posts in the footer card list.

Every post ends up with both a direct link from `/blog/` (preserved flat grid) **and** a link from its hub — net increase in internal links, no regression.

## Category assignments (51 posts)

### Comparisons (10)
09 paprika/mealie · 18 OSS 2026 · 19 6 formats compared · 24 chef · 40 mealie review · 41 formats for developers · 42 tandoor/mealie/kitchenowl · 48 best software · 51 vs mealie · 52 vs tandoor

### Guides & Tutorials (12)
15 obsidian · 23 cookcli guide · 25 publishing collection · 28 migrating · 30 playground · 33 beginners · 39 editor setup · 44 parser integration · 45 reports/dashboards · 47 format guide · 49 markdown template · 50 cook build web

### Self-Hosting & Integrations (8)
06 sync library · 17 raspberry pi · 21 docker · 29 recipe API · 32 home assistant · 34 mobile app · 36 desktop/sync agent · 38 plain-text database

### Recipe Workflows (11)
01 grocery shopping · 02 savings · 10 pantry · 11 meal planning · 13 dishwasher salmon · 14 greedy coverage/pantry · 16 discovery · 20 social media · 26 scaling · 31 food bloggers · 43 version control

### Format & Design (10)
03 AI evolution · 04 why standard · 05 stack machines · 07 nutrients · 08 mundie interview · 12 why plain text · 22 cooking for programmers · 35 markup language · 37 designing markup · 46 timers

## Edge cases & safety

- **Posts without `categories`** — templates use `with .Params.categories` guards; missing category renders no breadcrumb, no footer, no JSON-LD. No build failure.
- **Future posts** — author must add `categories: ["..."]` in frontmatter; otherwise the post appears on `/blog/` but is invisible to hubs (graceful degradation, not a build error).
- **Renaming a category later** — would invalidate URLs. Treat category names as durable. If a rename is unavoidable, add a redirect rule in `netlify.toml`.
- **Single-category rule** — `categories` must be a one-element list. Multi-category dilutes the internal-linking signal that makes topic clusters work.

## Schema markup

`BreadcrumbList` JSON-LD only — emitted by the breadcrumb partial. Format:

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Blog", "item": "https://cooklang.org/blog/"},
    {"@type": "ListItem", "position": 2, "name": "Comparisons", "item": "https://cooklang.org/blog/comparisons/"},
    {"@type": "ListItem", "position": 3, "name": "<post title>"}
  ]
}
```

The third item omits `item` per Google's BreadcrumbList guidance (current page).

No `Article` schema changes in this scope — that's separate work.

## Verification

After implementation:

1. `hugo` builds cleanly with no warnings.
2. `/blog/comparisons/` and the other four hubs render their `_index.md` content above an auto-generated post grid.
3. Every post page shows breadcrumb at top and related-posts footer at bottom.
4. Inspect one post's HTML — confirm `BreadcrumbList` JSON-LD is present and validates in Google's Rich Results Test.
5. `/blog/` index still shows all 51 posts plus the new topic-nav row.
6. No old URLs return 404 (this work only adds URLs, doesn't change existing ones).

## Why this design

- **Hybrid (real intro content + auto-list)** over pure taxonomy avoids the "thin content" penalty Google applies to bare listing pages.
- **One category per post** keeps each hub's internal-linking signal concentrated.
- **Preserved flat `/blog/`** means no temporary loss of direct internal links to existing posts.
- **`/blog/<topic>/` URLs** keep the topic keyword in the path and avoid an extra `/categories/` segment that would itself need to be a thin parent page.
- **Breadcrumb + footer** is the standard topic-cluster pattern: breadcrumb gives crawler context and SERP-display schema; footer gives engagement and sibling links.
