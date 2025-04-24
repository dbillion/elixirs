#!/bin/bash

# Exit on any error
set -e

echo "Installing rpk CLI for Redpanda..."

# Create a temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download the Redpanda RPK CLI
curl -LO https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip

# Install unzip if not available
if ! command -v unzip &> /dev/null; then
    echo "Installing unzip..."
    apt-get update && apt-get install -y unzip
fi

# Unzip the package
unzip rpk-linux-amd64.zip

# Move to bin directory
sudo mv rpk /usr/local/bin/
chmod +x /usr/local/bin/rpk

# Verify installation
rpk version

# Clean up
cd -
rm -rf "$TMP_DIR"

echo "rpk CLI installation completed successfully!"