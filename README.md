# Elixir Version Management with ASDF

This repository demonstrates how to manage different versions of Elixir and its frameworks using ASDF.

## Setup ASDF

If you haven't installed ASDF yet:

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
```

## Installing Elixir with ASDF

1. Add the Erlang and Elixir plugins:

```bash
asdf plugin add erlang
asdf plugin add elixir
```

2. Install specific versions:

```bash
# Install Erlang (dependency for Elixir)
asdf install erlang 26.2.1

# Install multiple Elixir versions
asdf install elixir 1.16.0
asdf install elixir 1.15.7
asdf install elixir 1.14.5
```

3. Set global or local versions:

```bash
# Set a global version
asdf global elixir 1.16.0

# Set a project-specific version (uses .tool-versions file)
asdf local elixir 1.15.7
```

## Installing Phoenix Framework

After installing Elixir:

```bash
# Install Hex package manager
mix local.hex --force

# Install Phoenix
mix archive.install hex phx_new 1.7.10 --force
```

For a different Phoenix version:

```bash
mix archive.install hex phx_new 1.6.16 --force
```

## Installing Broadway

Broadway is installed as a dependency in your project:

```bash
# Add to mix.exs dependencies:
# {:broadway, "~> 1.0"}

# Then run:
mix deps.get
```

## Switching Between Versions

1. List installed versions:
```bash
asdf list elixir
```

2. Switch version in current directory:
```bash
asdf local elixir 1.14.5
```

3. Check current version:
```bash
elixir --version
```

## Managing Multiple Projects

Each project can have its own `.tool-versions` file specifying its requirements.