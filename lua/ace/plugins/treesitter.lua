return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function(plugin)
		vim.opt.runtimepath:prepend(plugin.dir .. "/runtime")
	end,
}
