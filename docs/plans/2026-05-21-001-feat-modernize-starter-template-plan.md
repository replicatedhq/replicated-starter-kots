---
title: Update Replicated Starter KOTS to Modern Template
type: feat
status: active
date: 2026-05-21
---

# Update Replicated Starter KOTS to Modern Template

## Summary

Restructure the `replicated-starter-kots` repository from its stale KOTS-centric layout to a modern, Helm-based Replicated collaboration template. The new baseline harvests proven patterns from active customer collaboration repositories (notably `copia-automation-replicated`) and provides a generic, platform-agnostic starting point that Replicated engineers and customers can adopt without immediately deleting most of the files.

---

## Problem Frame

The current `replicated-starter-kots` repository is 2-3 years old and still organized around KOTS-specific manifests (`manifests/kots-*.yaml`). Replicated's platform has moved toward Helm charts, modern CI workflows, and enterprise portal features. As a result, both Replicated engineers and customers clone the template, delete the majority of its contents, and rebuild from scratch. This undermines the shared baseline for support, proof-of-value engagements, and automated onboarding.

---

## Requirements

- R1. The repository structure must match how Replicated engineers set up collaboration repositories today (Helm chart + `replicated/` manifests + `Makefile` + `docs/`).
- R2. The README must explain both release management workflows and support ticket engagement (dual use).
- R3. The repository must include agent-friendly files (`CLAUDE.md`, `docs/`) so AI agents can successfully support customers through this repository.
- R4. All files must be generic (not tied to any specific customer or application) while preserving useful patterns.
- R5. CI/CD workflows must be modern, using current GitHub Actions syntax and covering release creation, issue management, and automated followups.
- R6. The template must include a placeholder Helm chart structure, generic Replicated manifests, and build automation scripts.

---

## Scope Boundaries

- **Non-goal:** We will not port actual customer data, secrets, or Copia-specific configuration values. The template is generic.
- **Non-goal:** We will not implement enterprise portal email content - only the structure and tooling to manage it.
- **Non-goal:** We will not create a fully working application deployment. The chart is a structural placeholder.
- **Deferred to Follow-Up Work:**
  - Populate the Helm chart with meaningful application templates (beyond placeholder `Chart.yaml` and `values.yaml`): tracked in follow-up issue
  - Add Replicated License Field examples to `replicated/config.yaml`: can be added when a specific app needs them
  - Add actual `.github/actions` implementations beyond the `require-replicatedhq-member` example

---

## Context & Research

### Relevant Code and Patterns

- Template source: `/Users/chuck/workspace/accounts/copia/copia-automation-replicated` - an active collaboration repo using modern Replicated practices.
- Current repo layout: `manifests/` contains KOTS-specific YAMLs; `.github/workflows/main.yml` uses deprecated Actions syntax (`::set-output`); README is KOTS-centric.
- Modern patterns observed in template source:
  - `replicated/` directory for Replicated-specific manifests (`application.yaml`, `config.yaml`, `preflight.yaml`, `sig-application.yaml`, `embedded-cluster.yaml`)
  - `charts/<app>/` for Helm chart source
  - `Makefile` for `release`, `lint`, and `manifests` targets
  - `Taskfile.yml` for changelog generation
  - `bin/setup.sh` for developer environment bootstrapping
  - `script/` directory with linting utilities (`lint-helm`, `lint-shellcheck`, `lint-editorconfig`, `test`)
  - `docs/` for customer-facing installation and troubleshooting documentation
  - `.github/workflows/` for issue lifecycle automation (`trigger-analysis.yml`, `trigger-followups.yml`, `stale-issues.yaml`, `inbound-escalation-slashcommands.yaml`, `update-status-on-external-comment.yaml`)
  - `.github/renovate.json` for dependency automation
  - `enterprise-portal/` structure for branding and email template management
  - `.husky/` for git hooks
  - `Brewfile` and `.tool-versions` for tool versioning

### External References

- Replicated Vendor CLI documentation: https://docs.replicated.com/vendor/cli-install
- Replicated Helm install methods: https://docs.replicated.com/vendor/helm-install
- Troubleshoot.sh documentation: https://troubleshoot.sh/

