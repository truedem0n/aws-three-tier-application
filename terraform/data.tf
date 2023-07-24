data "aws_subnets" "application_subnets" {
  filter {
    name   = "cidrBlock"
    values = local.application_subnets
  }
}

data "aws_subnet" "application_subnet" {
  for_each = toset(data.aws_subnets.application_subnets.ids)
  id       = each.value
}

data "aws_subnets" "database_subnets" {
  filter {
    name   = "cidrBlock"
    values = local.database_subnets
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "cidrBlock"
    values = local.public_subnets
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}