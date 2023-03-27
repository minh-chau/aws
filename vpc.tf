# https://docs.aws.amazon.com/glue/latest/dg/set-up-vpc-dns.html
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "main_vpc"
  }
}

# private subnet for app_server
resource "aws_subnet" "private_subnet" {
  count             = length(var.subnet_cidr_private)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_private[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "private_subnet"
  }
}

# public subnet for bastion host
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_public
  #availability_zone = var.availability_zone[count.index]
  tags = {
    "Name" = "public_subnet"
  }
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "main_route_table"
  }
}

resource "aws_route_table_association" "private_rt_asso" {
  count          = length(var.subnet_cidr_private)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "main_gateway"
  }
}

resource "aws_route" "internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.main_rt.id
  gateway_id             = aws_internet_gateway.main_igw.id
}