---

## Key Technical Decisions

- **Helm over raw KOTS manifests:** The modern Replicated platform supports Helm as a first-class deployment method. The starter template should lead with Helm, not KOTS.
- **`replicated/` directory convention:** Isolates Replicated-specific configuration from application source code, making the structure easier to understand and maintain.
- **Makefile over shell scripts for release automation:** The Makefile pattern from `copia-automation-replicated` provides discoverable targets (`make lint`, `make release`) and is familiar to engineers.
- **Generic placeholder chart:** The starter will include a minimal `charts/app/` directory with `Chart.yaml`, `values.yaml`, and empty `templates/` directory. Users replace `app` with their application name.
- **Retain issue automation workflows:** The modern GitHub workflows for issue management (trigger-analysis, trigger-followups, stale issues, slash commands) are valuable for support engagement and should be part of the baseline.
- **Add `CLAUDE.md`:** To satisfy the agent-friendly requirement, we include a `CLAUDE.md` describing the repository structure, build commands, and how agents should interact with Replicated manifests.

---

## Open Questions

### Resolved During Planning

- **Q: Should we keep any KOTS-specific files for backwards compatibility?**
  - A: No. The goal is to modernize the baseline. Users who need KOTS can reference older tags. Removing KOTS files avoids confusion.
- **Q: Should the template include an actual working application or just structure?**
  - A: Just structure. A fully working app would need to be generic and would likely still be deleted. The structural patterns (Helm chart layout, Makefile targets, Replicated manifests) are what engineers keep.
- **Q: What application name should be used in the generic template?**
  - A: Use `app` as the placeholder name in `charts/app/` and `replicated/` references. Users will rename it during setup.

### Deferred to Implementation

- **Exact content of generic `replicated/config.yaml`:** The structure will mirror `copia-automation-replicated`'s config but with generic group/item names. Final YAML structure depends on how cleanly we can strip Copia-specific values.
- **Whether to include `enterprise-portal/email/` templates in the starter:** We will include the directory structure and a generic `email.yaml` config, but the actual HTML templates may be too customer-specific. Decision deferred to implementation - if they can be made generic, include them; otherwise, leave as placeholders.

---

## Output Structure

```
replicated-starter-kots/
├── .github/
│   ├── workflows/
│   │   ├── release.yaml              # Create Replicated release on push
│   │   ├── lint.yaml                 # Lint Helm chart and Replicated manifests
│   │   ├── trigger-analysis.yml      # Analyze incoming issues
│   │   ├── trigger-followups.yml     # Follow up on stale issues
│   │   ├── stale-issues.yaml         # Mark and close stale issues
│   │   ├── inbound-escalation-slashcommands.yaml  # Support slash commands
│   │   └── update-status-on-external-comment.yaml   # Sync issue status
│   ├── actions/
│   │   └── require-replicatedhq-member/
│   │       └── action.yml            # Example composite action
│   ├── ISSUE_TEMPLATE/
│   │   └── issue.md                  # Modern issue template
│   ├── renovate.json                 # Dependency automation
│   └── security.yaml                 # Security policy / reporting
├── bin/
│   └── setup.sh                      # Developer environment setup
├── charts/
│   └── app/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values.schema.json        # Optional schema
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml       # Generic placeholder
│           ├── service.yaml          # Generic placeholder
│           └── ingress.yaml          # Generic placeholder
├── docs/
│   └── README.md                     # Customer-facing install docs
├── replicated/
│   ├── application.yaml              # Generic Replicated Application manifest
│   ├── config.yaml                   # Generic Replicated Config manifest
│   ├── preflight.yaml                # Generic preflight checks
│   ├── sig-application.yaml          # SIG Application manifest
│   └── embedded-cluster.yaml         # Embedded cluster config (optional)
├── script/
│   ├── lint-helm                     # Helm lint wrapper
│   ├── lint-shellcheck               # Shell script lint wrapper
│   ├── lint-editorconfig             # EditorConfig lint wrapper
│   └── test                          # Test runner wrapper
├── enterprise-portal/
│   ├── branding/
│   │   ├── branding.yaml             # Generic branding config
│   │   └── README.md
│   └── email/
│       ├── email.yaml                # Generic email template config
│       └── templates/
│           └── .gitkeep
├── .gitignore
├── .tool-versions                    # asdf tool versions
├── Brewfile                          # Homebrew dependencies
├── CLAUDE.md                         # Agent instructions
├── Makefile                          # Release and lint automation
├── Taskfile.yml                      # Changelog generation
├── package.json                      # npm tooling (linting, etc.)
└── README.md                         # Repository overview and dual-use guide
```

