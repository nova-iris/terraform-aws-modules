# Terraform AWS Modules

A comprehensive monorepo of Terraform AWS wrapper modules that provide simplified, opinionated interfaces around official Terraform AWS modules.

## 🚀 Features

- **📦 Wrapper modules** for common AWS services (VPC, EC2, ECS, Lambda, S3, etc.)
- **🏷️ Per-module semantic versioning** with automatic release management
- **📚 Examples included** in each module directory for easy reference
- **🤖 Automated CI/CD** with validation, testing, and documentation generation
- **✅ Consistent patterns** across all modules
- **🔒 Security scanning** with TFSec, Checkov, and TFLint
- **🧪 Integration testing** in ephemeral AWS sandbox environments

## 📋 Prerequisites

- Terraform >= 1.0
- AWS Provider >= 4.0
- AWS credentials configured

## 🏁 Quick Start

Each module can be used independently with its own version tag:

```hcl
# VPC Module
module "vpc" {
  source = "git::https://github.com/nova-iris/terraform-aws-modules.git//modules/vpc?ref=vpc-1.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
}

# EC2 Module
module "ec2" {
  source = "git::https://github.com/nova-iris/terraform-aws-modules.git//modules/ec2?ref=ec2-1.0.0"
  
  name           = "my-ec2-instance"
  ami            = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type  = "t3.micro"
  subnet_id      = module.vpc.public_subnets[0]
  
  tags = {
    Environment = "production"
    Purpose     = "web-server"
  }
}
```

## 📦 Available Modules

| Module | Description | Latest Version |
|--------|-------------|----------------|
| **[VPC](modules/vpc/README.md)** | Virtual Private Cloud configuration | [vpc-1.0.0](https://github.com/nova-iris/terraform-aws-modules/releases/tag/vpc-1.0.0) |
| **[EC2](modules/ec2/README.md)** | EC2 instance management | [ec2-1.0.0](https://github.com/nova-iris/terraform-aws-modules/releases/tag/ec2-1.0.0) |
| **[ECS](modules/ecs/README.md)** | Elastic Container Service setup | [ecs-1.0.0](https://github.com/nova-iris/terraform-aws-modules/releases/tag/ecs-1.0.0) |
| **[Lambda](modules/lambda/README.md)** | Serverless functions | [lambda-1.0.0](https://github.com/nova-iris/terraform-aws-modules/releases/tag/lambda-1.0.0) |
| **[S3](modules/s3/README.md)** | Simple Storage Service buckets | [s3-1.0.0](https://github.com/nova-iris/terraform-aws-modules/releases/tag/s3-1.0.0) |

## 🏷️ Versioning

Each module follows semantic versioning with module-prefixed tags:
- Format: `{module-name}-{major}.{minor}.{patch}`
- Examples: `vpc-1.0.0`, `ecs-2.1.3`, `lambda-0.9.0`

### Version Bump Rules

- **Major**: Breaking changes (explicit `BREAKING CHANGE:` in commit)
- **Minor**: New features (commits starting with `feat:`)
- **Patch**: Bug fixes (commits starting with `fix:` or other changes)

### Usage

Always use specific version tags when referencing modules:

```hcl
# ✅ Good - Specific version
module "vpc" {
  source = "git::https://github.com/nova-iris/terraform-aws-modules.git//modules/vpc?ref=vpc-1.0.0"
}

# ❌ Bad - No version or global version
module "vpc" {
  source = "git::https://github.com/nova-iris/terraform-aws-modules.git//modules/vpc?ref=main"
}
```

## 🔄 CI/CD Pipeline

### Pull Request Checks

- **Format Check**: `terraform fmt -check -recursive`
- **Syntax Validation**: `terraform validate`
- **Security Scanning**: TFSec, Checkov, TFLint
- **Documentation**: Verify README and CHANGELOG are up-to-date
- **Examples**: Run `terraform plan` for all module examples
- **Multi-version Testing**: Test across Terraform 1.0, 1.5, and latest

### Release Process

On merge to `main` branch:

1. **Detect Changes**: Identify modules with changes since last release
2. **Integration Tests**: Run apply + destroy in AWS sandbox environment
3. **Version Bump**: Determine version based on commit messages
4. **Tag Creation**: Create module-specific git tags
5. **GitHub Release**: Create releases with changelog
6. **Documentation Update**: Update CHANGELOG.md files

## 🧪 Testing

### Local Development

```bash
# Test all modules
./scripts/test.sh

# Test specific module
cd modules/vpc/examples/basic
terraform init
terraform plan
terraform apply
terraform destroy
```

### Integration Tests

Integration tests run in ephemeral AWS sandboxes with automatic cleanup:

```bash
# Manually trigger integration tests
gh workflow run release.yml -f modules=vpc -f run-integration-tests=true
```

## 🤝 Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Update examples and documentation
5. Submit a pull request
6. CI checks will run automatically
7. After review, merge to main branch triggers release

### Module Development Standards

- Follow the established module structure pattern
- Include comprehensive variable descriptions and defaults
- Add examples for all major use cases
- Use conventional commit messages
- Update CHANGELOG.md for any user-facing changes

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues and questions:
- **Bug Reports**: [GitHub Issues](https://github.com/nova-iris/terraform-aws-modules/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/nova-iris/terraform-aws-modules/discussions)
- **Documentation**: [Wiki](https://github.com/nova-iris/terraform-aws-modules/wiki)

---

**⚠️ Important**: Always use module-prefixed version tags. Never reference `main` branch in production.
