vim.api.nvim_create_user_command("SyntaxGaslighterOn", function()
	require("syntax-gaslighter").SyntaxGasLighterOn()
end, { desc = "Render gaslighing errors" })

vim.api.nvim_create_user_command("SyntaxGaslighterOff", function()
	require("syntax-gaslighter").SyntaxGasLighterOff()
end, { desc = "Removes all gaslighing errors" })

vim.api.nvim_create_user_command("SyntaxGaslighterSayHello", function()
	require("syntax-gaslighter").say_hello()
end, { desc = "Log Hello world" })
