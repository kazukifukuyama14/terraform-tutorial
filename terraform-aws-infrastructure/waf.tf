# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-${var.environment}-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # AWS Managed Rule - Core Rule Set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rule - Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rule - SQL Injection
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # Rate Limiting Rule
  rule {
    name     = "RateLimitRule"
    priority = 4

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.waf_rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  # IP Whitelist Rule (if enabled)
  dynamic "rule" {
    for_each = var.enable_ip_whitelist ? [1] : []
    content {
      name     = "IPWhitelistRule"
      priority = 5

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPWhitelistRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  # IP Blacklist Rule (if enabled)
  dynamic "rule" {
    for_each = var.enable_ip_blacklist ? [1] : []
    content {
      name     = "IPBlacklistRule"
      priority = 6

      action {
        block {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blacklist[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "IPBlacklistRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  # Geo Blocking Rule (if enabled)
  dynamic "rule" {
    for_each = length(var.blocked_countries) > 0 ? [1] : []
    content {
      name     = "GeoBlockingRule"
      priority = 7

      action {
        block {}
      }

      statement {
        geo_match_statement {
          country_codes = var.blocked_countries
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "GeoBlockingRuleMetric"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}${var.environment}WebACL"
    sampled_requests_enabled   = true
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-web-acl"
    Environment = var.environment
  }
}

# IP Whitelist Set
resource "aws_wafv2_ip_set" "whitelist" {
  count              = var.enable_ip_whitelist ? 1 : 0
  name               = "${var.project_name}-${var.environment}-ip-whitelist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.whitelist_ips

  tags = {
    Name        = "${var.project_name}-${var.environment}-ip-whitelist"
    Environment = var.environment
  }
}

# IP Blacklist Set
resource "aws_wafv2_ip_set" "blacklist" {
  count              = var.enable_ip_blacklist ? 1 : 0
  name               = "${var.project_name}-${var.environment}-ip-blacklist"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.blacklist_ips

  tags = {
    Name        = "${var.project_name}-${var.environment}-ip-blacklist"
    Environment = var.environment
  }
}

# WAF Association with ALB
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# WAF Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count                   = var.enable_waf_logging ? 1 : 0
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs[0].arn]

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }
}

# CloudWatch Log Group for WAF
resource "aws_cloudwatch_log_group" "waf_logs" {
  count             = var.enable_waf_logging ? 1 : 0
  name              = "/aws/wafv2/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.environment}-waf-logs"
    Environment = var.environment
  }
}
