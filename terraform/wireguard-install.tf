# resources to install wireguard via gcloud

resource "null_resource" "scan_wireguard" {
depends_on = [google_container_node_pool.primary_nodes]
provisioner "local-exec" {
    command = "${var.wireguard-query-cmd} --project ${var.project} > ${var.workers-path}"
 }
}

data "google_compute_instance_group" "all" {
    depends_on = [google_container_node_pool.primary_nodes]
    self_link = replace(google_container_node_pool.primary_nodes.instance_group_urls[0], "instanceGroupManagers", "instanceGroups")
}

data "google_compute_instance" "all_instances" {
  depends_on = [data.google_compute_instance_group.all]
  count = var.node-count
  self_link = tolist(data.google_compute_instance_group.all.instances)[count.index]
}


resource "null_resource" "install_wireguard" {
  depends_on = [data.google_compute_instance.all_instances]
  count = var.node-count
  provisioner "local-exec" {
    command = "gcloud beta compute ssh ${data.google_compute_instance.all_instances[count.index].name} --zone ${var.zones} --project ${var.project} --command '${var.wireguard-install-cmd}'"
 }
}

