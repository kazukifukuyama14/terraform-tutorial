# RDS関連のパラメータ
resource "aws_ssm_parameter" "rds_master_password" {
  name  = "/${var.project_name}/rds/master-password"
  type  = "SecureString"
  value = var.db_password
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-rds-master-password"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "/${var.project_name}/rds/endpoint"
  type  = "String"
  value = aws_db_instance.main.endpoint
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-rds-endpoint"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "database_url" {
  name  = "/${var.project_name}/app/database-url"
  type  = "SecureString"
  value = "mysql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}:${aws_db_instance.main.port}/${var.db_name}"
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-database-url"
    Environment = var.environment
    Project     = var.project_name
  }
}

# アプリケーション設定用パラメータ
resource "aws_ssm_parameter" "app_environment" {
  name  = "/${var.project_name}/app/environment"
  type  = "String"
  value = var.environment
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-app-environment"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "app_log_level" {
  name  = "/${var.project_name}/app/log-level"
  type  = "String"
  value = var.app_log_level
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-app-log-level"
    Environment = var.environment
    Project     = var.project_name
  }
}

# S3バケット情報（正しいリソース名に修正）
resource "aws_ssm_parameter" "s3_static_bucket" {
  name  = "/${var.project_name}/s3/static-bucket"
  type  = "String"
  value = aws_s3_bucket.content.bucket
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-s3-static-bucket"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "s3_logs_bucket" {
  name  = "/${var.project_name}/s3/logs-bucket"
  type  = "String"
  value = aws_s3_bucket.logs.bucket
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-s3-logs-bucket"
    Environment = var.environment
    Project     = var.project_name
  }
}

# API設定用パラメータ
resource "aws_ssm_parameter" "api_key" {
  name  = "/${var.project_name}/app/api-key"
  type  = "SecureString"
  value = var.api_key
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-api-key"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/${var.project_name}/app/jwt-secret"
  type  = "SecureString"
  value = var.jwt_secret
  tier  = var.ssm_parameter_tier

  tags = {
    Name        = "${var.project_name}-jwt-secret"
    Environment = var.environment
    Project     = var.project_name
  }
}
