output "worker_nodes_null_ids" {
  value = null_resource.worker_nodes.*.id
}

