# 最新のAmazon Linux 2 AMIを取得
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2インスタンス起動時に実行するユーザーデータスクリプト
locals {
  user_data = base64encode(<<-EOF
    #!/bin/bash
    # システムアップデート
    yum update -y

    # 基本パッケージのインストール
    yum install -y httpd mysql git

    # CloudWatch Agentのインストール
    yum install -y amazon-cloudwatch-agent

    # Apacheの起動と自動起動設定
    systemctl start httpd
    systemctl enable httpd

    # 簡単なHTMLページを作成
    echo "<h1>Hello from ${var.project_name}-${var.environment}</h1>" > /var/www/html/index.html
    echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
    echo "<p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>" >> /var/www/html/index.html

    # SSM Agentの起動（Amazon Linux 2にはプリインストール済み）
    systemctl start amazon-ssm-agent
    systemctl enable amazon-ssm-agent
  EOF
  )
}

# Launch Template（起動テンプレート）
resource "aws_launch_template" "app_server" {
  name_prefix   = "${var.project_name}-${var.environment}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  # セキュリティグループの設定
  vpc_security_group_ids = [aws_security_group.app_server.id]

  # IAMインスタンスプロファイルの設定
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  # ユーザーデータ（起動時スクリプト）
  user_data = local.user_data

  # EBSボリューム設定
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  # メタデータオプション（セキュリティ強化）
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # 監視設定
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-app-server"
      Environment = var.environment
      Type        = "application-server"
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-launch-template"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group（オートスケーリンググループ）
resource "aws_autoscaling_group" "app_server" {
  name                      = "${var.project_name}-${var.environment}-asg"
  vpc_zone_identifier       = aws_subnet.private[*].id # 最初のプライベートサブネットのみ使用
  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  # インスタンス数の設定
  min_size         = var.min_instances
  max_size         = var.max_instances
  desired_capacity = var.desired_instances

  # Launch Templateの設定
  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  # インスタンス更新ポリシー
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  # タグ設定
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg"
    propagate_at_launch = false
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Policy - スケールアウト（CPU使用率が70%を超えた場合）
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-${var.environment}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_server.name
}

# CloudWatch Alarm - CPU使用率高（スケールアウト用）
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_server.name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cpu-high-alarm"
    Environment = var.environment
  }
}

# Auto Scaling Policy - スケールイン（CPU使用率が30%を下回った場合）
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-${var.environment}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_server.name
}

# CloudWatch Alarm - CPU使用率低（スケールイン用）
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_server.name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cpu-low-alarm"
    Environment = var.environment
  }
}

# Launch Templateのuser_dataセクションを更新
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-app-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # キーペアの条件付き設定
  key_name = var.enable_ssh_access && var.key_name != null ? var.key_name : null

  # 正しいセキュリティグループ名に修正
  vpc_security_group_ids = [aws_security_group.app_server.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
    region       = data.aws_region.current.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-app-server"
      Environment = var.environment
      Project     = var.project_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# 踏み台サーバ用のインスタンス（SSH接続が必要な場合）
resource "aws_instance" "bastion" {
  count                  = var.enable_ssh_access && var.key_name != null ? 1 : 0
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name        = "${var.project_name}-bastion"
    Environment = var.environment
    Project     = var.project_name
  }
}