---

## Implementation Units

### U1. Remove Legacy KOTS and Stale Files

**Goal:** Delete the old KOTS-centric files that are immediately discarded by users.

**Requirements:** R1

**Dependencies:** None

**Files:**
- Delete: `manifests/kots-app.yaml`
- Delete: `manifests/kots-config.yaml`
- Delete: `manifests/kots-preflight.yaml`
- Delete: `manifests/kots-support-bundle.yaml`
- Delete: `manifests/k8s-app.yaml`
- Delete: `manifests/example-configmap.yaml`
- Delete: `manifests/example-deployment.yaml`
- Delete: `manifests/example-service.yaml`
- Delete: `kurl-installer.yaml`
- Delete: `.gitlab-ci.yaml`
- Delete: `.github/workflows/main.yml`
- Delete: `.github/ISSUE_TEMPLATE/feature-request.md`
- Delete: `doc/REPLICATED_APP.png`
- Delete: `doc/REPLICATED_API_TOKEN.png`
- Delete: `doc/` directory (will be replaced by `docs/`)

**Approach:**
- Remove all `manifests/` files and the `manifests/` directory itself.
- Remove `.gitlab-ci.yaml` - GitLab CI is out of scope for the modern starter.
- Remove `.github/workflows/main.yml` - will be replaced by modern workflows.
- Remove `kurl-installer.yaml` - embedded cluster config moves to `replicated/embedded-cluster.yaml` if needed.
- Remove old `doc/` directory and its screenshots.

**Patterns to follow:**
- Keep `.gitignore` intact (will be updated in U8).

**Test scenarios:**
- Structural: `find . -name 'kots-*.yaml' -o -name 'k8s-app.yaml' | wc -l` returns 0.
- Structural: `git ls-files | grep -E '^manifests/|^doc/' | wc -l` returns 0.

**Verification:**
- `ls manifests/` returns "No such file or directory"
- `ls doc/` returns "No such file or directory"
- `.gitlab-ci.yaml` does not exist
- `.github/workflows/main.yml` does not exist
- **Operational:** Create a git tag `legacy/kots-template` on the pre-change commit so users can reference the old KOTS starter.

---

### U2. Create Generic Helm Chart Structure

**Goal:** Add a placeholder Helm chart that users can rename and populate.

**Requirements:** R1, R4

**Dependencies:** U1

**Files:**
- Create: `charts/app/Chart.yaml`
- Create: `charts/app/values.yaml`
- Create: `charts/app/values.schema.json`
- Create: `charts/app/templates/_helpers.tpl`
- Create: `charts/app/templates/deployment.yaml`
- Create: `charts/app/templates/service.yaml`
- Create: `charts/app/templates/ingress.yaml`
- Create: `charts/app/templates/NOTES.txt`

**Approach:**
- Use `appVersion: "1.0.0"` and `version: 0.1.0` in `Chart.yaml`.
- Provide a minimal `values.yaml` with common patterns: `replicaCount`, `image`, `service`, `ingress`.
- Include generic Kubernetes placeholders in templates (Deployment, Service, Ingress) with standard Helm helpers.
- Ensure templates are valid Helm but clearly marked as requiring customization.

**Patterns to follow:**
- Helm standard conventions (helpers, values schema, NOTES.txt).

**Test scenarios:**
- Happy path: `helm lint charts/app/` passes with no errors.
- Happy path: `helm template charts/app/` renders valid Kubernetes YAML.
- Edge case: `helm lint` with empty `values.yaml` still passes (chart should have defaults).

