resource "aws_vpc" "openshift" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "openshift" {
  vpc_id = aws_vpc.openshift.id
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.openshift.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.subnetaz[var.region]
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.openshift]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.openshift.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.openshift.id
  }
}

resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}

