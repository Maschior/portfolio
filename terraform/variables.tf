variable "project_name" {
    default = "portfolio"
}

variable "domain_name" {
  description = "Domain name for the Cloudflare DNS record"
  default     = "maschior.com"
}

variable "portfolio_instance_type" {
  description = "Instance type for the portfolio EC2 instance"
  default     = "t3.micro"
}

variable "portfolio_elastic_ip" {
    description = "Public Elastic IP address for the portfolio EC2 instance"
    default     = ""
}