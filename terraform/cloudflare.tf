data "cloudflare_zone" "main" {
  filter = {
    name = var.cloudflare_zone_name
  }
}

# updated by DDNS
resource "cloudflare_dns_record" "kubernetes" {
  zone_id = data.cloudflare_zone.main.id
  name    = "kubernetes.${var.cloudflare_zone_name}"
  type    = "A"
  ttl     = 1 # automatic
  proxied = false
  # placeholder until DDNS writes the real address
  content = "192.0.2.1"
  comment = "WAN address"

  lifecycle {
    ignore_changes = [content]
  }
}

resource "cloudflare_api_token" "cert_manager" {
  name = "cert-manager"

  policies = [{
    effect = "allow"

    permission_groups = [
      { id = "c8fed203ed3043cba015a93ad1616f1f" }, # Zone Read
      { id = "4755a26eedb94da69e1066d98aa820be" }, # DNS Write
    ]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.${data.cloudflare_zone.main.id}" = "*"
    })
  }]
}

resource "cloudflare_api_token" "external_dns" {
  name = "external-dns"

  policies = [{
    effect = "allow"

    permission_groups = [
      { id = "c8fed203ed3043cba015a93ad1616f1f" }, # Zone Read
      { id = "4755a26eedb94da69e1066d98aa820be" }, # DNS Write
    ]
    resources = jsonencode({
      "com.cloudflare.api.account.zone.${data.cloudflare_zone.main.id}" = "*"
    })
  }]
}
