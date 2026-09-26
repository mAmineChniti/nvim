return {
  'mizisu/django.nvim',
  -- NOTE: the blink.cmp 'django' completion provider is declared in
  -- init.lua (single place for all blink providers), so this spec only
  -- declares runtime dependencies.
  dependencies = {
    { 'folke/snacks.nvim' },
  },
  ft = { 'python' },
  config = function()
    require('django').setup {
      -- Default configuration
      -- views = {
      --   auto_refresh = {
      --     on_picker_open = true,
      --     file_watch_patterns = {
      --       "*/urls.py",
      --       "*/views.py",
      --       "*/view.py",
      --       "*/*views.py",
      --       "*/*view.py",
      --       "*/*viewset.py",
      --       "*/*view_set.py",
      --       "*/*api.py",
      --     },
      --   },
      -- },
      -- models = {
      --   auto_refresh = {
      --     on_picker_open = true,
      --     file_watch_patterns = { "*/models.py", "*/models/*.py" },
      --   },
      -- },
      -- shell = {
      --   command = "shell",  -- "shell", "shell_plus", "shell_plus --ipython", etc.
      --   position = "right", -- "bottom", "top", "left", "right", "float"
      --   env = {},           -- { DJANGO_SETTINGS_MODULE = "myproject.settings" }
      -- },
    }
  end,
}