**Verification:**
- `helm lint charts/app` succeeds.
- `helm template charts/app` produces valid YAML.

---

### U3. Create Generic Replicated Manifests

**Goal:** Add a `replicated/` directory with generic versions of the modern manifest types.

**Requirements:** R1, R4

**Dependencies:** U1

**Files:**
- Create: `replicated/application.yaml`
- Create: `replicated/config.yaml`
- Create: `replicated/preflight.yaml`
- Create: `replicated/sig-application.yaml`
- Create: `replicated/embedded-cluster.yaml`

**Approach:**
- `application.yaml`: Generic `kots.io/v1beta1` Application manifest with placeholder `title` and empty `icon`.
- `config.yaml`: Generic Config manifest with a single group and a few common field types (text, password, bool) to demonstrate the pattern. Strip all Copia-specific values. **Fallback structure if stripping proves complex:** include one simple group named `app_config` with a single `text` item `app_name` (required) and a single `password` item `admin_password`. This satisfies `replicated release lint` while being minimal and obviously generic.
- `preflight.yaml`: Generic Troubleshoot preflight spec demonstrating common checks (k8s version, storage class, memory). Adapt from `copia-automation-replicated/replicated/preflight.yaml` but make checks generic.
- `sig-application.yaml`: Standard SIG Application manifest with generic metadata.
- `embedded-cluster.yaml`: Optional embedded cluster configuration with placeholder values.

**Patterns to follow:**
- `copia-automation-replicated/replicated/` structure and API versions.
- Replicated Config manifest patterns from vendor documentation.

**Test scenarios:**
- Happy path: `replicated release lint --yaml-dir=replicated` passes (note: may need build dir, see U6).
- Edge case: Config YAML is valid and parseable by `yq`.
- Error path: Missing required field in `application.yaml` should fail lint.

**Verification:**
- `yq eval replicated/application.yaml` succeeds.
- `yq eval replicated/config.yaml` succeeds.
- `replicated release lint --yaml-dir=./replicated` (or equivalent Makefile target from U6) passes.
- **Critical path:** U4 `make lint` depends on U3 producing valid YAML. If `config.yaml` is malformed, `make lint` will fail.

---

### U4. Add Build Automation (Makefile and Taskfile)

**Goal:** Provide `make` targets for release, lint, and manifest packaging.

**Requirements:** R1, R5

**Dependencies:** U2, U3

**Files:**
- Create: `Makefile`
- Create: `Taskfile.yml`

**Approach:**
- `Makefile`:
  - `lint`: runs `replicated release lint --yaml-dir $(BUILDDIR)` after building release files. Also runs `helm lint charts/app` for standalone chart validation.
  - `lint-replicated`: standalone target that only lints Replicated manifests without requiring a full release build.
  - `release`: packages Helm chart and Replicated manifests, then runs `replicated release create --auto`.
  - `manifests`: copies `replicated/*.yaml` to `build/`.
  - `charts`: packages `charts/app` to `build/app-<version>.tgz`.
  - `build` target creates `build/` directory.
  - Use variables for `REPLICATED_APP`, `VERSION`, `CHANNEL` sourced from environment variables or passed as `make REPLICATED_APP=... release`.
- `Taskfile.yml`:
  - `changelog`: runs `mogensen/helm-changelog` in Docker (copied from template source, but generic).

**Patterns to follow:**
- `copia-automation-replicated/Makefile` structure but generic (no Copia-specific chart names or dependencies).

**Test scenarios:**
- Happy path: `make build` creates `build/` directory.
- Happy path: `make manifests` copies Replicated YAMLs to `build/`.
- Happy path: `make charts` packages the Helm chart.
- Happy path: `make lint-helm` passes without requiring `REPLICATED_APP`.
- Edge case: `make lint` fails gracefully if `REPLICATED_APP` is not set.
- Integration: `make release` depends on `manifests` and `charts`.

**Verification:**
- `make build` succeeds.
- `make manifests` succeeds and `build/` contains copied YAMLs.
- `make charts` succeeds and `build/` contains `.tgz`.
- `make lint-helm` passes independently of Replicated manifest validity.
- `make lint` passes (or fails with clear error if env vars missing).

