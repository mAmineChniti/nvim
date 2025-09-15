return {
  'yetone/avante.nvim',
  build = 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = 'gemini',
    providers = {
      gemini = {
        endpoint = nil, -- only needed if not default
        model = 'gemini-2.0-flash',
        timeout = 120000,
        extra_request_body = {},
      },
      ollama = {
        endpoint = 'http://127.0.0.1:11434',
        model = nil, -- you can omit or set default
        timeout = 30000,
        extra_request_body = {
          options = {
            temperature = 0,
            num_ctx = 20480,
          },
        },
      },
      ['ollama-codellama'] = {
        __inherited_from = 'ollama',
        model = 'codellama:7b',
        timeout = 30000,
        extra_request_body = {
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
    web_search_engine = { provider = 'google' },
    behaviour = {
      minimize_diff = false,
      enable_cursor_planning_mode = true,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.pick',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'ibhagwan/fzf-lua',
    'stevearc/dressing.nvim',
    'folke/snacks.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
