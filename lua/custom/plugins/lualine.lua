return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local colors = require('tokyonight.colors').setup()
    local theme = require 'lualine.themes.auto' -- Change this if you want to switch to a different theme
    return {
      options = {
        component_separators = { left = ' ', right = ' ' },
        section_separators = { left = ' ', right = ' ' },
        theme = theme, -- This will now use the theme variable, change it to use a different theme
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
      },
      sections = {
        lualine_a = { { 'mode', icon = 'M' } },
        lualine_b = {
          {
            'branch',
            icon = '',
            fmt = function(str)
              -- Truncate the branch name if it's longer than 15 characters
              if #str > 15 then
                return string.sub(str, 1, 12) .. '...'
              end
              return str
            end,
          },
        },
        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = '󰝶 ',
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          {
            'filename',
            symbols = { modified = '  ', readonly = '', unnamed = '' },
          },
          {
            function()
              return require('nvim-navic').get_location()
            end,
            cond = function()
              return package.loaded['nvim-navic'] and require('nvim-navic').is_available()
            end,
            color = { fg = colors.green, bg = colors.bg },
          },
        },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return ''
              end
              local lsp_names = {}
              for _, client in pairs(clients) do
                table.insert(lsp_names, client.name)
              end
              return table.concat(lsp_names, ', ')
            end,
            icon = ' ',
            color = { fg = colors.cyan, bg = colors.bg }, -- Adjust colors as needed
          },
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
            color = { fg = colors.green },
          },
          { 'diff' },
        },
        lualine_y = {
          'progress',
          'location',
        },
        lualine_z = {
          function()
            return '  ' .. os.date '%X' .. ' 🚀 '
          end,
        },
      },
      extensions = { 'lazy', 'toggleterm', 'mason', 'neo-tree', 'trouble' },
    }
  end,
}
