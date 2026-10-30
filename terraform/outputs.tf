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
