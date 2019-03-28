kubelet_node_names = [
  "worker1",
  "worker2",
  "worker3"
]
apiserver_node_names = [
  "controller1",
  "controller2",
  "controller3"
]
kubelet_node_ips = ${kubelet-private-ip}
kubelet_public_ips = ${kubelet-public-ip}
apiserver_master_ips= ${master-ip}
apiserver_public_ip = "${apiserver-ip}"
node_user ="${node-user}"
node_password = "${node-password}"
bastionIP = "${apiserver-ip}"