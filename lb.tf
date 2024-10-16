resource "aws_lb_target_group" "tg" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.tcb_blog_vpc.id
  target_type = "ip"  # Alteração para ECS (Fargate usa IP)

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "my-target-group"
  }
}


resource "aws_lb" "alb" {
  name               = "__VPC_ALB__"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_ssh_http.id]
  subnets            = [for s in aws_subnet.public : s.id]

  enable_deletion_protection = false

  tags = {
    Name = "__VPC_ALB__"
  }
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  depends_on = [aws_lb.alb]
}

resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.cert.arn

  depends_on = [aws_acm_certificate_validation.cert_validation]
}


resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.existing_zone.id
  name    = "__R53_DOMAIN_NAME__"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }

  depends_on = [aws_lb.alb]
}
