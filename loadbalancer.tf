resource "aws_security_group" "alb_sg" {
  name        = "alb_http_access"
  description = "allow inbound http traffic to alb"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http from public"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }

  tags = {
    "Name" = "alb_sg"
  }
}

resource "aws_lb_target_group" "app_server_alb_tg" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher             = 200
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "app_server_tg_att" {
  count            = length(aws_instance.app_server)
  target_group_arn = aws_lb_target_group.app_server_alb_tg.arn
  target_id        = element(aws_instance.app_server.*.id, count.index)
  port             = 80
}

resource "aws_lb_listener" "app_server_listener" {
  load_balancer_arn = aws_lb.app_server_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_server_alb_tg.arn
  }
}

resource "aws_lb" "app_server_alb" {
  name               = "app-server-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.private_subnet : subnet.id]

  enable_deletion_protection = false

  tags = {
    Environment = "app_server_alb"
  }
}