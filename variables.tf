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
