variable "vpc_name" {
    description = "vpc's name, e.g. main-vpc"
}

variable "vpc_cidr_block" {
    description = "vpc's cidr block, e.g. 10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
    type = "list"
    description = "public subnets' cidr blocks, e.g. [\"10.0.0.0/24\", \"10.0.1.0/24\"]"
}

variable "public_subnet_availability_zones" {
    type = "list"
    description = "public subnets' cidr blocks, e.g. [\"ap-northeast-1a\",\"ap-northeast-1c\"]"
}

variable "private_subnet_cidr_blocks" {
    type = "list"
    description = "private subnets' cidr blocks, e.g. [\"10.0.2.0/24\", \"10.0.3.0/24\"]"
}

variable "private_subnet_availability_zones" {
    type = "list"
    description = "public subnets' cidr blocks, e.g. [\"ap-northeast-1a\",\"ap-northeast-1c\"]"
}
