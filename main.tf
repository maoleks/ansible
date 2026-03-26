# Получаем default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "allow-my-ip-2"
  description = "Allow SSH from my IP and HTTP from anywhere"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["89.245.181.158/32"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Ubuntu
resource "aws_instance" "web" {
  ami                         = "ami-027066fb16fc18634"  # Ubuntu 22.04 LTS в eu-central-1
  instance_type                = "t2.micro"
  key_name                     = "ansible-key"
  subnet_id                    = "subnet-0da73cd1c81f661b9"  # твоя публичная подсеть
  associate_public_ip_address  = true
  security_groups              = ["sg-0872af5183de3ad83"]

  tags = {
    Name = "terraform-web-server"
  }
}

# Output
output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
