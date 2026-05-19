#!/bin/bash
# Run n8n AWS Cost Alerts locally using Podman (rootless)

echo "Building n8n image with Podman..."
podman build -t n8n-aws-cost-alerts .

echo "Starting n8n container (rootless)..."
podman run -d \
  --name n8n-aws-cost-alerts \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=admin123 \
  -v n8n_data:/home/node/.n8n:Z \
  n8n-aws-cost-alerts

echo "✅ n8n running at http://localhost:5678"
echo "📌 Login: admin / admin123"
echo "📌 Import workflow from: n8n-workflows/aws-cost-alert.json"
