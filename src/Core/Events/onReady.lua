-- Core Dependencies --
local DiscordLuau = require('../../../Dependencies/DiscordLuau')

-- Dependencies --
local PresenceBuilder = DiscordLuau.PresenceBuilder
local ActivityBuilder = DiscordLuau.ActivityBuilder

local Main = require('../main')

-- Bot --
local Client = Main:GetBot()

return function()
    print("------------------------------")
    print("Client is ready!")

    -- Presence Building --
    local newActivity = ActivityBuilder.new()
        :setActivityName("you...")
        :setActivityType(ActivityBuilder.Type.Watching)
    
    local newPresence = PresenceBuilder.new()
        :addActivity(newActivity)
        :setAfk(false)
        :setSince(os.time())
        
    -- Updating Presence --
    Client:updatePresenceAsync(newPresence):after(function()
        print("------------------------------")
        print("Updated discord presence for the bot client.")
    end)
end
