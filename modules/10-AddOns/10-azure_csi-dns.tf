resource "null_resource" "azure_csi-dns" {

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${var.apiserver_public_ip}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"

  }
  provisioner "remote-exec" {
    inline = [
      "echo ${jsonencode(var.etcd_server_null_ids)}",
      "echo ${jsonencode(var.control_plane_null_ids)}", 
      "echo ${jsonencode(var.worker_nodes_null_ids)}",
      "echo ${var.rbac_ccm_null_id}",
      "echo ${var.rbac_apiserver_null_id}",      

    ]
  }    
  provisioner "remote-exec" {
    scripts = [
      "${path.module}/dns-csi.sh",
    ]
  }
}