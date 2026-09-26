-- Snippets guide (<leader>c) + ensure snippet collections are actually loaded.
--
-- Root causes fixed here:
-- 1. `<leader>c` group existed in which-key but had ZERO global mappings
--    (only buffer-local `<leader>cd` from LSP), so which-key showed an empty
--    popup. This file adds real `<leader>c*` snippet actions.
-- 2. `friendly-snippets` was installed but never loaded: init.lua declares it
--    with `config = function() end` (no-op), so no VS Code snippets were ever
--    available. We call `from_vscode.lazy_load()` here.
return {
	'L3MON4D3/LuaSnip',
	version = '2.*',
	dependencies = {
		'rafamadriz/friendly-snippets',
		'mlaursen/vim-react-snippets',
	},
	keys = {
		{
			'<leader>cs',
			function()
				local ls = require 'luasnip'
				-- available() takes no filetype arg; it returns { ft = {...} }
				-- for the current buffer's filetypes (honours filetype_extend).
				-- Use its keys to fetch the REAL snippet objects so we can
				-- expand with snip_expand() (writes directly into the file).
				local by_ft = ls.available()
				local snippets = {}
				local seen = {}
				for ft, _ in pairs(by_ft) do
					for _, snip in ipairs(ls.get_snippets(ft)) do
						if not snip.invalidated then
							local key = tostring(snip.trigger) .. '\0' .. tostring(snip.name)
							if not seen[key] then
								seen[key] = true
								table.insert(snippets, snip)
							end
						end
					end
					for _, snip in ipairs(ls.get_snippets(ft, { type = 'autosnippets' })) do
						if not snip.invalidated then
							local key = tostring(snip.trigger) .. '\0' .. tostring(snip.name)
							if not seen[key] then
								seen[key] = true
								table.insert(snippets, snip)
							end
						end
					end
				end
				if #snippets == 0 then
					vim.notify('No snippets for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
					return
				end
				local function str_of(v)
					if v == nil then
						return ''
					end
					if type(v) == 'string' then
						return v
					end
					if type(v) == 'table' then
						-- VS Code descriptions can be {"line1", "line2"};
						-- triggers can be tables in exotic snippets.
						if #v > 0 then
							local parts = {}
							for _, p in ipairs(v) do
								table.insert(parts, str_of(p))
							end
							return table.concat(parts, ' ')
						end
						if type(v.trigger) == 'string' then
							return v.trigger
						end
						return ''
					end
					return tostring(v)
				end
				local function trig_of(snip)
					local t = str_of(snip.trigger)
					if t ~= '' then
						return t
					end
					return str_of(snip.name) ~= '' and str_of(snip.name) or '?'
				end
				local names = {}
				for _, snip in ipairs(snippets) do
					table.insert(names, trig_of(snip) .. ' — ' .. str_of(snip.description))
				end
				vim.ui.select(names, { prompt = 'Snippets:' }, function(_, idx)
					if idx then
						-- Expands the snippet object at the cursor and writes
						-- it into the current file. Afterwards jump between
						-- placeholders with Tab / S-Tab (or <leader>cj/ck).
						ls.snip_expand(snippets[idx])
					end
				end)
			end,
			desc = 'Snippets: Search & expand',
		},
		{
			'<leader>cl',
			function()
				local ls = require 'luasnip'
				local by_ft = ls.available()
				local available = {}
				for _, list in pairs(by_ft) do
					for _, snip in ipairs(list) do
						table.insert(available, snip)
					end
				end
				if #available == 0 then
					vim.notify('No snippets for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
					return
				end
				local lines = { 'Snippets for ' .. vim.bo.filetype .. ' (' .. #available .. '):' }
				for _, snip in ipairs(available) do
					local function s(v)
						if v == nil then
							return ''
						end
						if type(v) == 'string' then
							return v
						end
						if type(v) == 'table' then
							if #v > 0 then
								local parts = {}
								for _, p in ipairs(v) do
									table.insert(parts, s(p))
								end
								return table.concat(parts, ' ')
							end
							return ''
						end
						return tostring(v)
					end
					local trig = s(snip.trigger) ~= '' and s(snip.trigger) or s(snip.name) ~= '' and s(snip.name) or '?'
					table.insert(lines, '  ' .. trig .. ' — ' .. s(snip.description))
				end
				vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
			end,
			desc = 'Snippets: List for filetype',
		},
		{
			'<leader>ce',
			function()
				require('luasnip').expand()
			end,
			desc = 'Snippets: Expand at cursor',
		},
		{
			'<leader>cj',
			function()
				require('luasnip').jump(1)
			end,
			mode = { 'i', 's' },
			desc = 'Snippets: Jump forward',
		},
		{
			'<leader>ck',
			function()
				require('luasnip').jump(-1)
			end,
			mode = { 'i', 's' },
			desc = 'Snippets: Jump backward',
		},
		{
			'<leader>cx',
			function()
				local ls = require 'luasnip'
				if ls.choice_active() then
					ls.change_choice(1)
				else
					vim.notify('No active snippet choice', vim.log.levels.WARN)
				end
			end,
			mode = { 'i', 's' },
			desc = 'Snippets: Next choice',
		},
		{
			'<leader>cr',
			function()
				require('luasnip.loaders.from_vscode').lazy_load()
				vim.notify('Snippets reloaded', vim.log.levels.INFO)
			end,
			desc = 'Snippets: Reload collections',
		},
	},
	config = function()
		local ls = require 'luasnip'
		ls.setup {
			history = true,
			updateevents = 'TextChanged,TextChangedI',
			enable_autosnippets = true,
		}

		-- Actually load friendly-snippets (init.lua declares it with a no-op
		-- config, so without this call zero VS Code snippets exist).
		require('luasnip.loaders.from_vscode').lazy_load()

		-- Load vim-react-snippets once (init.lua also requests it via opts;
		-- guard against double-load duplicating snippets).
		if not vim.g._vim_react_snippets_setup then
			local ok, vrs = pcall(require, 'vim-react-snippets')
			if ok then
				vrs.setup {}
				vim.g._vim_react_snippets_setup = true
			end
		end

		-- React filetype aliases so TS/JS snippets work in React files.
		ls.filetype_extend('typescriptreact', { 'typescript', 'javascript', 'javascriptreact' })
		ls.filetype_extend('javascriptreact', { 'javascript' })
	end,
}
