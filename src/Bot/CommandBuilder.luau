local DiscordLuau = require('../../Dependencies/DiscordLuau')

local DiscordCommandBuilder = DiscordLuau.CommandBuilder
local PermissionBuilder = DiscordLuau.PermissionsBuilder

local CommandBuilder = {}
CommandBuilder.__index = CommandBuilder

export type SelfType = typeof(CommandBuilder)

function CommandBuilder.new(discordClient: DiscordLuau.DiscordClient): SelfType
    local self = {}

    self._discordClient = discordClient

    return setmetatable(self, CommandBuilder) :: any
end

function CommandBuilder.AddSlashCommand(command)

end

function CommandBuilder.AddSlashCommandsFromDirectory(directory: string)
    
end

return CommandBuilder
