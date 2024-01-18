variable "instance_name" {
  type        = string
  description = "The name of the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Type of the ec2 instance to provision preferably t2.micro"

}
variable "subnet_id" {
  type        = string
  description = "The subnet ID for the EC2 instance"
}

variable "user_data_file" {
  type        = string
  description = "The path to the user data file"
}

variable "key_name" {
  type        = string
  description = "The name of the key that will be used to ssh to the EC2 instance"
}

variable "sg_id" {
  type        = string
  description = "The id of the security group to be referenced in the ec2 instance"
}

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
