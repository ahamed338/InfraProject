provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "terraform-demo-bucket"
}

output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}
