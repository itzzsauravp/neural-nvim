-- lua/plugins/git.lua

return {
  -- 1. Gitsigns: Shows color bars in the gutter and inline blame
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true, -- Shows "You, 3 minutes ago" inline
        current_line_blame_opts = { delay = 500 },
      })
    end,
  },

  -- 2. Neogit: The full-screen "Source Control" view (Press 's' to stage, 'c' to commit)
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- Required for diffing
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        kind = "floating", -- Opens like a VS Code popup
        integrations = { diffview = true },
      })
    end,
  },

  -- 3. Diffview: Specifically for merge conflicts and full file history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  }
}
