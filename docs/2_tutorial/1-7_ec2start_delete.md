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
