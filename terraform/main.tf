# -- Configuração do GitHub OIDC Provider para autenticação de ações do GitHub com AWS
module "github_oidc" {
  source = "./modules/github_oidc"
}

# --- Definição da network
module "network_dev" {
  source             = "./modules/network"
  vpc_cidr           = "10.0.1.0/24"
  public_subnet_cidr = "10.0.1.0/24"
  availability_zone  = "sa-east-1a"
  environment        = "dev"
  project_name       = var.project_name
}

# --- Criação da IAM Role ---
module "iam_role" {
  source       = "./modules/iam"
  project_name = var.project_name
}

# --- Security Group ---
module "security_group" {
  source         = "./modules/security"
  vpc_id         = module.network_dev.vpc_id
  project_name   = var.project_name
  sg_description = "Security group para o servidor do portfolio"
}

# --- AMIs ---

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- Cloudflare 
module "cloudflare" {
  source = "./modules/cloudflare"

  domain_name           = var.domain_name
  project_name          = var.project_name
  cloudflare_account_id = "faf3af21f00c13e26febc2e4d6e12a2a"
}

# --- Instances
module "compute" {
  source = "./modules/compute"

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.portfolio_instance_type
  subnet_id            = module.network_dev.public_subnet_id
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam_role.ec2_profile_name

  needs_public_ip = true

  tpl_name = "bootstrap.sh.tpl"
  tunnel_token = module.cloudflare.tunnel_token

  project_name = var.project_name
  environment  = "dev"
}
