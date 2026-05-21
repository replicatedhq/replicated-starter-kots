# Installation Guide

## Prerequisites

Before installing, ensure you have:

- A Kubernetes cluster (1.22+)
- Helm 3.x installed
- Access to the Replicated Vendor Portal (for license and configuration)

## Installation

### 1. Configure the Application

Update `values.yaml` with your specific configuration:

```yaml
replicaCount: 2

image:
  repository: your-registry/your-image
  tag: "1.0.0"

service:
  type: LoadBalancer
  port: 80

ingress:
  enabled: true
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
```

### 2. Install via Helm

```bash
helm upgrade --install my-app ./charts/app \
  -f values.yaml \
  -n my-namespace \
  --create-namespace
```

Or, if distributed via Replicated:

```bash
helm upgrade --install my-app oci://registry.replicated.com/my-app/my-app \
  -f values.yaml \
  -n my-namespace \
  --create-namespace
```

### 3. Verify Installation

```bash
kubectl get pods -n my-namespace
kubectl get svc -n my-namespace
```

## Configuration

See `charts/app/values.yaml` for all available configuration options. Key areas:

- **Scaling:** `replicaCount`, `autoscaling`
- **Networking:** `service`, `ingress`
- **Resources:** `resources` (CPU/memory limits)
- **Security:** `podSecurityContext`, `securityContext`

## Troubleshooting

### Pre-flight Checks

Run pre-flight checks before installation:

```bash
kubectl preflight ./replicated/preflight.yaml
```

Or via Helm:

```bash
helm template my-app ./charts/app --values values.yaml | kubectl preflight -
```

### Support Bundles

Generate a support bundle for troubleshooting:

```bash
kubectl support-bundle --load-cluster-specs --namespace my-namespace
```

### Common Issues

| Issue | Solution |
|-------|----------|
| Pods stuck in Pending | Check node resources and storage class |
| Image pull errors | Verify registry credentials and image tags |
| Service unreachable | Check `service.type` and firewall rules |

## Getting Help

- Open a [GitHub Issue](../../issues/new/choose) for support requests
- Include your environment details and any error messages
- Attach a support bundle if possible
