#!/usr/bin/env bash
# NEURAL.nvim Installer

set -Eeuo pipefail

echo "🧠 Initializing NEURAL setup..."

REPO_URL="https://github.com/itzzsauravp/neural-nvim.git"
NVIM_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_CONF="${NVIM_CONF}.bak.$(date +%Y%m%d_%H%M%S)"

die() { echo "❌ $*" >&2; exit 1; }

restore_if_needed() {
  # if we moved the config away but didn't finish, restore it.
  if [[ -n "${BACKUP_MADE:-}" && "${BACKUP_MADE}" == "1" ]]; then
    if [[ ! -d "$NVIM_CONF" && -d "$BACKUP_CONF" ]]; then
      echo "↩️  Restoring previous config from $BACKUP_CONF"
      mv "$BACKUP_CONF" "$NVIM_CONF" || true
    fi
  fi
}

cleanup_on_error() {
  local exit_code=$?
  echo "💥 Installation failed (exit $exit_code). Rolling back..."
  # Remove partial clone if it exists
  if [[ -n "${CLONE_STARTED:-}" && "${CLONE_STARTED}" == "1" && -d "$NVIM_CONF" ]]; then
    rm -rf "$NVIM_CONF" || true
  fi
  restore_if_needed
  exit "$exit_code"
}

trap cleanup_on_error ERR INT TERM

command -v git >/dev/null 2>&1 || die "Git is not installed. Install git and retry."

# Ensure parent directory exists
mkdir -p "$(dirname "$NVIM_CONF")"

# If NVIM_CONF exists but is not a directory (file/symlink), don't touch it
if [[ -e "$NVIM_CONF" && ! -d "$NVIM_CONF" ]]; then
  die "Path exists but is not a directory: $NVIM_CONF (refusing to overwrite)."
fi

missing_deps=()
if ! command -v nvim >/dev/null 2>&1; then
  missing_deps+=("neovim")
fi
if ! command -v rg >/dev/null 2>&1; then
  missing_deps+=("ripgrep")
fi
if ! command -v fd >/dev/null 2>&1 && ! command -v fd-find >/dev/null 2>&1; then
  missing_deps+=("fd")
fi
if [[ ${#missing_deps[@]} -gt 0 ]]; then
  echo "⚠️  Missing recommended dependencies: ${missing_deps[*]}"
  if [[ "${OSTYPE:-}" == "darwin"* ]]; then
    echo "👉 Install with Homebrew: brew install neovim ripgrep fd"
  else
    echo "👉 Install with your package manager (e.g., apt, dnf, pacman, brew)."
  fi
fi

if [[ -d "$NVIM_CONF/.git" ]]; then
  if [[ -t 0 ]]; then
    read -r -p "Existing NEURAL.nvim repo found. Update in place with git pull --ff-only? [Y/n] " reply
    reply=${reply:-Y}
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      echo "🔄 Updating existing NEURAL.nvim in: $NVIM_CONF"
      git -C "$NVIM_CONF" pull --ff-only
      echo "✨ Update complete!"
      echo "👉 Next: run 'nvim' to let your plugin manager install/sync plugins."
      exit 0
    fi
  else
    echo "🔄 Existing NEURAL.nvim repo found (non-interactive). Updating in place..."
    git -C "$NVIM_CONF" pull --ff-only
    echo "✨ Update complete!"
    echo "👉 Next: run 'nvim' to let your plugin manager install/sync plugins."
    exit 0
  fi
fi

# Backup existing config dir
if [[ -d "$NVIM_CONF" ]]; then
  echo "📦 Backing up existing config to $BACKUP_CONF"
  mv "$NVIM_CONF" "$BACKUP_CONF"
  BACKUP_MADE="1"
fi

# Clone into place
echo "🚀 Cloning NEURAL.nvim into: $NVIM_CONF"
CLONE_STARTED="1"
git clone --depth 1 "$REPO_URL" "$NVIM_CONF"

# Basic sanity check: confirm we cloned a git repo
[[ -d "$NVIM_CONF/.git" ]] || die "Clone did not produce a valid git repository at $NVIM_CONF"

# Success: disable trap rollback
trap - ERR INT TERM

echo "✨ Installation complete!"
echo "👉 Next: run 'nvim' to let your plugin manager install/sync plugins."
echo "📌 Backup (if any) saved at: $BACKUP_CONF"
