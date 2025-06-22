resource "aws_lb" "eatfit_alb" {
  name               = "eatfit-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.eatfit_alb_sg.id]
  subnets            = ["subnet-00389885a11689564", "subnet-041492e3c727632cf"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.eatfit_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = "arn:aws:acm:ap-northeast-2:248189949085:certificate/21096eb4-f66f-4143-8aba-24bbe3334db2"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eatfit_backend_tg.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.eatfit_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
