return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        typescript = { 'eslint_d', 'eslint' },
        typescriptreact = { 'eslint_d', 'eslint' },
        javascript = { 'eslint_d', 'eslint' },
        javascriptreact = { 'eslint_d', 'eslint' },
        lua = { 'luacheck' },
        python = { 'ruff', 'flake8' },
        go = { 'golangci-lint' },
        rust = { 'cargo' },
        sh = { 'shellcheck' },
        dockerfile = { 'hadolint' },
        yaml = { 'yamllint' },
        json = { 'jsonlint' },
        markdown = { 'markdownlint' },
      }

      -- Only configured linters whose binary exists actually run; the rest
      -- are silently skipped (no "linter not found" spam for tools you
      -- haven't installed via Mason yet).
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint(nil, { ignore_errors = true })
          end
        end,
      })
    end,
  },
}
