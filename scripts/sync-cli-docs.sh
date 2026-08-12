#!/bin/bash

# Script to sync CookCLI documentation from cookcli repo to website
# Usage: ./scripts/sync-cli-docs.sh

set -e

# Configuration
COOKCLI_DOCS="../cookcli/docs"
SITE_CLI_DIR="content/cli"
COMMANDS_DIR="$SITE_CLI_DIR/commands"

# Check if cookcli docs directory exists
if [ ! -d "$COOKCLI_DOCS" ]; then
    echo "Error: CookCLI docs directory not found at $COOKCLI_DOCS"
    echo "Please ensure the cookcli repo is cloned at ../cookcli"
    exit 1
fi

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Copy screenshots from cookcli to static/server/
SCREENSHOTS_SRC="$COOKCLI_DOCS/screenshots"
SCREENSHOTS_DST="static/server"
if [ -d "$SCREENSHOTS_SRC" ]; then
    mkdir -p "$SCREENSHOTS_DST"
    echo "Copying screenshots..."
    cp "$SCREENSHOTS_SRC"/*.png "$SCREENSHOTS_DST/" 2>/dev/null || true
fi

echo "Syncing CookCLI documentation..."

# Copy and process README.md to commands/_index.md
echo "Processing CLI README for commands index..."
if [ -f "$COOKCLI_DOCS/README.md" ]; then
    temp_file="$(mktemp)"
    
    # Add Hugo frontmatter
    cat > "$temp_file" << 'EOF'
---
title: 'Commands'
weight: 20
description: 'CookCLI commands documentation'
---

EOF
    
    # Copy README content, skipping H1 heading (title is in frontmatter)
    # Commands are in the same directory, so just strip .md from links
    if head -n 1 "$COOKCLI_DOCS/README.md" | grep -q "^# "; then
        tail -n +2 "$COOKCLI_DOCS/README.md" | sed 's/\[\([^]]*\)\](\([^)]*\)\.md)/[\1](\2)/g' >> "$temp_file"
    else
        sed 's/\[\([^]]*\)\](\([^)]*\)\.md)/[\1](\2)/g' "$COOKCLI_DOCS/README.md" >> "$temp_file"
    fi
    
    mv "$temp_file" "$COMMANDS_DIR/_index.md"
    echo "Created commands index from CLI README (full content)"
else
    # Fallback: create basic _index.md if README doesn't exist
    cat > "$COMMANDS_DIR/_index.md" << 'EOF'
---
title: 'Commands'
weight: 20
---

All CookCLI commands documentation.
EOF
fi

# Function to add Hugo frontmatter to markdown files
add_frontmatter() {
    local file="$1"
    local title="$2"
    local weight="$3"
    local description="${4:-CookCLI $title command documentation}"
    local dest="$5"
    local temp_file="$(mktemp)"

    # Reuse the destination's existing date rather than stamping now. Syncing
    # an unchanged page should produce no diff at all — otherwise every run
    # rewrites all fourteen dates and buries the one real content change in
    # churn. New pages get today's date.
    local page_date=""
    if [ -n "$dest" ] && [ -f "$dest" ]; then
        page_date=$(awk '/^---$/{c++; next} c==1 && /^date: /{sub(/^date: /, ""); print; exit}' "$dest")
    fi
    if [ -z "$page_date" ]; then
        page_date=$(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
    fi

    cat > "$temp_file" << EOF
---
title: '$title'
weight: $weight
description: '$description'
date: $page_date
---

EOF
    
    # Skip the H1 heading if it exists (first line starting with #)
    # Rewrite image paths: screenshots/foo.png -> /server/foo.png
    # Rewrite sibling doc links: (server.md) -> (server). The docs cross-link
    # by filename, which resolves on GitHub but 404s here, where every page
    # lives at an extensionless URL. Same rewrite the README gets below.
    # Two link expressions rather than one optional group: BSD sed (macOS) has
    # no \? in a basic regex.
    rewrite='s|src="screenshots/|src="/server/|g
             s|(screenshots/|(/server/|g
             s|\[\([^]]*\)\](\([^):/]*\)\.md)|[\1](\2)|g
             s|\[\([^]]*\)\](\([^):/]*\)\.md#|[\1](\2#|g'
    if head -n 1 "$file" | grep -q "^# "; then
        tail -n +2 "$file" | sed -e "$rewrite" >> "$temp_file"
    else
        sed -e "$rewrite" "$file" >> "$temp_file"
    fi
    
    echo "$temp_file"
}

# Function to get weight for command
get_weight() {
    case "$1" in
        "recipe") echo 10 ;;
        "shopping-list") echo 20 ;;
        "server") echo 30 ;;
        "search") echo 40 ;;
        "import") echo 50 ;;
        "doctor") echo 60 ;;
        "seed") echo 70 ;;
        "report") echo 80 ;;
        # Reference pages sort after the per-command ones.
        "api") echo 90 ;;
        *) echo 99 ;;
    esac
}

# Copy and process command documentation
for doc_file in "$COOKCLI_DOCS"/*.md; do
    filename=$(basename "$doc_file")
    
    # Skip README.md - we'll handle it separately
    if [ "$filename" = "README.md" ]; then
        continue
    fi
    
    # Extract command name (remove .md extension)
    command_name="${filename%.md}"
    
    # Get weight for this command
    weight=$(get_weight "$command_name")
    
    # Generate title (capitalize and format), unless the page has a name that
    # title-casing would mangle
    description=""
    case "$command_name" in
        "api")
            title="Server API"
            description="HTTP API reference for the CookCLI recipe server"
            ;;
        "lsp") title="LSP" ;;
        *) title=$(echo "$command_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1') ;;
    esac
    
    echo "Processing $command_name..."
    
    # Add frontmatter and copy to site
    temp_file=$(add_frontmatter "$doc_file" "$title" "$weight" "$description" "$COMMANDS_DIR/$filename")
    cp "$temp_file" "$COMMANDS_DIR/$filename"
    rm "$temp_file"
done

# Update the main CLI index page with overview from README
echo "Updating CLI index page..."
temp_file="$(mktemp)"

# Keep existing frontmatter from _index.md
sed -n '1,/^---$/p' "$SITE_CLI_DIR/_index.md" > "$temp_file"

# Add overview content from cookcli README
echo "" >> "$temp_file"

# Extract overview content from README (skip title and installation)
# First extract the content, then fix the links
awk '
    /^# / { next }
    /^## Installation$/ { exit }
    /^## Available Commands$/ {
        print "## Available Commands"
        print ""
        print "Click on any command below to see detailed documentation:"
        print ""
        in_commands = 1
        next
    }
    in_commands && /^\* / {
        print
        next
    }
    in_commands && /^$/ { in_commands = 0 }
    {
        if (!in_commands) print
    }
' "$COOKCLI_DOCS/README.md" | sed 's/\[\([^]]*\)\](\([^)]*\)\.md)/[\1](commands\/\2)/g' >> "$temp_file"


# Replace the _index.md file
mv "$temp_file" "$SITE_CLI_DIR/_index.md"

# Update the download page with installation instructions from cookcli README
echo "Updating download page..."
DOWNLOAD_PAGE="$SITE_CLI_DIR/download.md"
if [ -f "$DOWNLOAD_PAGE" ]; then
    temp_file="$(mktemp)"

    # Keep existing frontmatter (everything up to and including the second ---)
    awk '/^---$/{c++; print; if(c==2) exit; next} {print}' "$DOWNLOAD_PAGE" > "$temp_file"

    # Extract Installation section from README (between ## Installation and next ##)
    echo "" >> "$temp_file"
    awk '
        /^## 📦 Installation$/ { found=1; next }
        found && /^## / { exit }
        found { print }
    ' "../cookcli/README.md" >> "$temp_file"

    mv "$temp_file" "$DOWNLOAD_PAGE"
    echo "Updated download page with installation instructions"
fi

echo "Documentation sync complete!"
echo ""
echo "Generated files:"
ls -la "$COMMANDS_DIR"/*.md 2>/dev/null | grep -v "_index.md" | awk '{print "  - " $NF}'
echo ""
echo "Run 'hugo server' to preview the updated documentation."
