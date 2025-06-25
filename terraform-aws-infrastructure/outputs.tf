# ALBのDNS名を出力
output "alb_dns_name" {
  description = "Application Load BalancerのDNS名"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Application Load BalancerのZone ID"
  value       = aws_lb.main.zone_id
}

output "alb_arn" {
  description = "Application Load BalancerのARN"
  value       = aws_lb.main.arn
}

# VPC情報の出力
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "パブリックサブネットのID一覧"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "プライベートサブネットのID一覧"
  value       = aws_subnet.private[*].id
}

# RDS関連の出力
output "rds_endpoint" {
  description = "RDSエンドポイント"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDSポート番号"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "データベース名"
  value       = aws_db_instance.main.db_name
}

# CloudWatch関連の出力
output "cloudwatch_dashboard_url" {
  description = "CloudWatchダッシュボードのURL"
  value       = "https://${data.aws_region.current.name}.console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.name}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "sns_topic_arn" {
  description = "SNSトピックのARN"
  value       = aws_sns_topic.alerts.arn
}
# Route53関連の出力
output "hosted_zone_id" {
  description = "Route53ホストゾーンID"
  value       = aws_route53_zone.main.zone_id
}

output "hosted_zone_name_servers" {
  description = "Route53ネームサーバー"
  value       = aws_route53_zone.main.name_servers
}

output "domain_name" {
  description = "設定されたドメイン名"
  value       = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"
}

output "website_url" {
  description = "WebサイトのURL"
  value       = "http://${var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"}"
}

output "private_hosted_zone_id" {
  description = "プライベートホストゾーンID"
  value       = var.enable_private_dns ? aws_route53_zone.private[0].zone_id : null
}

# WAF関連の出力
output "waf_web_acl_id" {
  description = "WAF Web ACL ID"
  value       = aws_wafv2_web_acl.main.id
}

output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}

output "waf_web_acl_capacity" {
  description = "WAF Web ACL Capacity"
  value       = aws_wafv2_web_acl.main.capacity
}

# SSMパラメータの出力
output "ssm_parameters" {
  description = "SSMパラメータ名一覧"
  value = {
    rds_master_password = aws_ssm_parameter.rds_master_password.name
    rds_endpoint        = aws_ssm_parameter.rds_endpoint.name
    database_url        = aws_ssm_parameter.database_url.name
    app_environment     = aws_ssm_parameter.app_environment.name
    app_log_level       = aws_ssm_parameter.app_log_level.name
    s3_static_bucket    = aws_ssm_parameter.s3_static_bucket.name
    api_key             = aws_ssm_parameter.api_key.name
    jwt_secret          = aws_ssm_parameter.jwt_secret.name
  }
}

# EC2キーペア情報の出力
output "ec2_key_name" {
  description = "terraform-tutorial-key"
  value       = var.key_name
}

# SSH接続情報の出力
output "ssh_access_info" {
  description = "SSH接続設定情報"
  value = {
    enabled       = var.enable_ssh_access
    allowed_cidrs = var.allowed_ssh_cidr
    key_name      = var.key_name
  }
}

# セキュリティグループ情報の出力
output "security_groups" {
  description = "作成されたセキュリティグループ"
  value = {
    alb        = aws_security_group.alb.id
    nlb        = aws_security_group.nlb.id
    app_server = aws_security_group.app_server.id
    bastion    = aws_security_group.bastion.id
    rds        = aws_security_group.rds.id
  }
}
