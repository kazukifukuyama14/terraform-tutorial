resource "aws_key_pair" "new_main" {
  key_name   = "terraform-tutorial-key-new"
  public_key = file("terraform-tutorial-key-new.pub")

  tags = {
    Name        = "${var.project_name}-${var.environment}-key-new"
    Environment = var.environment
  }
}
