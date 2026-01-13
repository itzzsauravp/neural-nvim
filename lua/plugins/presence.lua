return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  event = "VeryLazy",
  opts = {
    user_plugins = true,
    display = {
      theme = "default",
    },
    timestamp = { enabled = true },
    idle = {
      enabled = true,
      timeout = 300000,
    },
    text = {
      -- Terminal status for ToggleTerm
      terminal = "$ sudo rm -rf opps --dry-run",

      editing = function(opts)
        local ext = opts.filename:match("^.+(%..+)$") or ""
        return "Editing " .. ext .. " file"
      end,

      viewing = function(opts)
        local ext = opts.filename:match("^.+(%..+)$") or ""
        return "Viewing " .. ext .. " file"
      end,

      file_browser = "File Browser",
      workspace = "¯\\_(ツ)_/¯",
    },
  },
}
