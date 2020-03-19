#!/bin/bash -v
sleep 20
# Azure CSI
{
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/v0.6.0/crd-csi-node-info.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/v0.6.0/rbac-csi-azuredisk-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/v0.6.0/csi-azuredisk-driver.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/v0.6.0/csi-azuredisk-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/v0.6.0/csi-azuredisk-node.yaml
}
# Default Storage
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
  name: default
provisioner: disk.csi.azure.com
parameters:
  skuname: Standard_LRS
  kind: managed         
  cachingMode: ReadOnly
reclaimPolicy: Delete
volumeBindingMode: Immediate
EOF
#Premium Storage Class
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-premium
provisioner: disk.csi.azure.com
parameters:
  skuname: Premium_LRS
  kind: managed 
  cachingMode: ReadOnly
reclaimPolicy: Delete
volumeBindingMode: Immediate
EOF
