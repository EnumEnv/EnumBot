-- Dependencies --
local DiscordLuau = require("../../Dependencies/DiscordLuau")
local Settings = require("../settings")
local CommandBuilder = require("CommandBuilder")
local FS = require("@lune/FS")

-- DiscordLuau Dependencies --
local DiscordIntentsBuilder = DiscordLuau.IntentsBuilder
local DiscordSettingsBuilder = DiscordLuau.SettingsBuilder
local DiscordClient = DiscordLuau.DiscordClient

-- Module --
local Bot = {}
Bot.__index = Bot

-- Types --
export type SelfType = typeof(Bot) & {
	_applicationId: string,
	_clientId: string,
	_token: string,
	_discordClient: DiscordLuau.DiscordClient,
	_commandBuilder: CommandBuilder.SelfType,
}

export type CommandType = {
	Name: string,
	Description: string,
	Permissions: { [number]: string },
	ContextType: string,
	Type: string,
}

-- Local Functions --
--[=[
	Checks if a file name ends with ".luau".
	@param name string -- The file name to check.
	@returns boolean -- True if the file name ends with ".luau", false otherwise.
--]=]
local function EndsWithLuau(name: string)
	local split = string.split(name, ".")

	if split[2] then
		if split[2] == "luau" then
			return true
		end
	end

	return false
end

-- Module Functions --
--[=[
	Creates a new instance of the Bot.
	@param token string -- The bot token used to authenticate with Discord.
	@param applicationId string -- The application ID of the bot.
	@param clientId string -- The client ID of the bot.
	@returns SelfType -- The new instance of the Bot.
--]=]
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
	self._commandBuilder = CommandBuilder.new(discordClient)

	return setmetatable(self, Bot) :: any
end

--[=[
	Binds an event to the bot.
	@param self SelfType -- The instance of the bot.
	@param eventName string -- The name of the event to bind.
	@param callback function -- The callback function to execute when the event is triggered.
--]=]
function Bot.BindEvent(self: SelfType, eventName: string, callback: () -> ())
	self._discordClient.eventManager[eventName]:connect(callback)
end

--[=[
	Connects the bot to Discord.
	@param self SelfType -- The instance of the bot.
	@param after function -- The function to execute after the bot is connected.
--]=]
function Bot.Connect(self: SelfType, after: () -> ())
	self._discordClient:connectAsync():after(after)
end

--[=[
	Loads commands from a specified directory.
	@param self SelfType -- The instance of the bot.
	@param customDirectory string? -- The custom directory to load commands from. Defaults to "./src/Bot/Commands".
--]=]
function Bot.LoadCommands(self: SelfType, customDirectory: string?)
	self._commandBuilder:AddSlashCommandsFromDirectory("./src/Bot/Commands" or customDirectory)
end

--[=[
	Loads a single command.
	@param self SelfType -- The instance of the bot.
	@param command CommandType -- The command to load.
--]=]
function Bot.LoadCommand(self: SelfType, command: CommandType)
	self._commandBuilder:AddSlashCommand(command)
end

--[=[
	Checks if the certain command exists.
	@param name string -- The command to check for.
	@return boolean -- If it exists or not.
--]=]
function Bot.CommandNameExists(self: SelfType, name: string)
	local commands = FS.readDir("./src/Bot/Commands")

	for _, commandName in commands do
		if EndsWithLuau(commandName) then
			if string.lower(string.split(commandName, ".")[1]) == string.lower(name) then
				return true
			end
		end
	end

	return false
end

--[=[
	Retrieves a command file (already required)
	@param name string -- The command name.
	@return Command
--]=]
function Bot.GetCommand(self: SelfType, name: string)
	local commands = FS.readDir("./src/Bot/Commands")

	for _, commandName in commands do
		if EndsWithLuau(name) then
			if string.lower(string.split(commandName, ".")[1]) == string.lower(name) then
				local file = require("./src/Bot/Commands/" .. commandName)

				return file
			end
		end
	end

	return
end

--[=[
	Registers all loaded commands on the guild.
	@param self SelfType -- The instance of the bot.
--]=]
function Bot.RegisterCommandsOnGuild(self: SelfType)
	local commands = self._commandBuilder:GetCommands()

	self._discordClient.discordApplication:setSlashCommandsAsync(commands):after(function(data)
		print("Commands updated! Fetching current...")

		self._discordClient.discordApplication:fetchSlashCommandsAsync():after(function(...)
			print("Commands have been fetched!")
		end)
	end)
end

--[=[
	Updates the bot's presence.
	@param self SelfType -- The instance of the bot.
	@param presence DiscordLuau.PresenceBuilder -- The presence to set for the bot.
	@param after function -- The function to execute after the presence is updated.
--]=]
function Bot.UpdatePresence(self: SelfType, presence: DiscordLuau.PresenceBuilder, after: () -> ())
	self._discordClient:updatePresenceAsync(presence):after(after)
end

return Bot.new(Settings.TOKEN, Settings.APPLICATION_ID, Settings.CLIENT_ID)
