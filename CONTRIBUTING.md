# Contributing to Terraform AWS Modules

Thank you for your interest in contributing to this project! We welcome all types of contributions - bug reports, feature requests, documentation improvements, and code changes.

## 📋 Table of Contents

- [Development Workflow](#development-workflow)
- [Module Structure](#module-structure)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Version Management](#version-management)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)
- [Code of Conduct](#code-of-conduct)

## 🔄 Development Workflow

### 1. Fork and Clone

Fork the repository and clone it locally:

```bash
git clone https://github.com/your-username/terraform-aws-modules.git
cd terraform-aws-modules
git remote add upstream https://github.com/nova-iris/terraform-aws-modules.git
```

### 2. Create a Feature Branch

Use conventional branch naming:

```bash
# Feature branch
git checkout -b feat/add-new-module

# Bug fix branch  
git checkout -b fix/vpc-subnet-issue

# Documentation branch
git checkout -b docs/update-readme
```

### 3. Make Changes

Follow these guidelines:

#### Conventional Commit Messages

```bash
# Feature additions
feat: add support for multiple NAT gateways
feat(vpc): enable IPv6 support

# Bug fixes
fix: resolve subnet IP address conflict
fix(ec2): correct security group attachment

# Documentation
docs: update VPC module README
docs: add migration guide

# Breaking changes
fix: remove deprecated parameter

BREAKING CHANGE: The deprecated 'old_parameter' has been removed.
Use 'new_parameter' instead.
```

#### Module Development

- Follow existing module patterns
- Include examples in the module's `examples/` directory
- Add comprehensive variable descriptions
- Update CHANGELOG.md for user-facing changes

### 4. Test Your Changes

#### Local Testing

```bash
# Format and validate all modules
terraform fmt -recursive
terraform fmt -check -recursive

# Test specific module
cd modules/vpc
terraform init -upgrade
terraform validate

# Test examples
cd modules/vpc/examples/basic
terraform init
terraform plan -input=false

# Run all tests
./scripts/test.sh
```

#### Security Scanning

```bash
# Install and run tflint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint --init
tflint

# Install and run tfsec
curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
tfsec .

# Install and run checkov
pip install checkov
checkov -d .
```

### 5. Submit a Pull Request

1. **Sync with upstream**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your branch**:
   ```bash
   git push origin feature/your-branch-name
   ```

3. **Create a PR** using the provided template
4. **Ensure CI checks pass** (format, validate, security scanning, examples)
5. **Wait for review and approval**

## 📁 Module Structure

Each module should follow this structure:

```
modules/service-name/
├── main.tf              # Main resources and module logic
├── variables.tf         # Input variables with descriptions
├── outputs.tf          # Output values for module consumers
├── README.md           # Auto-generated module documentation
├── CHANGELOG.md        # Module changelog (Keep a Changelog format)
└── examples/           # Usage examples
    ├── basic/          # Simple usage example
    ├── advanced/       # Complex usage with all features
    └── complete/       # Production-ready example
```

### Required Files

- **main.tf**: Contains the main module resources and logic
- **variables.tf**: All input variables with descriptions and defaults
- **outputs.tf**: All output values from the module
- **README.md**: Module documentation (can be auto-generated)
- **CHANGELOG.md**: Changelog following [Keep a Changelog](https://keepachangelog.com/)
- **examples/basic/main.tf**: Minimum viable usage example

### Module Standards

- Use Terraform >= 1.0 syntax
- Include `terraform` and `required_providers` blocks
- Use wrapper pattern around official AWS modules when possible
- Include comprehensive variable descriptions
- Provide sensible defaults
- Support conditional resource creation where appropriate

## 💻 Coding Standards

### Terraform Code Style

```hcl
# ✅ Good formatting
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# ✅ Good resource naming
resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "web-server"
  }
}

# ✅ Good output naming
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
```

### Naming Conventions

- **Variables**: Use snake_case with descriptive names
- **Resources**: Use snake_case with the service prefix
- **Outputs**: Use snake_case describing what is output
- **Locals**: Use snake_case for local values

### Documentation Requirements

- **Variables**: Always include `description` and `type`
- **Outputs**: Always include `description`
- **Modules**: Document all parameters and return values
- **Examples**: Include usage instructions and expected outputs

## 🧪 Testing Guidelines

### Test Types

1. **Format Tests**: `terraform fmt -check`
2. **Validation Tests**: `terraform validate`
3. **Plan Tests**: `terraform plan` on examples
4. **Security Tests**: TFSec, Checkov, TFLint
5. **Integration Tests**: Apply + destroy in sandbox

### Test Coverage

- All modules must have at least a `basic` example
- Examples should cover major use cases
- Test across multiple Terraform versions (1.0, 1.5, latest)
- Security tools should pass without critical findings

### Local Test Commands

```bash
# Test single module
cd modules/vpc/examples/basic
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform destroy -auto-approve

# Test all modules
./scripts/test.sh
```

## 🏷️ Version Management

### Semantic Versioning

- **Format**: `{module-name}-{major}.{minor}.{patch}`
- **Examples**: `vpc-1.0.0`, `ec2-2.1.3`, `lambda-0.9.0`

### Version Bump Rules

- **Major**: Breaking changes (requires explicit `BREAKING CHANGE:`)
- **Minor**: New features (commits starting with `feat:`)
- **Patch**: Bug fixes (commits starting with `fix:` or other changes)

### Changelog Management

- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Update CHANGELOG.md for any user-facing changes
- Use proper section headers: Added, Changed, Deprecated, Removed, Fixed, Security

## 📋 Pull Request Process

### PR Template

When creating a PR, fill out the template:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Tested locally with `terraform plan`
- [ ] Ran security scanning tools
- [ ] Updated examples as needed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-documenting code with clear naming
- [ ] CHANGELOG.md updated for user-facing changes
- [ ] Documentation updated if needed
```

### Review Process

1. **Automated Checks**: CI runs format, validation, security, and example tests
2. **Peer Review**: At least one maintainer must approve
3. **Merge**: Squash and merge to main branch triggers release

### CI/CD Pipeline

The CI/CD pipeline will:

1. **Detect Changes**: Identify which modules changed
2. **Run Checks**: Format, validate, security scan, test examples
3. **Comment on PR**: Report any failures
4. **Block Merge**: Prevent merge if any checks fail

## 🚀 Release Process

Releases are fully automated on merge to main:

### Automated Release Steps

1. **Change Detection**: Identify modules with changes since last release
2. **Version Analysis**: Determine version bump based on commit messages
3. **Integration Tests**: Run apply + destroy in AWS sandbox
4. **Changelog Update**: Generate and commit CHANGELOG.md updates
5. **Tag Creation**: Create module-specific git tags
6. **GitHub Release**: Create release with changelog
7. **Documentation**: Update module documentation

### Manual Release

```bash
# Trigger release for specific modules
gh workflow run release.yml -f modules=vpc,ec2

# Run integration tests
gh workflow run release.yml -f modules=vpc -f run-integration-tests=true
```

## 🤝 Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). Please read and follow it.

### Getting Help

- **Questions**: Use [GitHub Discussions](https://github.com/nova-iris/terraform-aws-modules/discussions)
- **Bug Reports**: [GitHub Issues](https://github.com/nova-iris/terraform-aws-modules/issues)
- **Feature Requests**: [GitHub Issues](https://github.com/nova-iris/terraform-aws-modules/issues)

### Recognition

Contributors will be recognized in:
- Release notes
- CHANGELOG.md entries
- GitHub contributors section

---

Thank you for helping improve Terraform AWS Modules! 🎉