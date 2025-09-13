# Terraform AWS Modules

A comprehensive monorepo of Terraform AWS wrapper modules that provide simplified, opinionated interfaces around official Terraform AWS modules.

## Features

- **Wrapper modules** for common AWS services (VPC, EC2, ECS, Lambda, S3, etc.)
- **Per-module semantic versioning** with automatic release management
- **Examples included** in each module directory for easy reference
- **Automated CI/CD** with validation, testing, and documentation generation
- **Consistent patterns** across all modules

## Quick Start

Each module can be used independently with its own version tag:

```hcl
module "vpc" {
  source = "github.com/nova-iris/terraform-aws-modules//modules/vpc?ref=vpc-1.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

## Available Modules

- **VPC** - Virtual Private Cloud configuration
- **EC2** - EC2 instance management
- **ECS** - Elastic Container Service setup
- **Lambda** - Serverless functions
- **S3** - Simple Storage Service buckets

## Versioning

Each module follows semantic versioning with module-prefixed tags:
- `vpc-1.0.0`, `vpc-1.0.1`, `vpc-1.1.0`
- `ecs-0.9.0`, `ecs-1.0.0`, `ecs-1.1.0`

Version bumps are determined automatically based on commit messages:
- `feat:` → minor version bump
- `fix:` → patch version bump  
- `BREAKING CHANGE:` → major version bump

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## License

MIT License - see [LICENSE](LICENSE) file for details.
# Test change
test workflow trigger
