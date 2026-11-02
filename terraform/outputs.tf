output "b2_bucket_name" {
  description = "The name of the B2 backup bucket"
  value       = b2_bucket.backups.bucket_name
}

output "b2_s3_api_url" {
  description = "The S3-compatible endpoint for the B2 account"
  value       = data.b2_account_info.this.s3_api_url
}
