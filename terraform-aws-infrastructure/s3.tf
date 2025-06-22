# バケット名をユニークにするためのランダム文字列
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 静的・動的コンテンツ配信用のS3バケット
resource "aws_s3_bucket" "content" {
  bucket = "${var.project_name}-${var.environment}-content-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-content"
    Environment = var.environment
  }
}

# コンテンツバケットのバージョニング設定
resource "aws_s3_bucket_versioning" "content" {
  bucket = aws_s3_bucket.content.id
  versioning_configuration {
    status = "Enabled"
  }
}

# コンテンツバケットの暗号化設定
resource "aws_s3_bucket_server_side_encryption_configuration" "content" {
  bucket = aws_s3_bucket.content.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# コンテンツバケットのパブリックアクセス制限
resource "aws_s3_bucket_public_access_block" "content" {
  bucket = aws_s3_bucket.content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# アプリケーションログ保存用のS3バケット
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-${var.environment}-logs-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-logs"
    Environment = var.environment
  }
}

# ログバケットのバージョニング設定
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ログバケットの暗号化設定
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ログバケットのパブリックアクセス制限
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ログバケットのライフサイクル設定（90日で削除）
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "log_lifecycle"
    status = "Enabled"

    # すべてのオブジェクトに適用するためのフィルター
    filter {
      prefix = ""
    }

    # 現在バージョンのオブジェクトを90日で削除
    expiration {
      days = 90
    }

    # 非現在バージョンのオブジェクトを30日で削除
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
