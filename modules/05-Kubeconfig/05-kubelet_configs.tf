## Kubelet configuration files
data "template_file" "kubelet_config_template" {
  template = "${file("${path.module}/kubelet_kubeconfig.tpl")}"

  count = "${var.NodeCount}"

  vars {
    certificate-authority-data = "${base64encode(var.kube_ca_crt_pem)}"
    client-certificate-data    = "${base64encode(var.kubelet_crt_pems[count.index])}"
    client-key-data            = "${base64encode(var.kubelet_key_pems[count.index])}"
    
    apiserver_public_ip        = "${var.apiserver_public_ip}"
    node_name                  = "${element(var.kubelet_node_names, count.index)}"
  }
}
resource "local_file" "kubelet_config" {
  count = "${var.NodeCount}"
  content  = "${data.template_file.kubelet_config_template.*.rendered[count.index]}"
  filename = "./generated/${element(var.kubelet_node_names, count.index)}.kubeconfig"
}
resource "null_resource" "kubelet_provisioner" {
  count = "${var.NodeCount}"

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