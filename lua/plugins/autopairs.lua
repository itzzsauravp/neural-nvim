return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Only load when you start typing
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,      -- Use Treesitter to be smarter (e.g., don't pair in strings)
      ts_config = {
        lua = { "string" }, -- Don't add pairs in lua string nodes
        javascript = { "template_string" },
      },
      fast_wrap = {
        map = "<M-e>", -- Alt+e to wrap an existing word in pairs
      },
    })

    -- If you want it to work with your Autocomplete (CMP)
    -- This makes it so if you select a function, it adds () automatically
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
