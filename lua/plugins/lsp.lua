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
      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "typescript-language-server", "pyright", "lua-language-server",
          "clangd", "prettier", "biome", "eslint_d"
        },
      })

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()

      vim.lsp.config('*', {
        root_markers = { ".git", "package.json", "tsconfig.json" },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
        vim.lsp.enable(server)
      end
    end,
  },
}
