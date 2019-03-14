#!/bin/bash -v
#Access to kubelet data
sleep 20
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF

#Healthz Checks roles
cat <<EOF | kubectl apply -f -
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: healthz-reader
rules:
- nonResourceURLs: ["/healthz", "/healthz/*"]
  verbs: ["get", "post"]
EOF
cat <<EOF | kubectl apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-healthz-global
subjects:
- kind: Group
  name: system:unauthenticated
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: healthz-reader
  apiGroup: rbac.authorization.k8s.io
EOF

#CoreDNS
kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
cat <<EOF | kubectl apply -f -
kind: Service
apiVersion: v1
metadata:
  name: projetservice
spec:
  selector:
    app: projet-31
  ports:
    - protocol: "TCP"
      port: 8081
      targetPort: 5000
      nodePort: 30000
  type: NodePort
EOF

#Deploy a test app
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: projet-31
  labels:
    app: "projet-31"
spec:
  containers:
  - name: projet-31
    image: abdelhakverwest/projet-31:v3
    ports:
    - containerPort: 5000
    imagePullPolicy: Always
    volumeMounts:
    - name: redis-storage
      mountPath: /data/redis
  volumes:
  - name: redis-storage
    emptyDir: {}
EOF