locals {
  default_tags = merge(var.tags, {
    project  = var.project
    env      = var.env
    region   = var.region.short_name
    tfmodule = "wpx"
  })
}
