variable "region" {
  default = "europe-west4"
}

variable "zones" {
  default = "europe-west4-b"
}

variable "project" {
  default = "k8s-wireguard-project"
}

variable "machine-type" {
   default = "n1-standard-1"
}

variable "image-type" {
   default = "ubuntu"
}

variable "cluster-name" {
   default = "k8s-wireguard"
}

variable "node-pool-name" {
   default = "node-pool"
}

variable "node-count" {
   default = 2
}

variable "cluster-subnet-range" {
   default = "10.50.0.0/16"
}

variable "wireguard-install-cmd" {
   default = "curl https://gist.githubusercontent.com/ddorgan/c764abb840ba087bfd8775bec01b7e0d/raw/51435e99487402c25a8903909d2483580f06921c/install.sh | sudo bash"
}

variable "wireguard-query-cmd" {
   default = "gcloud beta compute instances list  --format='get(name,networkInterfaces[0].accessConfigs[0].natIP)'"
}

variable "workers-path" {
   default = "../data/workers"
}

variable "wireguard-config-cmd" {
   default = "../scripts/wireguard-config.sh"
}

variable "kube-config" {
   default = "../data/kubeconfig"
}

variable "wireguard-client-conf" {
   default = "../data/wireguard-client.conf"
}

variable "k8s-deploy-wireguard" {
   default = "../scripts/k8s-deploy-wireguard.sh"
}
