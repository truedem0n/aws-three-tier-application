resource "aws_placement_group" "web_server" {
  name     = "web_server"
  strategy = "spread"
}

resource "aws_autoscaling_group" "web_server" {
  name                      = "web_server_asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 1
  target_group_arns         = [aws_lb_target_group.web_server.id]
  depends_on = [ module.vpc, module.db ]
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
  force_delete              = true
  placement_group           = aws_placement_group.web_server.id
  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
  vpc_zone_identifier       = module.vpc.public_subnets

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#     notification_metadata = jsonencode({
#       foo = "bar"
#     })

#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

#   tag {
#     key                 = "foo"
#     value               = "bar"
#     propagate_at_launch = true
#   }

  timeouts {
    delete = "15m"
  }

#   tag {
#     key                 = "lorem"
#     value               = "ipsum"
#     propagate_at_launch = false
#   }
}
