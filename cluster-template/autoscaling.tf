module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  name   = "${var.environment}-asg"
  # Launch configuration
  lc_name              = "${var.environment}-lc"
  key_name             = aws_key_pair.generated_key.key_name
  image_id             = var.image_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.autoscaling.id]
  iam_instance_profile = aws_iam_instance_profile.ecs.name
  root_block_device = [
    {
      volume_size = "30"
      volume_type = "gp2"
    },
  ]
  user_data = <<EOT
#!/bin/bash
echo "ECS_CLUSTER=${var.environment}-cluster" >> /etc/ecs/ecs.config
   EOT
  # Auto scaling group
  asg_name                  = "${var.environment}-asg"
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  target_group_arns         = [aws_lb_target_group.alb_tg.arn]
  tags = [
    {
      key                 = "AmazonECSManaged"
      value               = "yes"
      propagate_at_launch = true
    }
  ]
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.environment}-ecs-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "${var.environment}-ecs-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_key_pair" "generated_key" {

  key_name   = "${var.environment}-ecs-key"
  public_key = tls_private_key.example.public_key_openssh

}
/*
output "key" {
  value = tls_private_key.example.private_key_pem
}
*/

