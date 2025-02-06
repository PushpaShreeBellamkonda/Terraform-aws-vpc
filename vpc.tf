# VPC creation

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
     var.common_tags ,
    var.vpc_tags ,
    {
      Name = local.resource_name
    }
  )
}

# Internet gate way

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags ,
    var.igw_tags ,
    {
      Name = local.resource_name
    }
  )
  
}

# Public subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

   tags = merge(
    var.common_tags ,
    var.public_subnet_cidrs_tags ,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}


# Private subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

   tags = merge(
    var.common_tags ,
    var.private_subnet_cidrs_tags ,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

# Database subnet

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

   tags = merge(
    var.common_tags ,
    var.database_subnet_cidrs_tags ,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

# Nat gate way

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    var.common_tags , 
    var.nat_gateway_tags , 
    {
      Name = "${local.resource_name}"   #expense-dev
    }
  )
# To ensure proper ordering , it is reccomended to add an explicit dependency
# on the IGW for the vpc
  depends_on = [ aws_internet_gateway.gw ]  #this is explicit dependency
}


#  Public Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags ,
    var.public_route_table_tags,
    {
      Name = "${local.resource_name}-public"  #expense-dev
    }
  )
}


# Private route table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags ,
    var.private_route_table_tags,
    {
      Name = "${local.resource_name}-private"  #expense-dev
    }
  )
}

# database route table

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags ,
    var.database_route_table_tags,
    {
      Name = "${local.resource_name}-database"  #expense-dev
    }
  )
}