# Enterprise Portal Branding

This directory contains branding configuration for the Replicated Enterprise Portal.

## Files

- `branding.yaml` - Branding configuration (colors, logos, contact info)
- `assets/` - Directory for logo and favicon images

## Usage

1. Update `branding.yaml` with your application's branding details
2. Add your logo and favicon to the `assets/` directory
3. Uncomment the `logo` and `favicon` lines in `branding.yaml`
4. Upload to the Replicated Vendor Portal or via the Replicated API

## Example

```yaml
title: "My Application"
overview: "Welcome to My Application"
supportPortalLink: "https://support.example.com"
contact: "support@example.com"
logo: assets/logo.png
favicon: assets/favicon.png
primaryColor: "#0d6efd"
```
