output "etcd_server_null_ids" {
  value = null_resource.etcd_server.*.id
}

