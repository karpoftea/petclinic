data "digitalocean_kubernetes_versions" "karpoftea-k8s-main-versions" {
  version_prefix = "1.22."
}

resource "digitalocean_kubernetes_cluster" "karpoftea-k8s-main" {
  name         = "karpoftea-k8s-main"
  region       = "fra1"
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.karpoftea-k8s-main-versions.latest_version

  node_pool {
    name       = "service-aug"
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 2
  }

  maintenance_policy {
    start_time  = "04:00"
    day         = "sunday"
  }
}
