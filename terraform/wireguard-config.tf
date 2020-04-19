# resources to configure wireguard

resource "null_resource" "localconfig_wireguard" {
depends_on = [null_resource.install_wireguard]
provisioner "local-exec" {
    command = var.wireguard-config-cmd
 }
}


resource "null_resource" "get_kubeconfig" {
depends_on = [null_resource.install_wireguard]
provisioner "local-exec" {
    command = <<LOCAL_EXEC
    export KUBECONFIG="${var.kube-config}"
    gcloud container clusters get-credentials ${var.cluster-name}  --zone ${var.zones} --project ${var.project}
    LOCAL_EXEC
 }
}

resource "null_resource" "deploy_wireguard" {
depends_on = [null_resource.get_kubeconfig]
provisioner "local-exec" {
    command = <<LOCAL_EXEC
    export KUBECONFIG="${var.kube-config}"
    sh "${var.k8s-deploy-wireguard}"
    LOCAL_EXEC
 }
}

resource "null_resource" "qrcode-wireguard" {
depends_on = [null_resource.deploy_wireguard]
provisioner "local-exec" {
    command = "cat '${var.wireguard-client-conf}' | qrencode -t utf8"
 }
}

