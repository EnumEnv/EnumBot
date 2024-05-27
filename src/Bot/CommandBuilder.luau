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
    local split = string.split(name, ".")
    
    if split[2] then
        if split[2] == "luau" then
            return true
        end
    end

    return false
end

function CommandBuilder.new(discordClient: DiscordLuau.DiscordClient): SelfType
    local self = { _registeredCommands = {} }

    self._discordClient = discordClient

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
            local commandFile = require(string.sub(directory,11,#directory)..'/'..commandName)

            self:AddSlashCommand(commandFile)
        end
    end
end

return CommandBuilder
