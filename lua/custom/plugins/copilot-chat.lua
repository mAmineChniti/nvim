-- CopilotChat: actually TALK to Copilot (chat sidebar, prompts, quick actions).
--
-- What you already had vs what this adds:
-- * `copilot.lua` = ghost-text suggestions only. It DOES read comments already:
--   type `// fetch users and cache them`, stay in Insert mode, wait a beat,
--   ghost text appears, `<Tab>` accepts / `<M-w>` word / `<C-l>` line.
--   `<leader>ap` opens the Panel with alternate completions for the same
--   cursor context.
-- * This file = conversational Copilot: ask questions, `/fix`, `/explain`,
--   generate code from a prompt, commit messages, etc.
return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- uses your existing Copilot auth
      { 'nvim-lua/plenary.nvim' },
    },
    -- tiktoken (token counting) needs `make`; skip the build where unavailable.
    build = (function()
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make tiktoken'
    end)(),
    event = 'VeryLazy',
    opts = {
      -- Right-side vertical chat window.
      window = {
        layout = 'vertical',
        width = 0.35,
      },
      -- Show help hint line at the bottom of the chat.
      show_help = true,
    },
    keys = {
      { '<leader>ao', '<cmd>CopilotChatToggle<cr>', mode = { 'n', 'v' }, desc = 'CopilotChat: Toggle chat' },
      {
        '<leader>aq',
        function()
          local input = vim.fn.input 'CopilotChat: '
          if input ~= '' then
            require('CopilotChat').ask(input)
          end
        end,
        desc = 'CopilotChat: Quick prompt',
      },
      { '<leader>ax', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = 'CopilotChat: Explain selection' },
      { '<leader>af', '<cmd>CopilotChatFix<cr>', mode = { 'n', 'v' }, desc = 'CopilotChat: Fix code' },
      { '<leader>aR', '<cmd>CopilotChatReview<cr>', mode = 'v', desc = 'CopilotChat: Review selection' },
      { '<leader>am', '<cmd>CopilotChatCommit<cr>', desc = 'CopilotChat: Write commit message' },
    },
  },
}
