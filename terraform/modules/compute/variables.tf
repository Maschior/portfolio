variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "security_group_id" {
  description = "ID do security group associado à instância"
  type        = string
}

variable "iam_instance_profile" {
  description = "Nome do IAM instance profile para SSM"
  type        = string
}

variable "aws_region" {
  description = "Região AWS (usada para AMI lookup)"
  type        = string
}

variable "tunnel_token" {
  description = "Token do Cloudflare Tunnel para o bootstrap"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Nome do projeto para tagueamento"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}