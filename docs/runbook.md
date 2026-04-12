# Operational Runbook

## Deploy the Application
kubectl apply -f k8s/base/
kubectl apply -f k8s/production/

## Scale the Cluster
kops edit instancegroups nodes-us-east-1a --state=s3://taskapp-kops-state-448866496656
# Change maxSize/minSize, then:
kops update cluster --name=taskapp.xpresskode.site --state=s3://taskapp-kops-state-448866496656 --yes
kops rolling-update cluster --name=taskapp.xpresskode.site --state=s3://taskapp-kops-state-448866496656 --yes

## Rotate Secrets
kubectl create secret generic postgres-secret \
  --from-literal=POSTGRES_USER=taskapp \
  --from-literal=POSTGRES_PASSWORD=NEW_PASSWORD \
  --dry-run=client -o yaml | \
  kubeseal --controller-name=sealed-secrets \
  --controller-namespace=kube-system \
  --format yaml > k8s/production/postgres-sealed-secret.yaml
kubectl apply -f k8s/production/postgres-sealed-secret.yaml
kubectl rollout restart deployment backend -n taskapp

## Validate Cluster
kops validate cluster --name=taskapp.xpresskode.site --state=s3://taskapp-kops-state-448866496656

## Troubleshoot Pod Issues
kubectl get pods -n taskapp
kubectl describe pod <pod-name> -n taskapp
kubectl logs <pod-name> -n taskapp

## Destroy Infrastructure
terraform -chdir=terraform/environments/production destroy
kops delete cluster --name=taskapp.xpresskode.site --state=s3://taskapp-kops-state-448866496656 --yes
