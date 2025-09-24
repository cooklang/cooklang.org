---
title: "Creating Cookbooks"
description: "Step-by-step guide to transform your Cooklang recipes into professional PDF cookbooks"
date: 2024-01-15
categories:
  - Publishing
  - Tutorial
tags:
  - cookbook
  - PDF
  - LaTeX
  - tutorial
  - publishing
featured: true
---

Transform your digital recipe collection into a professional cookbook that you can print, share, or publish. This guide shows you how to use CookCLI's LaTeX export feature (supported in version after 0.18.0) to create PDF cookbooks from your Cooklang recipes.

## 🎯 What You'll Create

By the end of this tutorial, you'll have:
- A professionally formatted PDF cookbook
- Organized chapters by meal type
- Color-coded ingredients and equipment
- Automatic table of contents and index
- Print-ready or digital ebook format

## 📋 Prerequisites

Before starting, make sure you have:

1. **CookCLI installed** ([Installation guide](/cli/download))
2. **LaTeX distribution** installed:
   ```bash
   # macOS
   brew install --cask mactex

   # Ubuntu/Debian
   sudo apt-get install texlive-full

   # Windows
   # Download MiKTeX from https://miktex.org/
   ```
3. **Your recipes** in `.cook` format organised in folders (that will become book chapters later)

```
my_recipes/
├── breakfast/
│   └── pancakes.cook
├── lunch/
│   └── sandwich.cook
└── dinner/
    └── pasta.cook
```

## 🚀 Quick Start: Your First Cookbook in 5 Minutes

### Step 1: Get the Cookbook Tools

```bash
# Clone the cookbook creator repository
git clone https://github.com/cooklang/cookbook-creator.git
cd cookbook-creator

# Or download just the script
wget https://raw.githubusercontent.com/cooklang/cookbook-creator/main/scripts/create_cookbook.py
```

### Step 2: Generate Your Cookbook

```bash
# Generate cookbook LaTeX file from your recipes directory
python3 scripts/create_cookbook.py path/to/recipes my_cookbook.tex \
  --title "Family Recipes" \
  --author "Your Name"

# Or try with the included example recipes
python3 scripts/create_cookbook.py examples/recipes my_cookbook.tex \
  --title "Sample Cookbook" \
  --author "Jane Doe"
```

### Step 3: Compile to PDF

```bash
# Compile the LaTeX file to PDF
pdflatex my_cookbook.tex
makeindex my_cookbook.idx  # Generate index
pdflatex my_cookbook.tex   # Update references
pdflatex my_cookbook.tex   # Final compilation

# Open your new cookbook!
open my_cookbook.pdf       # macOS
xdg-open my_cookbook.pdf   # Linux
```

## 📖 Step-by-Step Walkthrough

### 1️⃣ Organize Your Recipes

Structure your recipes in folders by category:

```
my-recipes/
├── breakfast/
│   ├── pancakes.cook
│   ├── french-toast.cook
│   └── smoothie-bowl.cook
├── lunch/
│   ├── caesar-salad.cook
│   └── grilled-cheese.cook
├── dinner/
│   ├── roast-chicken.cook
│   ├── pasta-carbonara.cook
│   └── vegetable-stir-fry.cook
└── desserts/
    ├── chocolate-cake.cook
    └── apple-pie.cook
```

The folder names become chapter titles in your cookbook!

### 2️⃣ Generate Your Cookbook

#### Using the Python Script (Recommended)

```bash
cd cookbook-creator
python3 scripts/create_cookbook.py ~/my-recipes my-cookbook.tex \
  --title "The Smith Family Cookbook" \
  --author "Jane Smith"
```

#### Script Options

```bash
# Basic usage
python3 scripts/create_cookbook.py <recipe_directory> <output_file> [options]

# Available options:
--title TITLE       # Cookbook title (default: "My Cookbook")
--author AUTHOR     # Author name (optional)
--no-index         # Skip index generation
--no-toc           # Skip table of contents
```

#### Manual Generation

For individual recipes, you can use CookCLI directly:

```bash
# Generate LaTeX for a single recipe
cook recipe -f latex "breakfast/pancakes.cook" > pancakes.tex
```

### 3️⃣ Customize Your Cookbook

Edit the generated `.tex` file to customize:

```latex
% Change colors
\definecolor{ingredientcolor}{RGB}{219, 112, 147}  % Pink
\definecolor{cookwarecolor}{RGB}{100, 149, 237}    % Blue
\definecolor{timercolor}{RGB}{255, 140, 0}         % Orange

% Add dedication
\chapter*{Dedication}
To my grandmother, who taught me that cooking is love...

% Add introduction to chapters
\chapter{Breakfast}
\section*{Introduction}
These breakfast recipes have been weekend favorites...
```

