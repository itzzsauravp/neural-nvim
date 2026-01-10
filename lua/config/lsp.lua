-- 1. Setup Mason (The binary manager)
require("mason").setup()

-- 2. Setup Tool Installer
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
    "eslint_d",
    "prisma-language-server",
  },
})

-- 3. Setup the Bridge
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup()

-- 4. Native Neovim LSP Configuration (Global)
vim.lsp.config('*', {
  root_markers = {
    ".git",
    "package.json",
    "go.mod",
    "Cargo.toml",
    "ols.json",
    "Makefile",
    "schema.prisma" -- Added for Prisma
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- 5. THE UNIVERSAL LOOP
-- This handles everything from Odin to Prisma automatically
for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  -- Special case: Mason calls it 'prisma-language-server'
  -- but lspconfig usually needs 'prismals'
  if server == "prisma-language-server" then
    vim.lsp.enable("prismals")
  else
    vim.lsp.enable(server)
  end
end
