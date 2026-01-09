#!/bin/bash

# NEURAL.nvim Installer
echo "🧠 Initializing NEURAL setup..."

# 1. Define paths
NVIM_CONF="$HOME/.config/nvim"
BACKUP_CONF="$HOME/.config/nvim.bak.$(date +%Y%m%d_%H%M%S)"

# 2. Backup existing config if it exists
if [ -d "$NVIM_CONF" ]; then
    echo "📦 Backing up existing config to $BACKUP_CONF"
    mv "$NVIM_CONF" "$BACKUP_CONF"
fi

# 3. Create directory and Clone (Replace with your actual GitHub URL later)
echo "🚀 Cloning NEURAL.nvim..."
git clone https://github.com/itzzsauravp/neural-nvim.git "$NVIM_CONF"

echo "✨ Installation complete! Launch 'nvim' to finish plugin sync."
