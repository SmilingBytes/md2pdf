#!/bin/bash

# Simple changelog generator based on commit prefixes
# Usage: ./generate_changelog.sh [tag_name]

CURRENT_TAG=$1
PREVIOUS_TAG=$(git describe --tags --abbrev=0 "$CURRENT_TAG^" 2>/dev/null || git rev-list --max-parents=0 HEAD)

# Define categories
declare -A categories
categories=(
    ["feat"]="🚀 Features"
    ["fix"]="🐛 Bug Fixes"
    ["refactor"]="⚙️ Refactors"
    ["docs"]="📝 Documentation"
    ["ci"]="👷 CI/CD"
)

# Function to print category
print_category() {
    local prefix=$1
    local title=$2
    local logs=$(git log "$PREVIOUS_TAG..$CURRENT_TAG" --pretty=format:"* %s (%h)" | grep -i "^* $prefix" || true)
    
    if [ -n "$logs" ]; then
        echo "### $title"
        echo "$logs"
        echo ""
    fi
}

for prefix in "feat" "fix" "refactor" "docs" "ci"; do
    print_category "$prefix" "${categories[$prefix]}"
done

# Other changes
OTHER_LOGS=$(git log "$PREVIOUS_TAG..$CURRENT_TAG" --pretty=format:"* %s (%h)" | grep -ivE "^\* (feat|fix|refactor|docs|ci)" || true)
if [ -n "$OTHER_LOGS" ]; then
    echo "### 📦 Other Changes"
    echo "$OTHER_LOGS"
    echo ""
fi

echo "---"
echo "**Full Changelog**: https://github.com/SmilingBytes/md2pdf/compare/${PREVIOUS_TAG}...${CURRENT_TAG}"