---

### U5. Add Developer Setup and Linting Scripts

**Goal:** Provide scripts for environment setup and code quality checks.

**Requirements:** R1, R4

**Dependencies:** U2

**Files:**
- Create: `bin/setup.sh`
- Create: `script/lint-helm`
- Create: `script/lint-shellcheck`
- Create: `script/lint-editorconfig`
- Create: `script/test`
- Create: `Brewfile`
- Create: `.tool-versions`

**Approach:**
- `bin/setup.sh`: Generic developer setup script. Primary path uses Homebrew on macOS. Include a documented Linux fallback (e.g., `apt-get install yq jq helm shellcheck` or manual install links) so non-macOS users are not blocked. Install `asdf` plugins from `.tool-versions`, install Node deps if `package.json` exists, install Helm plugins (`helm-unittest`). Keep generic (not Copia-branded).
- `script/lint-helm`: Wrapper around `helm lint charts/app`.
- `script/lint-shellcheck`: Run `shellcheck` on `bin/setup.sh` and `script/*`.
- `script/lint-editorconfig`: Run `editorconfig-checker` or `eclint`.
- `script/test`: Run `helm unittest charts/app` if plugin installed.
- `Brewfile`: List common tools (`yq`, `jq`, `helm`, `shellcheck`, `asdf`).
- `.tool-versions`: Pin versions for `helm`, `yq`, `jq`.

**Patterns to follow:**
- `copia-automation-replicated/bin/setup.sh` structure but generic branding.
- `copia-automation-replicated/script/` linting wrappers.

**Test scenarios:**
- Happy path: `bin/setup.sh` executes without syntax errors (dry-run with `bash -n`).
- Happy path: `script/lint-helm` runs and exits 0 when chart is valid.
- Error path: `script/lint-shellcheck` reports issues if scripts have syntax errors.

**Verification:**
- `bash -n bin/setup.sh` passes.
- `script/lint-helm` passes.
- `script/lint-shellcheck` passes on all shell scripts.

---

### U6. Add Modern GitHub Workflows

**Goal:** Replace the old single CI workflow with modern issue lifecycle and release workflows.

**Requirements:** R5

**Dependencies:** U1

**Files:**
- Create: `.github/workflows/release.yaml`
- Create: `.github/workflows/lint.yaml`
- Create: `.github/workflows/trigger-analysis.yml`
- Create: `.github/workflows/trigger-followups.yml`
- Create: `.github/workflows/stale-issues.yaml`
- Create: `.github/workflows/inbound-escalation-slashcommands.yaml`
- Create: `.github/workflows/update-status-on-external-comment.yaml`
- Create: `.github/ISSUE_TEMPLATE/issue.md`
- Create: `.github/renovate.json`
- Create: `.github/security.yaml`
- Create: `.github/actions/require-replicatedhq-member/action.yml`

**Approach:**
- `release.yaml`: **Primary trigger is `workflow_dispatch` (manual)** to avoid accidental releases from forked/cloned template repositories. Optionally support push-to-`main` gated behind a repository variable (`ENABLE_AUTO_RELEASE=true`) that adopters must explicitly set. Run `make lint` and `make release` using the Replicated vendor CLI. Use modern GitHub Actions syntax (no deprecated `::set-output`).
- `lint.yaml`: On PR/push, run `make lint` and `script/test`.
- Issue workflows: Copy from `copia-automation-replicated/.github/workflows/` but strip Copia-specific org references. Use `replicated-collab` or generic placeholder org names where appropriate.
- `renovate.json`: Basic Renovate config for Helm dependencies.
- `security.yaml`: Generic security policy and reporting template.
- `require-replicatedhq-member/action.yml`: Example composite action checking if actor is a member of the `replicatedhq` org (for slash command guards).

**Patterns to follow:**
- `copia-automation-replicated/.github/workflows/` patterns.
- Modern GitHub Actions syntax (`GITHUB_OUTPUT`, `actions/checkout@v4`).

