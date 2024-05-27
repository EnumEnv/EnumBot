--[[
----               ----
The loader for the bot.
----               ----
--]]

local Bot = require("Bot")
Bot:Connect(function()
	print("<< Connected to Discord API >>")
end)
