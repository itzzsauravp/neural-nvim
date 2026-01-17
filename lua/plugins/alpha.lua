-- lua/plugins/alpha.lua
return {
	"goolord/alpha-nvim",
	lazy = false,
	priority = 1000,
	dependencies = { "nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- [Your Header/Buttons/Footer logic remains the same]
		dashboard.section.header.val = {
			[[                                                     ]],
			[[  ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗     ]],
			[[  ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║     ]],
			[[  ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║     ]],
			[[  ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║     ]],
			[[  ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗]],
			[[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝]],
			[[                                                     ]],
			[[                N E U R A L  •  I D E                ]],
			[[                                                     ]],
		}

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
			dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
		}

		local alpha_group = vim.api.nvim_create_augroup("AlphaLogic", { clear = true })

		-- 1. Auto-close Alpha when a real file is opened
		vim.api.nvim_create_autocmd("BufEnter", {
			group = alpha_group,
			callback = function()
				local bufs = vim.fn.getbufinfo({ buflisted = 1 })
				if #bufs > 1 then
					for _, buf in ipairs(bufs) do
						if vim.bo[buf.bufnr].filetype == "alpha" then
							vim.api.nvim_buf_delete(buf.bufnr, { force = true })
						end
					end
				end
			end,
		})

		-- 2. Open Alpha and WIPE the No-Name buffer
		vim.api.nvim_create_autocmd("BufDelete", {
			group = alpha_group,
			callback = function()
				vim.schedule(function()
					local bufs = vim.fn.getbufinfo({ buflisted = 1 })

					-- Filter out NvimTree from the count so it doesn't count as a "real" buffer
					local real_bufs = {}
					for _, b in ipairs(bufs) do
						local ft = vim.bo[b.bufnr].filetype
						if ft ~= "NvimTree" and ft ~= "alpha" then
							table.insert(real_bufs, b)
						end
					end

					-- If no real buffers are left, or only a No-Name is left
					if #real_bufs == 0 then
						-- Check if we are currently looking at a No-Name buffer
						local curr_buf = vim.api.nvim_get_current_buf()
						local name = vim.api.nvim_buf_get_name(curr_buf)
						local ft = vim.bo[curr_buf].filetype

						if name == "" and ft == "" then
							vim.cmd("Alpha")
							-- WIPEOUT (not just delete) the empty buffer to remove it from tabline
							vim.api.nvim_buf_delete(curr_buf, { force = true })
						elseif ft ~= "alpha" then
							vim.cmd("Alpha")
						end
					end
				end)
			end,
		})

		alpha.setup(dashboard.opts)
	end,
}
