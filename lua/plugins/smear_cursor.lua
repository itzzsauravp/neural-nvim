return {
  "sphamba/smear-cursor.nvim",
  -- This line prevents the plugin from loading if Neovide is running
  enabled = not vim.g.neovide,

  opts = {
    -- PHYSICS: Lower stiffness = Longer, more elastic trail
    stiffness = 0.6,
    trailing_stiffness = 0.1,
    damping = 0.7,

    -- TIMING: Critical for 180Hz
    time_interval = 4,

    -- TAIL LENGTH:
    min_horizontal_distance_smear = 1,
    min_vertical_distance_smear = 1,

    -- VISUALS: Set to true for a smoother "non-blocky" look
    legacy_computing_symbols_support = true,

    -- Ensure it doesn't cut off during big jumps
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
  },
}
