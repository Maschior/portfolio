resource "aws_vpc" "this" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.project_name}-vpc"
        Env  = var.environment
    }
}

resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.this.id
    cidr_block              = var.public_subnet_cidr
    availability_zone       = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet"
        Env  = var.environment
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.project_name}-igw"
        Env  = var.environment
    }
}

# tabela de roteamento
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.project_name}-public-rt"
        Env  = var.environment
    }
}

# Associação da route table pública à subnet pública
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}
