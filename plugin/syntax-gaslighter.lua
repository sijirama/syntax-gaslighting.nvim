-- Register the command
vim.api.nvim_create_user_command("SyntaxGaslighterOn", function()
	require("syntax-gaslighter").say_hello()
end, { desc = "Prints a hello message" })
