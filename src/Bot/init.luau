local DiscordLuau = require("../../Dependencies/DiscordLuau")
local Settings = require("../settings")
local CommandBuilder = require("CommandBuilder")

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

export type CommandType = {
	Name: string,
	Description: string,
	Permissions: { [number]: string },
	ContextType: string,
	Type: string,
}

function Bot.new(token: string, applicationId: string, clientId: string): SelfType
	local self = {}

	local discordIntents = DiscordIntentsBuilder.fromAll()
	local discordSettings = DiscordSettingsBuilder.new(token, discordIntents)

	local discordClient = DiscordClient.new(discordSettings)
	discordClient:setVerbose(true)

	self._applicationId = applicationId
	self._clientId = clientId
	self._token = token
	self._discordClient = discordClient

	return setmetatable(self, Bot) :: any
end

function Bot.BindEvent(self: SelfType, eventName: string, callback: () -> ())
	self._discordClient.eventManager[eventName]:connect(callback)
end

function Bot.Connect(self: SelfType, after: () -> ())
	self._discordClient:connectAsync():after(after)
end

function Bot.LoadCommands(customDirectory: string)
	CommandBuilder.AddSlashCommandsFromDirectory("Commands" or customDirectory)
end

function Bot.LoadCommand(command: CommandType)
	CommandBuilder.AddSlashCommand(command)
end

function Bot.UpdatePresence(self: SelfType, presence: DiscordLuau.PresenceBuilder, after: () -> ())
	self._discordClient:updatePresenceAsync(presence):after(after)
end

return Bot.new(Settings.TOKEN, Settings.APPLICATION_ID, Settings.CLIENT_ID)
