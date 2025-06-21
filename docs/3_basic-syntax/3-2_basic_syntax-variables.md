## 2.変数(locals, variable)

### 2-1.変数の種類

HCL2 で利用可能な変数は以下の 2 種類。

| 種類     | 説明                                                                                   |
| -------- | -------------------------------------------------------------------------------------- |
| locals   | ローカル変数。プライベートな変数で外部から変更はできない。                             |
| variable | 外部から変更可能な変数。コマンドライン実行時にオプションやファイル指定で上書きできる。 |

※参照：[Terraform 公式ドキュメント：locals,variables](https://developer.hashicorp.com/terraform/language/values/locals)

### 2-2.locals の定義と参照

locals ブロックで定義して、 ${(local.<NAME>)}で参照。
(例):

```hcl:main.tf
locals {
  # 複数の EC2 インスタンス セットの ID を結合したもの
  instance_ids = concat(aws_instance.blue.*.id, aws_instance.green.*.id)
}

locals {
  # すべてのリソースに割り当てられる共通のタグ
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }
}
```

### 2-3.variables の定義と参照

variables ブロックで定義を 1 つ定義し、${(var.<NAME>)}で参照。

(例):

```hcl:main.tf
variable "service_name" {
  type    = string
  default = "forum"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "service_token" {
  type      = string
  ephemeral = true
}

locals {
  service_tag   = "${var.service_name}-${var.environment}"
  session_token = "${var.service_name}:${var.service_token}"
}
```
