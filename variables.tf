### Project tags

variable "project_name" {
    type = string
    # we are not giving name here coz its a user choice we cant hardcode it , 
    # user will give his own choise ,here we give this name in "aws-vpc-test"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "common_tags" {
    type = map
}

###VPC tags

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
}

variable "vpc_tags" {
    type = map
    default = {}
}


##I GW tags
variable "igw_tags" {
    type = map
    default = {}
}

# Public subnet variables

variable "public_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.public_subnet_cidrs) == 2
      error_message = "Please provide 2 valid public subnet CIDR"
    }
}


variable "public_subnet_cidrs_tags" {
  type = map
  default = {}
}

# Private subnet variables

variable "private_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.private_subnet_cidrs) == 2
      error_message = "Please provide 2 valid private subnet CIDR"
    }
}


variable "private_subnet_cidrs_tags" {
  type = map
  default = {}
}

# Database subnet variables

variable "database_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.database_subnet_cidrs) == 2
      error_message = "Please provide 2 valid database subnet CIDR"
    }
}


variable "database_subnet_cidrs_tags" {
  type = map
  default = {}
}

# NAT gate way
variable "nat_gateway_tags" {
    type = map
    default = {}
  
}

# public route table

variable "public_route_table_tags" {
  type = map
  default = {}
}

# private route table

variable "private_route_table_tags" {
  type = map
  default = {}
}

# database route table

variable "database_route_table_tags" {
  type = map
  default = {}
}

# public route

resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.ic
}

# private route

resource "aws_route" "private_route_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
}

# database route

resource "aws_route" "database_route_nat" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
}


# public route table association

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public[*].id , count.index)
    route_table_id = aws_route_table.public.id
  
}

# private route table association

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = element(aws_subnet.private[*].id , count.index)
    route_table_id = aws_route_table.private.id
  
}

# database route table association

resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)
    subnet_id = element(aws_subnet.database[*].id , count.index)
    route_table_id = aws_route_table.database.id
  
}
