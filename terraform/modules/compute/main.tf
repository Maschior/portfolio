resource "aws_instance" "this" {
    ami                    = var.ami
    
    user_data = templatefile(
        "${path.module}/scripts/${var.tpl_name}",
        {
            tunnel_token = var.tunnel_token
        }
  )
    
    instance_type          = var.instance_type
    iam_instance_profile   = var.iam_instance_profile

    subnet_id              = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    
    associate_public_ip_address = true

    tags = {
        Name = "${var.project_name}-instance"
        Env  = var.environment
    }
}

# resource "aws_eip" "this" {
#     for_each = var.needs_public_ip ? { this = true }: {}
#     domain = "vpc"

#     tags = {
#         Name = "${var.project_name}-eip"
#         Env  = var.environment
#     }

#     lifecycle {
#       prevent_destroy = true
#     }
# }

# resource "aws_eip_association" "this" {
#     for_each = aws_eip.this

#     instance_id = aws_instance.this.id
#     allocation_id = each.value.id
# }