# --- Bootstrap para Estado Remoto (S3 + DynamoDB) ---
module "bootstrap" {
  source      = "./modules/bootstrap"
  aws_region  = var.aws_region
  domain_name = var.domain_name
}

# --- GitHub OIDC Provider para autenticação de GitHub Actions com AWS ---
module "github_oidc" {
  source = "./modules/github_oidc"
}

# --- Network ---
module "network_dev" {
  source = "./modules/network"

  vpc_cidr           = "10.0.1.0/24"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "${var.aws_region}a"
  environment        = "dev"
  project_name       = var.project_name
}

# --- IAM Role para EC2 (SSM) ----
module "iam_role" {
  source = "./modules/iam"

  project_name = var.project_name
  domain_name  = var.domain_name
}

# --- Security Group ---
module "security_group" {
  source = "./modules/security"

  vpc_id       = module.network_dev.vpc_id
  project_name = var.project_name
}

# --- Cloudflare DNS + Tunnel ---
# module "cloudflare" {
#   source = "./modules/cloudflare"

#   domain_name           = var.domain_name
#   project_name          = var.project_name
#   cloudflare_account_id = var.cloudflare_account_id
# }



# --- EC2 Instance -----
module "compute" {
  source = "./modules/compute"

  instance_type        = var.portfolio_instance_type
  subnet_id            = module.network_dev.public_subnet_id
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam_role.ec2_profile_name
  aws_region           = var.aws_region
  tunnel_token         = var.cloudflare_tunnel_token

  project_name = var.project_name
  environment  = "dev"
}

resource "aws_servicecatalogappregistry_application" "project" {
  provider    = aws.no_tags
  name        = "${var.project_name}-app"
  description = "Application do projeto ${var.project_name}"
}