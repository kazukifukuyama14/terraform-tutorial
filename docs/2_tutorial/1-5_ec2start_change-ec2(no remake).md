## 5.EC2 の変更(再作成なし)

作成した EC2 に対して変更を加えるとどうなるかを見ていく。

### 5-1.EC2 にタグを追加して変更

タグを追加する場合は、**resource ブロック内に tags を追加**する。

```hcl:main.tf
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami           = "ami-0bb2c57f7cfafb1cb"
  instance_type = "t2.micro"
  // タグを追加
  tags = {
    Name = "HelloWorld"
  }
}
```

`terraform apply`を実行すると、以下キャプチャのように、EC2 インスタンスにタグが追加される。  
![ec2instance-tag](/docs/2_tutorial/img/ec2_tag.png)  
![ec2instance-tag](/docs/2_tutorial/img/ec2_tag2.png)
