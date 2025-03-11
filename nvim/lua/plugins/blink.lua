return {
	"saghen/blink.cmp",
	version = not vim.g.lazyvim_blink_main and "*",
	build = vim.g.lazyvim_blink_main and "cargo build --release",
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat",
		"sources.default",
	},

	dependencies = {
		"rafamadriz/friendly-snippets",
		-- add blink.compat to dependencies
		{
			"saghen/blink.compat",
			optional = true, -- make optional so it's only enabled if any extras need it
			opts = {},
			version = not vim.g.lazyvim_blink_main and "*",
		},
	},
	event = "InsertEnter",

	opts = {
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "normal",
		},
		completion = {
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			ghost_text = {
				enabled = vim.g.ai_cmp,
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "buffer" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},
		keymap = {
			["<C-Space>"] = { "select_and_accept" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},
	},
	config = function(_, opts)
		-- setup compat sources
		local enabled = opts.sources.default
		for _, source in ipairs(opts.sources.compat or {}) do
			opts.sources.providers[source] = vim.tbl_deep_extend(
				"force",
				{ name = source, module = "blink.compat.source" },
				opts.sources.providers[source] or {}
			)
			if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
				table.insert(enabled, source)
			end
		end

		-- Unset custom prop to pass blink.cmp validation
		opts.sources.compat = nil

		-- check if we need to override symbol kinds
		for _, provider in pairs(opts.sources.providers or {}) do
			if provider.kind then
				local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
				local kind_idx = #CompletionItemKind + 1

				CompletionItemKind[kind_idx] = provider.kind
				---@diagnostic disable-next-line: no-unknown
				CompletionItemKind[provider.kind] = kind_idx

				local transform_items = provider.transform_items
				provider.transform_items = function(ctx, items)
					items = transform_items and transform_items(ctx, items) or items
					for _, item in ipairs(items) do
						item.kind = kind_idx or item.kind
					end
					return items
				end

				-- Unset custom prop to pass blink.cmp validation
				provider.kind = nil
			end
		end

		require("blink.cmp").setup(opts)
	end,
}
