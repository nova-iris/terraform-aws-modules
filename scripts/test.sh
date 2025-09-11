#!/bin/bash
set -e

# Test script for Terraform AWS Modules
# This script validates the structure and basic functionality of all modules

echo "🧪 Testing Terraform AWS Modules"

# Test 1: Check directory structure
echo "📁 Checking directory structure..."
for module in vpc ec2 ecs lambda s3; do
    if [ -d "modules/$module" ]; then
        echo "✅ $module module exists"
        
        # Check required files
        for file in main.tf variables.tf outputs.tf; do
            if [ -f "modules/$module/$file" ]; then
                echo "  ✅ $file exists"
            else
                echo "  ❌ $file missing"
            fi
        done
        
        # Check examples
        if [ -d "modules/$module/examples" ]; then
            echo "  ✅ examples directory exists"
        else
            echo "  ❌ examples directory missing"
        fi
    else
        echo "❌ $module module missing"
    fi
done

# Test 2: Check Terraform formatting
echo ""
echo "🎨 Checking Terraform formatting..."
terraform fmt -check -recursive
echo "✅ All files formatted correctly"

# Test 3: Check GitHub Actions
echo ""
echo "🤖 Checking GitHub Actions workflows..."
for workflow in validate.yml release.yml docs.yml; do
    if [ -f ".github/workflows/$workflow" ]; then
        echo "✅ $workflow exists"
    else
        echo "❌ $workflow missing"
    fi
done

# Test 4: Check documentation
echo ""
echo "📚 Checking documentation..."
if [ -f "README.md" ]; then
    echo "✅ Root README.md exists"
else
    echo "❌ Root README.md missing"
fi

if [ -f "CONTRIBUTING.md" ]; then
    echo "✅ CONTRIBUTING.md exists"
else
    echo "❌ CONTRIBUTING.md missing"
fi

# Test 5: Check CODEOWNERS
echo ""
echo "👥 Checking CODEOWNERS..."
if [ -f ".github/CODEOWNERS" ]; then
    echo "✅ CODEOWNERS file exists"
else
    echo "❌ CODEOWNERS file missing"
fi

echo ""
echo "🎉 Testing complete!"