resource "google_container_cluster" "primary" {
  name               = var.cluster-name
  location           = var.zones
  # delete on cluster creation
  initial_node_count = 1
  remove_default_node_pool = true


  master_auth {
  username = ""
  password = ""

  client_certificate_config {
    issue_client_certificate = false
    }
  }
}


resource "google_container_node_pool" "primary_nodes" {
  name       = var.node-pool-name
  location   = var.zones
  cluster    = google_container_cluster.primary.name
  node_count = var.node-count

  node_config {
    machine_type = var.machine-type
    image_type   = var.image-type

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
   tags = ["wireguard-vpn"]
  }
}
