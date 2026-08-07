---
title: "Creating Cookbooks"
weight: 50
description: "Turn your Cooklang recipes into PDF cookbooks with LaTeX export"
---

CookCLI exports a recipe as LaTeX or Typst, which you compile into a professional PDF. Ingredients, cookware, and timers are color-coded automatically.

Two things to know before you start:

- `cook recipe -f latex` exports **one recipe as a complete, standalone document** (`\documentclass{article}` through `\end{document}`). It is not a fragment, so you cannot simply concatenate several exports into one file.
- To build a **whole cookbook** — chapters, title page, table of contents, index, images — use the [cookbook-creator](https://github.com/cooklang/cookbook-creator) script ([sample PDF](https://github.com/cooklang/cookbook-creator/blob/main/examples/my_cookbook.pdf)). It calls `cook recipe -f latex` per recipe and assembles the results. If you'd rather assemble the book yourself, see [Building a cookbook by hand](#building-a-cookbook-by-hand).

## Prerequisites

1. **CookCLI installed** ([Installation guide](/cli/download))

2. **A typesetter.** [Typst](https://typst.app/) is a single ~40 MB binary and needs nothing else, so reach for it first unless you specifically want LaTeX:

   ```bash
   # macOS
   brew install typst

   # Ubuntu/Debian - see https://github.com/typst/typst/releases
   ```

   For LaTeX, **install a subset, not the full distribution.** `texlive-full` is 7.9 GB on Debian; the packages CookCLI's export actually needs come to 495 MB:

   ```bash
   # Ubuntu/Debian
   sudo apt-get install --no-install-recommends texlive-latex-extra lmodern

   # macOS - BasicTeX (~100 MB) plus the packages the export uses
   brew install --cask basictex
   sudo tlmgr update --self
   sudo tlmgr install enumitem titlesec microtype

   # Windows - MiKTeX (https://miktex.org/) installs packages on demand
   ```

   `texlive-latex-extra` pulls in `texlive-latex-base` and `texlive-latex-recommended`, which together cover every package the export loads. Omitting `--no-install-recommends` triples the install to 1.4 GB for documentation and GUI tools you don't need. If a compile still stops at a missing `.sty`, install just that package rather than escalating to `texlive-full`.

3. **Your recipes** organized in folders (folders become chapters):
   ```
   recipes/
   ├── breakfast/
   │   ├── pancakes.cook
   │   └── french-toast.cook
   ├── dinner/
   │   ├── roast-chicken.cook
   │   └── pasta-carbonara.cook
   └── desserts/
       └── chocolate-cake.cook
   ```

## Exporting a Single Recipe

```bash
# Generate LaTeX output
cook recipe "Neapolitan Pizza" -f latex > pizza.tex

# Compile to PDF
pdflatex pizza.tex
open pizza.pdf

# Or pipe directly
cook recipe "Neapolitan Pizza" -f latex | pdflatex -jobname="pizza-recipe"
```

Page setup is controlled with two options that apply to `latex` and `typst` output:

```bash
# US Letter paper with a 2 cm margin
cook recipe "Neapolitan Pizza" -f latex --paper-size letter --margin 2 > pizza.tex
```

`--paper-size` accepts `a4` (default), `letter`, `a5`, and `legal`. `--margin` takes centimetres (default `2.5`) and applies to all four sides.

## Building a Full Cookbook

Use the [cookbook-creator](https://github.com/cooklang/cookbook-creator) script. It walks your recipe directory, turns each subdirectory into a chapter, and generates a `book` document with a title page, table of contents, a tag-based recipe index, and recipe images.

```bash
git clone https://github.com/cooklang/cookbook-creator
cd cookbook-creator

# Generate the LaTeX file from your recipes directory
python3 scripts/create_cookbook.py ~/recipes cookbook.tex \
  --title "Family Recipes" --author "Jane Doe"

# Compile to PDF (three passes resolve the TOC and index)
pdflatex cookbook.tex
makeindex cookbook.idx
pdflatex cookbook.tex
pdflatex cookbook.tex
```

The script requires Python 3 and a `cook` binary on your `PATH`. Options:

| Option | Description |
|--------|-------------|
| `--title TITLE` | Cookbook title (default: `My Cookbook`) |
| `--author AUTHOR` | Author name for the title page |
| `--no-index` | Skip the recipe index |
| `--no-toc` | Skip the table of contents |

### Including Images

Place an image next to each recipe with a matching base name and cookbook-creator will include it:

```
recipes/
├── pasta-carbonara.cook
├── pasta-carbonara.jpg
├── chocolate-cake.cook
└── chocolate-cake.png
```

Supported formats: PNG, JPG, JPEG. Note that images are added by cookbook-creator, not by `cook recipe -f latex` — the CookCLI export itself never emits `\includegraphics`.

## Building a Cookbook by Hand

If you want your own layout, extract the recipe body from each export and wrap the bodies in a document of your own. Every LaTeX export marks its body with comments:

```latex
% BEGIN_RECIPE_CONTENT
...        % the part you want
% END_RECIPE_CONTENT
```

Within that block, `% BEGIN_TITLE`/`% END_TITLE` wraps the recipe title (drop it if you emit your own `\section`), and `% TAGS:`, `% SERVINGS:`, and `% SOURCE:` comments carry metadata you can reuse.

Extract the bodies, one chapter per directory:

```bash
: > body.tex
for dir in recipes/*/; do
  printf '\\chapter{%s}\n' "$(basename "$dir")" >> body.tex
  for recipe in "$dir"*.cook; do
    cook recipe -f latex "$recipe" \
      | sed -n '/% BEGIN_RECIPE_CONTENT/,/% END_RECIPE_CONTENT/p' \
      | sed '1d;$d' >> body.tex
    echo >> body.tex
  done
done
```

Your wrapper document must define everything the extracted bodies rely on — the same packages and the three `\ingredient`, `\cookware`, `\timer` commands the exporter would otherwise have defined itself:

```latex
\documentclass[11pt,a4paper]{book}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{textcomp}     % \textdegree in temperatures
\usepackage{microtype}
\usepackage{enumitem}
\usepackage{multicol}     % ingredient lists
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{titlesec}
\usepackage{geometry}
\usepackage{hyperref}

\geometry{left=2.5cm,right=2.5cm,top=2.5cm,bottom=2.5cm}

% Colors used by the exported bodies
\definecolor{ingredientcolor}{RGB}{204, 85, 0}
\definecolor{cookwarecolor}{RGB}{34, 139, 34}
\definecolor{timercolor}{RGB}{220, 20, 60}

% Commands the exported bodies call
\newcommand{\ingredient}[1]{\textcolor{ingredientcolor}{\textbf{#1}}}
\newcommand{\cookware}[1]{\textcolor{cookwarecolor}{\textbf{#1}}}
\newcommand{\timer}[1]{\textcolor{timercolor}{\textbf{#1}}}

\title{Family Recipes}
\author{Your Name}

\begin{document}
\maketitle
\tableofcontents

\input{body.tex}

\end{document}
```

Compile:

```bash
pdflatex cookbook.tex
pdflatex cookbook.tex     # Second pass fills in the table of contents
```

Dropping `multicol` or `textcomp` is the most common cause of a failed build — the exported bodies use `\begin{multicols}` for ingredient lists and `\textdegree` for temperatures.

For an index, add `\usepackage{makeidx}`, `\makeindex`, and `\printindex` to your wrapper and emit an `\index{...}` line per recipe in the loop above. The CookCLI export does not generate index entries on its own.

## Customization

### Scaling for Events

Export scaled versions for different occasions:

```bash
# Party-size lasagna (12 servings)
cook recipe -f latex "dinner/lasagna.cook:12" > lasagna-party.tex
```

### Different Versions

Point cookbook-creator at different directories to build different books:

```bash
# Full family cookbook
python3 scripts/create_cookbook.py recipes family-cookbook.tex --title "Family Recipes"

# Gift version with selected favorites
python3 scripts/create_cookbook.py recipes/favorites gift-cookbook.tex --title "Our Favorites"
```

### Recipe Metadata

Add metadata to your `.cook` files for richer output:

```cooklang
---
description: A classic Italian pasta dish
tags: italian, pasta, quick
servings: 4
prep time: 15 minutes
cook time: 20 minutes
---
```

Tags become index entries in cookbook-creator, and servings appear under the recipe title.

## Typst Instead of LaTeX

`cook recipe -f typst` produces the same layout for [Typst](https://typst.app/), which compiles in a fraction of the time and needs no TeX distribution:

```bash
cook recipe "Neapolitan Pizza" -f typst > pizza.typ
typst compile pizza.typ
```

Typst output is standalone too, and carries the same `// BEGIN_RECIPE_CONTENT` markers, so the by-hand approach above works the same way.

## Other Output Formats

CookCLI also exports to Markdown, YAML, JSON, and Schema.org. For web-based cookbooks, Markdown or HTML via the [report system](../reports/) may be simpler than LaTeX.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "LaTeX command not found" | Install the packages listed under [Prerequisites](#prerequisites) — you do not need `texlive-full` |
| `File 'foo.sty' not found` | Install the one package that provides it (`sudo apt-get install --no-install-recommends texlive-...` or `sudo tlmgr install foo`), rather than the full distribution |
| `Environment multicols undefined` | Add `\usepackage{multicol}` to your wrapper preamble |
| `Command \textdegree unavailable` | Add `\usepackage{textcomp}` to your wrapper preamble |
| `Undefined control sequence \ingredient` | Define `\ingredient`, `\cookware`, and `\timer` in your wrapper preamble |
| `Can be used only in preamble` | You concatenated whole exports — extract the `% BEGIN_RECIPE_CONTENT` block instead |
| Table of contents empty | Run `pdflatex` a second time |
| Index not generated | Run `makeindex` between compilations, and check you emit `\index{}` entries |
| Images not showing | Ensure image files sit next to the recipe with a matching base name |

## See Also

- [CookCLI Recipe Command](/cli/commands/recipe/) — output format reference
- [Reports](../reports/) — custom template-based exports
- [Publishing Your Recipes](../publishing-recipes/) — share with the community
