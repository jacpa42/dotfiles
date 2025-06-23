return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	event = "VimEnter",
	config = function()
		local utils = require("alpha.utils")

		local path_ok, plenary_path = pcall(require, "plenary.path")
		if not path_ok then
			return
		end

		local dashboard = require("alpha.themes.dashboard")
		local if_nil = vim.F.if_nil

		local file_icons = {
			enabled = true,
			highlight = true,
			provider = "mini",
		}

		local function icon(fn)
			if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
				vim.notify(
					"Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons",
					vim.log.levels.WARN
				)
				file_icons.enabled = false
				return "", ""
			end

			local ico, hl = utils.get_file_icon(file_icons.provider, fn)
			if ico == "" then
				file_icons.enabled = false
				vim.notify("Alpha: Mini icons or devicons get icon failed, disable file icons", vim.log.levels.WARN)
			end
			return ico, hl
		end

		local function file_button(fn, sc, short_fn, autocd)
			short_fn = short_fn or fn
			local ico_txt
			local fb_hl = {}

			if file_icons.enabled then
				local ico, hl = icon(fn)
				local hl_option_type = type(file_icons.highlight)
				if hl_option_type == "boolean" then
					if hl and file_icons.highlight then
						table.insert(fb_hl, { hl, 0, #ico })
					end
				end
				if hl_option_type == "string" then
					table.insert(fb_hl, { file_icons.highlight, 0, #ico })
				end
				ico_txt = ico .. "  "
			else
				ico_txt = ""
			end
			local cd_cmd = (autocd and " | cd %:p:h" or "")
			local file_button_el =
				dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
			local fn_start = short_fn:match(".*[/\\]")
			if fn_start ~= nil then
				table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
			end
			file_button_el.opts.hl = fb_hl
			return file_button_el
		end

		local default_mru_ignore = { "gitcommit" }

		local mru_opts = {
			ignore = function(path, ext)
				return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
			end,
			autocd = false,
		}

		--- @param start number
		--- @param cwd string? optional
		--- @param items_number number? optional number of items to generate, default = 10
		local function mru(start, cwd, items_number, opts)
			opts = opts or mru_opts
			items_number = if_nil(items_number, 10)

			local oldfiles = {}
			for _, v in pairs(vim.v.oldfiles) do
				if #oldfiles == items_number then
					break
				end
				local cwd_cond
				if not cwd then
					cwd_cond = true
				else
					cwd_cond = vim.startswith(v, cwd)
				end
				local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
				if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
					oldfiles[#oldfiles + 1] = v
				end
			end
			local target_width = 35

			local tbl = {}
			for i, fn in ipairs(oldfiles) do
				local short_fn
				if cwd then
					short_fn = vim.fn.fnamemodify(fn, ":.")
				else
					short_fn = vim.fn.fnamemodify(fn, ":~")
				end

				if #short_fn > target_width then
					short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
					if #short_fn > target_width then
						short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
					end
				end

				local shortcut = tostring(i + start - 1)

				local file_button_el = file_button(fn, shortcut, short_fn, opts.autocd)
				tbl[i] = file_button_el
			end
			return {
				type = "group",
				val = tbl,
				opts = {},
			}
		end

		local header = {
			type = "text",
			val = {
				[[████╗     ████╗ ██████████═╗   ████████████╗ ██████████████╗]],
				[[████║   █████╔╝████████████║   ████████████║ ██████████████║]],
				[[████║ █████╔═╝ ████╔═══████║  ████╔═════████╗█████╔═══█████║]],
				[[█████████╔═╝   ████║   ████║  ████║     ████║█████║   ╚════╝]],
				[[███████╔═╝     ████████████║  ██████████████║█████║  ██████╗]],
				[[█████████╗     ███████████╔╝  ██████████████║█████║  ██████║]],
				[[████╔═█████╗   ████╔═══████╗  ████╔═════████║█████║  ╚═████║]],
				[[████║ ╚═█████╗ ████║   ╚████╗ ████║     ████║██████████████║]],
				[[████║   ╚═████╗████║    ╚████╗████║     ████║██████████████║]],
				[[╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═══╝     ╚═══╝╚═════════════╝]],
			},
			opts = {
				position = "center",
				hl = "Title",
			},
		}

		local section_mru = {
			type = "group",
			val = {
				{
					type = "text",
					val = "Recent files",
					opts = {
						hl = "Title",
						shrink_margin = false,
						position = "center",
					},
				},
				{ type = "padding", val = 1 },
				{
					type = "group",
					val = function()
						return { mru(0, vim.fn.getcwd()) }
					end,
					opts = { shrink_margin = false },
				},
				{ type = "padding", val = 1 },
				{
					type = "text",
					val = "Plugins",
					opts = { shrink_margin = false, position = "center", hl = "Title" },
				},
				{ type = "padding", val = 1 },
				{
					type = "text",
					val = function()
						local stats = require("lazy").stats()
						local time = stats.times.LazyDone
						local count = stats.count
						local loaded = stats.loaded
						if time and count then
							return string.format("lazy.nvim: loaded %d/%d in %.2fms", loaded, count, time)
						else
							return "bruh"
						end
					end,
					opts = { shrink_margin = false, position = "center", hl = "Folded" },
				},
			},
		}

		local config = {
			layout = {
				{ type = "padding", val = 4 },
				header,
				{ type = "padding", val = 2 },
				section_mru,
			},
			opts = {
				margin = 5,
				setup = function()
					vim.api.nvim_create_autocmd("DirChanged", {
						pattern = "*",
						group = "alpha_temp",
						callback = function()
							require("alpha").redraw()
							vim.cmd("AlphaRemap")
						end,
					})

					vim.api.nvim_create_autocmd("User", {
						pattern = { "AlphaReady" },
						callback = function(args)
							local buf = args.buf
							vim.keymap.set("n", "q", ":q<cr>", {
								buffer = buf,
								noremap = true,
								silent = true,
								desc = "Quit alpha greeter",
							})
						end,
					})

					vim.api.nvim_create_autocmd("User", {
						pattern = "AlphaReady",
						callback = function(args)
							local buf = args.buf
							vim.keymap.set("n", "n", ":enew<cr>", {
								buffer = buf,
								noremap = true,
								silent = true,
								desc = "New empty buffer",
							})
						end,
					})
				end,
			},
		}

		require("alpha").setup(config)
	end,
}
