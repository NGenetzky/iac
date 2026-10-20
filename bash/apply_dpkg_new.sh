#!/usr/bin/env bash
set -euo pipefail

# Find all .dpkg-new files in /etc
DPKG_NEW_FILES=$(find /etc -type f -name "*.dpkg-new" 2>/dev/null || true)

if [ -z "$DPKG_NEW_FILES" ]; then
    echo "No .dpkg-new files found in /etc."
    exit 0
fi

echo "Found .dpkg-new files. Overwriting standard configurations..."

# Track modified files for final summary
MODIFIED_FILES=()

for dpkg_file in $DPKG_NEW_FILES; do
    # Target file is the path without '.dpkg-new'
    target_file="${dpkg_file%.dpkg-new}"
    
    if [ -f "$target_file" ]; then
        # Preserve original file ownership and permissions
        chmod --reference="$target_file" "$dpkg_file"
        chown --reference="$target_file" "$dpkg_file"
        
        # Replace target file with the .dpkg-new content
        mv "$dpkg_file" "$target_file"
        MODIFIED_FILES+=("$target_file")
        echo "  [UPDATED] $target_file"
    else
        # Handle orphan .dpkg-new files
        mv "$dpkg_file" "$target_file"
        MODIFIED_FILES+=("$target_file")
        echo "  [CREATED] $target_file"
    fi
done

echo ""
echo "Creating etckeeper commit..."
etckeeper commit "Applied upstream .dpkg-new configuration updates"

echo ""
echo "=================================================="
echo "               CONCISE DIFF SUMMARY               "
echo "=================================================="

# Show git diff output from the latest commit
if git -C /etc rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C /etc diff --stat HEAD~1 HEAD
else
    etckeeper vcs diff --stat HEAD~1 HEAD
fi