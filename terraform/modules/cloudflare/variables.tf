variable "domain_name" {
  description = "Nome do domínio gerenciado no Cloudflare"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto para nomeação do tunnel"
  type        = string
}

variable "cloudflare_account_id" {
  description = "ID da conta Cloudflare"
  type        = string
  sensitive   = true
}