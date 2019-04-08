resource "null_resource" "control_plane_server" {
  count = 3
  
  depends_on = ["null_resource.etcd_server"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }
  provisioner "file" {
    source      = "${path.module}/azure-cloud-controller-manager"
    destination = "~/azure-cloud-controller-manager"
  }  
  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.ca_cert_null_ids, count.index)}",
      "echo ${element(var.kubernetes_certs_null_ids, count.index)}",
      "echo ${element(var.service_account_null_ids, count.index)}",
      "echo ${element(var.encryption_config_null_ids, count.index)}",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.controller_prov_null_ids, count.index)}",
      "echo ${element(var.scheduler_prov_null_ids, count.index)}",
      "echo ${element(var.admin_prov_null_ids, count.index)}",
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/controlplane.sh",
    ]
  }
}