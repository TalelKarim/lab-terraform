
# terraform apply -var-file="app.tfvars" -var="createdby=e2esa"

# locals {
#   name = "${var.project}-${var.prefix}"
#   tags = {
#     Project     = var.project
#     createdby   = var.createdby
#     CreatedOn   = timestamp()
#     Environment = terraform.workspace
#   }
# }

resource "aws_lb" "my_alb" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_load_balancer_type 
  security_groups    = var.lb_security_group_ids
  subnets            = var.lb_subnets

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
  name     = "my-tg"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}


