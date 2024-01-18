# Load Balancer
lb_name                       = "mylb"
lb_internal                   = false
lb_load_balancer_type         = "application"
lb_security_groups            = ["sg-########"]
lb_subnets                    = ["subnet-########", "subnet-########"]
lb_enable_deletion_protection = false
lb_target_port                = 80
lb_protocol                   = "HTTP"
lb_target_type                = "instance" # While using LB with ASG (Auto Scaling Group , the type must be 'instance' not ip)
vpc_id                        = "vpc-########"
lb_listener_port              = 80
lb_listener_protocol          = "HTTP"



target_group_arns     = []
