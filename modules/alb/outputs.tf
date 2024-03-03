
output "lb_target_group_arn" {
  value = aws_lb_target_group.my_tg.arn
}

output "load_balancer_dns" {
  value = aws_lb.my_alb.dns_name
}

output "load_balancer_zone_id" {
  value = aws_lb.my_alb.zone_id
}

output "load_balancer_security_group_id" {
  value = aws_security_group.alb_sg.id
}