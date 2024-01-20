

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}



resource "aws_lb" "my_alb" {
  name                             = var.lb_name
  internal                         = var.lb_internal
  load_balancer_type               = var.lb_load_balancer_type
  subnets                          = var.lb_subnets
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.alb_sg.id]

  access_logs {
    bucket  = var.input_bucket_name
    prefix  = "${var.lb_name}/AWSLogs/${var.account_id}/*"
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