-- Core Dependencies --
local FS = require('@lune/fs')

-- Dependencies --
local BotClass = require('main')

-- Bot --
local Client = BotClass:GetBot()

-- Module --
local EventsConnected: { [string]: any } = {}

-- Loop Through Dir --
local Files = FS.readDir('./src/Events')

for _,name in Files do
    local file = "./Events/"..name
    local methodName = string.split(name,".")[1]

    xpcall(function() 
        local eventFunction = require(file)
        Client.eventManager[methodName]:connect(eventFunction)
    end, function(err)
        warn("<EventLoader> Failed to load event:",name,"for",tostring(err))
    end)
end

-- End --
return EventsConnected
