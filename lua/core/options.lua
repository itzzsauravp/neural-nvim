-- basic editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true

-- leader key
vim.g.mapleader = " "

-- use system plugin
vim.opt.clipboard = "unnamedplus"

vim.opt.autoread = true

-- Trigger autoread when files change on disk
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Disable the built-in file explorer (netrw)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
