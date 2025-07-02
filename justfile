# vault-plugin-secrets-nats development tasks

# Set environment variables
export VAULT_ADDR := "http://127.0.0.1:8200"
export VAULT_TOKEN := "root"

# Default recipe - show available commands
default:
    @just --list

# Build the plugin (skipping problematic generate step)
build:
    go build -o vault-plugin-secrets-nats ./cmd/vault-plugin-secrets-nats/

# Clean build artifacts
clean:
    rm -f vault-plugin-secrets-nats
    go clean -cache

# Start Vault in dev mode with plugin support
start-vault: build
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Kill any existing vault process
    pkill vault || true
    sleep 2
    
    # Create a clean plugin directory
    mkdir -p ./plugins
    cp vault-plugin-secrets-nats ./plugins/
    
    echo "🚀 Starting Vault in dev mode..."
    vault server -dev \
        -dev-root-token-id=root \
        -dev-plugin-dir=$(pwd)/plugins \
        -log-level=info &
    
    echo "⏳ Waiting for Vault to start..."
    sleep 5
    
    # Wait for vault to be ready
    for i in {1..10}; do
        if vault status &>/dev/null; then
            break
        fi
        echo "Still waiting for Vault..."
        sleep 2
    done
    
    echo "✅ Vault started at $VAULT_ADDR"
    echo "🔑 Root token: $VAULT_TOKEN"

# Register and enable the NATS secrets plugin
enable-plugin: build
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Ensure plugin is in the plugins directory
    mkdir -p ./plugins
    cp vault-plugin-secrets-nats ./plugins/
    
    SHA256SUM=$(sha256sum ./plugins/vault-plugin-secrets-nats | cut -d' ' -f1)
    echo "📦 Plugin SHA256: $SHA256SUM"
    
    # Wait for vault to be ready
    echo "⏳ Waiting for Vault to be ready..."
    for i in {1..15}; do
        if vault status &>/dev/null; then
            echo "✅ Vault is ready"
            break
        fi
        if [ $i -eq 15 ]; then
            echo "❌ Vault not ready after 30 seconds"
            exit 1
        fi
        sleep 2
    done
    
    echo "📝 Registering plugin..."
    vault plugin register -sha256=${SHA256SUM} secret vault-plugin-secrets-nats
    
    echo "🔌 Enabling plugin at nats-secrets/ ..."
    vault secrets enable -path=nats-secrets vault-plugin-secrets-nats
    
    echo "✅ Plugin enabled! Check with: vault secrets list"

# Stop Vault
stop-vault:
    pkill vault || echo "No vault process found"

# List enabled secrets engines
list-secrets:
    vault secrets list

# Run tests
test:
    go test ./...

# Run tests with verbose output
test-verbose:
    go test -v ./...

# Check code with linter (if available)
lint:
    golangci-lint run || echo "golangci-lint not available"

# Show plugin status and basic info
status:
    @echo "🔍 Vault Status:"
    @vault status || echo "Vault not running"
    @echo ""
    @echo "🔌 Secrets Engines:"
    @vault secrets list 2>/dev/null || echo "Cannot connect to vault"
    @echo ""
    @echo "📦 Plugin Binary:"
    @ls -la vault-plugin-secrets-nats 2>/dev/null || echo "Plugin not built"

# Clean everything (vault, plugin, artifacts)
reset: stop-vault clean
    echo "🧹 Everything cleaned up!"