# Terraform 基本構文

## 1.ブロックタイプ

| 種類      | 説明                                       |
| --------- | ------------------------------------------ |
| locals    | 外部から変更できないローカル変数           |
| variable  | 外部から変更できる変数                     |
| terraform | Terraform の設定                           |
| provider  | プロバイダ                                 |
| data      | Terraform 管理していないリソースの取り込み |
| resource  | Terraform 管理対象となるリソース           |
| output    | 外部から参照できるようにする値             |

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

## 3.データ型

HCL2 で扱えるデータ型は以下の通り。

| 種類         | 型名                    | 説明                           |
| ------------ | ----------------------- | ------------------------------ |
| プリミティブ | string                  | Unicode 文字列                 |
|              | number                  | 数値。整数と小数の両方を表現。 |
|              | bool                    | true/false の 2 値。           |
| 構造体       | object({NAME=TYPE,...}) | キーバリュー型データ           |
|              | tuple([TYPE])           | 各列の型が決まっている配列     |
| コレクション | list(TYPE)              | 特定の型で構成される配列。     |
|              | map(TYPE)               | キーが文字列の値。             |
|              | set(TYPE)               | 値の重複が無い配列。           |

### 3-1.プリミティブ

- **string** : Unicode 文字列
- **number** : 数値。整数と少数の両方を表現する
- **bool**: true/false

```bash
variable "string" {
  type    = string       # 変数の型
  default = "HelloWorld" # デフォルト値
}

variable "number" {
  type    = number # 変数の型
  default = 10     # デフォルト値
}

variable "bool" {
  type    = bool # 変数の型
  default = true # デフォルト値
}
```

### 3-2.構造体

```bash
# 定義
variable "object_sample" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "tanaka"
    age  = 40
  }
}
```

- **object**({NAME=TYPE, ...}) : キーバリュー型データ

```bash
# 参照
Name = ${var.object_sample.name}
```

- **tuple**([TYPE, ...]) : 各列の型が決まっている配列

```bash
# 定義
variable "tuple_sample" {
  type = tuple([
    string, number
  ])
  default = ["sasayoshi", 1000]
}
```

```bash
# 参照
 Name = "${var.tuple_sample[0]}"
```

### 3-3.コレクション

- **list**(TYPE): 特定の型で構成される配列

```bash
# 定義
variable "list_sample" {
  type    = list(string)
  default = ["hoge", "hogehoge"]
}
```

```bash
# 参照
Name = "${var.list_sample[0]}"
```

- **map**(TYPE): キーが文字列の配列

```bash
# 定義
variable "map_sample" {
  type = map(string)
  default = {
    "High" = "m5.2xlarge"
    "Mid"  = "m5.large"
    "Low"  = "t2.micro"
  }
}
```

```bash
# 参照
instance_type = var.map_sample.High
```

- **set**(TYPE): 値の重複がない配列

```bash
# 定義
variable "set_sample" {
  type = set(string)
  default = [
    "tanaka",
    "sato",
    "tanaka",
    "sato"
  ]
}
```

```bash
# 参照
[for itm in var.set_samle : itm]

→ toset([
    "sato",
    "tanaka"
  ])
```
