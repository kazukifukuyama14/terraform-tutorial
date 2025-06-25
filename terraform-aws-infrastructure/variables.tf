# プロジェクト名
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "myapp"
}

# 環境名
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# AWSリージョンs
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

# アベイラビリティゾーン
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

# VPCのCIDRブロック
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# パブリックサブネットのCIDRブロック
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# プライベートサブネットのCIDRブロック
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# データベースサブネットのCIDRブロック
variable "db_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.100.0/24", "10.0.200.0/24"]
}

# EC2インスタンスのタイプ
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Auto Scaling Groupの最小サイズ
variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

# Auto Scaling Groupの最大サイズ
variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

# Auto Scaling Groupの希望サイズ
variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

# RDSインスタンスのクラス
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

# RDSデータベース名
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "myappdb"
}

# RDSデータベースユーザー名
variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

# 通信要件追加

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

# EC2情報を追加
variable "key_pair_name" {
  description = "EC2インスタンス用のキーペア名"
  type        = string
  default     = "" # 空の場合はキーペアなしで起動
}

variable "root_volume_size" {
  description = "ルートボリュームのサイズ（GB）"
  type        = number
  default     = 20
}

variable "min_instances" {
  description = "Auto Scaling Groupの最小インスタンス数"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Auto Scaling Groupの最大インスタンス数"
  type        = number
  default     = 4
}

variable "desired_instances" {
  description = "Auto Scaling Groupの希望インスタンス数"
  type        = number
  default     = 2
}

# 証明書、ドメイン設定追加
variable "ssl_certificate_arn" {
  description = "SSL証明書のARN（HTTPS使用時）"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "ドメイン名（Route53使用時）"
  type        = string
  default     = ""
}

# Route53関連の変数
variable "enable_private_dns" {
  description = "プライベートDNSを有効にするかどうか"
  type        = bool
  default     = false
}

variable "enable_health_check" {
  description = "Route53ヘルスチェックを有効にするかどうか"
  type        = bool
  default     = false
}


# RDS関連の変数
variable "db_engine_version" {
  description = "RDSエンジンバージョン"
  type        = string
  default     = "8.0.35"
}

variable "db_allocated_storage" {
  description = "RDS初期ストレージサイズ（GB）"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "RDS最大ストレージサイズ（GB）"
  type        = number
  default     = 100
}

variable "db_password" {
  description = "データベースパスワード"
  type        = string
  sensitive   = true
}

variable "db_backup_retention_period" {
  description = "バックアップ保持期間（日）"
  type        = number
  default     = 7
}

variable "create_read_replica" {
  description = "読み取りレプリカを作成するかどうか"
  type        = bool
  default     = false
}

variable "db_replica_instance_class" {
  description = "読み取りレプリカのインスタンスクラス"
  type        = string
  default     = "db.t3.micro"
}

# CloudWatch関連の変数
variable "log_retention_days" {
  description = "CloudWatchログの保持期間（日）"
  type        = number
  default     = 14
}

variable "alert_email" {
  description = "アラート通知用のメールアドレス"
  type        = string
  default     = ""
}

# リージョン
variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

# WAF関連の変数
variable "waf_rate_limit" {
  description = "WAFレート制限（5分間のリクエスト数）"
  type        = number
  default     = 2000
}

variable "enable_ip_whitelist" {
  description = "IPホワイトリストを有効にするかどうか"
  type        = bool
  default     = false
}

variable "enable_ip_blacklist" {
  description = "IPブラックリストを有効にするかどうか"
  type        = bool
  default     = false
}

variable "whitelist_ips" {
  description = "ホワイトリストIP（CIDR形式）"
  type        = list(string)
  default     = []
}

variable "blacklist_ips" {
  description = "ブラックリストIP（CIDR形式）"
  type        = list(string)
  default     = []
}

variable "blocked_countries" {
  description = "ブロックする国コード（ISO 3166-1 alpha-2）"
  type        = list(string)
  default     = []
}

variable "enable_waf_logging" {
  description = "WAFログを有効にするかどうか"
  type        = bool
  default     = false
}

# アプリケーション設定関連の変数
variable "app_log_level" {
  description = "アプリケーションのログレベル"
  type        = string
  default     = "INFO"

  # 有効な値: DEBUG, INFO, WARN, ERROR
  validation {
    condition     = contains(["DEBUG", "INFO", "WARN", "ERROR"], var.app_log_level)
    error_message = "ログレベルは DEBUG, INFO, WARN, ERROR のいずれかを指定してください。"
  }
}


# EC2インスタンス設定関連の変数
variable "key_name" {
  description = "EC2インスタンスに使用するキーペア名"
  type        = string
  default     = null
}

variable "enable_ssh_access" {
  description = "SSH接続を有効にするかどうか"
  type        = bool
  default     = true
}

variable "api_key" {
  description = "外部サービス用のAPIキー"
  type        = string
  sensitive   = true
  default     = ""
}

variable "jwt_secret" {
  description = "JWT秘密鍵"
  type        = string
  sensitive   = true
  default     = ""
}

# SSM Parameter Store 設定関連の変数

variable "ssm_parameter_tier" {
  description = "SSMパラメータのティア設定"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Advanced"], var.ssm_parameter_tier)
    error_message = "SSMパラメータティアは Standard または Advanced を指定してください。"
  }
}

variable "enable_ssm_encryption" {
  description = "SSMパラメータの暗号化を有効にするかどうか"
  type        = bool
  default     = true
}

variable "parameter_store_kms_key_id" {
  description = "SSMパラメータストア用のKMSキーID（オプション）"
  type        = string
  default     = null
}

# 環境固有の設定変数
variable "backup_retention_days" {
  description = "バックアップの保持日数"
  type        = number
  default     = 7
}

variable "monitoring_enabled" {
  description = "詳細監視を有効にするかどうか"
  type        = bool
  default     = true
}
