-- Retains render-markdown.nvim now that Avante (its installer) is gone, and
-- extends pretty-markdown rendering to CopilotChat buffers (upstream
-- wiki recommendation). Without this spec lazy.nvim would garbage-collect
-- the plugin on the next `:Lazy clean`.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'copilot-chat' },
  opts = {
    file_types = { 'markdown', 'copilot-chat' },
  },
}
