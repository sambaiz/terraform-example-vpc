terraform {
  backend "s3" {
    bucket = "<bucket_name>"
    key    = "state"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "test-vpc" {
  source                            = "./vpc"
  vpc_name                          = "test-vpc"
  vpc_cidr_block                    = "10.0.0.0/16"
  public_subnet_cidr_blocks         = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnet_availability_zones  = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnet_cidr_blocks        = ["10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_availability_zones = ["ap-northeast-1a", "ap-northeast-1c"]
}

