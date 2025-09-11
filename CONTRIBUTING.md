# Contributing to Terraform AWS Modules

Thank you for your interest in contributing to this project!

## Development Workflow

### 1. Fork and Clone

Fork the repository and clone it locally:

```bash
git clone https://github.com/your-username/terraform-aws-modules.git
cd terraform-aws-modules
```

### 2. Create a Feature Branch

```bash
git checkout -b feature/my-new-module
```

### 3. Make Changes

- Follow existing module patterns
- Include examples in the module's `examples/` directory
- Use conventional commit messages:
  - `feat: add new feature` → minor version bump
  - `fix: resolve issue` → patch version bump
  - `BREAKING CHANGE: ...` → major version bump

### 4. Test Your Changes

```bash
# Format and validate
terraform fmt -check
terraform validate

# Test examples
cd modules/vpc/examples/simple
terraform init
terraform plan
```

### 5. Submit a Pull Request

1. Push your branch
2. Create a PR using the provided template
3. Ensure CI checks pass
4. Wait for review and approval

## Module Structure

Each module should follow this structure:

```
modules/service-name/
├── main.tf              # Main resources
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── versions.tf         # Provider and module versions
├── README.md           # Module documentation
└── examples/           # Usage examples
    ├── simple/
    └── advanced/
```

## Coding Standards

- Use Terraform 1.0+ syntax
- Follow official AWS module patterns
- Include comprehensive documentation
- Add examples for all major use cases
- Use descriptive variable names

## Release Process

Releases are automated based on commit messages. The CI/CD pipeline will:

1. Detect changed modules
2. Determine version bump based on commits
3. Create module-prefixed tags (e.g., `vpc-1.0.0`)
4. Generate GitHub releases

## Questions?

Feel free to open an issue for any questions!