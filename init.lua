-- 0. THE GUI/PATH FIX (Must be first)
-- This pulls your PATH from your shell so Neovide can find your LSPs
if vim.g.neovide or vim.fn.has("gui_running") == 1 then
	local shell_path = vim.fn.system("source $HOME/.zshrc; echo $PATH")
	if vim.v.shell_error == 0 then
		vim.env.PATH = shell_path:gsub("%s+", "")
	end
end

-- 1. Leader key (Must be set before lazy.nvim)
vim.g.mapleader = " "

-- 2. Bootstrap lazy.nvim
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

-- 3. Run Lazy Setup
require("lazy").setup({
	spec = { { import = "plugins" } },
	change_detection = { notify = false },
	ui = { border = "rounded" },
})

-- 4. Load Core Configurations
require("core.options")
require("core.keymaps")
require("config.lsp")
require("config.bridge").setup()

-- Apply colorscheme
vim.cmd.colorscheme("elflord")

-- 5. Dashboard & Nvim-Tree Startup Logic
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			local delay = vim.g.neovide and 50 or 10
			vim.defer_fn(function()
				vim.cmd("bwipeout!")
				require("alpha").redraw()
				require("nvim-tree.api").tree.open()
				vim.cmd("wincmd l")
			end, delay)
		end
	end,
})

-- Create an autocmd to save the theme whenever it changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(args)
		-- Don't save if the theme is 'alpha' (the dashboard)
		if args.match ~= "alpha" and args.match ~= "" then
			local theme_cache = vim.fn.stdpath("data") .. "/last_theme.txt"
			local f = io.open(theme_cache, "w")
			if f then
				f:write(args.match)
				f:close()
			end
		end
	end,
})
