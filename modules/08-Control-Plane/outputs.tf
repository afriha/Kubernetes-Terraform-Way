output "control_plane_null_ids" {
  value = "${null_resource.control_plane_server.*.id}"
}
output "rbac_ccm_null_id" {
  value = "${null_resource.rbac_ccm.id}"
}
output "rbac_apiserver_null_id" {
  value = "${null_resource.rbac_apiserver.id}"
}