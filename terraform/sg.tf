module "web-server-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-server-sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  #  computed_ingress_with_source_security_group_id = [
  #   {
  #     rule                     = "mysql-tcp"
  #     source_security_group_id = module.http_sg.security_group_id
  #   }
  # ]
  # number_of_computed_ingress_with_source_security_group_id = 1

  ingress_cidr_blocks      = local.public_subnets
  ingress_rules            = ["https-443-tcp", "http-80-tcp"]
  egress_cidr_blocks       = ["0.0.0.0/0"]
  egress_rules             = ["https-443-tcp", "http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "allow ssh"
      cidr_blocks = "${local.my_ip}/32"
    },
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      description = "allow ssh"
      cidr_blocks = "${local.my_ip}/32"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "allow ssh"
      cidr_blocks = local.vpc_cidr
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "allow mysql"
      cidr_blocks = local.vpc_cidr
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "allow ssh"
      cidr_blocks = local.vpc_cidr
    },
  ]
}


module "lb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "lb-sg"
  vpc_id      = module.vpc.vpc_id

  #  computed_ingress_with_source_security_group_id = [
  #   {
  #     rule                     = "mysql-tcp"
  #     source_security_group_id = module.http_sg.security_group_id
  #   }
  # ]
  # number_of_computed_ingress_with_source_security_group_id = 1

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp", "http-80-tcp"]
  egress_cidr_blocks       = local.application_subnets
  egress_rules             = ["https-443-tcp", "http-80-tcp"]
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     description = "allow ssh"
  #     cidr_blocks = "${local.my_ip}/32"
  #   },
  # ]
  egress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "allow mysql"
      cidr_blocks = local.vpc_cidr
    },
  ]
}


module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-sg"
  vpc_id      = module.vpc.vpc_id

  #  computed_ingress_with_source_security_group_id = [
  #   {
  #     rule                     = "mysql-tcp"
  #     source_security_group_id = module.http_sg.security_group_id
  #   }
  # ]
  # number_of_computed_ingress_with_source_security_group_id = 1

  ingress_cidr_blocks      = local.application_subnets
  ingress_rules            = ["mysql-tcp"]
  # egress_cidr_blocks       = [local.vpc_cidr]
  # egress_rules             = ["https-443-tcp", "http-80-tcp"]
  # ingress_with_cidr_blocks = [
  #   {
  #     from_port   = 22
  #     to_port     = 22
  #     protocol    = "tcp"
  #     description = "allow ssh"
  #     cidr_blocks = "${local.my_ip}/32"
  #   },
  # ]
}