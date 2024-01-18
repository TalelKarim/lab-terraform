

# Use the aws_ami data source to find the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Create an Elastic IP
resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}


# Attach the security group to the EC2 instance
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  user_data              = file(var.user_data_file)
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = var.instance_name
  }
}

# Associate Elastic IP with the EC2 instance
resource "aws_eip_association" "elastic_ip_association" {
  instance_id   = aws_instance.ec2_instance.id
  allocation_id = aws_eip.elastic_ip.id
}



#Create a launch template for the autoscaling group 
resource "aws_launch_template" "this" {
  name          = "${var.project}-tpl"
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = file(var.user_data_file)
}


resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = var.lb_subnets
  target_group_arns         = "ffff"
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
  threshold           = "30" # The alarm will be triggered and a new instance will be created if CPU utilisation is more than thirty
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
