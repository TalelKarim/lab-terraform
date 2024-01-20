
# Use the aws_ami data source to find the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create an SSH key pair
resource "tls_private_key" "tf_key_pair" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename = "./tf-key-pair.pem" # Change the path as needed
  content  = tls_private_key.tf_key_pair.private_key_pem
}

resource "aws_key_pair" "key_pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.tf_key_pair.public_key_openssh
}

resource "null_resource" "set_file_permissions" {
  provisioner "local-exec" {
    command = "chmod 400 ./tf-key-pair.pem"
  }

  triggers = {
    local_file_content = local_file.private_key.content
  }
}


# Create a security group
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
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


#Create a launch template for the autoscaling group 
resource "aws_launch_template" "this" {
  name          = "${var.project}-tpl"
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name
  user_data     = filebase64(var.user_data_file)
  image_id      = data.aws_ami.ubuntu.id
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg.id]
  }
}


resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type
  target_group_arns         = [var.input_lb_target_group_arn]
  vpc_zone_identifier       = var.vpc_zone_identifier
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUTILIZATION"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "99" # The alarm will be triggered and a new instance will be created if CPU utilisation is more than thirty
  dimensions = {
    "AutoscalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUTILIZATION"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # The alarm will be triggered and a new instance will be created if CPU utilisation is more than thirty
  dimensions = {
    "AutoscalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}
