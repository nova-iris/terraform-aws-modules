# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Terraform Operations
```bash
# Format and validate all modules
terraform fmt -recursive
terraform init -upgrade
terraform validate

# Test a specific module
cd modules/vpc/examples/simple
terraform init
terraform plan
terraform apply

# Run comprehensive tests
./scripts/test.sh
```

### CI/CD Commands
```bash
# Manual validation
terraform fmt -check
terraform validate -no-color

# Manual release (requires GitHub CLI)
gh workflow run release.yml -f modules=vpc,ec2
```

## Architecture Overview

This is a **monorepo of Terraform AWS wrapper modules** that provide simplified, opinionated interfaces around official Terraform AWS modules.

### Module Structure Pattern
Each module follows this standardized structure:
```
modules/service-name/
├── main.tf              # Main resources and wrapper logic
├── variables.tf         # Input variables with defaults
├── outputs.tf          # Output values from underlying modules
├── README.md           # Auto-generated documentation
└── examples/           # Usage examples
    ├── simple/          # Basic usage example
    └── advanced/        # Complex usage (optional)
```

### Module Categories
- **VPC**: Virtual Private Cloud wrapper around terraform-aws-modules/vpc/aws
- **EC2**: EC2 instance management
- **ECS**: Elastic Container Service setup
- **Lambda**: Serverless functions with automatic IAM role creation
- **S3**: Simple Storage Service buckets

### Key Design Patterns
1. **Wrapper Modules**: Most modules wrap official Terraform AWS modules for consistency
2. **Per-module Versioning**: Each module has independent semantic versioning
3. **Automated Documentation**: README.md files are auto-generated with `terraform-docs`
4. **Example-driven**: Each module includes working examples in `examples/` directories
5. **Tagging Consistency**: All modules support unified tagging with merge pattern

## Development Workflow

### Module Development
1. Follow the established module structure pattern
2. Include comprehensive variable descriptions and defaults
3. Add examples for all major use cases
4. Use conventional commit messages:
   - `feat:` → minor version bump
   - `fix:` → patch version bump
   - `BREAKING CHANGE:` → major version bump

### Testing Strategy
- **Format Checks**: `terraform fmt -check`
- **Syntax Validation**: `terraform validate`
- **Example Testing**: CI validates all module examples across multiple Terraform versions
- **Multi-version Testing**: Matrix testing across Terraform 1.0, 1.5, and latest

### Release Process
Releases are fully automated through GitHub Actions:
1. Detect changed modules based on commit messages
2. Determine version bump using conventional commits
3. Create module-prefixed tags (e.g., `vpc-1.0.0`, `ecs-1.2.0`)
4. Generate GitHub releases with changelogs

### CI/CD Pipeline
- **Validation Workflow**: Runs on push/PR to main branch
- **Release Workflow**: Manual trigger for creating releases
- **Documentation Workflow**: Auto-generates module documentation
- **Matrix Testing**: Tests across multiple Terraform versions and example configurations

## Module Implementation Details

### VPC Module (`modules/vpc/`)
- Wraps `terraform-aws-modules/vpc/aws` version >= 5.0
- Supports public, private, and database subnets
- Configurable NAT gateway strategies
- Automatic tagging with Type-based subnet tags

### Lambda Module (`modules/lambda/`)
- Creates Lambda functions with automatic zip packaging
- Optional IAM role creation with appropriate policies
- CloudWatch log group creation with configurable retention
- VPC configuration support with automatic policy attachment

### Common Patterns
- All modules use `terraform >= 1.0` and `aws provider >= 4.0`
- Tag merging pattern: `merge(default_tags, user_tags)`
- Conditional resource creation using `count` pattern
- Comprehensive output variables for cross-module references

## Versioning and Tagging

### Version Format
Each module uses semantic versioning with module-prefixed tags:
- Format: `{module-name}-{major}.{minor}.{patch}`
- Examples: `vpc-1.0.0`, `ecs-2.1.3`, `lambda-0.9.0`

### Version Bump Rules
- **Major**: Breaking changes (explicit `BREAKING CHANGE:` in commit)
- **Minor**: New features (commits starting with `feat:`)
- **Patch**: Bug fixes (commits starting with `fix:` or other changes)

### Git Workflow
- Main branch for production releases
- All development happens via feature branches
- PR template ensures proper commit message format
- Automated branch protection for main branch