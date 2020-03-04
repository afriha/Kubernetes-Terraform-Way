#!/bin/bash -v
sudo apt-get update
sudo apt-get -y install socat conntrack ipset
#Binaries
wget -q --show-progress --https-only --timestamping \
  "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.16.0/crictl-v1.16.0-linux-amd64.tar.gz" \
  "https://github.com/opencontainers/runc/releases/download/v1.0.0-rc9/runc.amd64" \
  "https://github.com/containernetworking/plugins/releases/download/v0.8.3/cni-plugins-linux-amd64-v0.8.3.tgz" \
  "https://github.com/containerd/containerd/releases/download/v1.3.1/containerd-1.3.1.linux-amd64.tar.gz" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kubectl" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kube-proxy" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.16.3/bin/linux/amd64/kubelet"

#Creating installation directories
sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes \
  /etc/containerd/ \
  /etc/kubernetes/


#Installing binaries
sudo mv runc.amd64 runc
chmod +x kubectl kube-proxy kubelet runc
sudo mv kubectl kube-proxy kubelet runc /usr/local/bin/
sudo tar -xvf crictl-v1.16.0-linux-amd64.tar.gz -C /usr/local/bin/
sudo tar -xvf cni-plugins-linux-amd64-v0.8.3.tgz -C /opt/cni/bin/
sudo tar -xvf containerd-1.3.1.linux-amd64.tar.gz -C /

#Configure CNI Networking
POD_CIDR="$(echo $(curl --silent -H Metadata:true "http://169.254.169.254/metadata/instance/compute/tags?api-version=2017-08-01&format=text") | cut -d : -f2)"
cat <<EOF | sudo tee /etc/cni/net.d/10-bridge.conf
{
    "cniVersion": "0.3.1",
    "name": "bridge",
    "type": "bridge",
    "bridge": "cnio0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "${POD_CIDR}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
    }
}
EOF
#Loopback interface
cat <<EOF | sudo tee /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "name": "lo",
    "type": "loopback"
}
EOF

#Containerd config
cat << EOF | sudo tee /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
EOF

#Containerd service
cat <<EOF | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

#Configure the Kubelet
{
  sudo mv ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
  sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
  sudo mv ca.pem /var/lib/kubernetes/
  sudo mv azure.json /etc/kubernetes/
} 
#kubelet-config.yaml configuration file
cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
EOF

#Kubelet service
cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --cloud-provider=external \\
  --azure-container-registry-config=/etc/kubernetes/azure.json \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --resolv-conf=/run/systemd/resolve/resolv.conf \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

#Configure the Kubernetes Proxy
sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
EOF
#Kube-proxy service
cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
#Start the Worker Services
{
  sudo systemctl daemon-reload
  sudo systemctl enable containerd kubelet kube-proxy
  sudo systemctl start containerd kubelet kube-proxy
}