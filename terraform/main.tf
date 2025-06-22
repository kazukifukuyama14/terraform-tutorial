# ----------------------------
# Terraform 基本設定
# ----------------------------
terraform {
  # Terraform バージョン指定(今回は0.13以上)
  required_version = ">=0.13"
  # プロバイダーのバージョン指定
  required_providers {
    aws = {
      # AWSプロバイダーのバージョン指定
      source = "hashicorp/aws"
      # バージョン指定(今回は3.0以上)
      version = "~> 3.0"
    }
  }
}

# ----------------------------
# プロバイダーの指定
# ----------------------------
# AWSプロバイダーの指定
provider "aws" {
  # AWSリージョンの指定
  region = "ap-northeast-1"
}

# ----------------------------
# 変数の指定
# ----------------------------
# projectの変数指定
variable "project" {
  # 変数の型指定
  type = string
}

# environmentの変数指定
variable "environment" {
  type = string
}
