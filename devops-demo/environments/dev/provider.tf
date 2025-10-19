provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_force_path_style         = true
  endpoints {
    s3 = "http://localhost:4566"
  }
}
