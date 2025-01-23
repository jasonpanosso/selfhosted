output "smtp_username" {
  value     = aws_iam_access_key.ses_smtp_key.id
  sensitive = true
}

output "smtp_password" {
  value     = aws_iam_access_key.ses_smtp_key.ses_smtp_password_v4
  sensitive = true
}
