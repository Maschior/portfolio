output "instance_id" {
  description = "ID da instância EC2"
  value       = module.compute.instance_id
}

output "vpc_id" {
  description = "ID da VPC"
  value       = module.network_dev.vpc_id
}

output "domain" {
  description = "Domínio do portfolio"
  value       = var.domain_name
}

output "public_ip" {
  description = "IP público da instância EC2"
  value       = module.compute.public_ip
}
