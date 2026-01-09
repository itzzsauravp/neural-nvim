-- ========================================================================== --
-- 1. BASIC EDITOR OPTIONS
-- ========================================================================== --
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.opt.conceallevel = 2    -- Better Markdown rendering
vim.o.winborder = 'rounded' -- Global border preference

-- Disable built-in netrw explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ========================================================================== --
-- 2. UI HIGHLIGHTS (Separation of Concerns)
-- ========================================================================== --
-- NormalFloat: Background of floating windows
-- FloatBorder: The actual outline/border color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1d2021" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7c6f64", bg = "#1d2021" })

-- ========================================================================== --
-- 3. LSP & AUTO-COMPLETE UI
-- ========================================================================== --
local border = "rounded"

-- LSP Hover (K)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = border }
)

-- LSP Signature Help
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, { border = border }
)

-- LSP Rename (fixes <leader>rn)
vim.lsp.handlers["textDocument/rename"] = vim.lsp.with(
  vim.lsp.handlers.rename, { border = border }
)

-- Diagnostic Popups
vim.diagnostic.config({
  float = { border = border },
})

-- nvim-cmp (Syntax Auto-complete)
-- Ensure this runs AFTER cmp is loaded
local ok, cmp = pcall(require, 'cmp')
if ok then
  cmp.setup({
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
end

-- ========================================================================== --
-- 4. AUTOCOMMANDS
-- ========================================================================== --
-- Trigger autoread when files change on disk
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- ========================================================================== --
-- 5. GUI SPECIFIC (NEOVIDE)
-- ========================================================================== --
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"

  -- Performance & Smoothness
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.3

  -- Window behavior
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_use_logo = 1
end
