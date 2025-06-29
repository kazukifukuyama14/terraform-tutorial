# Terraform AWS Infrastructure Tutorial

このプロジェクトは、Terraform で AWS インフラストラクチャを構築し、SSH 接続を設定するチュートリアルです。

## 🏗️ アーキテクチャ

Internet Gateway | Public Subnet (10.0.1.0/24) | Bastion Server | Private Subnet (10.0.10.0/24) | App Server

## 📋 構築されるリソース

- **VPC**: カスタム VPC (10.0.0.0/16)
- **Subnets**:
  - Public Subnet (10.0.1.0/24)
  - Private Subnet (10.0.10.0/24)
- **EC2 Instances**:
  - Bastion Server (Public Subnet)
  - App Server (Private Subnet)
- **Security Groups**: 適切なアクセス制御
- **Key Pair**: SSH 接続用
- **S3 Bucket**: ログ保存用

## 🚀 セットアップ手順

### 前提条件

- AWS CLI 設定済み
- Terraform インストール済み
- SSH クライアント

### 1. リポジトリのクローン

```bash
git clone https://github.com/kazukifukuyama14/terraform-tutorial.git
cd terraform-tutorial/terraform-aws-infrastructure
```

### 2. Terraform の初期化

```bash
terraform init
```

### 3. 設定ファイルの作成

```txt
# terraform.tfvarsファイルを作成（必要に応じて）
# デフォルト設定で動作します
```

### 4. インフラストラクチャの構築

```bash
# 実行計画の確認
terraform plan

# リソースの作成
terraform apply
```

### 5. 接続情報の取得

```bash
# 構築完了後、接続情報を表示
terraform output

```

### 6. SSH 接続の設定

#### SSH Agent の設定

```bash
# SSH Agentに秘密鍵を追加
ssh-add terraform-tutorial-key-new

# 追加確認
ssh-add -l
```

#### SSH 設定ファイルの作成

```bash
# Terraform outputから取得したIPアドレスを使用
BASTION_IP=$(terraform output -raw bastion_public_ip)
APP_SERVER_IP=$(terraform output -raw app_server_private_ip)

# ~/.ssh/configに設定を追加
cat >> ~/.ssh/config << EOF
# Bastion Server
Host bastion
    HostName $BASTION_IP
    User ec2-user
    IdentityFile $(pwd)/terraform-tutorial-key-new
    ForwardAgent yes
    StrictHostKeyChecking no

# App Server (via Bastion)
Host app-server
    HostName $APP_SERVER_IP
    User ec2-user
    ProxyJump bastion
    StrictHostKeyChecking no
EOF

# 権限設定
chmod 600 ~/.ssh/config
```

## 🔗 接続方法

### Bastion サーバーへの接続

```bash
# 設定ファイル使用（推奨）
ssh bastion

# 直接接続
ssh -i terraform-tutorial-key-new ec2-user@$(terraform output -raw bastion_public_ip)
```

### アプリサーバーへの接続

```bash
# 設定ファイル使用（推奨）
ssh app-server

# Agent Forwarding使用
ssh -A -i terraform-tutorial-key-new ec2-user@$(terraform output -raw bastion_public_ip) \
    'ssh ec2-user@$(terraform output -raw app_server_private_ip)'
```

## 🧪 接続テスト

### 基本接続テスト

```bash
# Bastionサーバー
ssh bastion 'echo "✅ Bastion接続成功!"'

# アプリサーバー
ssh app-server 'echo "✅ アプリサーバー接続成功!"'
```

### システム情報確認

```bash
# システム情報
ssh app-server 'whoami && hostname && uptime'

# ネットワーク接続確認
ssh app-server 'ping -c 3 8.8.8.8'

# ディスク使用量
ssh app-server 'df -h'

# 開発環境確認
ssh app-server 'python3 --version && which git && which curl'
```

### 包括的テスト

