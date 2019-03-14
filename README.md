# Kubernetes The Terraform Way

## Automating Kubernetes The Hard Way Tutorial with Terraform.

- Module Infrastructure provisions computes ressources and network configuration for Kubernetes' architecture - 3 masters and 3 workers (step 3) - and generates kubectl remote access bat and bash scripts. 

- Module Bootstrap provision certificates and kubeconfig files and install ETCD, Control Plane and Worker nodes and finishes with deploying CoreDNS and a test App (Step 4 to 12 in the tutorial).

## How does it work? 

1 - Terraform init then apply in the folder. (Windows 10 version) (linux version will be uploaded soon with small changes)

2 - Go to /generated/tls and launch the .bat or .sh, depends on your host. 