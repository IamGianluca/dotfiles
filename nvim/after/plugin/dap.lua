--=====================================================
-- mason-nvim-dap Settings
--=====================================================

require("mason").setup()
require("mason-nvim-dap").setup({
	ensure_installed = {
		"python",
		"codelldb", -- rust debugger
	},
	automatic_installation = true,
	handlers = {}, -- sets up dap in the predefined manner
})

-- keymaps to interact with DAP
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "DAP continue" })
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = "DAP step over" })
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = "DAP step into" })
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = "DAP step out" })
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end, { desc = "DAP set breakpoint" })
vim.keymap.set('n', '<Leader>lp',
	function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
	{ desc = "DAP log point message" })
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "DAP open REPL" })
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = "DAP run last" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
	require('dap.ui.widgets').hover()
end, { desc = "DAP UI hover" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
	require('dap.ui.widgets').preview()
end, { desc = "DAP UI preview" })
vim.keymap.set('n', '<Leader>df', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.frames)
end, { desc = "DAP UI display frame widget" })
vim.keymap.set('n', '<Leader>ds', function()
	local widgets = require('dap.ui.widgets')
	widgets.centered_float(widgets.scopes)
end, { desc = "DAP UI display scope widget" })


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
