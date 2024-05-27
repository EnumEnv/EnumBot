local DiscordLuau = require('../../Dependencies/DiscordLuau')
local FS = require('@lune/FS')

local DiscordCommandBuilder = DiscordLuau.CommandBuilder
local PermissionBuilder = DiscordLuau.PermissionsBuilder

local CommandBuilder = {}
CommandBuilder.__index = CommandBuilder

export type SelfType = typeof(CommandBuilder) & {
    _registeredCommands: { any }
}

local function CreateSlashCommand(info: { [string]: any })
    local permissionsFormatted = PermissionBuilder.new()
    
    for _,permission in info.Permissions do
        permissionsFormatted:addPermission(PermissionBuilder.Permissions[permission])
    end

    local slashCommand = DiscordCommandBuilder
		.new()
		:setName(info.Name)
		:setDescription(info.Description)
		:setGuildPermissions(permissionsFormatted)
		:addContext(DiscordCommandBuilder.Context[info.ContextType])
		:setType(DiscordCommandBuilder.Type[info.Type])

    return slashCommand
end

local function EndsWithLuau(name: string)
    return string.sub(name, #name-4,#name) == "luau"
end

function CommandBuilder.new(discordClient: DiscordLuau.DiscordClient): SelfType
    local self = {}

    self._discordClient = discordClient
    self._registeredCommands = {}

    return setmetatable(self, CommandBuilder) :: any
end

function CommandBuilder.GetCommands(self: SelfType)
    return self._registeredCommands
end

function CommandBuilder.AddSlashCommand(self: SelfType, command)
    table.insert(self._registeredCommands, CreateSlashCommand(command))
end

function CommandBuilder.AddSlashCommandsFromDirectory(self: SelfType, directory: string)
    for _,commandName in FS.readDir(directory) do
        if EndsWithLuau(commandName) then
            local commandFile = require(directory..'/'..string.split(commandName,".")[1])

            self:AddSlashCommand(commandFile)
        end
    end
end

return CommandBuilder
