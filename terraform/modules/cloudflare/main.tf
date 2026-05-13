data "cloudflare_zone" "this" {
    filter = {
        name = var.domain_name
    }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
    account_id = var.cloudflare_account_id

    name = "${var.project_name}-tunnel"
    config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id

  config = {
    ingress = [ 
        {
            hostname = var.domain_name
            service  = "http://localhost:80"
        },
        {
            hostname = "www.${var.domain_name}"
            service  = "http://localhost:80"
        },
        {
            service  = "http_status:404"
        }
    ]
  }
}

resource "cloudflare_dns_record" "root" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = var.domain_name
  type    = "CNAME"

  content = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"

  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.this.zone_id

  name    = "www"
  type    = "CNAME"

  content = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"

  proxied = true
  ttl     = 1
}