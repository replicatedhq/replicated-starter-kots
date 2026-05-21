#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

detect_platform() {
  case "$(uname -s)" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      echo "linux"
      ;;
    *)
      echo "unknown"
      ;;
  esac
}

PLATFORM=$(detect_platform)

install_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    if [ "$PLATFORM" = "macos" ]; then
      echo "Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
      echo "Homebrew is not available on this platform. Please install the required tools manually."
      return 1
    fi
  fi
}

install_dependencies() {
  if [ "$PLATFORM" = "macos" ] && command -v brew >/dev/null 2>&1; then
    if [ -f "${PROJECT_ROOT}/Brewfile" ]; then
      echo "Installing dependencies from Brewfile..."
      brew bundle --file="${PROJECT_ROOT}/Brewfile"
    fi
  elif [ "$PLATFORM" = "linux" ]; then
    echo "Linux detected. Please ensure the following tools are installed:"
    echo "  - helm"
    echo "  - yq"
    echo "  - jq"
    echo "  - shellcheck"
    echo ""
    echo "You can typically install these via:"
    echo "  apt-get install shellcheck jq  # Debian/Ubuntu"
    echo "  or"
    echo "  snap install helm yq          # snap packages"
  fi
}

install_helm_plugins() {
  echo "Installing Helm plugins..."
  if command -v helm >/dev/null 2>&1; then
    if ! helm plugin list | grep -q "unittest"; then
      helm plugin install https://github.com/helm-unittest/helm-unittest.git
    else
      echo "Helm unittest plugin already installed."
    fi
  else
    echo "Helm not found. Please install Helm first."
  fi
}

install_node_deps() {
  if [ -f "${PROJECT_ROOT}/package.json" ]; then
    if [ ! -d "${PROJECT_ROOT}/node_modules" ]; then
      echo "Installing Node.js dependencies..."
      if command -v npm >/dev/null 2>&1; then
        npm install
      else
        echo "npm not found. Skipping Node.js dependencies."
      fi
    else
      echo "Node.js dependencies already installed."
    fi
  fi
}

main() {
  echo "======================================"
  echo "Developer Environment Setup"
  echo "======================================"
  echo ""

  install_homebrew || true
  install_dependencies
  install_helm_plugins
  install_node_deps

  echo ""
  echo "Setup complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Ensure you have the Replicated CLI installed: https://docs.replicated.com/vendor/cli-install"
  echo "  2. Set REPLICATED_APP and REPLICATED_API_TOKEN environment variables"
  echo "  3. Run 'make lint' to validate your changes"
  echo "  4. Run 'make release' to create a Replicated release"
}

main "$@"
