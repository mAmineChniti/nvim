return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  --
  keys = {
    -- Sidebar and AI interactions
    { '<leader>aa', '<cmd>AvanteSidebar<cr>', desc = 'Show Avante sidebar' },
    { '<leader>at', '<cmd>AvanteToggleSidebar<cr>', desc = 'Toggle sidebar visibility' },
    { '<leader>ar', '<cmd>AvanteRefreshSidebar<cr>', desc = 'Refresh sidebar' },
    { '<leader>af', '<cmd>AvanteSidebarFocus<cr>', desc = 'Switch sidebar focus' },
    { '<leader>a?', '<cmd>AvanteSelectModel<cr>', desc = 'Select Avante model' },
    { '<leader>ae', '<cmd>AvanteEditSelectedBlocks<cr>', desc = 'Edit selected blocks' },
    { '<leader>aS', '<cmd>AvanteStopRequest<cr>', desc = 'Stop current AI request' },
    { '<leader>ak', '<cmd>AvanteShowKeyBindings<cr>', desc = 'Show Avante key bindings' },
    { '<leader>aa', '<cmd>AvanteAsk<cr>', desc = 'Ask Avante AI about code' },

    -- Conflict resolution
    { 'co', '<cmd>AvanteChooseOurs<cr>', desc = 'Choose our changes' },
    { 'ct', '<cmd>AvanteChooseTheirs<cr>', desc = 'Choose their changes' },
    { 'ca', '<cmd>AvanteChooseAllTheirs<cr>', desc = 'Choose all their changes' },
    { 'c0', '<cmd>AvanteChooseNone<cr>', desc = 'Choose no changes' },
    { 'cb', '<cmd>AvanteChooseBoth<cr>', desc = 'Choose both changes' },
    { 'cc', '<cmd>AvanteChooseCursor<cr>', desc = 'Choose changes at cursor' },

    -- Navigation
    { ']x', '<cmd>AvanteNextConflict<cr>', desc = 'Move to next conflict' },
    { '[x', '<cmd>AvantePrevConflict<cr>', desc = 'Move to previous conflict' },
    { ']]', '<cmd>AvanteNextCodeblock<cr>', desc = 'Jump to next codeblock' },
    { '[[', '<cmd>AvantePrevCodeblock<cr>', desc = 'Jump to previous codeblock' },
  },
  config = function()
    -- Function to display key bindings
    vim.api.nvim_create_user_command('AvanteShowKeyBindings', function()
      local key_bindings = {
        -- Sidebar and AI interactions
        { key = '<leader>aa', desc = 'Show Avante sidebar/Ask Avante AI' },
        { key = '<leader>at', desc = 'Toggle sidebar visibility' },
        { key = '<leader>ar', desc = 'Refresh sidebar' },
        { key = '<leader>af', desc = 'Switch sidebar focus' },
        { key = '<leader>a?', desc = 'Select model' },
        { key = '<leader>ae', desc = 'Edit selected blocks' },
        { key = '<leader>aS', desc = 'Stop current AI request' },
        { key = '<leader>ak', desc = 'Show Avante key bindings' },

        -- Conflict resolution
        { key = 'co', desc = 'Choose ours' },
        { key = 'ct', desc = 'Choose theirs' },
        { key = 'ca', desc = 'Choose all theirs' },
        { key = 'c0', desc = 'Choose none' },
        { key = 'cb', desc = 'Choose both' },
        { key = 'cc', desc = 'Choose cursor' },

        -- Navigation
        { key = ']x', desc = 'Move to next conflict' },
        { key = '[x', desc = 'Move to previous conflict' },
        { key = ']]', desc = 'Jump to next codeblocks' },
        { key = '[[', desc = 'Jump to previous codeblocks' },
      }

      -- Create a buffer to display key bindings
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_name(buf, 'Avante Key Bindings')

      -- Prepare the content
      local content = { 'Avante.nvim Key Bindings:', '' }
      for _, binding in ipairs(key_bindings) do
        table.insert(content, string.format('%-10s %s', binding.key, binding.desc))
      end

      -- Set the buffer content
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

      -- Open the buffer in a new window
      vim.cmd 'new'
      vim.api.nvim_win_set_buf(0, buf)
      vim.api.nvim_win_set_option(0, 'wrap', false)
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end, {})
  end,
  --
  opts = {
    -- add any opts here
    -- for example
    provider = 'ollama',
    ollama = {
      model = 'codellama:70b',
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
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
