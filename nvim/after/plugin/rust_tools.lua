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
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions,
				{ buffer = bufnr, desc = "rust-tools hover actions" })
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group,
				{ buffer = bufnr, desc = "rust-tools code action groups" })
		end,
	},
	tools = {
		hover_actions = {
			auto_focus = true,
		},
	},
}

require('rust-tools').setup(opts)
