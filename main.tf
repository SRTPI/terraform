terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
provider "aws" {
access_key = var.AWS_ACCESS_KEY
secret_key = var.AWS_SECRET_KEY
region = "ap-south-1"
}
resource "aws_instance" "myec2" {
  ami           = "ami-08fe36427228eddc4"
  instance_type = "t2.micro"
  vpc_security_group_ids=[aws_security_group.web-sg.id]
  key_name="linux"  tags={
 Name="web-server"
}
user_data= <<-EOF
#!/bin/bash
yum install httpd -y
service httpd start
cd /var/www/html
touch index.html
echo "hello from Terraform" > index.html
EOF
}
resource "aws_security_group" "web-sg" {
 name="web-sg"
ingress {
 from_port=80
 to_port=80
protocol="tcp"
cidr_blocks= ["0.0.0.0/0"]
}  ingress {
 from_port=22
 to_port=22
protocol="tcp"
cidr_blocks= ["0.0.0.0/0"]
}
egress {
 from_port=0
 to_port=0
protocol="-1"
cidr_blocks= ["0.0.0.0/0"]
}
}
