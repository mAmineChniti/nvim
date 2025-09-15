return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require('neo-tree').setup {
      window = {
        position = 'right',
        width = 20, -- Set the width of the NeoTree window to 20 columns
      },
      filesystem = {
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
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local relative_path = require('avante.utils').relative_path(filepath)

            local sidebar = require('avante').get()
            local open = sidebar:is_open()
            if not open then
              require('avante.api').ask()
              sidebar = require('avante').get()
            end

            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo-tree buffer if the sidebar wasn't already open
            if not open then
              sidebar.file_selector:remove_selected_file 'neo-tree filesystem [1]'
            end
          end,
        },
        window = {
          mappings = {
            ['oa'] = 'avante_add_files',
          },
        },
      },
    }
  end,
}
