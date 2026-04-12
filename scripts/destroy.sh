#!/bin/bash
echo "=== Destroying TaskApp Infrastructure ==="

export KOPS_STATE_STORE=s3://taskapp-kops-state-448866496656
export CLUSTER_NAME=taskapp.xpresskode.site

echo "Step 1: Deleting Kubernetes resources..."
kubectl delete namespace taskapp --ignore-not-found

echo "Step 2: Deleting Kops cluster..."
kops delete cluster --name=$CLUSTER_NAME --state=$KOPS_STATE_STORE --yes

echo "Step 3: Destroying Terraform resources..."
cd terraform/environments/production
terraform destroy -auto-approve

echo "Step 4: Emptying S3 buckets..."
aws s3 rm s3://taskapp-terraform-state-448866496656 --recursive
aws s3 rm s3://taskapp-kops-state-448866496656 --recursive

echo "=== Cleanup complete ==="
