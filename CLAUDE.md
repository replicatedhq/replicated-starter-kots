# Agent Instructions

This is a Replicated collaboration repository. It uses Helm charts for application packaging and the Replicated platform for distribution.

## Repository Structure

```
.
├── charts/app/          # Helm chart for the application
├── replicated/          # Replicated-specific manifests
├── docs/               # Customer-facing documentation
├── bin/setup.sh        # Developer environment setup
├── Makefile            # Build and release automation
└── .github/workflows/  # CI/CD and issue automation
```

## Key Commands

- `make lint` - Lint Helm chart and Replicated manifests
- `make release` - Create a Replicated release (requires REPLICATED_APP and REPLICATED_API_TOKEN)
- `make build` - Build release artifacts
- `make clean` - Remove build artifacts
- `helm lint charts/app` - Validate Helm chart
- `helm template charts/app` - Preview rendered Kubernetes YAML

## Working with Replicated Manifests

When modifying Replicated manifests:

1. Edit files in `replicated/` directory
2. Run `make lint` to validate
3. Update `charts/app/Chart.yaml` version before releasing
4. Run `make release` to publish

### Key Files

- `replicated/application.yaml` - Application metadata and status informers
- `replicated/config.yaml` - Config options shown in admin console
- `replicated/preflight.yaml` - Pre-installation checks (troubleshoot.sh)
- `replicated/sig-application.yaml` - Kubernetes Application CR
- `replicated/embedded-cluster.yaml` - Embedded cluster configuration

## Working with Helm Charts

When modifying the Helm chart:

1. Edit templates in `charts/app/templates/`
2. Update `charts/app/values.yaml` for defaults
3. Update `charts/app/Chart.yaml` version for releases
4. Run `helm lint charts/app` to validate

## Release Workflow

1. Update `charts/app/Chart.yaml` version
2. Run `make lint` to validate everything
3. Run `make release` to create and promote release
4. The release will be promoted to the current git branch name (or "Unstable" for main)

## Support Ticket Integration

This repository includes GitHub issue templates and workflows for support ticket management:

- Use `kind::support-request` label for customer issues
- Use `status::*` labels to track issue state
- Slash commands in issue comments: `/close`, `/label <name>`
- Automated stale issue management runs daily

## Notes for Agents

- Do not hardcode customer-specific values in generic manifests
- Always run `make lint` before committing changes to Replicated manifests
- Keep `replicated/config.yaml` minimal and generic - customers customize this
- The `build/` directory is ephemeral and gitignored
- Never commit `REPLICATED_API_TOKEN` or customer credentials
