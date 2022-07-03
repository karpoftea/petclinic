resource "digitalocean_container_registry" "karpoftea-cr-main" {
  name                   = "karpoftea-cr-main"
  subscription_tier_slug = "starter"
}
