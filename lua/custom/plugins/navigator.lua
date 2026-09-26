return {
  'ray-x/navigator.lua',
  enabled = false, -- Requires configuration, disabled to prevent errors
  dependencies = {
    { 'ray-x/guihua.lua', build = 'cd lua/fzy && make' },
    { 'neovim/nvim-lspconfig' },
  },
}
