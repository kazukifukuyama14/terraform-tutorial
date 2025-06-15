# デフォルト VPC に EC2 を起動

## 概要

デフォルトの VPC より、EC2 を起動する。

![create_ec2](/docs/2_tutorial/img/create_ec2.png)

## 作業前準備

### 1.作業ディレクトリと Terraform のファイルを作成

今回は`terraform`というディレクトリを作成し、その直下に`main.tf`というファイルを作成する。

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

## 3.初めての起動

### 3-1. Terraform の初期化

初期化前に、terraform ディレクトリへ移動する:

```bash
cd terraform
```

初期化を実行する:

```bash
terraform init
```

出力ログは以下のようになる:

```bash
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.100.0...
- Installed hashicorp/aws v5.100.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

このコマンドは、Terraform のワークスペースを初期化し、必要なプラグインやプロバイダーをダウンロードする。

### 3-2. Terraform の実行

実行前に、`terraform plan` コマンドを実行して、リソースの作成計画を確認する:

```bash
terraform plan
```

このコマンドは Terraform の重要なコマンドの一つで、実際にリソースを作成・変更・削除する前に、何が実行されるかを確認するためのコマンドになる。

出力コマンドは以下のようになる:

```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.hello-world will be created
  + resource "aws_instance" "hello-world" {
      + ami                                  = "ami-0bb2c57f7cfafb1cb"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags_all                             = (known after apply)
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.ｓ
```

今回は EC2 インスタンスを新規作成するので、`ami`と`instance_type`が新たに追加されていることがわかる。

```bash
terraform apply
```

このコマンドは、Terraform の計画を実行し、AWS にリソースをプロビジョニングする。

出力ログは以下のようになり、ログの途中で`Enter a value:`と問われるので`yes`と入力する。

```bash

\Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.hello-world will be created
  + resource "aws_instance" "hello-world" {
      + ami                                  = "ami-0bb2c57f7cfafb1cb"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags_all                             = (known after apply)
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.hello-world: Creating...
aws_instance.hello-world: Still creating... [00m10s elapsed]
aws_instance.hello-world: Still creating... [00m20s elapsed]
aws_instance.hello-world: Creation complete after 23s [id=i-0c7f3b15ca3be4c64]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

コンソールを確認し、EC2 インスタンスが作成されていることを確認する。  
![ec2instance-create](/docs/2_tutorial/img/create_ec2_after.png)

## 4.tfstate ファイル

![tfstate](/docs/2_tutorial/img/tfstate.png)

Terraform のリソースを AWS 上に展開すると、ローカルに tfstate ファイルが生成される。  
このファイルは、**Terraform を使って構築したクラウドの状態情報が記述**されている。

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

## 6.EC2 の変更(再作成あり)

前回と異なる変更を行っていく。

- UserData に NGINX をインストールするスクリプトを追加
- tfstate の確認

![nginxec2](/docs/2_tutorial/img/NGINXfromEC2.png)

UserData は起動時に処理されるスクリプトで、EC2 は起動中に変更を加えることはできない。  
→ そのため、EC2 自体が再作成される。

```hcl:main.tf
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami           = "ami-0bb2c57f7cfafb1cb"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
  user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1.12
systemctl start nginx
EOF
}
```

Terraform のスクリプトについては、[ヒアドキュメント](https://qiita.com/take4s5i/items/e207cee4fb04385a9952)で記述可能。

`terraform apply`を実行すると、以下ログから`replace`(置き換え)が出力される想定だったが、想定とは違うログが出てしまった。

```bash
❯ terraform apply
aws_instance.hello-world: Refreshing state... [id=i-0c7f3b15ca3be4c64]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_instance.hello-world will be updated in-place
  ~ resource "aws_instance" "hello-world" {
        id                                   = "i-0c7f3b15ca3be4c64"
      ~ public_dns                           = "ec2-18-182-2-163.ap-northeast-1.compute.amazonaws.com" -> (known after apply)
      ~ public_ip                            = "18.182.2.163" -> (known after apply)
        tags                                 = {
            "Name" = "HelloWorld"
        }
      + user_data                            = "da7731f936872f3322e2a6a96a4105295b382056"
        # (37 unchanged attributes hidden)

        # (8 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.hello-world: Modifying... [id=i-0c7f3b15ca3be4c64]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 00m10s elapsed]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 00m20s elapsed]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 00m30s elapsed]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 00m40s elapsed]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 00m50s elapsed]
aws_instance.hello-world: Still modifying... [id=i-0c7f3b15ca3be4c64, 01m00s elapsed]
aws_instance.hello-world: Modifications complete after 1m2s [id=i-0c7f3b15ca3be4c64]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

MC で確認しても特に変化なし。
![ec2instance-tag](/docs/2_tutorial/img/ec2_tag.png)

### 6-1.なぜ再作成されなかったのか

EC2 インスタンスの user_data は、既存インスタンスに対して変更可能な属性として扱われるが、実際にはインスタンス起動時にのみ実行されるという重要な制約がある。

### 6-2.実際に起こったこと

- Terraform は既存インスタンスの user_data 属性を更新
- しかし、既に起動済みのインスタンスでは user_data スクリプトは再実行されない
- つまり、NGINX はインストールされていない可能性が高い

### 6-3.main.tf 再作成

```hcl:main.tf
provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
  ami           = "ami-0bb2c57f7cfafb1cb"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld-NGINX"
  }

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx1.12
systemctl start nginx
systemctl enable nginx
EOF

<!-- user_dataが変更された時にインスタンスを再作成 -->
  user_data_replace_on_change = true
}
```

`user_data_replace_on_change` を `true` に設定することで、user_data が変更された場合にインスタンスを再作成するようになる。

再度`terraform apply`を実行してみる。

```bash
❯ terraform apply
aws_instance.hello-world: Refreshing state... [id=i-0c7f3b15ca3be4c64]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # aws_instance.hello-world must be replaced
-/+ resource "aws_instance" "hello-world" {
      ~ arn                                  = "arn:aws:ec2:ap-northeast-1:276713244139:instance/i-0c7f3b15ca3be4c64" -> (known after apply)
      ~ associate_public_ip_address          = true -> (known after apply)
      ~ availability_zone                    = "ap-northeast-1c" -> (known after apply)
      ~ cpu_core_count                       = 1 -> (known after apply)
      ~ cpu_threads_per_core                 = 1 -> (known after apply)
      ~ disable_api_stop                     = false -> (known after apply)
      ~ disable_api_termination              = false -> (known after apply)
      ~ ebs_optimized                        = false -> (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      - hibernation                          = false -> null
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      ~ id                                   = "i-0c7f3b15ca3be4c64" -> (known after apply)
      ~ instance_initiated_shutdown_behavior = "stop" -> (known after apply)
      + instance_lifecycle                   = (known after apply)
      ~ instance_state                       = "running" -> (known after apply)
      ~ ipv6_address_count                   = 0 -> (known after apply)
      ~ ipv6_addresses                       = [] -> (known after apply)
      + key_name                             = (known after apply)
      ~ monitoring                           = false -> (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      ~ placement_partition_number           = 0 -> (known after apply)
      ~ primary_network_interface_id         = "eni-0607076b5a3a4aed6" -> (known after apply)
      ~ private_dns                          = "ip-172-31-5-43.ap-northeast-1.compute.internal" -> (known after apply)
      ~ private_ip                           = "172.31.5.43" -> (known after apply)
      ~ public_dns                           = "ec2-18-183-251-43.ap-northeast-1.compute.amazonaws.com" -> (known after apply)
      ~ public_ip                            = "18.183.251.43" -> (known after apply)
      ~ secondary_private_ips                = [] -> (known after apply)
      ~ security_groups                      = [
          - "default",
        ] -> (known after apply)
      + spot_instance_request_id             = (known after apply)
      ~ subnet_id                            = "subnet-04ddb7a66b5e92a34" -> (known after apply)
        tags                                 = {
            "Name" = "HelloWorld"
        }
      ~ tenancy                              = "default" -> (known after apply)
      ~ user_data                            = "da7731f936872f3322e2a6a96a4105295b382056" -> "e1a83f4c1989a59a63ed82fb99b397ea4c255f77" # forces replacement
      + user_data_base64                     = (known after apply)
      ~ user_data_replace_on_change          = false -> true
      ~ vpc_security_group_ids               = [
          - "sg-0b14cb04ff3dbd13d",
        ] -> (known after apply)
        # (5 unchanged attributes hidden)

      ~ capacity_reservation_specification (known after apply)
      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      ~ cpu_options (known after apply)
      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      ~ ebs_block_device (known after apply)

      ~ enclave_options (known after apply)
      - enclave_options {
          - enabled = false -> null
        }

      ~ ephemeral_block_device (known after apply)

      ~ instance_market_options (known after apply)

      ~ maintenance_options (known after apply)
      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      ~ metadata_options (known after apply)
      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      ~ network_interface (known after apply)

      ~ private_dns_name_options (known after apply)
      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      ~ root_block_device (known after apply)
      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0277f64c3427ffdde" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.hello-world: Destroying... [id=i-0c7f3b15ca3be4c64]
aws_instance.hello-world: Still destroying... [id=i-0c7f3b15ca3be4c64, 00m10s elapsed]
aws_instance.hello-world: Still destroying... [id=i-0c7f3b15ca3be4c64, 00m20s elapsed]
aws_instance.hello-world: Still destroying... [id=i-0c7f3b15ca3be4c64, 00m30s elapsed]
aws_instance.hello-world: Destruction complete after 30s
aws_instance.hello-world: Creating...
aws_instance.hello-world: Still creating... [00m10s elapsed]
aws_instance.hello-world: Still creating... [00m20s elapsed]
aws_instance.hello-world: Creation complete after 22s [id=i-026481d80faca0f6e]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```

MC を確認してみると、想定通りインスタンスが再作成されていることが確認できる。  
![ec2replace](/docs/2_tutorial/img/ec2replace.png)

## 7.EC2 の削除

### 7-1.インスタンス削除

ソースコード自体には変更する点は無い。
削除するには、`ターミナル`から以下のコマンドを実行する:

```bash
terraform destroy
```

出力ログから、`destroyed`と表示されていれば成功である:

```bash
aws_instance.hello-world: Refreshing state... [id=i-026481d80faca0f6e]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.hello-world will be destroyed
  - resource "aws_instance" "hello-world" {
      - ami                                  = "ami-0bb2c57f7cfafb1cb" -> null
      - arn                                  = "arn:aws:ec2:ap-northeast-1:276713244139:instance/i-026481d80faca0f6e" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-northeast-1c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-026481d80faca0f6e" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t2.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0170d2cef38be76f9" -> null
      - private_dns                          = "ip-172-31-15-218.ap-northeast-1.compute.internal" -> null
      - private_ip                           = "172.31.15.218" -> null
      - public_dns                           = "ec2-54-168-118-60.ap-northeast-1.compute.amazonaws.com" -> null
      - public_ip                            = "54.168.118.60" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-04ddb7a66b5e92a34" -> null
      - tags                                 = {
          - "Name" = "HelloWorld"
        } -> null
      - tags_all                             = {
          - "Name" = "HelloWorld"
        } -> null
      - tenancy                              = "default" -> null
      - user_data                            = "e1a83f4c1989a59a63ed82fb99b397ea4c255f77" -> null
      - user_data_replace_on_change          = true -> null
      - vpc_security_group_ids               = [
          - "sg-0b14cb04ff3dbd13d",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 1 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "standard" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = false -> null
          - iops                  = 3000 -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0b3ac23068e5225a6" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
            # (1 unchanged attribute hidden)
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.hello-world: Destroying... [id=i-026481d80faca0f6e]
aws_instance.hello-world: Still destroying... [id=i-026481d80faca0f6e, 00m10s elapsed]
aws_instance.hello-world: Still destroying... [id=i-026481d80faca0f6e, 00m20s elapsed]
aws_instance.hello-world: Still destroying... [id=i-026481d80faca0f6e, 00m30s elapsed]
aws_instance.hello-world: Destruction complete after 30s

Destroy complete! Resources: 1 destroyed.
```

### 7-2.MC の確認

![ec2destory](/docs/2_tutorial/img/ec2destroy.png)
