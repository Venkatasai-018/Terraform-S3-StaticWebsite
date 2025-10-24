output "bucket_name" {
  value = aws_s3_bucket.mybucket.bucket
}

output "sample" {
  value = "${var.ENV}-${var.bucket_name}"
}

output "URL" {
  value = aws_s3_bucket_website_configuration.mybucketconfig.website_endpoint
}