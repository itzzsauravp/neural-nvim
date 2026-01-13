return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        -- This ensures the "grey out" effect (backdrop) is active
        multi_window = true,
        forward = true,
        wrap = true,
      },
      modes = {
        -- This enables the specific behavior where labels appear during / search
        search = {
          enabled = true,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash Jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
}
