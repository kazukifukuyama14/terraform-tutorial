## 5-3.resource ブロック

リソースの定義を記述するブロック。

```hcl:/modules/s3/s3.tf
resource "aws_s3_bucket" "s3-private-bucket" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-328674"
  acl    = "private"
  # Manege version of S3 source
  versioning {
    enabled = false
  }
}

```

- `aws_s3_bucket` ： リソース・タイプ。指定のタイプがあり、定義したい型を記載する。
- `s3-private-bucket` ： ローカル名。タイプに対して、固有の名称を付ける。自分で名前を決めて記載する。
- `bucket`： S3 バケット名。${var.project}は変数。main.tf から渡される project を参照している。

実際の値（例：terraform）は terraform.tfvars に記載する。  
main.tf は terraform.tfvars を参照し、s3.tf へ変数を渡している。

---

## 5-4.data ブロック

terraform の管理対象外のリソースを tf ファイル内に取り込むブロック。

```hcl:/modules/lambda/lambda.tf
<!-- aws_iam_policyリソースの読み込み -->
data "aws_iam_policy_document" "lambda" {
  statement {
    sid     = "LambdaAssumeRolePolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type      = "Service"
      identifiers = [
        "logs.${var.region}.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}
```

↓

```hcl:/modules/lambda/lambda.tf
resource "aws_iam_role" "lambda" {
  name             = "${var.enviroment}-lambda-role"
  assume_role_policy = "${data.aws_iam_policy_document.lambda.json}" #参照することができる
}
```

- data ブロックの定義を、「**data.aws_iam_policy_document**」で（インスタンスとして）受け取ることができる。
- 複数個所に同様のコードを書かなくて済むようになる。

---

```hcl:/modules/lambda/lambda.tf
<!-- archive_fileリソース（生成したアーカイブ）を取り込む -->
data "archive_file" "initial_lambda_package" {
  type        = "zip"
  output_path = "./src/.temp_files/lambda.zip"
  source {
    content  = "# empty"
    filename = "main.py"
  }
}
```

- AWS の「archive_file」というリソースを参照することができる。
- このブロックでは「archive_file」リソースを参照し、指定ディレクトリ配下に「main.py」ファイルを作成している。
