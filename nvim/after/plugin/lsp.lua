--=====================================================
-- nvim-cmp Settings
--=====================================================

local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

lsp.ensure_installed({
	'lua_ls',
	'rust_analyzer',
	'pyright',
})

-- fix undefined global 'vim'
lsp.configure('lua_ls', {
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	-- normal mode
	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	-- vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<S-k>", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	-- insert mode
	vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
end)
lsp.skip_server_setup({ 'rust_analyzer' })
lsp.setup()


--=====================================================
-- conform Settings
--=====================================================

-- needed to format and sort imports in Python since PyRight doesn't offer
-- those functionalities; expects black and usort to be available in PATH
require("conform").setup({
	formatters_by_ft = {
		python = { "usort", "black" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})


--=====================================================
-- nvim-autopairs Settings
--=====================================================

require('nvim-autopairs').setup()


--=====================================================
-- General Settings
--=====================================================

-- format on save for every language
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- spelling
local o = vim.opt
o.spelllang = { 'en' }
o.spell = true

-- show inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = true })


--=====================================================
-- rust-tools Settings
--=====================================================

-- we installed codelldb through mason, so use that to dynamically get the codelldb path
local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb'
local this_os = vim.loop.os_uname().sysname;

-- the path in windows is different
if this_os:find "Windows" then
	codelldb_path = extension_path .. "adapter\\codelldb.exe"
	liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
else
	-- the liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
end

local rt = require("rust-tools")
local opts = {
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(
			codelldb_path, liblldb_path)
	},
	server = {
		on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, remap = false }
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions,
				{ buffer = bufnr, desc = "rust-tools hover actions" })
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group,
				{ buffer = bufnr, desc = "rust-tools code action groups" })
			-- normal mode
			vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
			-- vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
			vim.keymap.set("n", "<S-k>", function() vim.lsp.buf.hover() end, opts)
			vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
			vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
			vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, opts)
			vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			-- insert mode
			vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
		end,
	},
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
}

require('rust-tools').setup(opts)
