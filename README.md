# Cloud Portfolio Infrastructure (AWS + Terraform + Ansible)

📖 [Versão em Português aqui](README.pt-br.md)

💻 **Note:** This repository contains the Terraform IaC and Ansible playbooks for managing the deployment infrastructure. The source code for the Next.js portfolio application running on this infrastructure can be found here: [github.com/Maschior/portfolio-webapp](https://github.com/Maschior/portfolio-webapp).

---

This repository manages the Cloud Infrastructure and System Configuration for hosting my personal portfolio website, utilizing a modern, production-grade DevOps stack to deploy automatically and securely.

## Architecture Overview

The infrastructure simulates a corporate cloud environment with separate repository codebases and automated pipelines:
- **Terraform IaC:** Provisions AWS networking, computing, security, and integration with Cloudflare.
- **Ansible Automation:** Installs and configures system services (like Nginx) and handles host configurations on the EC2 instance.
- **Secure Cloudflare Tunnel:** Connects the EC2 instance to the public web via an outbound tunnel (no public inbound ports need to be exposed to the internet).
- **GitHub Actions Integration:** Utilizes secure AWS OpenID Connect (OIDC) authentication for passwordless IAM deployments.

## Technology Stack
- **Infrastructure as Code:** [Terraform](https://www.terraform.io/)
- **Configuration Management:** [Ansible](https://www.ansible.com/)
- **Cloud Provider:** [Amazon Web Services (AWS)](https://aws.amazon.com/)
- **DNS & Security:** [Cloudflare](https://www.cloudflare.com/) (Tunnels + DNS routing)
- **CI/CD:** GitHub Actions (with IAM OIDC role integration)

## Directory Structure
```bash
portfolio-infra/
├── terraform/                # Terraform Configurations
│   ├── modules/              # Reusable IaC Modules
│   │   ├── bootstrap/        # S3 Backend bucket & DynamoDB state lock table
│   │   ├── github_oidc/      # OpenID Connect Role for GitHub Actions
│   │   ├── network/          # VPC, Subnet, Route Table configurations
│   │   ├── iam/              # IAM Policies & Roles for SSM
│   │   ├── security/         # Security Groups
│   │   ├── cloudflare/       # Cloudflare Tunnel & DNS record resources
│   │   └── compute/          # EC2 instance & launch scripting
│   ├── main.tf               # Root module orchestrator
│   └── variables.tf          # Input declarations
└── ansible/                  # Ansible Provisioning configs
    ├── playbooks.yml         # Server configuration tasks (Nginx setup, etc.)
    └── hosts                 # Inventory definitions
```

## Deployment Guide

Follow the instructions below to configure and provision the infrastructure:

### 1. Prerequisites
Ensure you have the following installed:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [Ansible CLI](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials.

### 2. Infrastructure Provisioning
Navigate to the terraform directory:
```bash
cd terraform
```

Initialize Terraform (downloads providers and module requirements):
```bash
terraform init
```

Review planned changes:
```bash
terraform plan
```

Deploy infrastructure:
```bash
terraform apply
```

### 3. Server Configuration (Ansible)
After provisioning the EC2 instance, navigate to the ansible directory to configure it:
```bash
cd ../ansible
ansible-playbook playbook.yml
```
This installs Nginx, configures directories, and prepares the host for the web application deployment.
