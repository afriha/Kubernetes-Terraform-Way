resource "null_resource" "worker_server" {
  count = "${var.NodeCount}"
  
  depends_on = ["null_resource.etcd_server"]
  depends_on = ["null_resource.control_plane_server"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.worker_ca_null_ids, count.index)}",
      "echo ${element(var.kubelet_crt_null_ids, count.index)}",
      "echo ${element(var.kubelet_prov_null_ids, count.index)}",
      "echo ${element(var.proxy_prov_null_ids, count.index)}",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/workernodes.sh"
    ]
  }
}
resource "null_resource" "rbac_and_dns" {
  
  depends_on = ["null_resource.worker_server"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${var.apiserver_public_ip}"
    password     = "${var.node_password}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${jsonencode(null_resource.etcd_server.*.id)}",
      "echo ${jsonencode(null_resource.control_plane_server.*.id)}",
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/roles-dns.sh"
    ]
  }
}