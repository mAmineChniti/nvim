return {
	{
		'zbirenbaum/copilot.lua',
		enabled = true,
		event = 'InsertEnter',
		cmd = 'Copilot',
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = '<C-y>',
					accept_word = '<M-w>',
					accept_line = '<C-l>',
					next = '<M-n>',
					prev = '<M-p>',
					dismiss = '<C-d>',
				},
			},
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = '[p',
					jump_next = ']p',
					accept = '<CR>',
					refresh = 'gr',
					open = '<M-CR>',
				},
			},
			filetypes = {
				yaml = true,
				markdown = true,
				help = false,
				gitcommit = true,
				gitrebase = true,
				hgcommit = true,
				svn = true,
				cvs = true,
				['.'] = true,
			},
		},
		config = function(_, opts)
			require('copilot').setup(opts)

			-- Tab chain: Copilot accept -> blink snippet-forward -> LuaSnip
			-- expand/jump -> literal Tab.
			-- This mapping shadows blink.cmp's own <Tab> (preset 'enter' uses
			-- it for snippet_forward), so blink must be driven EXPLICITLY via
			-- its API here -- a feedkeys('<Tab>') fallback would bypass blink
			-- (noremap, no remap) and snippet jumps would silently die.
			vim.keymap.set('i', '<Tab>', function()
				local ok, suggestion = pcall(require, 'copilot.suggestion')
				if ok and suggestion.is_visible() then
					suggestion.accept()
					return
				end

				local blink_ok, blink = pcall(require, 'blink.cmp')
				if blink_ok and blink.snippet_active { direction = 1 } then
					blink.snippet_forward()
					return
				end

				local ls_ok, ls = pcall(require, 'luasnip')
				if ls_ok and ls.expand_or_jumpable() then
					ls.expand_or_jump()
					return
				end

				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', false)
			end, { silent = true, noremap = true, desc = 'Copilot accept / snippet jump / Tab' })

			-- S-Tab: same chain, backward.
			vim.keymap.set('i', '<S-Tab>', function()
				local blink_ok, blink = pcall(require, 'blink.cmp')
				if blink_ok and blink.snippet_active { direction = -1 } then
					blink.snippet_backward()
					return
				end
				local ls_ok, ls = pcall(require, 'luasnip')
				if ls_ok and ls.jumpable(-1) then
					ls.jump(-1)
					return
				end
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n', false)
			end, { silent = true, noremap = true, desc = 'Snippet jump backward' })

			-- Escape: dismiss Copilot ghost text, then preserve default Esc
			-- behaviour (exit insert mode). feedkeys with 'n' avoids recursion
			-- into this same mapping.
			vim.keymap.set('i', '<Esc>', function()
				local ok, suggestion = pcall(require, 'copilot.suggestion')
				if ok and suggestion.is_visible() then
					suggestion.dismiss()
				end
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', false)
			end, { silent = true, noremap = true, desc = 'Dismiss Copilot + exit insert' })
		end,
		keys = {
			{ '<leader>ap', '<cmd>Copilot panel<cr>', desc = 'Copilot: Panel' },
			{ '<leader>au', '<cmd>Copilot auth<cr>', desc = 'Copilot: Auth / Sign in' },
			{
				'<leader>aT',
				function()
					require('copilot.suggestion').toggle_auto_trigger()
				end,
				desc = 'Copilot: Toggle auto-trigger',
			},
		},
	},
}
