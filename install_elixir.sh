#!/bin/bash
# Script to install Elixir and Erlang using asdf
# Usage: ./install_elixir.sh [framework] [framework_version]
# Direct install: ./install_elixir.sh --direct [elixir_version] [erlang_version]

set -e

# Define compatibility matrices
declare -A phoenix_compatibility=(
  ["1.7.10"]="elixir:1.14.0-1.16.0 erlang:24.0-26.2"
  ["1.7.9"]="elixir:1.14.0-1.16.0 erlang:24.0-26.2"
  ["1.7.0"]="elixir:1.13.0-1.16.0 erlang:23.0-26.0"
  ["1.6.16"]="elixir:1.12.0-1.15.0 erlang:22.0-25.3"
  ["1.6.0"]="elixir:1.12.0-1.15.0 erlang:22.0-25.0"
  ["1.5.0"]="elixir:1.10.0-1.14.5 erlang:21.0-24.3"
)

declare -A broadway_compatibility=(
  ["1.0.7"]="elixir:1.11.0-1.16.0 erlang:23.0-26.2"
  ["1.0.0"]="elixir:1.11.0-1.16.0 erlang:22.0-26.0"
  ["0.6.0"]="elixir:1.7.0-1.13.4 erlang:21.0-24.3"
)

declare -A nerves_compatibility=(
  ["1.10.0"]="elixir:1.13.0-1.16.0 erlang:24.0-26.2"
  ["1.9.0"]="elixir:1.11.0-1.15.7 erlang:23.0-25.3"
  ["1.8.0"]="elixir:1.10.0-1.14.5 erlang:22.3-24.3"
  ["1.7.0"]="elixir:1.10.0-1.13.4 erlang:22.0-24.0"
)

# Function to check if ASDF is installed
check_asdf() {
  if ! command -v asdf &> /dev/null; then
    echo "ASDF is not installed. Installing now..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
    echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
    echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
    source ~/.asdf/asdf.sh
  fi
}

# Function to ensure plugins are installed
ensure_plugins() {
  if ! asdf plugin list | grep -q "erlang"; then
    echo "Adding Erlang plugin..."
    asdf plugin add erlang
  fi
  
  if ! asdf plugin list | grep -q "elixir"; then
    echo "Adding Elixir plugin..."
    asdf plugin add elixir
  fi
  
  # Set environment variables to skip documentation building
  # This avoids needing xsltproc and fop
  export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx --without-odbc --disable-docs"
  export KERL_BUILD_DOCS="no"
  
  # Ensure SSL certificates are available 
  mkdir -p ~/.mix
  if [ ! -f ~/.mix/ca-bundle.crt ]; then
    echo "Downloading CA certificate bundle for SSL verification..."
    curl -s -o ~/.mix/ca-bundle.crt https://curl.se/ca/cacert.pem
  fi
  
  # Set SSL certificate environment variables
  export SSL_CERT_FILE=$HOME/.mix/ca-bundle.crt
  export HEX_CACERTS_PATH=$HOME/.mix/ca-bundle.crt
  
  # Add these to bashrc if not already there
  if ! grep -q "SSL_CERT_FILE" ~/.bashrc; then
    echo 'export SSL_CERT_FILE=$HOME/.mix/ca-bundle.crt' >> ~/.bashrc
    echo 'export HEX_CACERTS_PATH=$HOME/.mix/ca-bundle.crt' >> ~/.bashrc
  fi
}

# Function to parse version range
parse_version_range() {
  local version_str=$1
  local lang=$2
  
  # Extract min and max versions
  local min_version=$(echo $version_str | cut -d':' -f2 | cut -d'-' -f1)
  local max_version=$(echo $version_str | cut -d':' -f2 | cut -d'-' -f2)
  
  echo "Compatible ${lang^} versions: $min_version to $max_version"
  
  # Return latest compatible version by default
  echo $max_version
}

# Function to install specific versions
install_specific_versions() {
  local elixir_version=$1
  local erlang_version=$2
  
  # Check ASDF installation
  check_asdf
  
  # Ensure plugins
  ensure_plugins
  
  # Install Erlang
  if [[ ! -z "$erlang_version" ]]; then
    echo "Installing Erlang $erlang_version..."
    asdf install erlang $erlang_version
    asdf local erlang $erlang_version
  fi
  
  # Install Elixir
  if [[ ! -z "$elixir_version" ]]; then
    echo "Installing Elixir $elixir_version..."
    asdf install elixir $elixir_version
    asdf local elixir $elixir_version
  fi
  
  # Create/update .tool-versions file
  echo "Creating .tool-versions file..."
  if [[ ! -z "$erlang_version" ]]; then
    echo "erlang $erlang_version" > .tool-versions
  fi
  if [[ ! -z "$elixir_version" ]]; then
    echo "elixir $elixir_version" >> .tool-versions
  fi
  
  if [[ ! -z "$elixir_version" ]]; then
    # Install hex and rebar
    echo "Installing Hex package manager..."
    mix local.hex --force
    echo "Installing rebar..."
    mix local.rebar --force
  fi
  
  # Add ASDF to shell config if not already there
  if ! grep -q "asdf.sh" ~/.bashrc; then
    echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  fi
  
  echo ""
  echo "✅ Installation completed!"
  if [[ ! -z "$erlang_version" ]]; then
    echo "- Erlang $erlang_version"
  fi
  if [[ ! -z "$elixir_version" ]]; then
    echo "- Elixir $elixir_version"
  fi
  echo ""
  echo "Run 'asdf current' to verify your installation."
  echo "To make Elixir available in your terminal, run 'source ~/.bashrc' or start a new terminal session."
}

