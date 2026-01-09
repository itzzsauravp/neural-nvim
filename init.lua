-- Set leader key first
vim.g.mapleader = " "

-----------------------------------------------------------
-- 1. Bootstrap lazy.nvim (Plugin Manager)
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- 2. Run Lazy Setup
-----------------------------------------------------------
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Loads every file in lua/plugins/
  },
  change_detection = { notify = false },
  -- This helps Alpha load faster on startup
  ui = { border = "rounded" },
})

-----------------------------------------------------------
-- 3. Load Core Configurations
-----------------------------------------------------------
require("core.options") -- Ensure vim.opt.autoread = true is in here!
require("core.keymaps")
require("config.lsp")

-----------------------------------------------------------
-- 4. "Vibecoded" Auto-Open Logic (Alpha + Nvim-Tree)
-----------------------------------------------------------
local function open_dashboard()
  -- 1. Close any existing directory buffers
  local bufname = vim.api.nvim_buf_get_name(0)
  if vim.fn.isdirectory(bufname) == 1 then
    vim.cmd("bwipeout!")
  end

  -- 2. Open Alpha
  require("alpha").redraw()

  -- 3. Open Nvim-Tree
  require("nvim-tree.api").tree.open()

  -- 4. Focus back on Alpha
  vim.cmd("wincmd l")
end

-- We use UIEnter because it fires after the window is actually rendered
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      open_dashboard()
    end
  end,
})
