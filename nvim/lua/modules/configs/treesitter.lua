local group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true })
require("nvim-treesitter").setup {
  ensure_install = { "core", "stable", "lua" }
}

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "TSUpdate",
  callback = function()
    local parsers = require "nvim-treesitter.parsers"

    parsers.blade = {
      tier = 0,
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade",
    }
  end,
})
