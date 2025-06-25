# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name        = "${var.project_name}-${var.environment}-hosted-zone"
    Environment = var.environment
  }
}

# ALB用のAレコード
resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

# WWWサブドメイン用のCNAMEレコード
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.environment == "prod" ? "www.${var.domain_name}" : "www.${var.environment}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"]
}

# ヘルスチェックｓ
resource "aws_route53_health_check" "main" {
  count                           = var.environment == "prod" ? 1 : 0
  fqdn                            = aws_lb.main.dns_name
  port                            = 80
  type                            = "HTTP"
  resource_path                   = "/health"
  failure_threshold               = 3
  request_interval                = 30
  cloudwatch_alarm_region         = data.aws_region.current.name
  cloudwatch_alarm_name           = aws_cloudwatch_metric_alarm.alb_target_response_time.alarm_name
  insufficient_data_health_status = "Unhealthy" # "Failure" → "Unhealthy" に修正

  tags = {
    Name        = "${var.project_name}-${var.environment}-health-check"
    Environment = var.environment
  }
}

# Route53 Resolver（プライベートDNS用）
resource "aws_route53_resolver_endpoint" "inbound" {
  count     = var.enable_private_dns ? 1 : 0
  name      = "${var.project_name}-${var.environment}-resolver-inbound"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.dns_resolver[0].id]

  ip_address {
    subnet_id = aws_subnet.private[0].id
  }

  ip_address {
    subnet_id = aws_subnet.private[1].id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-resolver-inbound"
    Environment = var.environment
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  count     = var.enable_private_dns ? 1 : 0
  name      = "${var.project_name}-${var.environment}-resolver-outbound"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.dns_resolver[0].id]

  ip_address {
    subnet_id = aws_subnet.private[0].id
  }

  ip_address {
    subnet_id = aws_subnet.private[1].id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-resolver-outbound"
    Environment = var.environment
  }
}

# プライベートホストゾーン（VPC内部用）
resource "aws_route53_zone" "private" {
  count = var.enable_private_dns ? 1 : 0
  name  = "internal.${var.domain_name}"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-hosted-zone"
    Environment = var.environment
  }
}

# RDS用のプライベートDNSレコード
resource "aws_route53_record" "rds_private" {
  count   = var.enable_private_dns ? 1 : 0
  zone_id = aws_route53_zone.private[0].zone_id
  name    = "database.internal.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_db_instance.main.endpoint]
}

# アプリケーション用のプライベートDNSレコード
resource "aws_route53_record" "app_private" {
  count   = var.enable_private_dns ? 1 : 0
  zone_id = aws_route53_zone.private[0].zone_id
  name    = "app.internal.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
