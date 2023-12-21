# resource "cloudflare_record" "main" {
#   zone_id = var.static_site_config.domain.cloudflare.zone_id
#   name    = var.static_site_config.domain.name
#   value   = azurerm_storage_account.main.primary_web_host
#   type    = "CNAME"
#   proxied = true
#   ttl     = 1
# }

# resource "cloudflare_record" "asverify" {
#   zone_id = var.static_site_config.domain.cloudflare.zone_id
#   name    = "asverify.${var.static_site_config.domain.name}"
#   value   = "asverify.${module.naming.storage_account.name}${var.static_site_config.identifier}.blob.core.windows.net"
#   type    = "CNAME"
#   proxied = false
#   ttl     = 1
# }
