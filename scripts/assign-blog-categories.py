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
