--=====================================================
-- comment.nvim Settings
--=====================================================

require('Comment').setup({
	extra = {
		above = 'gcO', -- add comment on the line above
		below = 'gco', -- add comment on the line below
		eol = 'gcA', -- add comment at the end of line
	},
})
