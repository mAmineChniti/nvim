--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.10-dev') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg', 'fd', 'node', 'npm', 'python3' } do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

local check_lsp_servers = function()
  vim.health.start 'LSP Servers'
  local servers = { 'clangd', 'ts_ls', 'eslint', 'lua_ls', 'intelephense', 'pyright-langserver' }
  for _, server in ipairs(servers) do
    local is_executable = vim.fn.executable(server) == 1
    if is_executable then
      vim.health.ok(string.format("Found LSP server: '%s'", server))
    else
      vim.health.warn(string.format("LSP server not in PATH: '%s' (install via :Mason)", server))
    end
  end
end

local check_formatters_linters = function()
  vim.health.start 'Formatters & Linters'
  local tools = {
    formatters = { 'prettier', 'stylua', 'ruff', 'gofmt', 'cargo' },
    linters = { 'eslint_d', 'eslint', 'luacheck', 'ruff', 'golangci-lint', 'shellcheck', 'hadolint', 'yamllint', 'jsonlint', 'markdownlint' },
  }
  for category, tool_list in pairs(tools) do
    for _, tool in ipairs(tool_list) do
      local is_executable = vim.fn.executable(tool) == 1
      if is_executable then
        vim.health.ok(string.format("Found %s: '%s'", category, tool))
      else
        vim.health.info(string.format("%s not in PATH: '%s' (install via Mason/npm/cargo/pip)", category, tool))
      end
    end
  end
end

local check_ai_tools = function()
  vim.health.start 'AI Tools'
  local has_copilot = vim.fn.executable('gh') == 1
  if has_copilot then
    vim.health.ok('GitHub CLI found (required for Copilot authentication)')
  else
    vim.health.warn('GitHub CLI not found - run `gh auth login` for Copilot')
  end
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim.uv or vim.loop
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
    check_lsp_servers()
    check_formatters_linters()
    check_ai_tools()
  end,
}
