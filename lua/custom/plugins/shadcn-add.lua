return {
  'BibekBhusal0/nvim-shadcn',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  cmd = { 'ShadcnAdd', 'ShadcnInit', 'ShadcnAddImportant' },
  opts = {
    default_installer = 'npm',

    format = {
      doc = 'https://ui.shadcn.com/docs/components/%s',
      npm = 'npx shadcn@latest add %s',
      pnpm = 'pnpm dlx shadcn@latest add %s',
      yarn = 'npx shadcn@latest add %s',
      bun = 'bunx --bun shadcn@latest add %s',
    },

    verbose = false,
    important = { 'button', 'card', 'checkbox', 'tooltip' },

    keys = {
      i = { doc = '<C-o>' },
      n = { doc = '<C-o>' },
    },

    init_command = {
      commands = {
        npm = 'npx shadcn@latest init',
        pnpm = 'pnpm dlx shadcn@latest init',
        yarn = 'npx shadcn@latest init',
        bun = 'bunx --bun shadcn@latest init',
      },
      flags = { defaults = false, force = false },
      default_color = 'Gray',
    },

    telescope_config = {
      sorting_strategy = 'ascending',
      layout_config = {
        prompt_position = 'top',
      },
      prompt_title = 'Shadcn UI components',
    },
  },
  keys = {
    { '<leader>ac', '<cmd>ShadcnAdd<cr>', mode = 'n', desc = 'Shadcn: Add component' },
    { '<leader>ai', '<cmd>ShadcnInit<cr>', mode = 'n', desc = 'Shadcn: Init' },
    { '<leader>aI', '<cmd>ShadcnAddImportant<cr>', mode = 'n', desc = 'Shadcn: Add important components' },
  },
}