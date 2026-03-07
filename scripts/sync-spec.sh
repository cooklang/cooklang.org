#!/bin/bash

# Script to sync Cooklang specification from spec repo to website
# Usage: ./scripts/sync-spec.sh

set -e

# Configuration
SPEC_README="../spec/README.md"
SPEC_CONVENTIONS="../spec/conventions.md"
SITE_SPEC_FILE="content/docs/spec.md"
SITE_CONVENTIONS_FILE="content/docs/conventions.md"

# Check if spec files exist
if [ ! -f "$SPEC_README" ]; then
    echo "Error: Spec README not found at $SPEC_README"
    echo "Please ensure the spec repo is cloned at ../spec"
    exit 1
fi

if [ ! -f "$SPEC_CONVENTIONS" ]; then
    echo "Error: Conventions file not found at $SPEC_CONVENTIONS"
    echo "Please ensure the spec repo is up to date"
    exit 1
fi

echo "Syncing Cooklang specification..."

# --- Sync spec ---
temp_file="$(mktemp)"

cat > "$temp_file" << EOF
---
title: 'Cooklang Specification'
date: $(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
draft: false
weight: 2
summary: This is the specification and reference for writing a recipe in Cooklang.
---

EOF

# Process the README.md content
# - Skip the "Table of Contents" heading
# - Rewrite the conventions.md link to point to the site page
awk '
    /^Table of Contents$/ { next }
    /^=================$/  { next }
    { gsub(/\(conventions\.md\)/, "({{< ref \"conventions\" >}})");
      gsub(/^```cooklang/, "```"); print }
' "$SPEC_README" >> "$temp_file"

cp "$temp_file" "$SITE_SPEC_FILE"
rm "$temp_file"

echo "Updated: $SITE_SPEC_FILE"

# --- Sync conventions ---
temp_file="$(mktemp)"

cat > "$temp_file" << EOF
---
title: 'Conventions'
date: $(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
draft: false
weight: 3
summary: Common conventions used in tools built on top of the Cooklang language.
---

EOF

# Skip the leading "# Conventions" heading (Hugo uses the frontmatter title)
awk '
    NR == 1 && /^# Conventions$/ { next }
    { gsub(/^```cooklang/, "```"); gsub(/^```toml/, "```"); print }
' "$SPEC_CONVENTIONS" >> "$temp_file"

cp "$temp_file" "$SITE_CONVENTIONS_FILE"
rm "$temp_file"

echo "Updated: $SITE_CONVENTIONS_FILE"

# --- Done ---
echo ""
echo "Specification sync complete!"
echo ""
echo "Run 'hugo server' to preview the updated specification."
