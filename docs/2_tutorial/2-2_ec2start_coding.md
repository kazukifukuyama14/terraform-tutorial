## 2.コーディング

```hcl:main.tf
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami           = "ami-0bb2c57f7cfafb1cb"
  instance_type = "t2.micro"
}
```

このソースコードをブロックごとに解説すると以下のようになる。

### 2-1. AWS プロバイダーの設定

```hcl:main.tf
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}
```

このブロックは、Terraform が AWS リソースを管理するための設定：

- `provider "aws"`: AWS プロバイダーを使用することを宣言
- `profile = "terraform"`: AWS CLI の認証情報プロファイル「terraform」を使用
- `region = "ap-northeast-1"`: リソースを作成する AWS リージョンを東京リージョンに設定

### 2-2. EC2 インスタンスリソースの定義

```hcl:main.tf
resource "aws_instance" "hello-world" {
  ami           = "ami-0bb2c57f7cfafb1cb"
  instance_type = "t2.micro"
}
```

このブロックは、EC2 インスタンスを作成するための設定：

- `resource "aws_instance" "hello-world"`: 「hello-world」という名前の EC2 インスタンスリソースを定義
- `ami = "ami-0bb2c57f7cfafb1cbs"`: 使用する Amazon Machine Image（AMI）の ID を指定
- `instance_type = "t2.micro"`: インスタンスタイプを t2.micro（無料利用枠対象）に設定

AMI ID は以下手順で確認できる。  
EC2 > インスタンス > インスタンスを起動  
の順で下記キャプチャまで遷移し、赤枠の AMI ID をコピーしてソースコードにペーストする。
![amiid](/docs/2_tutorial/img/ec2_ami-id.png)
