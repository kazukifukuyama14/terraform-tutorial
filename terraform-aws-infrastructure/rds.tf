# RDS用のサブネットグループ
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS用のパラメータグループ（MySQL 8.0用）
resource "aws_db_parameter_group" "main" {
  family = "mysql8.0"
  name   = "${var.project_name}-${var.environment}-db-params"

  # 日本語文字化け対策
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }

  # スロークエリログの有効化
  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  # 一般ログの有効化（開発環境のみ推奨）
  parameter {
    name  = "general_log"
    value = var.environment == "dev" ? "1" : "0"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-parameter-group"
    Environment = var.environment
  }
}

# RDS用のオプショングループ
resource "aws_db_option_group" "main" {
  name                     = "${var.project_name}-${var.environment}-db-options"
  option_group_description = "Option group for ${var.project_name} ${var.environment}"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-option-group"
    Environment = var.environment
  }
}

# RDSインスタンス（MySQL）
resource "aws_db_instance" "main" {
  # 基本設定
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  # ストレージ設定
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type = "gp2"
  storage_encrypted     = true

  # データベース設定
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  # ネットワーク設定
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # パラメータ・オプショングループ
  parameter_group_name = aws_db_parameter_group.main.name
  option_group_name    = aws_db_option_group.main.name

  # バックアップ設定
  backup_retention_period = var.db_backup_retention_period
  backup_window           = "03:00-04:00"         # UTC時間（日本時間12:00-13:00）
  maintenance_window      = "sun:04:00-sun:05:00" # UTC時間（日本時間13:00-14:00）

  # スナップショット設定
  final_snapshot_identifier = "${var.project_name}-${var.environment}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  skip_final_snapshot       = var.environment == "dev" ? true : false
  copy_tags_to_snapshot     = true

  # 削除保護（本番環境では有効にすることを推奨）
  deletion_protection = var.environment == "prod" ? true : false

  # 監視設定
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

  # ログエクスポート設定
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  # 自動マイナーバージョンアップグレード
  auto_minor_version_upgrade = var.environment == "prod" ? false : true

  # Multi-AZ設定（本番環境では有効にすることを推奨）
  multi_az = var.environment == "prod" ? true : false

  tags = {
    Name        = "${var.project_name}-${var.environment}-database"
    Environment = var.environment
  }

  # ライフサイクル設定
  lifecycle {
    prevent_destroy = false # 本番環境ではtrueに設定
  }
}

# RDS読み取りレプリカ（本番環境用）
resource "aws_db_instance" "read_replica" {
  count = var.environment == "prod" && var.create_read_replica ? 1 : 0

  identifier                 = "${var.project_name}-${var.environment}-db-replica"
  replicate_source_db        = aws_db_instance.main.id
  instance_class             = var.db_replica_instance_class
  publicly_accessible        = false
  auto_minor_version_upgrade = false

  # 監視設定
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

  tags = {
    Name        = "${var.project_name}-${var.environment}-database-replica"
    Environment = var.environment
    Type        = "read-replica"
  }
}
