resource "aws_ecs_service" "mario" {
  name            = "mario-${var.environment}-svc"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "mario"
    container_port   = 8080
  }
  depends_on = [aws_lb.alb]
}