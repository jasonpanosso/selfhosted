output "spaces_name" {
  description = "The name of the DigitalOcean Space"
  value       = digitalocean_spaces_bucket.backups.name
}

output "spaces_urn" {
  description = "The URN of the DigitalOcean Space"
  value       = digitalocean_spaces_bucket.backups.urn
}

output "spaces_domain_name" {
  description = "The domain name of the DigitalOcean Space"
  value       = digitalocean_spaces_bucket.backups.bucket_domain_name
}

output "spaces_access_key" {
  description = "The access key for the DigitalOcean Space"
  value       = digitalocean_spaces_key.this.access_key
  sensitive   = true
}

output "spaces_secret_key" {
  description = "The secret key for the DigitalOcean Space"
  value       = digitalocean_spaces_key.this.secret_key
  sensitive   = true
}

output "b2_bucket_name" {
  description = "The name of the B2 backup bucket"
  value       = b2_bucket.backups.bucket_name
}

output "b2_s3_api_url" {
  description = "The S3-compatible endpoint for the B2 account"
  value       = data.b2_account_info.this.s3_api_url
}
