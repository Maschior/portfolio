variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block da subnet pública"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone para a subnet pública"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto para tagueamento"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}
