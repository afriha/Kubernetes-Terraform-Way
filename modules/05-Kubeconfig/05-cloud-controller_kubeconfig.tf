data "template_file" "cloud-manager_config_template" {
  template = "${file("${path.module}/cloud-manager_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data    = "${base64encode(var.cloud-manager_crt_pem)}"
    client-key-data            = "${base64encode(var.cloud-manager_key_pem)}"

  }
}

resource "local_file" "cloud-manager_config" {
  content  = "${data.template_file.cloud-manager_config_template.rendered}"
  filename = "./generated/cloud-manager.kubeconfig"
}

resource "null_resource" "cloud-manager-provisioner" {
  count = 3

  depends_on = ["local_file.cloud-manager_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/cloud-manager.kubeconfig"
    destination = "~/cloud-manager.kubeconfig"
  }
}