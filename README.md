# Terraform + AWS Infrastructure (EC2 Ubuntu + EKS)

This repository provisions the following in AWS account `014197010512`:
- Ubuntu EC2 VM (`t3.medium`: 2 vCPU, 4 GiB RAM)
- EKS cluster control plane (AWS-managed)
- EKS managed node group with **2 worker nodes**
- Terraform remote state in **S3** + state locking in **DynamoDB**

## Important Note on "2 nodes and a master"
In EKS, the Kubernetes control plane ("master") is managed by AWS. You create and manage worker nodes only. This setup creates:
- 1 EKS control plane (managed service)
- 2 worker nodes (managed node group)

## Cost / Free Tier Note
`t3.medium` (2 vCPU / 4 GiB) is generally **not** AWS free tier. If you must stay in free tier, use smaller instances like `t2.micro`/`t3.micro` (where eligible), but they do not match 4 GiB RAM.

## Repo Structure
- `bootstrap/` creates S3 backend bucket + DynamoDB lock table
- root Terraform provisions VPC, EC2, EKS using that backend

## Prerequisites
- AWS CLI configured for account `014197010512`
- Terraform >= 1.6
- Permissions to create: S3, DynamoDB, IAM, VPC, EC2, EKS

## 1) Bootstrap backend (one time)
```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars values
terraform init
terraform apply
```

## 2) Deploy infrastructure
```bash
cd ..
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars values
terraform init \
  -backend-config="bucket=<your-state-bucket>" \
  -backend-config="key=envs/dev/terraform.tfstate" \
  -backend-config="region=<your-region>" \
  -backend-config="dynamodb_table=<your-lock-table>" \
  -backend-config="encrypt=true"
terraform apply
```

## 3) Configure kubectl
```bash
aws eks update-kubeconfig --region <your-region> --name <cluster-name>
kubectl get nodes
```

## Destroy
```bash
terraform destroy
cd bootstrap
terraform destroy
```
