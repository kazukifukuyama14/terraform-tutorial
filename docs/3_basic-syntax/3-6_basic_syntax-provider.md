## 5-2.provider ブロック

プロバイダーの定義を記述するブロック。

```hcl:main.tf
provider "aws" {
  profile    = "terraform"
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
```

- `profile` ： AWS のプロファイル名を指定する。
- `region`：AWS のリージョンを指定する。
- `access_key` ： AWS のアクセスキーを指定する。
- `secret_key` ： AWS のシークレットキーを指定する。
