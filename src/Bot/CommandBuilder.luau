local DiscordLuau = require('../../Dependencies/DiscordLuau')

local CommandBuilder = {}
CommandBuilder.__index = CommandBuilder

export type SelfType = typeof(CommandBuilder)

function CommandBuilder.new(discordClient: DiscordLuau.DiscordClient): SelfType
    local self = {}

    self._discordClient = discordClient

    return setmetatable(self, CommandBuilder) :: any
end

return CommandBuilder
