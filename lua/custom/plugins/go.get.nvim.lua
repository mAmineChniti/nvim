return {
  'RomanVolkov/go.get.nvim',
  keys = function()
    return {
      {
        '<leader>gog',
        function()
          require('telescope').extensions.go_get.packages_search { layout_config = { height = 0.5 } }
        end,
        desc = '[G]o [G]et packages',
      },
    }
  end,
}
