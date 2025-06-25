#!/bin/bash
# システムアップデート
yum update -y
yum install -y amazon-cloudwatch-agent

# AWS CLI v2のインストール
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# SSMエージェントのインストール（Amazon Linux 2では通常プリインストール済み）
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# アプリケーションディレクトリの作成
mkdir -p /opt/myapp
cd /opt/myapp

# SSMパラメータストアから環境変数ファイルを作成
cat > /opt/myapp/.env << EOF
# このファイルはSSM Parameter Storeから値を取得します
DATABASE_URL=\$(aws ssm get-parameter --name "/${project_name}/app/database-url" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
API_KEY=\$(aws ssm get-parameter --name "/${project_name}/app/api-key" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
JWT_SECRET=\$(aws ssm get-parameter --name "/${project_name}/app/jwt-secret" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
APP_ENV=\$(aws ssm get-parameter --name "/${project_name}/app/environment" --region ${region} --query 'Parameter.Value' --output text)
LOG_LEVEL=\$(aws ssm get-parameter --name "/${project_name}/app/log-level" --region ${region} --query 'Parameter.Value' --output text)
EOF

# 環境変数ファイルに実行権限を付与
chmod +x /opt/myapp/.env

# SSMパラメータを読み込むスクリプトを作成
cat > /opt/myapp/load_ssm_params.sh << 'EOF'
#!/bin/bash
# SSMパラメータストアから環境変数をエクスポート
export DATABASE_URL=$(aws ssm get-parameter --name "/${project_name}/app/database-url" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
export API_KEY=$(aws ssm get-parameter --name "/${project_name}/app/api-key" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
export JWT_SECRET=$(aws ssm get-parameter --name "/${project_name}/app/jwt-secret" --with-decryption --region ${region} --query 'Parameter.Value' --output text)
export APP_ENV=$(aws ssm get-parameter --name "/${project_name}/app/environment" --region ${region} --query 'Parameter.Value' --output text)
export LOG_LEVEL=$(aws ssm get-parameter --name "/${project_name}/app/log-level" --region ${region} --query 'Parameter.Value' --output text)
EOF

chmod +x /opt/myapp/load_ssm_params.sh

# Docker のインストール（コンテナ化されたアプリケーション用の例）
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# 完了ログの記録
echo "ユーザーデータスクリプトが完了しました: $(date)" >> /var/log/user-data.log
