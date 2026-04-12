# Monthly Cost Analysis

## Compute (EC2)
- 3x t3.medium control plane: $0.0416/hr x 3 x 720hrs = ~$89.86/month
- 3x t3.medium worker nodes: $0.0416/hr x 3 x 720hrs = ~$89.86/month

## Networking
- 3x NAT Gateways: $0.045/hr x 3 x 720hrs = ~$97.20/month
- NAT Gateway data processing: ~$10/month (estimated)
- Load Balancer (ELB): ~$18/month

## Storage
- EBS gp3 10Gi (PostgreSQL): $0.08/GB x 10 = ~$0.80/month
- S3 (Terraform state + Kops): ~$1/month

## DNS
- Route53 hosted zone: $0.50/month
- DNS queries: ~$0.50/month

## Total Estimated: ~$308/month

## Cost Optimization Options
- Use spot instances for worker nodes: saves ~50% on compute
- Schedule cluster shutdown outside business hours in dev: saves ~70%
- Reserved instances for 1 year: saves ~40%
