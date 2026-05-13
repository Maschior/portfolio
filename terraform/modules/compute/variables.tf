variable "needs_public_ip" {
  type    = bool
  default = false
}

variable "instance_type" {}
variable "subnet_id" {}
variable "ami" {}
variable "security_group_id" {}
variable "iam_instance_profile" {}
variable "project_name" {}
variable "environment" {}
variable "tpl_name" {}
variable "tunnel_token" {
  type     = string
  nullable = false
}