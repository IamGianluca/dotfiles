--=====================================================
-- mason-nvim-dap Settings
--=====================================================

require("mason").setup()
require("mason-nvim-dap").setup({
	ensure_installed = {
		"python",
		"codelldb", -- rust
	},
	automatic_installation = true,
	handlers = {}, -- sets up dap in the predefined manner
})


--=====================================================
-- nvim-dap-ui Settings
--=====================================================

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
