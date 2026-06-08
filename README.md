# Cloud Portfolio Infrastructure (AWS + Terraform + Ansible)

📖 [Versão em Português aqui](README.pt-br.md)

💻 **Note:** This repository contains the Terraform IaC and Ansible playbooks for managing the deployment infrastructure. The source code for the Next.js portfolio application running on this infrastructure can be found here: [github.com/Maschior/portfolio-webapp](https://github.com/Maschior/portfolio-webapp).

---

This repository manages the Cloud Infrastructure and System Configuration for hosting my personal portfolio website, utilizing a modern, production-grade DevOps stack to deploy automatically and securely.

## Architecture Overview

The infrastructure simulates a corporate cloud environment with separate repository codebases and automated pipelines:
- **Terraform IaC:** Provisions AWS networking, computing, and security. It uses a **Global Tagging (default_tags)** strategy at the provider level to ensure all resources are labeled consistently.
- **Ansible Automation:** Localized configuration execution. Ansible playbooks are dynamically injected into the EC2 launch instance via Cloud-Init/User Data. It automatically installs and configures system services (Nginx, Node.js, PM2) and prepares the host.
- **Secure Cloudflare Tunnel:** Decoupled from the lifecycle of the compute instance to prevent DNS collisions. A static tunnel is created once in Cloudflare, and the EC2 instance securely registers with it using a secret tunnel token on boot.
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
│   │   └── compute/          # EC2 instance & launch scripting (injects Ansible files)
│   ├── main.tf               # Root module orchestrator
│   ├── providers.tf          # Provider configs & global default_tags
│   └── variables.tf          # Input declarations
└── ansible/                  # Ansible Provisioning configs
    ├── playbook.yml          # Server configuration tasks (Nginx, Node.js, PM2 setup)
    ├── ansible.cfg           # Local Ansible configuration
    └── hosts                 # Local inventory definitions
```

## Deployment Guide

Follow the instructions below to configure and provision the infrastructure:

### 1. Prerequisites
Ensure you have the following installed:
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials.

### 2. Cloudflare Manual Setup (One-time)
Because the Cloudflare Tunnel is decoupled to prevent recreation/DNS failures:
1. Create a Cloudflare Tunnel manually in the **Cloudflare Zero Trust** console.
2. Route the traffic to your domain (e.g. `yourdomain.com` and `www.yourdomain.com`) to point to `http://localhost:80`.
3. Set up CNAME records pointing to your tunnel (`<tunnel-id>.cfargotunnel.com`).
4. Copy the **Tunnel Token**.

### 3. Infrastructure Provisioning
Navigate to the terraform directory:
```bash
cd terraform
```

Create a `terraform.tfvars` file or configure your environment variables:
```hcl
aws_region              = "sa-east-1"
domain_name             = "yourdomain.com"
project_name            = "portfolio"
cloudflare_tunnel_token = "YOUR_CLOUDFLARE_TUNNEL_TOKEN"
```
*(When deploying via GitHub Actions, add `CLOUDFLARE_TUNNEL_TOKEN` as a secret and inject it as `TF_VAR_cloudflare_tunnel_token`).*

Initialize Terraform (downloads providers and module requirements):
```bash
terraform init
```

Review and deploy changes:
```bash
terraform plan
terraform apply
```

### 4. Server Configuration
No manual execution of Ansible is needed! The EC2 instance automatically installs and runs the local Ansible playbooks on boot using the configs passed through Cloud-Init. Once boot completes, Nginx will be listening and routing traffic to the Next.js target.
