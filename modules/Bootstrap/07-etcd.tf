resource "null_resource" "etcd_server" {
  count = 3
    
    connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${element(null_resource.ca_certs.*.id, count.index)}",
      "echo ${element(null_resource.kubernetes_certs.*.id, count.index)}",
    ]
  }
  provisioner "remote-exec" {
    script = "${path.module}/etcd.sh"
  }
}
