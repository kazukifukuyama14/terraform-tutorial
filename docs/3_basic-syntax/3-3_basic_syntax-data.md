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
