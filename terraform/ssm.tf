module "rds_endpoint" {
  source  = "terraform-aws-modules/ssm-parameter/aws"

  name  = "/staging/rds_info"
  value = "${module.db.db_instance_endpoint}~${module.db.db_instance_master_user_secret_arn}"
}