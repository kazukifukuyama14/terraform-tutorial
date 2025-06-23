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