**Test scenarios:**
- Happy path: `release.yaml` YAML is valid (use `actionlint` or `yq`).
- Happy path: `lint.yaml` YAML is valid.
- Edge case: Issue templates render correctly in GitHub UI.
- Integration: `release.yaml` triggers on both push and workflow_dispatch.

**Verification:**
- `yq eval '.jobs' .github/workflows/release.yaml` succeeds.
- `yq eval '.jobs' .github/workflows/lint.yaml` succeeds.
- GitHub Actions schema validation passes (if available).
- Optional: `actionlint` passes on all `.github/workflows/*.yaml` files.

---

### U7. Add Enterprise Portal Structure

**Goal:** Include the directory structure and configuration files for Replicated Enterprise Portal branding and email templates.

**Requirements:** R1

**Dependencies:** U3

**Files:**
- Create: `enterprise-portal/branding/branding.yaml`
- Create: `enterprise-portal/branding/README.md`
- Create: `enterprise-portal/email/email.yaml`
- Create: `enterprise-portal/email/templates/.gitkeep`

**Approach:**
- `branding.yaml`: Generic branding config with placeholder colors, title, and support link. Include comments explaining each field.
- `email.yaml`: Generic email template configuration file (metadata only, no actual HTML templates included in starter).
- `README.md`: Explains how to customize branding and upload via `make branding` (target added in U4 if desired, or documented for future).

**Patterns to follow:**
- `copia-automation-replicated/enterprise-portal/` structure.

**Test scenarios:**
- Structural: `yq eval enterprise-portal/branding/branding.yaml` succeeds.
- Structural: `yq eval enterprise-portal/email/email.yaml` succeeds.

**Verification:**
- `yq eval enterprise-portal/branding/branding.yaml` succeeds.
- `yq eval enterprise-portal/email/email.yaml` succeeds.

---

### U8. Add Agent-Friendly and Repository Documentation

**Goal:** Add `CLAUDE.md`, update `docs/README.md`, and ensure `.gitignore` covers new artifacts.

**Requirements:** R2, R3

**Dependencies:** U2, U3, U4, U5, U6, U7

**Files:**
- Create: `CLAUDE.md`
- Create: `docs/README.md`
- Modify: `.gitignore`
- Modify: `README.md`

**Approach:**
- `CLAUDE.md`:
  - Describe the repository structure (Helm chart in `charts/`, Replicated manifests in `replicated/`, build with `Makefile`).
  - Document common `make` targets.
  - Explain how agents should modify `replicated/config.yaml`, add Helm templates, and run `make lint` before committing.
  - Include a note about updating `charts/app/Chart.yaml` version when releasing.
- `docs/README.md`:
  - Customer-facing documentation explaining how to install the application using the Replicated platform.
  - Include sections: Prerequisites, Installation, Configuration (`values.yaml` examples), Troubleshooting, Generating Support Bundles.
  - Generic - no customer-specific values.
- `.gitignore`:
  - Add `build/`, `*.tgz`, `.DS_Store`, `node_modules/`, `.env`.
- `README.md`:
  - Rewrite to explain dual use: (1) Replicated release management for engineers, and (2) support ticket engagement for customers.
  - Include quickstart: `bin/setup.sh`, `make lint`, `make release`.
  - Link to `docs/README.md` for customer installation details.
  - Explain the repository structure briefly.

**Patterns to follow:**
- `copia-automation-replicated/README.md` structure but generic and concise.
- `copia-automation-replicated/docs/README.md` structure but generic.

**Test scenarios:**
- Structural: `grep -iE 'kots|manifests/' README.md` returns no matches (no old terminology).
- Structural: `grep -E 'make (lint|release|manifests|charts)' CLAUDE.md` returns matches.
- Structural: `.gitignore` contains `build/` and `*.tgz`.

**Verification:**
- `CLAUDE.md` is present and describes the build workflow.
- `docs/README.md` is present and contains installation instructions.
- `README.md` is rewritten and no longer references KOTS or the old `manifests/` directory.
- `.gitignore` ignores `build/` and `*.tgz`.
- Generic-ness: `grep -ri 'copia' --include='*.yaml' --include='*.yml' --include='*.md' .` returns no matches (case-insensitive).

---

### U9. Add npm Tooling and Husky Hooks

