resource "aws_s3_bucket" "demo_bucket" {
  bucket = "terraform-demo-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 8
}

