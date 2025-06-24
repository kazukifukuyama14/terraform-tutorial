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

# 現在のリージョンを取得するデータソース
data "aws_region" "current" {}

# CloudWatch関連の出力
output "cloudwatch_dashboard_url" {
  description = "CloudWatchダッシュボードのURL"
  value       = "https://${data.aws_region.current.name}.console.aws.amazon.com/cloudwatch/home?region=${data.aws_region.current.name}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

output "sns_topic_arn" {
  description = "SNSトピックのARN"
  value       = aws_sns_topic.alerts.arn
}
