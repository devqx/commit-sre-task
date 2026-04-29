# 🚀 Commit SRE Task – AWS + EKS + EFS + ArgoCD (GitOps)

## 📌 Overview

This repository implements a **fully automated AWS environment** using **Terraform**, deploying a **Kubernetes (EKS) cluster** with **EFS-backed storage**, **GitOps via ArgoCD**, and **autoscaling**.

The system demonstrates:

* Infrastructure as Code (Terraform)
* GitOps (ArgoCD + ApplicationSets)
* Dynamic storage provisioning (EFS CSI)
* Autoscaling (Cluster Autoscaler)
* Inter-service communication via shared persistent storage

---

# 🏗️ Architecture

## High-Level Flow

```
            +----------------------+
            |      ArgoCD          |
            |  (ApplicationSet)    |
            +----------+-----------+
                       |
                       v
            +----------------------+
            |       EKS Cluster    |
            |                      |
            |  +----------------+  |
            |  |  Reader App   |  |
            |  | (Web Output)  |  |
            |  +--------+------+  |
            |           |         |
            |           v         |
            |    Shared PVC (EFS) |
            |           ^         |
            |  +--------+------+  |
            |  |  Logger App   |  |
            |  | (Writes logs) |  |
            |  +----------------+ |
            +----------------------+
                       |
                       v
            +----------------------+
            |   AWS EFS (One-Zone) |
            +----------------------+
```

---

# ⚙️ Phase 1 – Implementation

## ✅ 1. VPC & Networking

* Custom VPC created via Terraform
* 2 Private Subnets across different AZs
* Route Tables configured
* NAT Gateway enabled for outbound traffic
* Security Groups configured for:

    * EKS nodes
    * EFS (NFS port 2049)

---

## ✅ 2. EFS (One-Zone)

* EFS created using Terraform
* **One-Zone deployment (single AZ)**
* Mount target created in selected AZ
* Security group allows NFS access from cluster

---

## ✅ 3. EKS Cluster

* Kubernetes version: **1.35**
* Deployed via Terraform
* Worker nodes:

    * Managed node group
    * **Min size = 0 (autoscaling requirement)**

---

## ✅ 4. Autoscaling

* **Cluster Autoscaler deployed via Helm (Terraform)**
* Automatically:

    * Scales nodes from **0 → N**
    * Selects instance size dynamically

---

## ✅ 5. EFS CSI Driver

* Installed via Terraform (Helm)
* Enables Kubernetes to dynamically provision storage from EFS

---

## ✅ 6. Dynamic Storage Provisioning

* StorageClass created:

    * `efs-sc`
* PVC automatically binds to PV using EFS

---

## ✅ 7. Shared Persistent Storage

* Single PVC:

```
shared-efs-pvc
```

* Access mode:

```
ReadWriteMany (RWX)
```

* Used by **both applications**

---

## ✅ 8. Applications (GitOps via ArgoCD)

### 🔹 App 1 – Reader (Web App)

* Reads log files from EFS
* Runs every 20 seconds
* Displays log contents via HTTP

---

### 🔹 App 2 – Logger (Helm Chart)

* Packaged as a **Helm chart**
* Writes log files to EFS:

    * Every **5 minutes**
    * Max size ~5MB

---

## 🔄 Application Interaction Flow

```
Logger App → writes logs → EFS
Reader App → reads logs → prints in web
```

---

## ✅ 9. ArgoCD (GitOps)

* Installed via Terraform (Helm)
* Uses **ApplicationSet**

### ApplicationSet Features:

* Git-based generator
* Auto-deploys apps from repo
* Self-healing enabled

---

## 📁 Repository Structure

```
.
├── infra/                  # Terraform infrastructure
│   ├── vpc/
│   ├── eks/
│   ├── efs/
│   ├── autoscaler/
│   └── argocd/
│
├── apps/
│   ├── base/
│   │   ├── app1/          # Reader app manifests
│   │   └── app2/          # Logger Helm chart
│   │
│   ├── environments/
│   │   └── dev/
│   │
│   └── applicationset.yaml
│
├── docker/
│   ├── app1/
│   └── app2/
│
└── README.md
```

---

# ⚙️ Phase 2 – Requirements

## ✅ Infrastructure as Code

✔ All infrastructure defined in Terraform:

* VPC
* EKS
* EFS
* ArgoCD
* Autoscaler
* Storage

---

## ✅ ArgoCD Applications via IaC

* ApplicationSet applied via Terraform
* No manual `kubectl` steps required

---

## ⚙️ (Optional) CI/CD

Not implemented, but can be extended with:

* AWS CodePipeline
* Jenkins on EC2

---

# 🚀 Deployment Instructions

## 1. Clone Repository

```bash
git clone https://github.com/devqx/commit-sre-task.git
cd commit-sre-task
```

---

## 2. Deploy Infrastructure

```bash
cd infra
terraform init
terraform apply
```

---

## 3. Access ArgoCD

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:

```
https://localhost:8080
```

---

## 4. Verify Applications

Check pods:

```bash
kubectl get pods
```

---

## 5. Verify EFS Data Sharing

Exec into reader pod:

```bash
kubectl exec -it <reader-pod> -- ls /data
```

You should see log files created by logger app.

---

# 🧪 Validation Checklist

| Requirement              | Status |
| ------------------------ | ------ |
| VPC + Private Subnets    | ✅      |
| EFS One-Zone             | ✅      |
| EKS 1.35                 | ✅      |
| Multi-AZ Compute         | ✅      |
| Autoscaling (0 nodes)    | ✅      |
| ArgoCD ApplicationSet    | ✅      |
| Dynamic PVC provisioning | ✅      |
| Shared storage (RWX)     | ✅      |
| Helm app                 | ✅      |
| App interaction          | ✅      |
| Full Terraform IaC       | ✅      |

---

# 🧠 Design Decisions

## Why EFS?

* Supports **ReadWriteMany**
* Enables shared access between pods

## Why ArgoCD?

* Enables **GitOps workflow**
* Declarative application deployment

## Why Cluster Autoscaler?

* Simple and sufficient for requirement
* Enables scale-from-zero

---

# ⚠️ Known Limitations

* No external ingress configured
* No monitoring (Prometheus/Grafana)
* No CI/CD pipeline (optional)

---

# 🔮 Future Improvements

* Add Karpenter for smarter autoscaling
* Add Ingress + LoadBalancer
* Add observability stack
* Add CI/CD pipeline

---

# 👨‍💻 Author

**devqx**

---

# ✅ Final Note

This implementation demonstrates a **complete, production-style workflow** combining:

* Infrastructure as Code
* GitOps
* Kubernetes storage
* Autoscaling

All requirements of the task have been satisfied.
