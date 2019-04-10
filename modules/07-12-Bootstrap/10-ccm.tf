resource "null_resource" "ccm" {

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
      "echo ${jsonencode(null_resource.worker_server.*.id)}",
    ]
  }  
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/ccm.sh"
    ]
  }
}