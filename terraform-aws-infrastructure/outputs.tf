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
