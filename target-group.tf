resource "aws_lb_target_group" "eatfit_backend_tg" {
  name     = "eatfit-backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0ba36a518fb0a35d3"

  target_type = "instance"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "eatfit-backend-tg"
  }
}

resource "aws_lb_target_group_attachment" "eatfit_backend_instance" {
  target_group_arn = aws_lb_target_group.eatfit_backend_tg.arn
  target_id        = aws_instance.eatfit-backend.id
  port             = 8080
}

resource "aws_lb_target_group" "eatfit_ai_tg" {
  name     = "eatfit-ai-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "vpc-0ba36a518fb0a35d3"

  target_type = "instance"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "eatfit-ai-tg"
  }
}

resource "aws_lb_target_group_attachment" "eatfit_ai_instance" {
  target_group_arn = aws_lb_target_group.eatfit_ai_tg.arn
  target_id        = "i-0d56a88c5bacf9bb9"
  port             = 8000
}
