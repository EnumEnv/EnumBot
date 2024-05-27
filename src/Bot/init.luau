local DiscordLuau = require("../../Dependencies/DiscordLuau")
local settings = require("../settings")

local DiscordIntentsBuilder = DiscordLuau.IntentsBuilder
local DiscordSettingsBuilder = DiscordLuau.SettingsBuilder
local DiscordClient = DiscordLuau.DiscordClient

local Bot = {}
Bot.__index = Bot

export type SelfType = typeof(Bot) & {
	_applicationId: string,
	_clientId: string,
	_token: string,
	_discordClient: DiscordLuau.DiscordClient,
}

function Bot.new(token: string, applicationId: string, clientId: string): SelfType
	local self = {}

	local discordIntents = DiscordIntentsBuilder.fromAll()
	local discordSettings = DiscordSettingsBuilder.new(token, discordIntents)

	local discordClient = DiscordClient.new(discordSettings)

	self._applicationId = applicationId
	self._clientId = clientId
	self._token = token
	self._discordClient = discordClient

	return setmetatable(self, Bot) :: any
end

function Bot.Connect(self: SelfType, after: () -> ())
	self._discordClient:connectAsync():after(after)
end

return Bot.new(settings.TOKEN, settings.APPLICATION_ID, settings.CLIENT_ID)
