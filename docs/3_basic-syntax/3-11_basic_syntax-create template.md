## 5-8.ひな形作成

Terraform のコードを書く際に、毎回同じような記述を繰り返し書くのは効率的ではない。  
そこで、ひな形を作成することで、コードの記述を効率的に行うことができる。

作成するファイルは大きく分けて３つある。

- main.tf
- terraform.tfvars
- .gitignore

### 5-8-1.main.tf

前提：これまで学習用に作成した Terraform 関連のファイルは全削除し、新たに `main.tf` を下記のように作成していく。

```hcl:main.tf
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
      # バージョン指定(今回は3.0以上)s
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
```

### 5-8-2.terraform.tfvars

`main.tf` 内で定義した変数に具体的な値を入れるため、 `terraform.tfvars` を作成していく。

```hcl:terraform.tfvars
project     = "samplelog"
environment = "dev"
```

### 5-8-3.`.gitignore`

`.gitignore`とは、Git リポジトリ内でバージョン管理（トラッキング）の対象から外したいファイルやディレクトリを指定するための特殊なファイルのこと。  
Terraform プロジェクトで.gitignore を使う場合、主に以下のようなパターンを記載する。

- ローカルの Terraform ディレクトリを無視  
  `\*\*/.terraform/`

  - プロバイダバイナリや外部モジュールが格納されるディレクトリで、再生成可能かつ不要なため除外。

---

- Terraform ステートファイルを無視  
  `_.tfstate`  
  `_.tfstate.*`

  - ステートファイルやバックアップファイルには機密情報が含まれるため、除外。

---

- Terraform 変数ファイル（機密情報含む場合）  
  `_.tfvars`  
  `_.tfvars.json`

  - パスワードや API キーなどが含まれる場合、除外。

---

- オーバーライドファイル  
  `override.tf`  
  `override.tf.json`  
  `_override.tf`  
  `_override.tf.json`

  - ローカル環境でのみ使う設定ファイルなので除外。

---

- Terraform CLI 設定ファイル  
  `.terraformrc`  
  `terraform.rc`

  - ユーザー固有の設定なので除外。

---

- クラッシュログ  
  `crash.log`

  - 除外。

---

- IDE 設定ディレクトリ  
  `.vscode/`  
  `.idea/`

  - 特定の IDE を使う場合、プロジェクト固有の設定を除外できる。

ただ、手作業でファイル作成することは効率が悪いため、 `.gitignore.io` というサイトから生成していく。
https://www.toptal.com/developers/gitignore/

検索窓に `terraform` と入力すると、 Terraform に関連するファイルやディレクトリが除外される形で定義が生成される。

```git:.gitignore
# Created by https://www.toptal.com/developers/gitignore/api/terraform
# Edit at https://www.toptal.com/developers/gitignore?templates=terraform

### Terraform ###
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files, which are likely to contain sensitive data, such as
# password, private keys, and other secrets. These should not be part of version
# control as they are data points which are potentially sensitive and subject
# to change depending on the environment.
*.tfvars
*.tfvars.json

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

# Ignore CLI configuration files
.terraformrc
terraform.rc

# End of https://www.toptal.com/developers/gitignore/api/terraform
```

### 5-8-4.初期化

ひな型ファイルを作成後、以下のコマンドを実行して初期化する。

```bash
terraform init
```

出力結果は以下の通り。

```bash
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Installing hashicorp/aws v3.76.1...
- Installed hashicorp/aws v3.76.1 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
