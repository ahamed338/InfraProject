output "bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}

output "s3_bucket_id" {
  value = aws_s3_bucket.demo_bucket.id
}