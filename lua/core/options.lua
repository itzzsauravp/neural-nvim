-- basic editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true
vim.opt.conceallevel = 2 -- Added to make Markdown look rendered

-- Trigger autoread when files change on disk
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Disable the built-in file explorer (netrw)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.neovide then
  -- 1. Font Setting (Must match Windows Font Name exactly)
  -- We use :h13 to match your WezTerm font size
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"

  -- 3. Performance & Smoothness
  vim.g.neovide_cursor_animation_length = 0.05 -- Snappy cursor
  vim.g.neovide_scroll_animation_length = 0.3

  -- 4. Window behavior
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_use_logo = 1 -- Enables "Windows Key" binds if needed
end
