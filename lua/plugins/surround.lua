return {
  "kylechui/nvim-surround",
  version = "*",   -- Use for stability; omit to use main branch for latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty for defaults
    })
  end
}
