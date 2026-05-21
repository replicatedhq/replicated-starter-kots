---
name: Support Request
about: Create a support request or report an issue
title: '[Support] <short description>'
labels:
  - kind::support-request
  - status::open
body:
  - type: markdown
    attributes:
      value: |
        Thanks for reaching out! Please fill in the details below to help us assist you.
  - type: textarea
    id: description
    attributes:
      label: Description
      description: Describe the issue or request
      placeholder: What happened? What did you expect?
    validations:
      required: true
  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Details about your environment
      placeholder: |
        - Kubernetes version:
        - Replicated version:
        - Application version:
  - type: textarea
    id: bundle_url
    attributes:
      label: Support Bundle URL
      description: If available, provide a support bundle URL
      placeholder: https://...
