resource "null_resource" "azure_csi" {

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
      "echo ${jsonencode(null_resource.rbac_and_dns.*.id)}",
      "echo ${null_resource.ccm.id}",      

    ]
  }    
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/csi.sh"
    ]
  }
}