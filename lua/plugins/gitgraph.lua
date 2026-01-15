return {
  'isakbm/gitgraph.nvim',
  dependencies = { 'sindrets/diffview.nvim' },
  keys = {
    {
      "<leader>gl",
      function()
        require('gitgraph').draw({}, { all = true, max_count = 5000 })
        -- Set buffer local options to prevent E37/E162
        local buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.bo[buf].swapfile = false
        -- Optional: Press 'q' to quit the graph window
        vim.keymap.set('n', 'q', ':close<CR>', { buffer = buf, silent = true })
      end,
      desc = "GitGraph - Draw",
    },
  },
  opts = {
    symbols = {
      merge_commit = '',
      commit = '',
    },
    format = {
      timestamp = '%H:%M:%S %d-%m-%Y',
      fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
    },
    hooks = {
      on_select_commit = function(commit)
        vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
      end,
    },
  },
  config = function(_, opts)
    require('gitgraph').setup(opts)

    -- THIS IS THE FIX: Manually setting the branch colors
    -- This matches the Gruvbox/VS Code aesthetic
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg1', { fg = '#fb4934' }) -- Red
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg2', { fg = '#b8bb26' }) -- Green
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg3', { fg = '#fabd2f' }) -- Yellow
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg4', { fg = '#83a598' }) -- Blue
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg5', { fg = '#d3869b' }) -- Purple
    vim.api.nvim_set_hl(0, 'GitGraphBranchMsg6', { fg = '#8ec07c' }) -- Aqua
  end
}
