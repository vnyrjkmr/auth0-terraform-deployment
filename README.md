# Auth0 Terraform Infrastructure

This repository contains Terraform infrastructure as code for managing Auth0 tenants across multiple environments.

## 📁 Repository Structure

```
├── config/                   # Environment configuration files
│   ├── dev.tfvars            # Development environment variables
│   ├── qa.tfvars             # Staging environment variables
│   ├── prod.tfvars           # Production environment variables
│   ├── dev-original.tfvars   # Original development config
│   ├── dev-simplified.tfvars # Simplified development config
│   └── dev-minimal.tfvars    # Minimal development config
├── docs/                     # Documentation
│   ├── README.md            # Detailed setup and usage guide
│   ├── END-TO-END-GUIDE.md  # End-to-end deployment guide
│   ├── ENVIRONMENT-SECRETS-MIGRATION-COMPLETE.md
│   └── ENVIRONMENT-SECRETS-TEST.md
├── scripts/                  # PowerShell automation scripts
│   ├── setup-end-to-end.ps1 # Complete setup automation
│   ├── migrate-to-environment-secrets.ps1
│   └── fix-action-error.ps1
├── .github/
│   └── workflows/
│       └── deploy-auth0.yml  # CI/CD pipeline
├── main.tf                   # Terraform main configuration
├── variables.tf              # Terraform variable definitions
└── outputs.tf                # Terraform outputs
```

## 🚀 Quick Start

1. **Review Configuration**: Check `config/` folder for environment-specific variables
2. **Read Documentation**: See `docs/README.md` for detailed setup instructions
3. **Run Setup**: Execute `scripts/setup-end-to-end.ps1` for automated configuration
4. **Deploy**: Use GitHub Actions workflow or run Terraform manually

## 🔒 Security

This repository uses GitHub environment-specific secrets for secure credential management:
- Development environment secrets for dev deployments
- Staging environment secrets for qa deployments  
- Production environment secrets for prod deployments

No secrets are stored in source code or configuration files.

## 📖 Documentation

For detailed setup instructions, deployment guides, and troubleshooting, see the `docs/` folder.

## 🛠️ Automation Scripts

The `scripts/` folder contains PowerShell scripts for:
- End-to-end environment setup
- Secret migration utilities
- Error fixing and debugging

## 🌍 Environments

- **Development**: `config/dev.tfvars` → Development Auth0 tenant
- **Staging**: `config/qa.tfvars` → Staging Auth0 tenant
- **Production**: `config/prod.tfvars` → Production Auth0 tenant

---

*For detailed information, see [docs/README.md](docs/README.md)*