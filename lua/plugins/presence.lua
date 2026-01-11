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
      -- This function finds the extension (e.g., .odin) and displays it
      editing = function(opts)
        local ext = opts.filename:match("^.+(%..+)$") or ""
        return "Editing a " .. ext .. " file"
      end,

      viewing = function(opts)
        local ext = opts.filename:match("^.+(%..+)$") or ""
        return "Inspecting a " .. ext .. " file"
      end,

      file_browser = "In Explorer",
      workspace = "",
    },
  },
}
