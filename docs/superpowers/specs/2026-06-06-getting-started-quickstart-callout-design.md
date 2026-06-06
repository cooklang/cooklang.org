# Getting Started — "5-minute taste of the ecosystem" quick-start callout

**Date:** 2026-06-06
**Repo:** cooklang.org (Hugo + Tailwind)
**Status:** Approved design, ready for implementation plan

## Goal

Add a short, visually distinct quick-start callout near the top of the Getting
Started page that gives a newcomer the fastest possible path to *feeling* the
whole Cooklang ecosystem: a tailored recipe collection (Kickstart), a desktop
workspace (Cook Editor), and recipes in their pocket (mobile app). It sits above
the existing detailed steps and frames a low-friction "do this first" loop.

## Placement

In `content/docs/getting-started.md`, insert the callout immediately after the
intro paragraph, code example, and the `app-screens-demo.jpg` image (current
line 20), and **before** `## 1. Try It Right Now`. Readers still learn what
Cooklang *is* before being invited to act.

## The three steps (order: lowest friction first)

1. **Run Kickstart** — answer a few quick questions and get ~50 recipes tailored
   to your taste, ready to download as `.cook` files. No install required.
   Link: `https://cook.md/kickstart`
2. **Get the Cook Editor** — free desktop app (macOS/Windows/Linux) to write,
   preview, and plan meals from your recipes.
   Link: `https://cook.md/editor`
3. **Open the mobile app** — sync and carry your recipes everywhere.
   Links: [App Store](https://apps.apple.com/us/app/cooklangapp/id1598799259) ·
   [Google Play](https://play.google.com/store/apps/details?id=md.cook.android)

## Implementation

- **New Hugo shortcode:** `layouts/shortcodes/quickstart-callout.html` containing
  the styled markup (heading + three numbered steps with links). Called once at
  the top of `getting-started.md` via `{{< quickstart-callout >}}`. Keeps the
  markdown content clean and the component reusable.
- **Visual treatment:** subtle bordered callout — rounded box with a light
  `bg-cooklang-gray-50` tint and `border border-cooklang-gray-200`, padded
  (`p-6`), a short bold heading line (e.g. "🚀 The 5-minute taste of the whole
  ecosystem"), then the three steps. No full-width background band.
- **Responsive:** three steps sit in a row on desktop (e.g. a 3-column grid),
  stack vertically on mobile. Each step shows a number badge, a one-line title,
  a short supporting line, and a text link/button.
- **Styling source:** use existing Tailwind utilities and the project's custom
  colors (`cooklang-orange`, `cooklang-gray-*`). Reuse `.btn`/`.btn-secondary`
  component classes if they fit; otherwise plain utility classes.

## Build & verification

- CSS is pre-built and committed. After adding the shortcode, run
  `npm run build-css` in `themes/cooklang-tw/` so any new utility classes land in
  `static/css/style.css`.
- Verify by running Hugo locally and confirming the callout renders correctly on
  the Getting Started page (desktop + narrow viewport) and that all three links
  resolve to the right destinations.

## Out of scope

- No changes to the existing numbered sections (1–5) of the page.
- No new landing pages; Kickstart/Editor/mobile destinations already exist.
- No copy changes elsewhere on the site.
