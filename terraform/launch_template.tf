resource "aws_launch_template" "web_server" {
  name = "web_server"
  

  # block_device_mappings {
  #   device_name = "/dev/sdf"

  #   ebs {
  #     volume_size = 8
  #   }
  # }
  update_default_version = true

#   capacity_reservation_specification {
#     capacity_reservation_preference = "open"
#   }

#   cpu_options {
#     core_count       = 4
#     threads_per_core = 2
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   disable_api_stop        = true
#   disable_api_termination = true

  # ebs_optimized = true

#   elastic_gpu_specifications {
#     type = "test"
#   }

#   elastic_inference_accelerator {
#     type = "eia1.medium"
#   }

  iam_instance_profile {
    name = local.role_name
  }

  image_id = "ami-053b0d53c279acc90"

#   instance_initiated_shutdown_behavior = "terminate"

#   instance_market_options {
#     market_type = "spot"
#   }

  instance_type = "t2.micro"

#   kernel_id = "test"

  key_name = "atul_m"

#   license_specification {
#     license_configuration_arn = "arn:aws:license-manager:eu-west-1:123456789012:license-configuration:lic-0123456789abcdef0123456789abcdef"
#   }

#   metadata_options {
#     http_endpoint               = "enabled"
#     http_tokens                 = "required"
#     http_put_response_hop_limit = 1
#     instance_metadata_tags      = "enabled"
#   }

#   monitoring {
#     enabled = true
#   }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ module.web-server-sg.security_group_id ]
  }

#   placement {
#     availability_zone = "us-west-2a"
#   }

#   ram_disk_id = "test"

  # vpc_security_group_ids = [module.web-server-sg.security_group_id]

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name = "test"
#     }
#   }

  user_data = filebase64("${path.module}/userdata.sh")
}