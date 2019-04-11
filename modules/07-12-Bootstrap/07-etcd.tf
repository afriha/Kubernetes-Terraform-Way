resource "null_resource" "etcd_server" {
  count = "${var.MasterCount}"
    
    connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.ca_cert_null_ids, count.index)}",
      "echo ${element(var.kubernetes_certs_null_ids, count.index)}",
      "echo 'export count=${var.MasterCount}' >> ~/.profile"
    ]
  }
  provisioner "remote-exec" {
    script = "${path.module}/etcd.sh"
  }
}