**Goal:** Include `package.json`, `package-lock.json`, and `.husky/` for Node-based linting and git hooks.

**Requirements:** R1, R4

**Dependencies:** U5

**Files:**
- Create: `package.json`
- Create: `package-lock.json` (generated)
- Create: `.husky/pre-commit`
- Create: `.husky/post-commit`

**Approach:**
- `package.json`: Define `scripts` for `lint` (runs `script/lint-helm`, `script/lint-shellcheck`, `script/lint-editorconfig`), `test` (runs `script/test`).
- Include devDependencies: `husky`, `editorconfig-checker` (or equivalent). Note: `shellcheck` is typically a system package; do not rely on an npm wrapper unless one is verified.
- `.husky/pre-commit`: Run `npm run lint`. Document in `README.md` that users can bypass with `git commit --no-verify` if they haven't run `bin/setup.sh` yet.
- `.husky/post-commit`: Optional (e.g., update changelog or notify).
- `package-lock.json` is generated during implementation (`npm install`) and committed.

**Patterns to follow:**
- `copia-automation-replicated/package.json` structure but generic.

**Test scenarios:**
- Happy path: `npm install` succeeds.
- Happy path: `npm run lint` succeeds when all code is clean.
- Error path: `npm run lint` fails if Helm chart is broken.

**Verification:**
- `npm install` completes without errors.
- `npm run lint` executes all linting scripts.
- `git commit` triggers pre-commit hook successfully.

---

## System-Wide Impact

- **Interaction graph:** The new GitHub workflows (`release.yaml`, `lint.yaml`) interact with `Makefile` targets. Issue workflows interact with GitHub Issues API.
- **Error propagation:** `make lint` must fail CI if `replicated release lint` fails. `make release` must not create partial releases on lint failure.
- **State lifecycle risks:** `build/` directory is ephemeral and `.gitignore`d. Care must be taken in `Makefile` to not accidentally commit build artifacts.
- **API surface parity:** The `release.yaml` workflow should support both `push` and `workflow_dispatch` triggers.
- **Unchanged invariants:** The `.git/` directory is untouched. Existing git history is preserved.

---

## Risks & Dependencies

| Risk | Mitigation |
|------|------------|
| Generic placeholder chart is too minimal and still deleted by users | Include standard patterns (Deployment, Service, Ingress, helpers) that demonstrate Helm best practices and are genuinely useful as a starting point. |
| Copia-specific workflow logic leaks into generic templates | Review all copied workflow files and strip org names, repo names, and customer-specific conditions. Use `sed` to replace `copia` with `app` or generic placeholders. |
| `Makefile` assumes `replicated` CLI is installed | Document prerequisite in `README.md` and `bin/setup.sh`. Makefile targets should fail with clear error messages if CLI is missing. |
| Users unfamiliar with Helm may struggle with the new structure | Provide clear `docs/README.md` and `CLAUDE.md` instructions. Keep a Troubleshooting section. |

---

## Documentation / Operational Notes

- **Branch strategy:** Create a feature branch (e.g., `feat/modernize-template`) for this restructure. Before merging, create a git tag `legacy/kots-template` on the pre-change commit so users can reference the old KOTS starter. Merge via PR to preserve review history.
- After implementation, verify that the repository can be used as a GitHub Template Repository (the original intent per old README).
- Update any external documentation (e.g., Replicated internal wiki, onboarding runbooks) that references `manifests/` or the old workflow syntax.
- The `README.md` should explicitly call out that this is a **modern, Helm-based** starter and link to legacy KOTS starter if needed.

---

## Sources & References

- **Origin document:** None (direct request from user).
- **Template source repository:** `/Users/chuck/workspace/accounts/copia/copia-automation-replicated`
- **Current repository:** `/Users/chuck/workspace/replicated-starter-kots`
- **Strategy document:** `STRATEGY.md` (in current repository)
- External docs:
  - Replicated Vendor CLI: https://docs.replicated.com/vendor/cli-install
  - Replicated Helm: https://docs.replicated.com/vendor/helm-install
  - Troubleshoot.sh: https://troubleshoot.sh/
