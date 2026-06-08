variable "project_name" {
  description = "Nome do projeto, usado como prefixo em todos os recursos"
  type        = string
  default     = "portfolio"
}

variable "domain_name" {
  description = "Domínio gerenciado pelo Cloudflare"
  type        = string
  default     = "maschior.com"
}

variable "aws_region" {
  description = "Região AWS para provisionamento dos recursos"
  type        = string
  default     = "sa-east-1"
}

variable "portfolio_instance_type" {
  description = "Tipo de instância EC2 para o portfolio"
  type        = string
  default     = "t3.micro"
}

variable "cloudflare_account_id" {
  description = "ID da conta Cloudflare"
  type        = string
  sensitive   = true
}

variable "cloudflare_tunnel_token" {
  type        = string
  description = "Token para autenticação do túnel Cloudflare"
  sensitive = true
}