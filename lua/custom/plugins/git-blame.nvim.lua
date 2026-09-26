return {
  'f-person/git-blame.nvim',
  opts = { enabled = true },
  -- Lowercase-only toggle (broken Shift keys); blame virtual text is noisy
  -- in large files, so this is worth having on speed-dial.
  keys = {
    { '<leader>tg', '<cmd>GitBlameToggle<cr>', desc = '[T]oggle [g]it blame' },
  },
}
