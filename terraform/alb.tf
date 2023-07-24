resource "aws_lb" "web_server" {
  name               = "web-server"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.lb_sg.security_group_id]
  subnets            = module.vpc.public_subnets
  depends_on         = [ module.vpc ]
#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = "production"
#   }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_server.arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server.arn
  }
}

resource "aws_lb_target_group" "web_server" {
  name     = "web-server"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}