local keymap = vim.keymap

-----------------------------------------------------------
-- 1. General Editor Binds
-----------------------------------------------------------
-- Exit Insert Mode
keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit Insert mode" })

-- Search
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Toggle Word Wrap (Visual Separation)
keymap.set("n", "<leader>ww", function()
	vim.opt.wrap = not vim.opt.wrap:get()
	vim.notify("Word Wrap: " .. (vim.opt.wrap:get() and "Enabled" or "Disabled"))
end, { desc = "Toggle Word Wrap" })

-----------------------------------------------------------
-- 2. File & Buffer Management (Enhanced with BufDelete)
-----------------------------------------------------------

-- Quick Save/Quit
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", ":qa<CR>", { desc = "Quit all" })
keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and Close" })

-- Buffer Navigation (Shift + H/L)
keymap.set("n", "<S-L>", ":bnext<CR>", { desc = "Next Buffer" })
keymap.set("n", "<S-H>", ":bprevious<CR>", { desc = "Prev Buffer" })

-- Smart Close Current Buffer (Using bufdelete.nvim)
-- This prevents the "No-Name" buffer and keeps your window layout stable
keymap.set("n", "<leader>c", ":Bdelete<CR>", { desc = "Close Current Buffer" })
keymap.set("n", "<leader>C", ":Bdelete!<CR>", { desc = "Force Close Current Buffer" })

-- NEW: Advanced Buffer Closing (VS Code Style)
-- Close all buffers
keymap.set("n", "<leader>ba", ":%bd<CR>", { desc = "Close All Buffers" })

-- Close all buffers EXCEPT the current one
-- Using Bdelete prevents the screen from flickering to an empty buffer
keymap.set("n", "<leader>bo", ":%bd|e#|Bdelete#<CR>", { desc = "Close Others" })

-- Close buffers to the LEFT or RIGHT (Using Bufferline commands)
keymap.set("n", "<leader>br", ":BufferLineCloseRight<CR>", { desc = "Close Buffers to the Right" })
keymap.set("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { desc = "Close Buffers to the Left" })

-- Buffer Ordering (Bufferline)
keymap.set("n", "<leader>bL", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })
keymap.set("n", "<leader>bH", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })

-----------------------------------------------------------
-- 3. Layout & Window Management
-----------------------------------------------------------
-- File Explorer (NvimTree)
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })

-- Splits
keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Split Vertical" })
keymap.set("n", "<leader>h", ":split<CR>", { desc = "Split Horizontal" })

-- Window Navigation (Ctrl + hjkl)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to Bottom Window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to Top Window" })

-----------------------------------------------------------
-- 4. Diagnostics (Global) - Reading those red/yellow lines
-----------------------------------------------------------
-- This replaces leader e (which you use for Explorer)
-- with leader df to see the error message in a soft dark window
keymap.set("n", "<leader>df", function()
	vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Diagnostic Float (Read Error)" })

keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic List (Quickfix)" })

-- Close the location list window specifically
keymap.set("n", "<leader>lc", ":lclose<CR>", { desc = "Close LocList Window" })
-----------------------------------------------------------
-- 5. LSP Specific Binds (Only active when LSP is attached)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Universal Go-To-Definition (Multi-language support)
		keymap.set("n", "gd", function()
			if client and client.name == "ts_ls" then
				client:request("workspace/executeCommand", {
					command = "_typescript.goToSourceDefinition",
					arguments = { vim.uri_from_bufnr(ev.buf), vim.lsp.util.make_position_params().position },
				}, function(err, result)
					if err or not result or not result[1] then
						vim.lsp.buf.definition()
					else
						vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
					end
				end, ev.buf)
			else
				-- Standard for Rust, Go, C, Odin, etc.
				vim.lsp.buf.definition()
			end
		end, { buffer = ev.buf, desc = "Go to Definition" })

		-- Peek Views (Glance)
		keymap.set("n", "gp", "<CMD>Glance definitions<CR>", { buffer = ev.buf, desc = "Peek Definition" })
		keymap.set("n", "gy", "<CMD>Glance type_definitions<CR>", { buffer = ev.buf, desc = "Peek Type" })
		keymap.set("n", "gr", "<CMD>Glance references<CR>", { buffer = ev.buf, desc = "Peek References" })

		-- Standard LSP Actions
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, { desc = "Hover Documentation" })

		-- For Code Actions
		vim.keymap.set("n", "<leader>ca", function()
			vim.lsp.buf.code_action({ border = "rounded" })
		end, { desc = "Code Action" })

		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
	end,
})

-----------------------------------------------------------
-- 6. Git Integration (VS Code Style)
-----------------------------------------------------------
-- Open the full Git Status dashboard (Like VS Code Source Control tab)
keymap.set("n", "<leader>gs", ":Neogit<CR>", { desc = "Git Status (Neogit)" })

-- Open a full Diff view of your current changes
keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git Diff View" })

-- Close Diff view
keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Git Diff Close" })

-- Inline Git actions (Gitsigns)
keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { desc = "Git Preview Hunk" })
keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Git Toggle Blame" })

-- Toggle Lazygit in a floating window
keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Lazygit Terminal" })

-----------------------------------------------------------
-- 7. Terminal Management (VS Code Style: Ctrl + /)
-----------------------------------------------------------
local keymap = vim.keymap

-- Normal mode toggles (Mapping both because of terminal behavior)
keymap.set("n", "<C-/>", "<CMD>ToggleTerm<CR>", { desc = "Toggle Terminal" })
keymap.set("n", "<C-_>", "<CMD>ToggleTerm<CR>", { desc = "Toggle Terminal" })

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	keymap.set("t", "jk", [[<C-\><C-n>]], opts)

	-- Toggle OFF from inside the terminal
	keymap.set("t", "<C-/>", [[<C-\><C-n><CMD>ToggleTerm<CR>]], opts)
	keymap.set("t", "<C-_>", [[<C-\><C-n><CMD>ToggleTerm<CR>]], opts)

	-- Navigation
	keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
	keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
	keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
	keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		set_terminal_keymaps()
	end,
})

-----------------------------------------------------------
-- 8. Window Resizing (Mouse-Free)
-----------------------------------------------------------
-- Use Ctrl + Arrow keys to resize windows
-- Vertical Resizing (Width)
vim.keymap.set("n", "<C-Right>", ":vertical resize -5<CR>", { desc = "Resize Window Right" })
vim.keymap.set("n", "<C-Left>", ":vertical resize +5<CR>", { desc = "Resize Window Left" })

-- Horizontal Resizing (Height)
vim.keymap.set("n", "<C-Up>", ":resize +5<CR>", { desc = "Resize Window Up" })
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>", { desc = "Resize Window Down" })

-- Gruvbox background is usually #282828.
-- We'll make popups #1d2021 (Darker) to create "layers."
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1d2021" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ebdbb2", bg = "#1d2021" })

-- This ensures the completion menu (syntax) matches
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1d2021", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#504945", fg = "#ebdbb2" })

-----------------------------------------------------------
-- 9. Git Graph binds
-----------------------------------------------------------
-- Open Git Graph
keymap.set("n", "<leader>gl", function()
	require("gitgraph").draw({}, { all = true, max_count = 5000 })
end, { desc = "Git Graph (Visual Log)" })
