--[[
----               ----
The loader for the bot.
----               ----
--]]

local DiscordLuau = require("../Dependencies/DiscordLuau")

local PresenceBuilder = DiscordLuau.PresenceBuilder
local ActivityBuilder = DiscordLuau.ActivityBuilder

local Settings = require("settings")
local Bot = require("Bot")

-- Initializing The Bot --
--// Connecting Events
--/ OnReady
Bot:BindEvent("onReady", function()
	print("<< DiscordClient is ready >>")

	--// Creating Presence
	local newActivity = ActivityBuilder.new()
		:setActivityName(Settings.DEFAULT_PRESENCE_INFO.Content)
		:setActivityType(ActivityBuilder.Type[Settings.DEFAULT_PRESENCE_INFO.ActivityType])

	local newPresence = PresenceBuilder.new()
		:addActivity(newActivity)
		:setAfk(Settings.DEFAULT_PRESENCE_INFO.IsAfk)
		:setSince(Settings.DEFAULT_PRESENCE_INFO.TimeStamp)

	--// Updating Default Presence
	Bot:UpdatePresence(newPresence, function()
		print("<< Updated DiscordClient Presence >>")
	end)

	--// Command Building
end)

--// Connecting to API
Bot:Connect(function()
	print("<< Connected to Discord API >>")
end)

return { Bot, Settings }
