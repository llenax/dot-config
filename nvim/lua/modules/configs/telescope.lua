local data = assert(vim.fn.stdpath "data") --[[@as string]]
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

local MultiRipGrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts
    or {
      ["l"] = "*.lua",
      ["v"] = "*.vim",
      ["n"] = "*.{vim,lua}",
      ["c"] = "*.c",
      ["r"] = "*.rs",
      ["g"] = "*.go",
    }
  opts.pattern = opts.pattern or "%s"

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local prompt_split = vim.split(prompt, "  ")

      local args = { "rg" }
      if prompt_split[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      end

      if prompt_split[2] then
        table.insert(args, "-g")

        local pattern
        if opts.shortcuts[prompt_split[2]] then
          pattern = opts.shortcuts[prompt_split[2]]
        else
          pattern = prompt_split[2]
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      return vim.tbl_flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Live Grep (with shortcuts)",
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

require("telescope").setup {
  defaults = {
    file_ignore_patterns = {},
  },
  extensions = {
    wrap_results = true,

    fzf = {},
    history = {
      path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
      limit = 100,
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {},
    },
  },
}

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require "telescope.builtin"

vim.keymap.set("n", "<space>ff", builtin.find_files)
vim.keymap.set("n", "<space>gf", function()
  return builtin.git_files { cwd = vim.fn.expand "%:h" }
end)
vim.keymap.set("n", "<space>fh", builtin.help_tags)
vim.keymap.set("n", "<space>ft", MultiRipGrep)
vim.keymap.set("n", "<space>fb", builtin.buffers)
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)

vim.keymap.set("n", "<space>gw", builtin.grep_string)

vim.keymap.set("n", "<space>fa", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "data", "lazy") }
end)

-- vim.keymap.set("n", "<space>en", function()
--   builtin.find_files { cwd = vim.fn.stdpath "config" }
-- end)
