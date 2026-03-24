---
title: "Version Control Your Recipes with Git"
date: 2026-03-24
weight: 50
summary: "Every recipe app has a 'what if the company dies?' problem. If your recipes are plain text .cook files in a Git repo, that problem disappears. Here's how to set up a proper recipe repo, track changes meaningfully, collaborate with family, and publish to the Cooklang Federation."
---

Every recipe app eventually dies. MacGourmet, Panna, Evernote Food, ChefTap — they all took user recipes with them. The "what if the company shuts down?" problem is not paranoia. It is an industry pattern.

If your recipes are plain text `.cook` files in a Git repository, that problem does not exist. Your files will open fine in 2035. No company required.

This is a practical guide to using Git for recipes: setting up a repo, understanding why diffs on `.cook` files are actually useful, collaborating with others, and wiring up automation that keeps everything in sync.

## Why Git Works for Recipes

### Diffs Are Meaningful

When a recipe is prose buried in a database, you cannot diff it. When it is a `.cook` file, every change is visible and readable.

Here is what a small tweak to a pancake recipe looks like:

```diff
- Combine @flour{200%g}, @sugar{2%tbsp}, @baking powder{2%tsp}, and @salt{1/2%tsp}.
+ Combine @flour{200%g}, @sugar{1%tbsp}, @baking powder{2%tsp}, @salt{1/2%tsp}, and @cinnamon{1/2%tsp}.
```

One line tells you exactly what changed: sugar reduced, cinnamon added. No ambiguity. No "did I change this or was it always this way?"

Compare that to Paprika, Mealie, or any database-backed app. Edit a recipe there and the old version is gone forever.

### History Tells the Story

```bash
git log --oneline recipes/dinner/pasta-carbonara.cook
```

```
e3a1f02 use guanciale instead of pancetta, big improvement
b27c4d9 dial back the pepper, was too aggressive
91f3e54 add note about pasta water temperature
c2b85a3 initial recipe from Marcella Hazan's book
```

That log is a development history. You can see that the guanciale change came after the pepper adjustment. You can check out any commit and see the recipe as it was. You can revert if an experiment failed.

### Branches for Experiments

You want to try almond flour in your pancakes without destroying the original. That is a branch:

```bash
git checkout -b experiment/almond-flour-pancakes
# edit recipes/breakfast/pancakes.cook
# cook them, assess the result
git checkout main  # original untouched
```

If the experiment works, merge it. If it does not, delete the branch. This is exactly how software development handles uncertainty, and it applies directly to recipe development.

## Setting Up a Recipe Repo

```bash
mkdir my-recipes && cd my-recipes
git init
```

A structure that scales well:

```
recipes/
├── breakfast/
│   ├── pancakes.cook
│   └── french-toast.cook
├── dinner/
│   ├── roast-chicken.cook
│   └── pasta-carbonara.cook
├── config/
│   ├── aisle.conf
│   └── pantry.conf
└── Plans/
    └── Week 1.menu
```

The `config/` directory holds your [CookCLI](/cli/) configuration: `aisle.conf` defines shopping list groupings, `pantry.conf` lists items you always have. The `Plans/` directory holds `.menu` files for weekly meal planning. All of it belongs in version control — it is all plain text, and all of it changes over time.

## A Useful .gitignore

```gitignore
# OS noise
.DS_Store
Thumbs.db

# Editor artifacts
*.swp
*~
.vscode/
.idea/

# CookCLI output
*.pdf
site/

# Temporary files
*.tmp
```

You generally want to commit recipe images alongside their `.cook` files (`pancakes.jpg` next to `pancakes.cook`). The exception is if your photo directory is large enough to warrant Git LFS — at that point, put `*.jpg` and `*.png` in `.gitignore` and set up LFS separately.

## Writing a .cook File with YAML Frontmatter

Here is a real example with proper metadata:

```cooklang
---
title: Buttermilk Pancakes
servings: 8
time: 25 minutes
tags: [breakfast, weekend]
---

Whisk together @flour{200%g}, @sugar{1%tbsp}, @baking powder{2%tsp}, @salt{1/2%tsp}, and @cinnamon{1/2%tsp} in a large #bowl{}.

In a separate #bowl{}, whisk @buttermilk{240%ml}, @egg{1}, and @butter{2%tbsp}(melted).

Pour the wet ingredients into the dry ingredients and stir until just combined. Do not overmix — lumps are fine.

Heat a #non-stick pan{} over medium heat. Pour ~{1/4%cup} of batter per pancake. Cook until bubbles form on the surface (~{2%minutes}), then flip and cook for ~{1%minute} more.
```

YAML frontmatter goes between the `---` delimiters at the top of the file. That is the correct way to add metadata to Cooklang recipes. CookCLI reads it; so does the Federation crawler.

## Collaboration

### Family PR Workflow

Push your repo to GitHub. Add family members as collaborators. Now they can fork or clone, make changes on a branch, and submit a pull request.

```bash
# Family member clones the repo
git clone https://github.com/yourusername/my-recipes.git

# Creates a branch for their change
git checkout -b add-grandmas-pierogi

# Edits or adds a .cook file, then:
git add recipes/dinner/pierogi.cook
git commit -m "add grandma's pierogi recipe"
git push origin add-grandmas-pierogi
# Opens a PR on GitHub
```

This sounds heavy for a recipe collection. In practice, it is lighter than email. The PR shows the diff, you can leave comments, and the merge creates a clean record. It also works asynchronously — someone can submit a recipe at 11pm and you can review it in the morning.

### Fork Someone Else's Cookbook

GitHub makes this trivially easy. Find a recipe collection — for example, [github.com/dubadub/cookbook](https://github.com/dubadub/cookbook) — fork it, and customize freely. Your fork is independent. The upstream author's changes do not touch your collection unless you explicitly pull them. That is the plain text promise: your data is yours.

## Making Your Repo Discoverable with the Federation

The [Cooklang Federation](https://recipes.cooklang.org) indexes public recipe collections. If your GitHub repo is public, you can add it to the index and have your recipes show up in Federation search.

Fork the federation repo at [github.com/cooklang/federation](https://github.com/cooklang/federation). Add your entry to `config/feeds.yaml`:

```yaml
- url: "https://github.com/yourusername/my-recipes"
  title: "My Recipe Collection"
  feed_type: github
  branch: "main"
  enabled: true
  tags: [cookbook, github]
```

Submit a PR. Once it merges, the Federation crawler indexes your recipes automatically. No server to run, no API to maintain — your GitHub repo is the source of truth.

This is what open source recipes look like in practice: public `.cook` files on GitHub, discoverable without any central platform controlling access or monetizing your content.

## Automation

### GitHub Actions: Validate on Push

Every push to your recipe repo can automatically validate that all `.cook` files parse correctly:

```yaml
name: Validate Recipes
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install CookCLI
        run: |
          curl -L https://github.com/cooklang/cookcli/releases/latest/download/cook-linux-amd64 -o cook
          chmod +x cook
          sudo mv cook /usr/local/bin/

      - name: Validate all recipes
        run: |
          find recipes/ -name "*.cook" | while read -r f; do
            cook recipe "$f" --format json > /dev/null && echo "OK: $f" || echo "FAIL: $f"
          done
```

If a `.cook` file has a syntax error, the CI job fails and the PR is blocked. You get the same guard rails you have on a software project, applied to recipe authoring.

### GitHub Actions: Publish a Recipe Website

If you want your recipe collection to be a public website, a push to `main` can trigger a full build and deploy:

```yaml
name: Publish Recipes
on:
  push:
    branches: [main]
    paths: ['recipes/**']

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
```

The full publishing workflow — converting `.cook` files to JSON, building a static site with Hugo, deploying to GitHub Pages — is covered in detail in [Publishing Your Recipe Collection as a Website](/docs/use-cases/publishing-recipes/).

### Raspberry Pi: Auto-Sync from Git

If you run a [Raspberry Pi kitchen display](/docs/use-cases/raspberry-pi/), you can have it pull the latest recipes automatically:

```bash
crontab -e
```

Add this line:

```bash
# Pull recipe updates every 15 minutes
*/15 * * * * cd /home/pi/recipes && git pull --quiet
```

The Pi checks your repo every 15 minutes. You add a recipe on your laptop, push to GitHub, and within 15 minutes it appears on the kitchen display without any manual sync step.

## The Long Game

Everything above is available to you because Cooklang recipes are plain text. Git does not care what the files contain — it diffs and merges anything that is text. The meaningful diffs happen to be meaningful because the format is readable: ingredient names, quantities, and steps are human-legible without any special tooling.

A recipe in a database app is locked to that app. A recipe in a `.cook` file on GitHub is yours indefinitely. You can clone it, fork it, branch it, script against it, serve it, and share it — with no company in the middle.

Your recipes will outlive any app. That is worth setting up properly.

[Get started with Cooklang and CookCLI](/docs/getting-started/) | [Browse recipes on the Federation](/docs/use-cases/recipe-discovery/)

-Alex
