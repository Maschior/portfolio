variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "domain_name" {
  description = "The domain name to use for the S3 bucket."
  type        = string
}