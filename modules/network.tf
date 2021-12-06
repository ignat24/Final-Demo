resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
      "Name" = "VPC-${var.env}-${var.app}"
  }
}


# Internet Gateway==========================
resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "IG-${var.env}-${var.app}"
  }
}

resource "aws_subnet" "public_subnets" {
  count = var.az_count
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index+1)
  availability_zone = data.aws_availability_zones.avaliable.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    "Name" = "Public-Subnet-${count.index + 1}-${var.env}-${var.app}"
  }
}

resource "aws_route_table" "rt_public_subnets" {
    count = var.az_count
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_ig.id
    }

    tags = {
      "Name" = "Public-Route-Table-${count.index + 1}-${var.env}-${var.app}"
    }
  
}

resource "aws_route_table_association" "rta_public" {
  count = var.az_count
  route_table_id = aws_route_table.rt_public_subnets[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
}