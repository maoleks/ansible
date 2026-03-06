# Создаём Security Group для SSH и HTTP
resource "aws_security_group" "web_sg" {
  name        = "allow-my-ip"
  description = "Allow SSH and HTTP from my IP"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<YOUR_PUBLIC_IP>/32"]  # <-- замени на свой IP
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
  ami                    = "ami-0c02fb55956c7d316" # Ubuntu 22.04 eu-central-1
  instance_type           = "t2.micro"
  key_name                = "<YOUR_KEY_PAIR>"      # ключ который есть в AWS
  security_groups         = [aws_security_group.web_sg.name]

  tags = {
    Name = "terraform-web-server"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
