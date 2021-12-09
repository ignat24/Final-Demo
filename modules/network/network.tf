# network.tf

# Main VPC==================================
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = var.aws_dnc
  enable_dns_hostnames = var.aws_dnc_hostname

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
# Elastic IP================================
resource "aws_eip" "eip" {
  count = var.az_count
  vpc = true

  tags = {
      "Name" =  "EIP-${var.env}-${var.app}"
  }
}

# Nat Gateway===============================
resource "aws_nat_gateway" "nat" {
  count = var.az_count
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id

  tags = {
      "Name" =  "NAT-${var.env}-${var.app}"
  }
}

# Subnets===================================
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

resource "aws_subnet" "private_subnets" {
  count = var.az_count
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 11)
  availability_zone = data.aws_availability_zones.avaliable.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private-Subnet-${count.index + 1}-${var.env}-${var.app}"
  }

}


# Route Table for Public subnets============
resource "aws_route_table" "rt_public_subnets" {
    count = var.az_count
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = var.cidr_block_route
        gateway_id = aws_internet_gateway.main_ig.id
    }

    tags = {
      "Name" = "Public-Route-Table-${count.index + 1}-${var.env}-${var.app}"
    }
  
}

# Route Table for Private subnets===========
resource "aws_route_table" "rt_private_subnets" {
    count = var.az_count
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = var.cidr_block_route
        gateway_id = aws_nat_gateway.nat[count.index].id
    }

    tags = {
      "Name" = "Private-Route-Table-${count.index + 1}-${var.env}-${var.app}"
    }
  
}


# Route table association===================

resource "aws_route_table_association" "rta_private" {
  count = var.az_count
  route_table_id = aws_route_table.rt_private_subnets[count.index].id
  subnet_id = aws_subnet.private_subnets[count.index].id
}

resource "aws_route_table_association" "rta_public" {
  count = var.az_count
  route_table_id = aws_route_table.rt_public_subnets[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
}