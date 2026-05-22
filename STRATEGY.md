---
name: Replicated Starter
last_updated: 2026-05-21
---

# Replicated Starter Strategy

## Target problem

Replicated's collaboration repository template has become stale over 2–3 years and is still KOTS-focused, even though Replicated has moved on from KOTS. The baseline code is immediately deleted by customers and Replicated engineers, undermining the shared starting point for support and proof-of-value engagements.

## Our approach

Give an agent ownership of keeping the template current. Automate maintenance so the template evolves with Replicated's platform and does not depend on a single person remembering to update it.

## Who it's for

**Primary:** Replicated team members and onboarding automation setting up a new customer collaboration repo. They're hiring this template to bootstrap a working support and code-sharing baseline so the customer engagement can start immediately.

## Key metrics

- **Customer release tracking adoption** — % of new collaboration repos using the template's release tracking (measured in new repo analysis)
- **Template deletion rate** — % of template files deleted within the first week (measured in new repo analysis)
- **Engineer baseline reuse** — % of template code retained vs. rewritten by Replicated engineers (measured in pull request or commit review)

## Tracks

### Restructure to current practices

Restructure the repository layout to match how Replicated engineers set up a repository today, moving away from KOTS-specific structure.

_Why it serves the approach:_ A stale KOTS structure is the first thing engineers delete; a current platform-agnostic one is the first thing they keep.

### Rewrite README for dual use

Rewrite the README to explain how to use the repository for managing Replicated releases and for interacting with support tickets.

_Why it serves the approach:_ Customers cannot adopt what they do not understand; clarity drives both release management and support ticket engagement.

### Add agent-friendly files

Bring in files and structure that allow AI agents to be successful when supporting customers through this repository.

_Why it serves the approach:_ Agentic support is part of Replicated's future onboarding; the template must be ready for it.
