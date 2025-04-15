return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  opts = {
    -- provider = 'ollama',
    -- ollama = {
    --   model = 'codellama:7b',
    --   timeout = 120000,
    -- },
    provider = 'gemini',
    gemini = {
      model = 'gemini-2.0-flash',
      timeout = 120000,
    },
    ollama = {
      endpoint = 'http://127.0.0.1:11434',
      timeout = 30000, -- Timeout in milliseconds
      options = {
        temperature = 0,
        num_ctx = 20480,
      },
    },
    vendors = {
      ---@type AvanteSupportedProvider
      ['ollama-codellama'] = {
        __inherited_from = 'ollama',
        model = 'codellama:7b', -- put what you need here or nothing?
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 8192,
      },
    },
    web_search_engine = {
      provider = 'google',
    },
    behaviour = {
      minimize_diff = false,
      enable_cursor_planning_mode = true,
    },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'echasnovski/mini.pick',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'ibhagwan/fzf-lua',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = { file_types = { 'markdown', 'Avante' } },
      ft = { 'markdown', 'Avante' },
    },
  },
}