### 4️⃣ Add Special Sections

```latex
% Add conversion tables
\chapter*{Conversion Tables}
\begin{tabular}{ll}
\toprule
US & Metric \\
\midrule
1 cup & 240 ml \\
1 tbsp & 15 ml \\
\bottomrule
\end{tabular}

% Add tips section
\chapter*{Kitchen Tips}
\begin{itemize}
\item Always preheat your oven
\item Mise en place is key
\item Season as you go
\end{itemize}
```

## 🛠️ Advanced Features

### Including Recipe Images

The script automatically finds and includes images that match your recipe names:

```
recipes/
├── pasta-carbonara.cook
├── pasta-carbonara.jpg    # Will be automatically included
├── chocolate-cake.cook
└── chocolate-cake.png     # Will be automatically included
```

Supported image formats: PNG, JPG, JPEG

### Creating Multiple Versions

```bash
# Family version with all recipes
python3 create_cookbook.py recipes family-cookbook.tex

# Gift version with selected recipes
python3 create_cookbook.py recipes/favorites gift-cookbook.tex \
  --title "Our Favorite Recipes for You"
```

### Customizing Colors

Edit the generated LaTeX file to change ingredient, cookware, and timer colors:

```latex
% Color definitions (RGB values)
\definecolor{ingredientcolor}{RGB}{204, 85, 0}   % Orange
\definecolor{cookwarecolor}{RGB}{34, 139, 34}    % Green
\definecolor{timercolor}{RGB}{220, 20, 60}       % Red
```

### Scaling Recipes

```bash
# Generate scaled versions for different serving sizes
cook recipe -f latex "dinner/lasagna.cook:12" > lasagna-party.tex
```

### Download Sample Cookbook

[Download a sample PDF cookbook](https://github.com/cooklang/cookbook-creator/blob/main/examples/my_cookbook.pdf) to see what you can create!

## 💡 Pro Tips

### 1. Recipe Metadata
The script extracts metadata from recipe comments. Add metadata to your `.cook` files:

```cooklang
---
description: A classic Italian pasta dish
tags: italian, pasta, quick
servings: 4
prep time: 15 minutes
cook time: 20 minutes
---
```

### 2. Organizing by Chapters
The script automatically creates chapters based on your directory structure:

```
recipes/
├── appetizers/     → Chapter: Appetizers
├── main-dishes/    → Chapter: Main Dishes
├── desserts/       → Chapter: Desserts
└── beverages/      → Chapter: Beverages
```

### 3. Recipe Index
The script automatically generates:
- Recipe index by name
- Index by tags (if metadata includes tags)
- Index by author (if metadata includes author)

### 4. Version Control
Keep your recipes and cookbook under version control:

```bash
git init my-cookbook
git add *.cook *.tex scripts/
git commit -m "Initial cookbook version"
```


## 🚧 Troubleshooting

### Common Issues and Solutions

| Problem | Solution |
|---------|----------|
| "LaTeX command not found" | Install TeX distribution for your OS |
| "Package not found" error | Run `tlmgr install enumitem multicol xcolor titlesec geometry hyperref makeidx imakeidx fancyhdr` |
| "cook command not found" | Install CookCLI or use `cargo run` if building from source |
| Missing colors in PDF | Ensure `xcolor` package is included |
| Index not generated | Run `makeindex` between compilations |
| Recipes not found | Check file extensions are `.cook` |
| Images not showing | Ensure image files match recipe names (e.g., `pasta.cook` → `pasta.jpg`) |

## 📚 Resources

- 📖 [Cookbook Creator repository](https://github.com/cooklang/cookbook-creator)
- 📝 [CookCLI documentation](/cli/)
- 📄 [Example PDF cookbook](https://github.com/cooklang/cookbook-creator/blob/main/examples/my_cookbook.pdf)
- 💬 [Community forum](https://github.com/cooklang/spec/discussions)

## 🎉 Share Your Creation

Created a beautiful cookbook? We'd love to see it!

- Share on social media with **#CooklangCookbook**
- Post in our [community forum](https://github.com/cooklang/spec/discussions)
- Submit your template to the cookbook-sample repository

---

**Ready to create your cookbook?** [Get started with the cookbook-creator toolkit →](https://github.com/cooklang/cookbook-creator)

*Transform your recipes into a beautiful cookbook today with CookCLI!*
