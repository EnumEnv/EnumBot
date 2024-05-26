-- Core Dependencies --
local DiscordLuau = require('../Dependencies/DiscordLuau')

-- Dependencies --
local IntentsBuilder = DiscordLuau.IntentsBuilder

-- Configs --
local Settings = {
	"MTI0NDI5MjIzMjY5ODI2NTY5MA.G4w1r3.tl-0-Cu-aCmVD9bJDAGM7CzqeEUgReFw5xLAks",
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
    @return Bot / Self
--]=]
function Bot.new()
    local self = {}

    local settingsBuilder = DiscordLuau.SettingsBuilder.new(table.unpack(Settings))
    local discordClient = DiscordLuau.DiscordClient.new(settingsBuilder)

    self._discordClient = discordClient

    return setmetatable(self, Bot)
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
