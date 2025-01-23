data "cloudflare_zone" "this" {
  name = var.domain_name
}

locals {
  zone_id = data.cloudflare_zone.this.id
}

resource "aws_ses_domain_identity" "this" {
  domain = var.domain_name
}

resource "cloudflare_record" "ses_verification" {
  zone_id = local.zone_id
  name    = "_amazonses.${var.domain_name}"
  type    = "TXT"
  value   = aws_ses_domain_identity.this.verification_token
  ttl     = 300
}

resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.domain

  depends_on = [
    cloudflare_record.ses_verification
  ]
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "cloudflare_record" "ses_dkim_records" {
  for_each = toset(aws_ses_domain_dkim.this.dkim_tokens)
  zone_id  = local.zone_id
  name     = "${each.value}._domainkey.${var.domain_name}"
  type     = "CNAME"
  value    = "${each.value}.dkim.amazonses.com"
  ttl      = 300
}

resource "aws_iam_user" "ses_smtp_user" {
  name = "ses-smtp-user"
}

resource "aws_iam_user_policy_attachment" "ses_smtp_policy" {
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

resource "aws_iam_access_key" "ses_smtp_key" {
  user = aws_iam_user.ses_smtp_user.name
}

data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses_sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses_sender.json
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn = aws_iam_policy.ses_sender.arn
}
