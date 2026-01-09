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
  if [[ -d "$NVIM_CONF" ]]; then
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

# Backup existing config dir
if [[ -d "$NVIM_CONF" ]]; then
  echo "📦 Backing up existing config to $BACKUP_CONF"
  mv "$NVIM_CONF" "$BACKUP_CONF"
  BACKUP_MADE="1"
fi

# Clone into place
echo "🚀 Cloning NEURAL.nvim into: $NVIM_CONF"
git clone --depth 1 "$REPO_URL" "$NVIM_CONF"

# Basic sanity check: confirm we cloned a git repo
[[ -d "$NVIM_CONF/.git" ]] || die "Clone did not produce a valid git repository at $NVIM_CONF"

# Success: disable trap rollback
trap - ERR INT TERM

echo "✨ Installation complete!"
echo "👉 Next: run 'nvim' to let your plugin manager install/sync plugins."
echo "📌 Backup (if any) saved at: $BACKUP_CONF"
