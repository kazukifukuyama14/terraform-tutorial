# Application Load Balancer（ALB）
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  # 削除保護（本番環境では有効にすることを推奨）
  enable_deletion_protection = false

  # アクセスログの設定
  access_logs {
    bucket  = aws_s3_bucket.logs.id
    prefix  = "alb-access-logs"
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# ALBターゲットグループ（アプリケーションサーバー用）
resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-${var.environment}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  # ヘルスチェック設定
  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  # ターゲットの登録解除時の待機時間
  deregistration_delay = 300

  # スティッキーセッション（必要に応じて有効化）
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = false
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-target-group"
    Environment = var.environment
  }
}

# ALBリスナー（HTTP:80）
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  # HTTPSリダイレクト（SSL証明書がある場合）
  # default_action {
  #   type = "redirect"
  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }

  # 直接ターゲットグループに転送（開発環境用）
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-http-listener"
    Environment = var.environment
  }
}

# ALBリスナー（HTTPS:443）- SSL証明書がある場合に使用
# resource "aws_lb_listener" "app_https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   certificate_arn   = var.ssl_certificate_arn
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
#
#   tags = {
#     Name        = "${var.project_name}-${var.environment}-https-listener"
#     Environment = var.environment
#   }
# }

# ALBリスナールール（パスベースルーティング例）
resource "aws_lb_listener_rule" "app_path_pattern" {
  listener_arn = aws_lb_listener.app_http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    path_pattern {
      values = ["/app/*"]
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-path-rule"
    Environment = var.environment
  }
}

# ALBリスナールール（ホストベースルーティング例）
# resource "aws_lb_listener_rule" "app_host_header" {
#   listener_arn = aws_lb_listener.app_http.arn
#   priority     = 200
#
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
#
#   condition {
#     host_header {
#       values = ["app.${var.domain_name}"]
#     }
#   }
#
#   tags = {
#     Name        = "${var.project_name}-${var.environment}-app-host-rule"
#     Environment = var.environment
#   }
# }
