#!/bin/bash
set -e

# Terraform AWS Modules - Release Automation Script
# This script helps automate the release process for modules

MODULES=${1:-all}
DRY_RUN=${DRY_RUN:-false}

echo "🚀 Starting release process for modules: $MODULES"

if [ "$DRY_RUN" = "true" ]; then
    echo "📋 DRY RUN MODE - No changes will be made"
fi

# Function to release a single module
release_module() {
    local module=$1
    echo "📦 Processing module: $module"
    
    # Check if module directory exists
    if [ ! -d "modules/$module" ]; then
        echo "❌ Module directory not found: modules/$module"
        return 1
    fi
    
    # Get current version
    if git describe --tags --match "${module}-*" --abbrev=0 > /dev/null 2>&1; then
        LAST_TAG=$(git describe --tags --match "${module}-*" --abbrev=0)
        CURRENT_VERSION=$(echo $LAST_TAG | sed "s/${module}-//")
    else
        CURRENT_VERSION="0.0.0"
    fi
    
    echo "📊 Current version: $CURRENT_VERSION"
    
    # Analyze commits since last tag
    if [ "$LAST_TAG" ]; then
        COMMITS=$(git log --pretty=format:"%s" $LAST_TAG..HEAD -- modules/$module)
    else
        COMMITS=$(git log --pretty=format:"%s" --all -- modules/$module)
    fi
    
    # Determine version bump
    if echo "$COMMITS" | grep -q "BREAKING CHANGE"; then
        BUMP="major"
    elif echo "$COMMITS" | grep -q "^feat:"; then
        BUMP="minor"
    elif echo "$COMMITS" | grep -q "^fix:"; then
        BUMP="patch"
    else
        BUMP="patch"
    fi
    
    echo "📈 Version bump: $BUMP"
    
    # Calculate new version
    IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
    MAJOR=${VERSION_PARTS[0]}
    MINOR=${VERSION_PARTS[1]}
    PATCH=${VERSION_PARTS[2]}
    
    case $BUMP in
        "major")
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        "minor")
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        "patch")
            PATCH=$((PATCH + 1))
            ;;
    esac
    
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    echo "✨ New version: $NEW_VERSION"
    
    # Create tag
    TAG="${module}-${NEW_VERSION}"
    echo "🏷️  Tag: $TAG"
    
    if [ "$DRY_RUN" = "false" ]; then
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git tag -a $TAG -m "Release $module version $NEW_VERSION"
        git push origin $TAG
        echo "🎉 Tag pushed: $TAG"
    else
        echo "📋 DRY RUN: Would create and push tag: $TAG"
    fi
}

# Main execution
if [ "$MODULES" = "all" ]; then
    # Get all modules
    MODULE_LIST=$(find modules -maxdepth 1 -type d -name "*" | sed 's|modules/||' | grep -v "^modules$")
    for module in $MODULE_LIST; do
        if [ -n "$module" ]; then
            release_module "$module"
        fi
    done
else
    # Process specific modules
    IFS=',' read -ra MODULE_ARRAY <<< "$MODULES"
    for module in "${MODULE_ARRAY[@]}"; do
        release_module "$module"
    done
fi

echo "✅ Release process completed!"