
data "template_file" "kubectl_template" {
  template = "${file("${path.module}/kubectlconfig.tpl")}"
    vars {
        KUBERNETES_PUBLIC_ADDRESS   = "${azurerm_public_ip.PublicIP-FrontEndKubernetes.ip_address}"
    }
}
resource "local_file" "kubectl_config" {
  content  = "${data.template_file.kubectl_template.rendered}"
  filename = "./generated/tls/kubectlconfig.bat"
}
data "template_file" "kubectl_linux_template" {
  template = "${file("${path.module}/kubectlconfiglinux.tpl")}"
    vars {
        KUBERNETES_PUBLIC_ADDRESS   = "${azurerm_public_ip.PublicIP-FrontEndKubernetes.ip_address}"
    }
}
resource "local_file" "kubectl_linux_config" {
  content  = "${data.template_file.kubectl_linux_template.rendered}"
  filename = "./generated/tls/kubectlconfig.sh"
}
