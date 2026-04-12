# Architecture Design

## Overview
TaskApp is deployed on AWS using Kops-managed Kubernetes with Terraform-provisioned infrastructure.

## Network Design
- VPC CIDR: 10.0.0.0/16 (65,536 IPs — sized for future node pool expansion)
- 3 public subnets across us-east-1a, us-east-1b, us-east-1c (NAT Gateways, Load Balancer)
- 3 private subnets across us-east-1a, us-east-1b, us-east-1c (Kubernetes nodes)
- 3 redundant NAT Gateways — one per AZ, eliminates single point of failure

## High Availability Strategy
- 3 control plane nodes across 3 AZs — etcd quorum survives loss of 1 master
- 3 worker nodes across 3 AZs — workloads redistributed on node failure
- Rolling update strategy (maxUnavailable: 0) — zero downtime deployments
- EBS persistent volumes with Retain policy — data survives pod deletion

## Security Model
- All nodes in private subnets — no public IPs on any Kubernetes node
- NAT Gateways for outbound internet — no direct internet exposure
- Sealed Secrets — database credentials encrypted at rest, safe to commit to Git
- IAM roles with least privilege — separate roles for control plane vs worker nodes
- cert-manager with Let's Encrypt — automated SSL certificate provisioning and renewal

## DNS Architecture
- Domain: xpresskode.site registered on Namecheap
- NS records delegated to Route53 (ns-1521.awsdns-62.org etc.)
- Route53 hosted zone managed via Terraform
- Ingress routes: taskapp.xpresskode.site → frontend, api.xpresskode.site → backend
