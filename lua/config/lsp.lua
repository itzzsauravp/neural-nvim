-- This file manages the installation and activation of all Language Servers (C, Go, Rust, Odin, etc.)
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- 1. Setup Mason (The binary manager)
      require("mason").setup()

      -- 2. Setup Tool Installer (The "ensure_installed" list)
      require("mason-tool-installer").setup({
        ensure_installed = {
          "typescript-language-server",
          "pyright",
          "lua-language-server",
          "clangd",        -- C/C++
          "gopls",         -- Go
          "rust-analyzer", -- Rust
          "ols",           -- Odin
          "prettier",
          "eslint_d"
        },
      })

      -- 3. Setup the Bridge
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()

      -- 4. Native Neovim 0.11 Configuration
      -- This applies to EVERY server installed
      vim.lsp.config('*', {
        root_markers = {
          ".git",         -- Universal
          "package.json", -- JS/TS
          "go.mod",       -- Go
          "Cargo.toml",   -- Rust
          "ols.json",     -- Odin
          "Makefile"      -- C/Universal
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      -- 5. THE UNIVERSAL LOOP
      -- This enables every server you install via Mason automatically
      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        vim.lsp.enable(server)
      end
    end,
  },
}
