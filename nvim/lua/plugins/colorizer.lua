return {
	-- NOTE: I'm currently maintaining a fork of this plugin, to fix a warning
	-- that shows up when starting neovim. There is an open PR in the upstream repo
	-- which implements the same changes I made. Once the maintainer accepts the
	-- changes, we can switch to using the upstream repo.
	-- Link to the PR: https://github.com/norcalli/nvim-colorizer.lua/pull/115
	-- "norcalli/nvim-colorizer.lua",
	"iamgianluca/nvim-colorizer.lua",
	event = "BufEnter",
	opts = { "*" },
}
