resource "tls_private_key" "kubelet" {
  count = var.NodeCount

  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_cert_request" "kubelet" {
  key_algorithm   = tls_private_key.kubelet[count.index].algorithm
  private_key_pem = tls_private_key.kubelet[count.index].private_key_pem

  count = var.NodeCount

  lifecycle {
    ignore_changes = [id]
  }

  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  ip_addresses = [
    element(var.kubelet_node_ips, count.index),
  ]
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibilty in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  dns_names = [
    element(var.kubelet_node_names, count.index),
  ]

  subject {
    common_name         = "system:node:${element(var.kubelet_node_names, count.index)}"
    organization        = "system:nodes"
    country             = "FR"
    locality            = "Paris"
    organizational_unit = "Kubernetes The Hard Way"
    province            = "IdF"
  }
}

resource "tls_locally_signed_cert" "kubelet" {
  count = var.NodeCount

  cert_request_pem   = tls_cert_request.kubelet[count.index].cert_request_pem
  ca_key_algorithm   = tls_private_key.kube_ca.algorithm
  ca_private_key_pem = tls_private_key.kube_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.kube_ca.cert_pem

  validity_period_hours = 8760

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
}

resource "local_file" "kubelet_key" {
  count = var.NodeCount

  content  = tls_private_key.kubelet[count.index].private_key_pem
  filename = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}-key.pem"
}

resource "local_file" "kubelet_crt" {
  count = var.NodeCount

  content  = tls_locally_signed_cert.kubelet[count.index].cert_pem
  filename = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}.pem"
}

resource "null_resource" "kubelet_certs" {
  count = var.NodeCount

  depends_on = [
    local_file.kubelet_crt,
    local_file.kubelet_key,
  ]

  connection {
    type         = "ssh"
    user         = var.node_user
    host         = element(var.kubelet_node_names, count.index)
    password     = var.node_password
    bastion_host = var.bastionIP
  }

  provisioner "file" {
    source      = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}.pem"
    destination = "~/${element(var.kubelet_node_names, count.index)}.pem"
  }

  provisioner "file" {
    source      = "./generated/tls/kubelet/${element(var.kubelet_node_names, count.index)}-key.pem"
    destination = "~/${element(var.kubelet_node_names, count.index)}-key.pem"
  }
}

resource "null_resource" "worker_ca_cert" {
  count = var.NodeCount

  depends_on = [local_file.kube_ca_crt]

  connection {
    type         = "ssh"
    user         = var.node_user
    host         = element(var.kubelet_node_names, count.index)
    password     = var.node_password
    bastion_host = var.bastionIP
  }

  provisioner "file" {
    source      = "./generated/tls/ca.pem"
    destination = "~/ca.pem"
  }
}

