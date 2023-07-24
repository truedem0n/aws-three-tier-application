# TODO
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "two_tier_app_vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

