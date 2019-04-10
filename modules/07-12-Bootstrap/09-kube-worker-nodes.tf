resource "null_resource" "worker_server" {
  count = "${var.NodeCount}"

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${element(null_resource.etcd_server.*.id, count.index)}",
      "echo ${element(null_resource.control_plane_server.*.id, count.index)}",
    ]
  }  
  provisioner "remote-exec" {
    inline = [
      "echo ${element(var.worker_ca_null_ids, count.index)}",
      "echo ${element(var.kubelet_crt_null_ids, count.index)}",
      "echo ${element(var.kubelet_prov_null_ids, count.index)}",
      "echo ${element(var.proxy_prov_null_ids, count.index)}",
      "echo ${element(var.azure_worker_prov_null_ids, count.index)}",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/workernodes.sh"
    ]
  }
}