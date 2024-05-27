-- Dependencies --
local DiscordLuau = require("../../Dependencies/DiscordLuau")
local FS = require("@lune/FS")

-- DiscordLuau Dependencies --
local DiscordCommandBuilder = DiscordLuau.CommandBuilder
local PermissionBuilder = DiscordLuau.PermissionsBuilder

-- Module --
local CommandBuilder = {}
CommandBuilder.__index = CommandBuilder

-- Types --
export type SelfType = typeof(CommandBuilder) & {
	_registeredCommands: { any },
}

-- Local Functions --
--[=[
	Creates a slash command from the given information.
	@param info table -- The table containing command information such as Name, Description, Permissions, ContextType, and Type.
	@returns DiscordLuau.CommandBuilder -- The created slash command.
--]=]
local function CreateSlashCommand(info: { [string]: any })
	local permissionsFormatted = PermissionBuilder.new()

	for _, permission in info.Permissions do
		permissionsFormatted:addPermission(PermissionBuilder.Permissions[permission])
	end

	local slashCommand = DiscordCommandBuilder.new()
		:setName(info.Name)
		:setDescription(info.Description)
		:setGuildPermissions(permissionsFormatted)
		:addContext(DiscordCommandBuilder.Context[info.ContextType])
		:setType(DiscordCommandBuilder.Type[info.Type])

	return slashCommand
end

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
	Creates a new instance of CommandBuilder.
	@param discordClient DiscordLuau.DiscordClient -- The Discord client to associate with this command builder.
	@returns SelfType -- The new instance of CommandBuilder.
--]=]
function CommandBuilder.new(discordClient: DiscordLuau.DiscordClient): SelfType
	local self = { _registeredCommands = {} }

	self._discordClient = discordClient

	return setmetatable(self, CommandBuilder) :: any
end

--[=[
	Gets the list of registered commands.
	@param self SelfType -- The instance of CommandBuilder.
	@returns table -- The list of registered commands.
--]=]
function CommandBuilder.GetCommands(self: SelfType)
	return self._registeredCommands
end

--[=[
	Adds a slash command to the list of registered commands.
	@param self SelfType -- The instance of CommandBuilder.
	@param command table -- The command information to add.
--]=]
function CommandBuilder.AddSlashCommand(self: SelfType, command)
	table.insert(self._registeredCommands, CreateSlashCommand(command))
end

--[=[
	Adds slash commands from the specified directory.
	@param self SelfType -- The instance of CommandBuilder.
	@param directory string -- The directory to load commands from.
--]=]
function CommandBuilder.AddSlashCommandsFromDirectory(self: SelfType, directory: string)
	for _, commandName in FS.readDir(directory) do
		if EndsWithLuau(commandName) then
			local commandFile = require(string.sub(directory, 11, #directory) .. "/" .. commandName)

			self:AddSlashCommand(commandFile)
		end
	end
end

return CommandBuilder
