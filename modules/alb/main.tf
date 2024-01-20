
resource "aws_lb" "my_alb" {
  name                             = var.lb_name
  internal                         = var.lb_internal
  load_balancer_type               = var.lb_load_balancer_type
  subnets                          = var.lb_subnets
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket  = var.input_bucket_name
    prefix  = var.lb_name
    enabled = true
  }
  tags = {
    Environment = "demo-tf"
  }
}

resource "aws_lb_listener" "my_lb_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_lb_target_group" "my_tg" {
  name        = "my-tg"
  target_type = "instance"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}


output "lb_target_group_arn" {
  value = aws_lb_target_group.my_tg.arn
}