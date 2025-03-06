local M = {}

-- Define the function
function M.say_hello()
	vim.notify("Hello, Neovim!", vim.log.levels.INFO)
end

return M
