# Replicated Application Template

A modern, Helm-based template for Replicated application collaboration repositories.

## Overview

This repository serves two primary purposes:

1. **Release Management** - Engineers use this repo to build, lint, and publish Replicated releases
2. **Support Collaboration** - Customer support tickets are tracked here with automated workflows

This template replaces the legacy KOTS-focused starter with a modern Helm-centric approach that aligns with current Replicated platform capabilities.

## Quick Start

### Setup

```bash
# Install development dependencies
./bin/setup.sh

# Validate your changes
make lint

# Create a Replicated release
make release
```

### Environment Variables

```bash
export REPLICATED_APP=your-app-slug
export REPLICATED_API_TOKEN=your-api-token
```

## Repository Structure

```
.
├── charts/app/              # Helm chart for your application
├── replicated/              # Replicated manifests
│   ├── application.yaml     # App metadata and status informers
│   ├── config.yaml          # Config options for admin console
│   ├── preflight.yaml       # Pre-installation checks
│   ├── sig-application.yaml  # Kubernetes Application CR
│   └── embedded-cluster.yaml # Embedded cluster config
├── docs/                    # Customer-facing documentation
├── bin/setup.sh            # Developer environment setup
├── Makefile                # Build and release automation
├── script/                 # Linting and test scripts
└── .github/workflows/      # CI/CD and issue automation
```

## Release Workflow

1. Update application code in `charts/app/`
2. Bump version in `charts/app/Chart.yaml`
3. Run `make lint` to validate
4. Run `make release` to publish

The release is promoted to a channel matching your current git branch (or `Unstable` for `main`).

## Support Ticket Management

This repository includes GitHub issue automation for support workflows:

- **Issue Templates** - Structured support requests with environment details
- **Stale Issue Management** - Automatically flags and closes inactive issues
- **Slash Commands** - `/close`, `/label <name>` in issue comments
- **Status Tracking** - `status::*` labels track issue lifecycle

See [`.github/ISSUE_TEMPLATE/issue.md`](.github/ISSUE_TEMPLATE/issue.md) for the support request template.

## Customer Installation

For customer-facing installation instructions, see [`docs/README.md`](docs/README.md).

## Agent Support

This repository includes [`CLAUDE.md`](CLAUDE.md) with context for AI agents working on:
- Replicated manifest modifications
- Helm chart updates
- Release management
- Support ticket workflows

## Legacy KOTS Template

The previous KOTS-focused version of this template is preserved at tag `legacy/kots-template`.
