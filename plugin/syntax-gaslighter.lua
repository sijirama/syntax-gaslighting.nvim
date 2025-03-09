vim.api.nvim_create_user_command("SyntaxGaslighterOn", function()
	require("syntax-gaslighter").SyntaxGaslighterOn()
end, { desc = "Add gaslighting errors to your code" })

vim.api.nvim_create_user_command("SyntaxGaslighterOff", function()
	require("syntax-gaslighter").SyntaxGaslighterOff()
end, { desc = "Remove all gaslighting errors" })

vim.api.nvim_create_user_command("SyntaxGaslighterToggle", function()
	require("syntax-gaslighter").SyntaxGaslighterToggle()
end, { desc = "Toggle gaslighting errors" })

vim.api.nvim_create_user_command("SyntaxGaslighterSayHello", function()
	require("syntax-gaslighter").say_hello()
end, { desc = "Test if the plugin is working" })
