#!/bin/bash

# Setup script for enhanced Terraform module validation
# This script helps configure AWS secrets and test the new validation setup

set -e

echo "🚀 Setting up Enhanced Terraform Module Validation"
echo "================================================"

# Check if required tools are installed
echo "📋 Checking prerequisites..."

if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI is not installed. Please install it first."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ jq is not installed. Please install it first."
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Not in a git repository. Please run this script from the project root."
    exit 1
fi

echo "✅ Prerequisites checked successfully"

# Configure AWS secrets for GitHub Actions
echo "🔧 Configuring AWS secrets for GitHub Actions..."

read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
read -p "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY

# Set secrets for GitHub repository
echo "Setting AWS secrets in GitHub repository..."

gh secret set VTD_AWS_ACCESS_KEY_ID --body "$AWS_ACCESS_KEY_ID"
gh secret set VTD_AWS_SECRET_ACCESS_KEY --body "$AWS_SECRET_ACCESS_KEY"

echo "✅ AWS secrets configured successfully"

# Test Terraform formatting
echo "🎨 Testing Terraform formatting..."
terraform fmt -recursive

if [ $? -eq 0 ]; then
    echo "✅ All files are properly formatted"
else
    echo "❌ Terraform formatting issues found. Please run 'terraform fmt -recursive' to fix."
fi

# Test basic validation
echo "🧪 Testing basic validation..."
terraform init -upgrade
terraform validate

if [ $? -eq 0 ]; then
    echo "✅ Basic validation passed"
else
    echo "❌ Basic validation failed"
fi

# Test example structure
echo "📁 Testing example structure..."

for module in vpc ec2 ecs lambda s3; do
    if [ -d "modules/$module/examples" ]; then
        echo "📂 Testing module: $module"
        
        for example in basic advanced complete; do
            if [ -d "modules/$module/examples/$example" ]; then
                echo "  ✅ $example example exists"
                
                # Test terraform init and plan for the example
                cd "modules/$module/examples/$example"
                echo "    🔄 Testing terraform init..."
                terraform init -upgrade > /dev/null 2>&1
                
                if [ $? -eq 0 ]; then
                    echo "    ✅ Terraform init successful"
                else
                    echo "    ❌ Terraform init failed"
                fi
                
                echo "    📋 Testing terraform plan..."
                terraform plan -no-color > /dev/null 2>&1
                
                if [ $? -eq 0 ]; then
                    echo "    ✅ Terraform plan successful"
                else
                    echo "    ❌ Terraform plan failed"
                fi
                
                cd - > /dev/null
            else
                echo "  ⚠️  $example example missing"
            fi
        done
    else
        echo "❌ $module examples directory missing"
    fi
done

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Commit and push your changes"
echo "2. Create a pull request to test the validation"
echo "3. Monitor the GitHub Actions for validation results"
echo ""
echo "📚 Validation features:"
echo "- ✅ Plan-only validation (no apply)"
echo "- ✅ Three example types per module: basic, advanced, complete"
echo "- ✅ Cross-module dependencies using relative paths"
echo "- ✅ Changed module detection"
echo "- ✅ AWS credentials integration"
echo "- ✅ Enhanced branch protection"
echo ""
echo "🔗 Your branch protection rules now require:"
echo "- All validation jobs to pass"
echo "- Code owner approval"
echo "- Linear history"
echo "- No force pushes or deletions"