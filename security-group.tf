resource "aws_security_group" "eatfit_backend_sg" {
  name   = "eatfit-backend-sg"
  vpc_id = "vpc-0ba36a518fb0a35d3"

  ingress {
    description = "SSH from Bastion Host"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description     = "HTTP from ALB SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.eatfit_alb_sg.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eatfit-backend-sg"
  }
}

resource "aws_security_group" "eatfit_alb_sg" {
  name        = "eatfit-alb-sg"
  description = "Allow inbound HTTP/HTTPS to ALB"
  vpc_id      = "vpc-0ba36a518fb0a35d3"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eatfit-alb-sg"
  }
}
