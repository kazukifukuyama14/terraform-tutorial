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

## 4.外部から変数を変える

### 4-1.変更の種類と例題

- 外部から変数値を与える方法は 3 種類ある。
- 変数の上書き順としては、下記表で上から順に行われる。

| 種類         | 説明                                                                                    |
| ------------ | --------------------------------------------------------------------------------------- |
| 環境変数     | 環境変数へあらかじめ設定してある値を利用する。 / `TF_VAR_<NAME>`                        |
| 変数ファイル | あらかじめ決められた変数ファイル名のファイルに指定する。 / `terraform.tfstate`          |
| コマンド引数 | 次のコマンド引数で指定された値を利用する。 / `-var NAME=VALUE` , `var-file <FILE_PATH>` |

(例 1)

- `main.tf`内に message という文字列が定義されている
- "HELLO World!"という文字列に上書きしてあげ、ビルド実行するというもの

```hcl:main.tf
variable "message" {
  type    = string
  default = "nothing"
}
```

```bash
export TF_VAR_message="HELLO World!"
terraform apply
```

(例 2)

- 変数ファイルを使用して上書きする
- terraform.tfvars という変数ファイルに、上書きしたい定義を記載する

```hcl:main.tf
variable "message" {
  type    = string
  default = "nothing"
}
```

```hcl:terraform.tfvars
message = "HELLO World!"
```

```bash
terraform apply
```

(例 3)

- コマンドを使用して上書きを実施する

```hcl:main.tf
variable "message" {
  type    = string
  default = "nothing"
}
```

```bash
terraform apply -var message="HELLO World!"
```

### 4-2.変数の上書き使い分け

| 種類         | 使い分け                                                                                                                                                                    |
| ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 環境変数     | 実行ログに残らない(tfstate には場合により出力される)鍵情報(ファイルとして残したくないもの)、環境依存情報(dev, stg など)                                                     |
| 変数ファイル | Git 管理できる = 構成管理として残せるロジック(プロビジョン手続き)とデータ(変数)は切り離すことで Git 管理したときに変更箇所が明確になる。 / データは変数ファイルに記載する。 |
| コマンド引数 | 実行ログに残る。テストで部分的に変更したい。デバッグで一部変更したいなど、一時的な利用。                                                                                    |
