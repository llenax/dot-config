# window pane navigation
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

vim.keymap.set("n", "<CR>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return vim.keycode "<CR>"
  end
end, { expr = true })

vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)

vim.keymap.set("n", "<space>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)

vim.keymap.set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

vim.keymap.set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)

vim.keymap.set("x", "<M-j>", ":move '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("x", "<M-k>", ":move '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("n", "k", function()
  local count = vim.v.count

  if count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

vim.keymap.set("n", "j", function()
  local count = vim.v.count

  if count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })
