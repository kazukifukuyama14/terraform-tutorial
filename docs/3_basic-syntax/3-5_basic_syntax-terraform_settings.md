## 5.Terraform の設定

**ブロック**とは、以下の variable ブロックのように{ }に囲まれた一つのまとまりのものを指す。

```hcl:main.tf
variable "test" {
  type = string
}
```

基本的なブロックは、主に下記の通り。

| ブロック名         | 説明                                                               |
| ------------------ | ------------------------------------------------------------------ |
| terraform ブロック | Terraform のバージョンやプロバイダーなどの設定を記述するブロック。 |
| provider ブロック  | プロバイダーの設定を記述するブロック。                             |
| resource ブロック  | AWS リソースの定義を記述するブロック。                             |
| data ブロック      | 参照するインスタンスの定義を記述するブロック。                     |
| output ブロック    | 出力するインスタンスの定義を記述するブロック。                     |
| local ブロック     | （同一モジュール内の）ローカル変数の定義を記述するブロック。       |

local ブロックは前段で説明済みのため、それ以外のブロックを後述で記載する。

### 5-1.Terraform ブロック

Terraform 自体の定義ブロック。

```hcl:main.tf
terraform {
  required_version = ">=1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  backend "s3" {
    bucket  = "manage-bucket-sample"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
```

- `required_version` ： Terraform のバージョン設定
- `required_providers` ： 対象のプロバイダー（インフラのプラットフォーム）の設定
