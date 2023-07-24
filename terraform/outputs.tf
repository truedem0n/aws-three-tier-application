output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "application_subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.application_subnet : s.cidr_block]
}

output "db_endpoint" {
    value = module.db.db_instance_endpoint
}

output "db_instance_master_user_secret_arn" {
    value = module.db.db_instance_master_user_secret_arn
}

output "web_server_elb_dns_name" {
  value = aws_lb.web_server.dns_name
}

output "cdn_domain_name" {
  value = module.cdn.cloudfront_distribution_domain_name
}