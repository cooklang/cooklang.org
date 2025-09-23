#!/bin/bash

# Script to sync Cooklang specification from spec repo to website
# Usage: ./scripts/sync-spec.sh

set -e

# Configuration
SPEC_README="../spec/README.md"
SITE_SPEC_FILE="content/docs/spec.md"

# Check if spec README exists
if [ ! -f "$SPEC_README" ]; then
    echo "Error: Spec README not found at $SPEC_README"
    echo "Please ensure the spec repo is cloned at ../spec"
    exit 1
fi

echo "Syncing Cooklang specification..."

# Create temporary file
temp_file="$(mktemp)"

# Add Hugo frontmatter
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
# Skip the "Table of Contents" heading but keep the actual table
awk '
    /^Table of Contents$/ { next }
    /^=================$/  { next }
    { print }
' "$SPEC_README" >> "$temp_file"

# Replace the spec.md file
cp "$temp_file" "$SITE_SPEC_FILE"
rm "$temp_file"

echo "Specification sync complete!"
echo ""
echo "Updated file: $SITE_SPEC_FILE"
echo ""

# Show a preview of the updated content
echo "Preview of synced content:"
echo "---"
head -20 "$SITE_SPEC_FILE"
echo "..."
echo ""
echo "Run 'hugo server' to preview the updated specification."
