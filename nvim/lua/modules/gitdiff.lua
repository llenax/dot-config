local M = {}

M.setup = function()
	vim.api.nvim_create_user_command("GitDiffThis", function()
		local file = vim.fn.expand("%:p")
		local relative_file = vim.fn.fnamemodify(file, ":~:.")
		local temp_file = "/tmp/git_head_" .. vim.fn.fnamemodify(file, ":t")

		-- Check if file is tracked by git
		local is_tracked = vim.fn.system(
			"git ls-files --error-unmatch " .. vim.fn.shellescape(relative_file) .. " 2>/dev/null || echo 'untracked'"
		)
		if is_tracked:match("untracked") then
			vim.notify("File is not tracked by Git", 0, { title = "Git Diff" })
			return
		end

		-- Save current buffer if modified
		if vim.bo.modified then
			vim.cmd("write")
		end

		-- Get file from HEAD
		local cmd_result =
			vim.fn.system("git show HEAD:" .. vim.fn.shellescape(relative_file) .. " > " .. temp_file .. " 2>&1")
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed to get file from HEAD: " .. cmd_result, 0, { title = "Git Diff" })
			return
		end

		-- Open in vertical split and set up diff
		vim.cmd("vsplit " .. vim.fn.fnameescape(temp_file))
		vim.cmd("windo diffthis")

		-- Move back to original buffer
		vim.cmd("wincmd p")

		vim.notify("Showing Git diff for " .. relative_file, 0, { title = "Git Diff" })
	end, {})

	vim.api.nvim_create_user_command("GitDiff", function()
		-- Save all modified buffers
		vim.cmd("silent! wall")

		-- Check if we're in a git repository
		vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
		if vim.v.shell_error ~= 0 then
			vim.notify("Not in a Git repository", 0, { title = "Git Diff All" })
			return
		end

		-- Create temporary file for the diff
		local temp_file = "/tmp/git_diff_" .. os.time()
		local cmd = "git diff HEAD > " .. temp_file
		vim.fn.system(cmd)

		-- Open in a new tab
		vim.cmd("tabnew " .. temp_file)
		vim.cmd("setlocal buftype=nofile bufhidden=hide noswapfile")
		vim.cmd("setfiletype diff")

		vim.notify("Showing diff between working directory and HEAD", 0, { title = "Git Diff All" })
	end, {})
end

return M
