resource "aws_ecs_task_definition" "service" {
  family                = "mario-${var.environment}"
  container_definitions = file("mario.json")

}