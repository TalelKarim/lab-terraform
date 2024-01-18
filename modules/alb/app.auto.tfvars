
# Load Balancer
lb_name                       = "mylb"
lb_internal                   = false
lb_load_balancer_type         = "application"
lb_enable_deletion_protection = false
lb_target_port                = 80
lb_protocol                   = "HTTP"
lb_target_type                = "instance"
lb_listener_port              = 80
lb_listener_protocol          = "HTTP"