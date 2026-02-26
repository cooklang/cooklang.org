---
title: "Creating Cookbooks"
weight: 50
description: "Turn your Cooklang recipes into PDF cookbooks with LaTeX export"
---

CookCLI can export recipes as LaTeX, which you compile into professional PDF cookbooks. Ingredients, cookware, and timers are color-coded automatically.

For a ready-made solution, see the [cookbook-creator](https://github.com/cooklang/cookbook-creator) script ([sample PDF](https://github.com/cooklang/cookbook-creator/blob/main/examples/my_cookbook.pdf)).

## Prerequisites

1. **CookCLI installed** ([Installation guide](/cli/download))
2. **LaTeX distribution** installed:
   ```bash
   # macOS
   brew install --cask mactex

   # Ubuntu/Debian
   sudo apt-get install texlive-full

   # Windows - download MiKTeX from https://miktex.org/
   ```
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

## Building a Full Cookbook

Generate LaTeX for all recipes and combine them into a single document:

```bash
# Export each recipe
for recipe in recipes/**/*.cook; do
  cook recipe -f latex "$recipe" >> cookbook-body.tex
done
```

Wrap the output in a LaTeX document with a title page and table of contents:

```latex
\documentclass[11pt,a4paper]{book}
\usepackage[utf8]{inputenc}
\usepackage{xcolor}
\usepackage{geometry}
\usepackage{hyperref}
\usepackage{makeidx}

% Color-coded recipe elements
\definecolor{ingredientcolor}{RGB}{219, 112, 147}  % Pink
\definecolor{cookwarecolor}{RGB}{100, 149, 237}     % Blue
\definecolor{timercolor}{RGB}{255, 140, 0}          % Orange

\title{Family Recipes}
\author{Your Name}

\begin{document}
\maketitle
\tableofcontents

% Include your exported recipes here
\input{cookbook-body.tex}

\end{document}
```

Compile:

```bash
pdflatex cookbook.tex
makeindex cookbook.idx    # Generate index
pdflatex cookbook.tex     # Update references
pdflatex cookbook.tex     # Final compilation
```

## Customization

### Chapter Organization

Organize recipes into chapters by exporting each directory separately:

```bash
echo '\chapter{Breakfast}' >> cookbook-body.tex
for recipe in recipes/breakfast/*.cook; do
  cook recipe -f latex "$recipe" >> cookbook-body.tex
done

echo '\chapter{Dinner}' >> cookbook-body.tex
for recipe in recipes/dinner/*.cook; do
  cook recipe -f latex "$recipe" >> cookbook-body.tex
done
```

### Including Images

Place images alongside your recipes with matching names:

```
recipes/
├── pasta-carbonara.cook
├── pasta-carbonara.jpg    # Included automatically
├── chocolate-cake.cook
└── chocolate-cake.png     # Included automatically
```

Supported formats: PNG, JPG, JPEG.

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

### Scaling for Events

Export scaled versions for different occasions:

```bash
# Party-size lasagna (12 servings)
cook recipe -f latex "dinner/lasagna.cook:12" > lasagna-party.tex
```

### Different Versions

```bash
# Full family cookbook
for recipe in recipes/**/*.cook; do
  cook recipe -f latex "$recipe" >> family-cookbook.tex
done

# Gift version with selected favorites
for recipe in recipes/favorites/*.cook; do
  cook recipe -f latex "$recipe" >> gift-cookbook.tex
done
```

## Other Output Formats

CookCLI also exports to Markdown, YAML, JSON, Schema.org, and Typst. For web-based cookbooks, Markdown or HTML via the [report system](../reports/) may be simpler than LaTeX.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "LaTeX command not found" | Install a TeX distribution for your OS |
| "Package not found" error | Run `tlmgr install xcolor geometry hyperref makeidx` |
| Missing colors in PDF | Ensure `xcolor` package is included |
| Index not generated | Run `makeindex` between compilations |
| Images not showing | Ensure image files match recipe names |

## See Also

- [CookCLI Recipe Command](/cli/commands/recipe/) — output format reference
- [Reports](../reports/) — custom template-based exports
- [Publishing Your Recipes](../publishing-recipes/) — share with the community
