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

# Create _index.md for commands section if it doesn't exist
if [ ! -f "$COMMANDS_DIR/_index.md" ]; then
    cat > "$COMMANDS_DIR/_index.md" << 'EOF'
---
title: 'Commands'
weight: 20
---

All CookCLI commands documentation.
EOF
fi

echo "Syncing CookCLI documentation..."

# Function to add Hugo frontmatter to markdown files
add_frontmatter() {
    local file="$1"
    local title="$2"
    local weight="$3"
    local temp_file="$(mktemp)"
    
    cat > "$temp_file" << EOF
---
title: '$title'
weight: $weight
description: 'CookCLI $title command documentation'
date: $(date -u +"%Y-%m-%dT%H:%M:%S+00:00")
---

EOF
    
    # Skip the H1 heading if it exists (first line starting with #)
    if head -n 1 "$file" | grep -q "^# "; then
        tail -n +2 "$file" >> "$temp_file"
    else
        cat "$file" >> "$temp_file"
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
    
    # Generate title (capitalize and format)
    title=$(echo "$command_name" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
    
    echo "Processing $command_name..."
    
    # Add frontmatter and copy to site
    temp_file=$(add_frontmatter "$doc_file" "$title" "$weight")
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
echo "## Overview" >> "$temp_file"
echo "" >> "$temp_file"

# Extract overview content from README (skip title and installation)
awk '
    /^# CookCLI Documentation$/ { next }
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
        # Transform command links to Hugo-style links
        gsub(/\[([^\]]+)\]\([^)]+\.md\)/, "[\\1](commands/\\1/)")
        gsub(/shopping-list/, "shopping-list")
        print
        next
    }
    in_commands && /^$/ { in_commands = 0 }
    { 
        if (!in_commands) print 
    }
' "$COOKCLI_DOCS/README.md" >> "$temp_file"


# Replace the _index.md file
mv "$temp_file" "$SITE_CLI_DIR/_index.md"

echo "Documentation sync complete!"
echo ""
echo "Generated files:"
ls -la "$COMMANDS_DIR"/*.md 2>/dev/null | grep -v "_index.md" | awk '{print "  - " $NF}'
echo ""
echo "Run 'hugo server' to preview the updated documentation."