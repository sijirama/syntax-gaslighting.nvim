local M = {}

-- Array of fake error messages
local fake_errors = {
	"Syntax error: unexpected vibes",
	"Variable 'x' not found, lol",
	"Missing semicolon, obviously",
	"What is this, JavaScript?",
	"Error: skill issue detected",
	"Unexpected token: your code",
}

-- Namespace for diagnostics
local ns = vim.api.nvim_create_namespace("syntaxgaslighter")

-- Turn on the gaslighting
function M.SyntaxGaslighterOn()
	-- Get buffer line count
	local line_count = vim.api.nvim_buf_line_count(0)
	-- Decide how many errors to show (10% of lines, min 1, max 5)
	local error_count = math.max(1, math.min(5, math.floor(line_count * 0.1)))
	-- Seed random for variety
	math.randomseed(os.time())
	-- Generate diagnostics
	local diagnostics = {}
	for _ = 1, error_count do
		-- Pick a random line (0-based, so line_count - 1)
		local line = math.random(0, line_count - 1)
		-- Pick a random error message
		local message = fake_errors[math.random(1, #fake_errors)]
		-- Add diagnostic
		table.insert(diagnostics, {
			lnum = line, -- Line number (0-based)
			col = 0, -- Start at column 0
			end_col = 1, -- End after 1 char (for squiggle)
			severity = vim.diagnostic.severity.ERROR,
			message = message,
		})
	end

	-- Set diagnostics in the current buffer
	vim.diagnostic.set(ns, 0, diagnostics)
	vim.notify("Gaslighting activated!", vim.log.levels.INFO)
end

-- Turn off the gaslighting
function M.SyntaxGaslighterOff()
	-- Clear all diagnostics in our namespace for the current buffer
	vim.diagnostic.reset(ns, 0)
	vim.notify("Gaslighting stopped.", vim.log.levels.INFO)
end

function M.say_hello()
	vim.notify("Hello, Neovim!", vim.log.levels.INFO)
end

return M
