data "template_file" "kube-scheduler_config_template" {
  template = "${file("${path.module}/kube-scheduler_kubeconfig.tpl")}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data    = "${base64encode(var.kube-scheduler_crt_pem)}"
    client-key-data            = "${base64encode(var.kube-scheduler_key_pem)}"
  }
}

resource "local_file" "kube-scheduler_config" {
  content  = "${data.template_file.kube-scheduler_config_template.rendered}"
  filename = "./generated/kube-scheduler.kubeconfig"
}

resource "null_resource" "kube-scheduler-provisioner" {
  count = 3

  depends_on = ["local_file.kube-scheduler_config"]

  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.apiserver_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/kube-scheduler.kubeconfig"
    destination = "~/kube-scheduler.kubeconfig"
  }
}
