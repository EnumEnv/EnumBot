-- Core Dependencies --
local DiscordLuau = require('../../Dependencies/DiscordLuau')

-- Dependencies --
local IntentsBuilder = DiscordLuau.IntentsBuilder

-- Configs --
local Settings = {
	--"",
	IntentsBuilder.fromAll()
}

--[=[
    Bot Class.
    @class Bot
--]=]
local Bot = {}
Bot.__index = Bot

-- Types --
export type SelfType = typeof(Bot) & {
    _discordClient: DiscordLuau.DiscordClient
}

-- Module Functions --
--[=[
    Creates a new bot.
    @return Bot / self
--]=]
function Bot.new(): SelfType
    local self = {}

    local settingsBuilder = DiscordLuau.SettingsBuilder.new(table.unpack(Settings))
    local discordClient = DiscordLuau.DiscordClient.new(settingsBuilder)

    self._discordClient = discordClient

    return setmetatable(self, Bot) :: any
end

--[=[
    Connects the bot to the discord API.
    @rerturn void
--]=]
function Bot.Connect(self: SelfType, after: () -> ())
    self._discordClient:connectAsync():after(after)
end

--[=[
    Retrieves the created bot.
    @error "DiscordClient has not been created" --> Happens when you don't do "Bot.new()"
    @return DiscordClient
--]=]
function Bot.GetBot(self: SelfType): DiscordLuau.DiscordClient
    assert(self._discordClient, "DiscordClient has not been created, therefore can not get.")
    
    return self._discordClient
end

-- End --
return Bot.new()
