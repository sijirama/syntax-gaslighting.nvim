local M = {}

local messages = require("syntax-gaslighter.messages")

local ns = vim.api.nvim_create_namespace("syntaxgaslighter")

-- Helper function to check if a line is a comment
local function is_comment(line)
	local trimmed = line:gsub("^%s+", "")

	-- Check for Lua comments
	if trimmed:sub(1, 2) == "--" then
		return true
	end

	-- Check for C-style comments
	if trimmed:sub(1, 2) == "//" then
		return true
	end

	-- Check for Shell/Python comments
	if trimmed:sub(1, 1) == "#" then
		return true
	end

	-- Check for C-style block comments
	if trimmed:sub(1, 2) == "/*" then
		return true
	end

	-- Check for HTML comments
	if trimmed:sub(1, 4) == "<!--" then
		return true
	end

	return false
end

local function is_empty(line)
	for i = 1, #line do
		local char = line:sub(i, i)
		if char ~= " " and char ~= "\t" then
			return false
		end
	end
	return true
end

local function find_viable_positions()
	local bufnr = 0
	local positions = {}
	local line_count = vim.api.nvim_buf_line_count(bufnr)

	for lnum = 0, line_count - 1 do
		local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]

		if not is_empty(line) and not is_comment(line) then
			local col = 0

			-- Find first non-whitespace character manually
			local content_start = nil
			for i = 1, #line do
				local char = line:sub(i, i)
				if char ~= " " and char ~= "\t" then
					content_start = i
					break
				end
			end

			if content_start then
				col = content_start - 1

				-- Try to find operator positions manually
				local operators = { "{", "}", "(", ")", "=", "+", "-", "*", "/", ",", ";", ":" }
				for _, op in ipairs(operators) do
					local op_pos = nil
					for i = content_start, #line do
						if line:sub(i, i) == op then
							op_pos = i
							break
						end
					end

					if op_pos then
						col = op_pos -- Position right after the operator
						break
					end
				end
			end

			table.insert(positions, {
				lnum = lnum,
				col = col,
				line = line,
			})
		end
	end

	return positions
end

-- Turn on the gaslighting
function M.SyntaxGaslighterOn()
	-- Find viable positions
	local positions = find_viable_positions()

	-- If no viable positions found, notify user
	if #positions == 0 then
		vim.notify("No suitable lines found for gaslighting", vim.log.levels.WARN)
		return
	end

	-- Decide how many errors to show (10-15% of viable lines)
	local error_count = math.max(1, math.min(10, math.floor(#positions * 0.15)))

	math.randomseed(os.time())

	local diagnostics = {}

	for _ = 1, error_count do
		-- Pick a random position that we haven't used yet
		if #positions == 0 then
			break
		end

		local pos_idx = math.random(1, #positions)
		local pos = positions[pos_idx]

		-- Remove this position so we don't use it again
		table.remove(positions, pos_idx)

		-- Pick a random error message
		local message = messages[math.random(1, #messages)]

		-- Manual word detection without pattern matching
		local end_col = pos.col + 1
		local word_end = nil

		for i = pos.col + 1, #pos.line do
			local char = pos.line:sub(i, i)
			-- If not a word character (letter, number, underscore)
			if not (char:match("[a-zA-Z0-9_]")) then
				word_end = i - 1
				break
			end
			-- If we reach the end of the line
			if i == #pos.line then
				word_end = i
			end
		end

		if word_end then
			end_col = word_end
		else
			-- If not a word, try to find a reasonable end position
			end_col = math.min(pos.col + 10, #pos.line)
		end

		table.insert(diagnostics, {
			lnum = pos.lnum,
			col = pos.col,
			end_col = end_col,
			severity = vim.diagnostic.severity.ERROR,
			message = message,
			source = "SyntaxGaslighter",
		})
	end

	vim.diagnostic.set(ns, 0, diagnostics)
	vim.notify("Gaslighting activated with " .. #diagnostics .. " errors!", vim.log.levels.INFO)
end

-- Turn off the gaslighting
function M.SyntaxGaslighterOff()
	vim.diagnostic.reset(ns, 0)
	vim.notify("Gaslighting stopped. Your code is probably still terrible though.", vim.log.levels.INFO)
end

-- Toggle gaslighting
function M.SyntaxGaslighterToggle()
	local diagnostics = vim.diagnostic.get(0, { namespace = ns })

	if #diagnostics > 0 then
		M.SyntaxGaslighterOff()
	else
		M.SyntaxGaslighterOn()
	end
end

function M.say_hello()
	vim.notify("Syntax Gaslighter is ready to ruin your day!", vim.log.levels.INFO)
end

return M
