local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })

require("nvim-treesitter").setup({
	ensure_installed = {
		"php",
		"html",
		"javascript",
		"blade",
		"elixir",
		"heex",
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

local syntax_on = {
	php = true,
}

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function(args)
		local bufnr = args.buf
		local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
		if not ok or not parser then
			return
		end
		pcall(vim.treesitter.start)

		local ft = vim.bo[bufnr].filetype
		if syntax_on[ft] then
			vim.bo[bufnr].syntax = "on"
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "TSUpdate",
	callback = function()
		local parsers = require("nvim-treesitter.parsers")

		parsers.blade = {
			tier = 0,

			---@diagnostic disable-next-line: missing-fields
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.blade.php",
	callback = function()
		-- Set the filetype to blade
		vim.bo.filetype = "blade"
		-- Apply additional filetypes for highlighting
		vim.bo.syntax = "blade"
		-- Apply specific highlighting regions
		vim.cmd([[
      " Add PHP highlighting to Blade expressions
      syntax region bladePhpRegion matchgroup=bladeDelimiter start="{{"  end="}}"  contains=@PHP
      syntax region bladePhpRegion matchgroup=bladeDelimiter start="{!!" end="!!}" contains=@PHP
      
      " Add HTML highlighting to the rest
      syntax include @HTML syntax/html.vim
      syntax region bladeHtmlRegion start="<" end=">" contains=@HTML keepend
      
      " Keep Blade directives highlighted
      highlight link bladeDirective Keyword
      highlight link bladeDirectiveStart Keyword
      highlight link bladeDirectiveEnd Keyword
    ]])
	end,
})
