return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local ls = require("luasnip")
		local types = require("luasnip.util.types")

		-- Load friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		ls.config.set_config({
			-- This tells luasnip to remember to keep around the last snippet.
			-- You can jump back into it even if you move outside of the selection
			history = true,
			-- This one is cool cause if you have dynamic snippets, it updates as you type!
			updateevents = "TextChanged,TextChangedI",
			-- Autosnippets:
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { " « ", "NonTest" } },
					},
				},
			},
		})

		vim.keymap.set({ "i" }, "<C-K>", function()
			ls.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-L>", function()
			ls.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-H>", function()
			ls.jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true })
		vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
		-- Shorcut to source my luasnips file again, which will reload my snippets
		vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
	end,
}
