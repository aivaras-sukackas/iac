resource "aws_ecs_capacity_provider" "capacity-prov" {
  name = "${var.environment}-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.autoscaling.this_autoscaling_group_arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-cluster"
  capacity_providers = ["${var.environment}-cp"]
  depends_on = [
    aws_ecs_capacity_provider.capacity-prov,
  ]
}