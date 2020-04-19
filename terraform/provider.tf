provider "google-beta" {
  #credentials = GOOGLE_APPLICATION_CREDENTIALS
  project     = var.project
  region      = var.region
  zone        = var.zones
}

