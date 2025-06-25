# EC2インスタンス用のIAMロール
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  # EC2サービスがこのロールを引き受けることを許可
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-role"
    Environment = var.environment
  }
}

# EC2インスタンスプロファイル（EC2にIAMロールをアタッチするために必要）
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2からS3へのアクセス権限ポリシー
resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "${var.project_name}-${var.environment}-ec2-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        # コンテンツバケット内のオブジェクトに対する読み書き権限
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.content.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        # コンテンツバケットの一覧表示権限
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.content.arn
        ]
      },
      {
        Effect = "Allow"
        # ログバケットへの書き込み権限
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.logs.arn}/*"
        ]
      }
    ]
  })
}

# EC2からCloudWatch Logsへのアクセス権限ポリシー
resource "aws_iam_role_policy" "ec2_cloudwatch_policy" {
  name = "${var.project_name}-${var.environment}-ec2-cloudwatch-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        # CloudWatch Logsへのログ送信権限
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Systems Manager（Session Manager）用のマネージドポリシーをアタッチ
# これによりSSH不要でEC2にアクセス可能
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# RDS Enhanced Monitoring用のIAMロール
resource "aws_iam_role" "rds_enhanced_monitoring" {
  name = "${var.project_name}-${var.environment}-rds-enhanced-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-enhanced-monitoring-role"
    Environment = var.environment
  }
}

# RDS Enhanced Monitoring用のポリシーアタッチメント
resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# 既存のEC2ロールポリシーに追加
resource "aws_iam_role_policy" "ec2_ssm_policy" {
  name = "${var.project_name}-ec2-ssm-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [
          "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/ssm"
        ]
      }
    ]
  })
}

# データソースを追加（既存のファイルに追加）
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
