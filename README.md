# Kubernetes The Terraform Way

## Automating Kubernetes The Hard Way Tutorial with Terraform.

- Module 03-Infra provisions computes ressources and network configuration for Kubernetes' architecture - 3 masters and x workers (step 3) - and generates kubectl remote access bat and bash scripts. 

- Module 04-Certs generates and provisions certificates for Kubernetes components (step 4)

- Module 05-Kubeconfig generates kubeconfig files and an ecryption config (step 5-6)

- Module 07-12-Bootstrap installs ETCD, Control Plane and Worker nodes and finishes with deploying CoreDNS (Step 7 to step 12)

## How does it work? 

1 - Terraform init then apply in the folder.

2 - Navigate to /generated/tls and launch the .bat or .sh, depends on your host. 