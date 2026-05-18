# Deployment Guide

## Prerequisites

1. **AWS CLI** configured with credentials
2. **Terraform** >= 1.5 installed
3. **kubectl** installed
4. **Slack workspace** and webhook URL

## Step-by-Step Deployment

### 1. Prepare Lambda Package

```bash
cd lambda
zip cost-checker.zip cost-checker.py
cd ..
```

### 2. Configure Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `n8n_username` (your choice)
- `n8n_password` (strong password)
- `cost_threshold` (daily USD limit)

### 3. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

This will take about 15-20 minutes to provision:
- VPC with public/private subnets
- EKS cluster
- EKS node group
- n8n deployment on Kubernetes
- Lambda function for Cost Explorer

### 4. Configure kubectl

```bash
aws eks update-kubeconfig --region eu-west-1 --name n8n-cost-alerts-eks
```

Verify:
```bash
kubectl get nodes
kubectl get pods -n n8n
```

### 5. Get n8n URL

```bash
terraform output n8n_url
```

Open the URL in browser and login with your credentials.

### 6. Import Workflow

1. In n8n UI, click **"Workflows"** → **"Import from File"**
2. Select `n8n-workflows/aws-cost-alert.json`
3. Click **"Credentials"** → **"Add New"** → **"Slack"**
4. Add your Slack webhook URL
5. Click **"Save"** and **"Activate"** the workflow

### 7. Test Workflow

Click **"Execute Workflow"** to test immediately.

Check your Slack channel for the alert!

## Verify Deployment

```bash
# Check EKS cluster
kubectl get all -n n8n

# Check Lambda function
aws lambda invoke --function-name n8n-cost-alerts-cost-checker output.json
cat output.json

# Get n8n logs
kubectl logs -n n8n deployment/n8n
```

## Troubleshooting

### n8n pod not starting
```bash
kubectl describe pod -n n8n <pod-name>
kubectl logs -n n8n <pod-name>
```

### Lambda timeout
Increase timeout in `terraform/main.tf`:
```hcl
timeout = 60  # seconds
```

### Cost data not showing
Verify IAM permissions for Lambda:
```bash
aws lambda get-function --function-name n8n-cost-alerts-cost-checker
```

## Clean Up

**Warning:** This will destroy all resources!

```bash
cd terraform
terraform destroy
```

## Cost Estimate

Running this setup 24/7:
- EKS cluster: ~$75/month
- EC2 (2x t3.medium): ~$50/month
- NAT Gateway: ~$35/month
- Lambda (1000 invocations/month): <$1
- **Total: ~$160/month**

## Next Steps

- Add more workflows (EC2 instance stop/start, S3 cleanup)
- Set up Route53 domain for n8n
- Enable HTTPS with ACM certificate
- Add Prometheus monitoring for n8n