# Function to install framework
install_framework() {
  local framework=$1
  local version=$2
  
  case $framework in
    phoenix)
      echo "Installing Phoenix $version..."
      mix archive.install hex phx_new $version --force
      ;;
    broadway)
      echo "Broadway is a package that should be added to your project's dependencies."
      echo "Add the following to your mix.exs file:"
      echo '{:broadway, "~> '$version'"}'
      ;;
    nerves)
      echo "Installing Nerves $version..."
      mix archive.install hex nerves_bootstrap --force
      ;;
  esac
}

# Main function
main() {
  local framework=$1
  local framework_version=$2
  
  # Check if this is a direct installation request
  if [[ "$1" == "--direct" ]]; then
    local elixir_version=$2
    local erlang_version=$3
    
    if [[ -z "$elixir_version" && -z "$erlang_version" ]]; then
      echo "Usage for direct installation: ./install_elixir.sh --direct [elixir_version] [erlang_version]"
      echo "Example: ./install_elixir.sh --direct 1.12.0-otp-24 24.0.1"
      echo ""
      echo "For Node.js management, we recommend using Volta:"
      echo "curl https://get.volta.sh | bash"
      exit 1
    fi
    
    install_specific_versions "$elixir_version" "$erlang_version"
    exit 0
  fi
  
  if [[ -z "$framework" || -z "$framework_version" ]]; then
    echo "Usage: ./install_elixir.sh [framework] [framework_version]"
    echo "Supported frameworks: phoenix, broadway, nerves"
    echo ""
    echo "For direct installation of specific versions:"
    echo "./install_elixir.sh --direct [elixir_version] [erlang_version]"
    echo ""
    echo "For Node.js management, we recommend using Volta:"
    echo "curl https://get.volta.sh | bash"
    exit 1
  fi
  
  # Select the right compatibility map
  local compatibility_map
  case $framework in
    phoenix)
      compatibility_map="${phoenix_compatibility[$framework_version]}"
      ;;
    broadway)
      compatibility_map="${broadway_compatibility[$framework_version]}"
      ;;
    nerves)
      compatibility_map="${nerves_compatibility[$framework_version]}"
      ;;
    *)
      echo "Unsupported framework: $framework"
      echo "Supported frameworks: phoenix, broadway, nerves"
      exit 1
      ;;
  esac
  
  if [[ -z "$compatibility_map" ]]; then
    echo "Unknown version $framework_version for $framework"
    exit 1
  fi
  
  # Extract compatibility info
  local elixir_versions=$(echo $compatibility_map | grep -o "elixir:[^ ]*" || echo "")
  local erlang_versions=$(echo $compatibility_map | grep -o "erlang:[^ ]*" || echo "")
  
  # Install compatible versions
  check_asdf
  ensure_plugins
  
  if [[ ! -z "$erlang_versions" ]]; then
    local erlang_version=$(parse_version_range "$erlang_versions" "erlang")
    echo "Installing Erlang $erlang_version..."
    asdf install erlang $erlang_version
    asdf local erlang $erlang_version
  fi
  
  if [[ ! -z "$elixir_versions" ]]; then
    local elixir_version=$(parse_version_range "$elixir_versions" "elixir")
    echo "Installing Elixir $elixir_version..."
    asdf install elixir $elixir_version
    asdf local elixir $elixir_version
  fi
  
  # Create/update .tool-versions file
  echo "Creating .tool-versions file..."
  echo "erlang $erlang_version" > .tool-versions
  echo "elixir $elixir_version" >> .tool-versions
  
  # Install hex
  echo "Installing Hex package manager..."
  mix local.hex --force
  echo "Installing rebar..."
  mix local.rebar --force
  
  # Install framework
  install_framework $framework $framework_version
  
  echo ""
  echo "✅ Installation completed!"
  echo "- Erlang $erlang_version"
  echo "- Elixir $elixir_version"
  echo "- $framework $framework_version"
  echo ""
  echo "Run 'elixir -v' to verify your installation."
  echo "To make Elixir available in your terminal, run 'source ~/.bashrc' or start a new terminal session."
}

# Run the main function
main "$@"