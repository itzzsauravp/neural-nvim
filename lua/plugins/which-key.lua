-- This plugin provides a popup window with all available keybindings

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- Delay in ms before the popup appears
  end,
  opts = {
    -- Basic configuration
    preset = "classic", -- Can be "classic", "modern", or "helix"
    win = {
      border = "rounded",
    },
    -- This helps which-key recognize your leader groups
    spec = {
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Code/Close" },
      { "<leader>f", group = "Find/File" },
      { "<leader>g", group = "Git/Glance" },
    },
  },
}
