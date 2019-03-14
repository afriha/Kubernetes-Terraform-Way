## Kubelet configuration files
data "template_file" "kubelet_config_template" {
  template = "${file("${path.module}/kubelet_kubeconfig.tpl")}"

  count    = 3

  vars {
    certificate-authority-data = "${base64encode(tls_self_signed_cert.kube_ca.cert_pem)}"
    client-certificate-data    = "${base64encode(tls_locally_signed_cert.kubelet.*.cert_pem[count.index])}"
    client-key-data            = "${base64encode(tls_private_key.kubelet.*.private_key_pem[count.index])}"
    apiserver_public_ip        = "${var.apiserver_public_ip}"
    node_name                  = "${element(var.kubelet_node_names, count.index)}"
  }
}
resource "local_file" "kubelet_config" {
  count    = 3
  content  = "${data.template_file.kubelet_config_template.*.rendered[count.index]}"
  filename = "./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
}
resource "null_resource" "kubelet_provisioner" {
  count = 3

  depends_on = ["local_file.kubelet_config"]
  connection {
    type         = "ssh"
    user         = "${var.node_user}"
    host         = "${element(var.kubelet_node_names, count.index)}"
    password     = "${var.node_password}"
    bastion_host = "${var.bastionIP}"
  }

  provisioner "file" {
    source      = "./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
    destination = "~/${element(var.kubelet_node_names, count.index)}.kubeconfig"
  }
}