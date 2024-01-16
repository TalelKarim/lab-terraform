# Configure the AWS Provider

provider "aws" {
  region = "eu-west-3"
}




# Create a VPC named "main"
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # Set your desired CIDR block for the VPC

  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "main"
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



# Create three subnets in different availability zones
resource "aws_subnet" "public_subnets" {
  count= length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet ${count.index + 1}"
  }
}


# create an internet gateway
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Project VPC IG"
 }
}

#create a second route table
resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

#associate the route tables wuth the created subnets 
resource "aws_route_table_association" "public_subnet_asso" {
 count = 3
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
}

# Create a security group
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id
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
}



# Create Ubuntu EC2 instances in each subnet using the same key pair  and with the use of modules 
module "instances" {
  count = 3
  source         = "./modules/ec2_instance"
  instance_name  = "tf-instance-${var.prefixes[count.index]}"
  subnet_id      = aws_subnet.public_subnets[count.index].id
  key_name       = aws_key_pair.key_pair.key_name
  sg_id          = aws_security_group.instance_sg.id
  user_data_file = "user_data.sh"
}

# module "instance_b" {
#   source         = "./modules/ec2_instance"
#   instance_name  = "tf-instance-b"
#   subnet_id      = aws_subnet.subnet_b.id
#   key_name       = aws_key_pair.key_pair.key_name
#   sg_id          = aws_security_group.instance_sg.id
#   user_data_file = "user_data.sh"
# }

# module "instance_c" {
#   source         = "./modules/ec2_instance"
#   instance_name  = "tf-instance-c"
#   subnet_id      = aws_subnet.subnet_c.id
#   key_name       = aws_key_pair.key_pair.key_name
#   sg_id          = aws_security_group.instance_sg.id
#   user_data_file = "user_data.sh"
# }