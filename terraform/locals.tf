locals {
  my_ip = chomp(data.http.myip.response_body)
# VPC
    vpc_cidr = "10.0.0.0/16"
    azs = ["us-east-1a", "us-east-1b"]
  # subnets
    private_subnets = ["10.0.5.0/24", "10.0.6.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
    application_subnets = local.public_subnets
    database_subnets = local.private_subnets

    role_name = "two_tier_app_role"

}