```bash
# 全機能テスト
echo "=== 🎯 最終確認テスト ==="

echo "1. 基本接続確認:"
ssh bastion 'echo "✅ Bastion OK"'
ssh app-server 'echo "✅ App Server OK"'

echo "2. システム情報:"
ssh bastion 'echo "ホスト名: $(hostname)" && echo "IP: $(hostname -I)"'
ssh app-server 'echo "ホスト名: $(hostname)" && echo "IP: $(hostname -I)"'

echo "3. ネットワーク接続:"
ssh app-server 'ping -c 3 8.8.8.8'

echo "4. 開発環境:"
ssh app-server 'python3 --version && git --version'
```

## 🗑️ リソースの削除

### Terraform での削除

```bash
# リソース削除
terraform destroy
```

### S3 バケット削除エラーの対処

S3 バケットが空でない場合のエラー対処：

```bash
# バケット名を確認
aws s3 ls | grep myapp-dev-logs

# バケット内容を削除
aws s3 rm s3://[BUCKET_NAME] --recursive

# バージョニング対応（必要に応じて）
aws s3api delete-objects \
    --bucket [BUCKET_NAME] \
    --delete "$(aws s3api list-object-versions \
    --bucket [BUCKET_NAME] \
    --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

# 再度terraform destroy実行
terraform destroy
```

### 削除確認

```bash
# 全リソース削除確認
echo "=== 🔍 削除確認 ==="

# S3バケット
aws s3 ls | grep myapp-dev-logs || echo "✅ S3削除済み"

# EC2インスタンス
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name!=`terminated`].[InstanceId,State.Name]' --output table

# VPC
aws ec2 describe-vpcs --query 'Vpcs[?Tags[?Key==`Name` && contains(Value, `tutorial`)]].[VpcId,State]' --output table

# キーペア
aws ec2 describe-key-pairs --query 'KeyPairs[?contains(KeyName, `tutorial`)].[KeyName,KeyType]' --output table
```

## 📁 ファイル構成

```bash
terraform-aws-infrastructure/
├── README.md                    # このファイル
├── main.tf                     # メインのTerraform設定
├── variables.tf                # 変数定義
├── outputs.tf                  # 出力値定義
├── key_pair.tf                 # SSH Key Pair設定
├── terraform-tutorial-key-new.pub  # 公開鍵
└── .gitignore                  # Git除外設定

# ローカルのみ（gitignore対象）
├── terraform-tutorial-key-new  # 秘密鍵
├── terraform.tfstate           # Terraform状態ファイル
├── terraform.tfstate.backup    # 状態ファイルバックアップ
└── sessionmanager-bundle/      # Session Managerファイル
```

## 🔒 セキュリティ

### 保護されるファイル

以下のファイルは`.gitignore`で保護され、GitHub にプッシュされません：

- `terraform-tutorial-key-new` (秘密鍵)
- `.tfstate` (Terraform 状態ファイル)
- `sessionmanager-bundle/`
- `.backup`, `.old`, `\*.bak` (バックアップファイル)

### SSH 接続のセキュリティ

- SSH Agent Forwarding を使用
- ProxyJump で Bastion 経由接続
- 秘密鍵はローカルのみ保持
- StrictHostKeyChecking 設定

## 🎯 学習ポイント

### インフラストラクチャ

- Terraform でのインフラ構築
- AWS VPC、サブネット設計
- セキュリティグループ設定
- EC2 インスタンス管理

### セキュリティ

- SSH 接続とセキュリティ
- Bastion サーバーパターン
- プライベートサブネット設計

### 運用

- Git での機密情報管理
- SSH 設定ファイル管理
- リソース削除とクリーンアップ

## 🆘 トラブルシューティング

### SSH 接続エラー

```bash
# SSH Agent確認
ssh-add -l

# 接続テスト（詳細ログ）
ssh -v bastion

# 権限確認
ls -la terraform-tutorial-key-new
chmod 600 terraform-tutorial-key-new
```

### Terraform エラー

```bash
# 状態確認
terraform show

# 状態ファイル確認
terraform state list

# 強制削除（注意して使用）
terraform destroy -auto-approve
```

### S3 削除エラー

```bash
# バケット内容確認
aws s3 ls s3://[BUCKET_NAME] --recursive

# 強制削除
aws s3 rb s3://[BUCKET_NAME] --force
```

## 📚 参考資料

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/)
- [SSH Config File](https://www.ssh.com/academy/ssh/config)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)
