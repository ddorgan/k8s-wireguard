resource "google_compute_firewall" "wireguard-vpn" {
  name    = "wireguard-vpn"
  network = "default"
  allow {
    protocol = "udp"
    ports    = ["30443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wireguard-vpn"]
}

