return {
	'Jacob411/Ollama-Copilot',
	opts = {
		-- Model
		model_name = 'deepseek-coder-v2:16b',

		-- Streaming is essential for perceived speed
		stream_suggestion = true,

		-- Reduce latency & CPU spikes
		debounce = 100,  -- ms; prevents firing on every keystroke
		max_completion_tokens = 128, -- keep suggestions short & fast
		temperature = 0.15, -- deterministic, Copilot-like
		top_p = 0.95,

		-- Context control (important for 16b MoE)
		context_lines = 80, -- enough local context without overfeeding
		context_window = 8192, -- don’t try to use full 160K for inline

		-- UX
		auto_trigger = true, -- Copilot-like behavior
		ghost_text = true, -- inline suggestion text
		highlight_group = 'Comment',

		-- Keymaps
		keymaps = {
			suggestion = '<leader>os',
			insert_accept = '<Tab>',
			insert_reject = '<C-]>',
			next_suggestion = '<M-]>',
			prev_suggestion = '<M-[>',
		},
	},
}
