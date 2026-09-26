return {
  'mfussenegger/nvim-dap',
  desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio', -- required by nvim-dap-ui
    -- virtual text for the debugger
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
    -- Auto-install debug adapters via Mason instead of configuring each
    -- language adapter by hand. Adapters install on demand when you start
    -- a debug session; check/install manually anytime with `:Mason`.
    'mason-org/mason.nvim',
    {
      'jay-babu/mason-nvim-dap.nvim',
      opts = {
        automatic_installation = true,
        -- Pre-seed adapters for the daily-driver stacks so the first debug
        -- session doesn't stall on downloads (names per mason-nvim-dap).
        ensure_installed = { 'python', 'js' }, -- debugpy + js-debug-adapter
        handlers = {},
      },
    },
  },

  init = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,

  -- stylua: ignore
  keys = {
    { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function()
      local args = vim.fn.input 'Run with args: '
      require('dap').continue { before = function(config)
        config.args = vim.split(args, ' ', { trimempty = true })
      end }
    end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

  config = function()
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    local signs = {
      Breakpoint = { '●', 'DiagnosticError' },
      BreakpointCondition = { '◆', 'DiagnosticWarn' },
      BreakpointRejected = { '', 'DiagnosticError' },
      LogPoint = { '▶', 'DiagnosticInfo' },
      Stopped = { '', 'DiagnosticInfo', 'DapStoppedLine' },
    }

    for name, sign in pairs(signs) do
      vim.fn.sign_define('Dap' .. name, {
        text = sign[1],
        texthl = sign[2],
        linehl = sign[3],
        numhl = sign[3],
      })
    end

    -- .vscode/launch.json files are now read automatically on-demand
  end,
}
