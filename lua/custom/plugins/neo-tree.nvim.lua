return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  config = function()
    require('neo-tree').setup {
      window = {
        position = 'left',
        width = 20, -- Set the width of the NeoTree window to 20 columns
      },
      filesystem = {
        -- OS-level file watching: terminal mv/rm/git operations reflect
        -- in the tree automatically, no manual refresh needed.
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        filtered_items = {
          visible = true,
          hide_dotfiles = false, -- Show dotfiles in the NeoTree
          hide_by_name = {
            'node_modules',
          },
        },
      },
    }
  end,
}
