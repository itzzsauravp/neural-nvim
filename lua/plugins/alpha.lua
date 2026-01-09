-- lua/plugins/alpha.lua
return {
  "goolord/alpha-nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- 1. THE HEADER (ASCII ART - NEURAL)
    dashboard.section.header.val = {
      [[                                                     ]],
      [[  ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗     ]],
      [[  ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║     ]],
      [[  ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║     ]],
      [[  ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║     ]],
      [[  ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗]],
      [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝]],
      [[                                                     ]],
      [[               N E U R A L  •  I D E                 ]],
      [[                                                     ]],
    }

    -- 2. THE MENU (Quick Actions)
    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
      dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles<CR>"),
      dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
    }

    -- 3. THE DYNAMIC FOOTER (Plugin count + Start time)
    local function get_footer()
      local stats = require("lazy").stats()
      -- Calculate startup time in ms
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return "⚡ " .. stats.count .. " plugins loaded in " .. ms .. "ms"
    end

    dashboard.section.footer.val = get_footer()
    dashboard.section.footer.opts.hl = "Comment"
    dashboard.section.header.opts.hl = "Function"

    alpha.setup(dashboard.opts)
  end,
}
