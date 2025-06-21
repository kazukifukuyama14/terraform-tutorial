## 5-5.output ブロック

出力するインスタンスの定義を記述するブロック。

```hcl:/modules/s3/s3.tf
resource "aws_s3_bucket" "s3-private-bucket" {
  bucket = "${var.project}-${var.enviroment}-private-bucket-105"
  acl    = "private"
}
```

↓

```hcl:/modules/s3/output.tf
output "aws_s3_bucket" {
    value = aws_s3_bucket.s3-private-bucket.id
    sensitive = false # not external output
}
```

↓

```hcl:main.tf
module "sfn" {
  source                = "./modules/sfn"
  s3_private_bucket06   = module.S3.aws_s3_bucket
}
```

↓

```hcl:/modules/sfn/sfn.tf
resource "aws_s3_bucket_object" "lambda_file" {
  bucket = "${var.s3_private_bucket}"
  key    = "initial.zip"
  source = "./src/.temp_files/lambda.zip"
}
```

これらのコードを図に書き起こすと以下のようになる。  
(Mermaid Live Editor より生成)

![output-block](/docs/3_basic-syntax/img/output-block.png)
