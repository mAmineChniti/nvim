-- ============================================================================
-- treesitter.lua - Enhanced Treesitter config for Angular 18 + NestJS
-- ============================================================================
--
-- Provides comprehensive syntax highlighting and parsing for:
--   - TypeScript/JavaScript (Angular components, NestJS modules)
--   - HTML templates (Angular templates)
--   - CSS/SCSS (Angular component styles)
--   - JSON (Angular configs, package.json)
--   - Comment highlighting (TODO, FIXME, @model: prompts)
--
-- ============================================================================

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'main',
    },
  },
  opts = {
    ensure_installed = {
      -- Core languages
      'bash',
      'c',
      'diff',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
      'typescript',
      'javascript',
      'tsx', -- For Angular component templates with JSX-like syntax
      'jsdoc', -- For JSDoc comments in TypeScript
      'html', -- For Angular templates
      'css',
      'scss',
      'json',
      'php',
      'blade',
      'python',
      'yaml', -- For Angular/NestJS config files
      'regex', -- Useful for pattern matching in code
      'graphql', -- If using GraphQL with NestJS
      'comment', -- Highlights TODO, FIXME, @model: and custom comment tags
      'dockerfile', -- For Docker configurations
      'prisma', -- If using Prisma with NestJS
      'sql', -- For raw SQL queries
    },
    -- Textobjects for enhanced code navigation in Angular/NestJS
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Jump forward to textobj
        keymaps = {
          -- Function/method selections (useful for NestJS handlers)
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          -- Class selections (Angular components, NestJS services)
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          -- Parameter selections (useful for dependency injection)
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          -- Comment selections (useful for @model: prompts)
          ['aC'] = '@comment.outer',
          ['iC'] = '@comment.inner',
          -- Block selections
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer', -- Next method/function
          [']]'] = '@class.outer', -- Next class
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer', -- Previous method/function
          ['[['] = '@class.outer', -- Previous class
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>xp'] = '@parameter.inner', -- Swap parameter with next
        },
        swap_previous = {
          -- NOTE: lowercase `xb` ("back"), not `xP`: no Shift-key bindings.
          ['<leader>xb'] = '@parameter.inner', -- Swap parameter with previous
        },
      },
    },
  },
  config = function(_, opts)
    local treesitter = require('nvim-treesitter')
    treesitter.setup {
      install_dir = vim.fn.stdpath('data') .. '/site',
    }
    -- Install missing parsers in the background (fire-and-forget, no
    -- :wait()): blocking startup up to 5 minutes on a fresh machine is
    -- worse than a buffer without highlighting until its parser arrives.
    -- The FileType autocmd below enables highlighting per buffer anyway.
    treesitter.install(opts.ensure_installed)
    vim.treesitter.language.register('json', 'jsonc')

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang or not vim.treesitter.language.add(lang) then
          return
        end
        vim.treesitter.start(args.buf)
        if lang ~= 'ruby' then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = opts.textobjects.select.lookahead,
      },
      move = {
        set_jumps = opts.textobjects.move.set_jumps,
      },
    }

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')
    local swap = require('nvim-treesitter-textobjects.swap')

    local function select_mapping(query)
      return function()
        select.select_textobject(query)
      end
    end

    for lhs, query in pairs(opts.textobjects.select.keymaps) do
      vim.keymap.set({ 'x', 'o' }, lhs, select_mapping(query), { desc = 'Select ' .. query })
    end

    local function move_mapping(method, query)
      return function()
        move[method](query)
      end
    end

    for lhs, query in pairs(opts.textobjects.move.goto_next_start) do
      vim.keymap.set('n', lhs, move_mapping('goto_next_start', query), { desc = 'Next ' .. query })
    end

    for lhs, query in pairs(opts.textobjects.move.goto_next_end) do
      vim.keymap.set('n', lhs, move_mapping('goto_next_end', query), { desc = 'Next end of ' .. query })
    end

    for lhs, query in pairs(opts.textobjects.move.goto_previous_start) do
      vim.keymap.set('n', lhs, move_mapping('goto_previous_start', query), { desc = 'Prev ' .. query })
    end

    for lhs, query in pairs(opts.textobjects.move.goto_previous_end) do
      vim.keymap.set('n', lhs, move_mapping('goto_previous_end', query), { desc = 'Prev end of ' .. query })
    end

    local function swap_mapping(method, query)
      return function()
        swap[method](query)
      end
    end

    for lhs, query in pairs(opts.textobjects.swap.swap_next) do
      vim.keymap.set('n', lhs, swap_mapping('swap_next', query), { desc = 'Swap parameter with next' })
    end

    for lhs, query in pairs(opts.textobjects.swap.swap_previous) do
      vim.keymap.set('n', lhs, swap_mapping('swap_previous', query), { desc = 'Swap parameter with previous' })
    end

    -- Set up custom highlight for @model: comments
    -- This makes AI instruction comments visually distinct
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'lua' },
      callback = function()
        -- Highlight @model: comments with a special color
        vim.fn.matchadd('Todo', '@model:.*$')
      end,
    })

    -- Angular-specific file type detection
    vim.filetype.add {
      extension = {
        component = 'typescript',
        service = 'typescript',
        module = 'typescript',
        pipe = 'typescript',
        directive = 'typescript',
        guard = 'typescript',
        resolver = 'typescript',
      },
      pattern = {
        ['.*%.component%.ts'] = 'typescript',
        ['.*%.service%.ts'] = 'typescript',
        ['.*%.module%.ts'] = 'typescript',
        ['.*%.pipe%.ts'] = 'typescript',
        ['.*%.directive%.ts'] = 'typescript',
        ['.*%.guard%.ts'] = 'typescript',
        ['.*%.resolver%.ts'] = 'typescript',
        ['.*%.controller%.ts'] = 'typescript',
        ['.*%.dto%.ts'] = 'typescript',
        ['.*%.entity%.ts'] = 'typescript',
      },
    }
  end,
}
