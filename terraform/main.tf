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

  user_data_replace_on_change = true
}
