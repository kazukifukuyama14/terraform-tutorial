## 5-6.リソース参照

### 5-6-1.リソース生成時に他のリソースを参照

下記は、VPC を作成する際に、サブネットを参照している。

```hcl:main.tf
resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id # VPC の ID を参照
  availability_zone = "ap-northeast-1a"
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
}
```

### 5-6-2.HCL2 でリソース参照する記述

"."(ドット)で連結して参照する。

```txt
<BLOCK_TYPE>.<LABEL1>.<LABEL2>
```

ドット連結で表現されるリソースパスを、**アドレス**と呼ぶ。
※resource ブロックの場合は、BLOCK_TYPE は省略される

```hcl:main.tf
resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id # ここでドットで連結して参照
  availability_zone = "ap-northeast-1a"
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
}
```
