return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    presets = {
      bottom_search = true,
    },
    popupmenu = {
      width = 20, -- Adjust the width of the popupmenu
    },
    notify = {
      enabled = true, -- Enable notifications
      view = 'notify', -- Use 'notify' as the notification view
      width = 20, -- Adjust the width of notifications
    },
  },
  dependencies = {
    -- Lazy-load nui.nvim
    { 'MunifTanjim/nui.nvim' },
    -- Lazy-load nvim-notify
    {
      'rcarriga/nvim-notify',
      config = function()
        require('notify').setup {
          max_width = 50,
          max_height = math.floor(vim.o.lines * 0.75), -- Set max height to 75% of the screen height
          timeout = 3000,
          background_colour = 'FloatShadow',
          render = 'default', -- The 'default' renderer handles text wrapping
          -- Required fields to avoid missing fields warning
          level = 'info', -- Set default level (e.g., "info", "warn", "error")
          stages = 'fade', -- Animation stages (e.g., "fade", "slide", "fade_in_slide_out")
          icons = { -- Default icons for each level
            ERROR = '',
            WARN = '',
            INFO = '',
            DEBUG = '',
            TRACE = '✎',
          },
          time_formats = {}, -- Time format customization
          minimum_width = 10, -- Minimum width for notifications
          fps = 30, -- Frames per second for animations
          top_down = true, -- Notification direction (true = top-down, false = bottom-up)
        }
      end,
    },
  },
}
