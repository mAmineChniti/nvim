return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  lazy = false, -- load at startup so VimEnter auto-open works
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
      close_if_last_window = false, -- keep tree open when opening files
      window = {
        position = 'left',
        width = 20, -- Set the width of the NeoTree window to 20 columns
      },
      filesystem = {
        -- open_default: directory opens as left sidebar, files open in main window.
        -- open_current (netrw style) replaces the tree window with the file,
        -- which is why the tree seemed to "disappear" on file open.
        hijack_netrw_behavior = 'open_default',
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

    -- Auto-open on startup: `nvim` and `nvim file`
    -- `show` reveals the tree without stealing focus from a file.
    -- NOTE: `nvim <dir>` is already handled by hijack_netrw_behavior,
    -- so we skip it here to avoid opening the tree twice.
    local auto_open_group = vim.api.nvim_create_augroup('NeoTreeAutoOpen', { clear = true })
    vim.api.nvim_create_autocmd('VimEnter', {
      group = auto_open_group,
      callback = function()
        if vim.fn.argc() == 1 then
          local stat = vim.uv.fs_stat(vim.fn.argv(0))
          if stat and stat.type == 'directory' then
            return
          end
        end
        vim.cmd 'Neotree show'
      end,
    })
  end,
}
