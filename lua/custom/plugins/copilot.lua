return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true, -- show suggestions automatically
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = '<Tab>', -- Accept with Tab
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false }, -- disable panel unless you want it
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      -- Make <Tab> only accept Copilot suggestion when visible
      vim.keymap.set('i', '<Tab>', function()
        local copilot = require 'copilot.suggestion'
        if copilot.is_visible() then
          copilot.accept()
        else
          return '<Tab>'
        end
      end, { expr = true, silent = true })
    end,
  },
}
