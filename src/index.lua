-- SUBMODULES --
local DiscordLuau = require("../Dependencies/DiscordLuau")

-- DISCORD --
local Settings = {
	""
}

local ActivityBuilder = DiscordLuau.ActivityBuilder
local PresenceBuilder = DiscordLuau.PresenceBuilder
	
local SettingsBuilder = DiscordLuau.SettingsBuilder.new(table.unpack(Settings))
local DiscordClient = DiscordLuau.DiscordClient.new(SettingsBuilder)

---- Loading Events ----
--- DiscordClient:on ---
DiscordClient:connectAsync():after(function()
	print('<< Connected to the Discord API >>')

	local activity = ActivityBuilder.new()
		:setActivityName("Watching you")
		:setActivityType(ActivityBuilder.Type.Watching)

	local presence = PresenceBuilder.new()
		:addActivity(activity)
		:setStatus(PresenceBuilder.Status.Online)
		:setAfk(false)
		:setSince(os.time())
end)