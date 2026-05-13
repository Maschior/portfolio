resource "aws_security_group" "this" {
    name        = "${var.project_name}-sg"
    description = var.sg_description
    vpc_id      = var.vpc_id

    # Sem SSH (Suporte ao SSM configurado)

    # HTTP publico (certbot e redirect para HTTPS)
    ingress {
        description = "HTTP Publico"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTPS publico
    ingress {
        description = "HTTPS Publico"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-sg"
    }
}