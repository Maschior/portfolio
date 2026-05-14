# --- AMI Ubuntu LTS ---
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- EC2 Instance ---
resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  user_data = templatefile(
    "${path.module}/scripts/bootstrap.sh.tpl",
    {
      tunnel_token = var.tunnel_token
    }
  )

  tags = {
    Name = "${var.project_name}-instance"
    Env  = var.environment
  }
}