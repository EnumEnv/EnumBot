--[[
Loads the bot by "main.lua".
--]]

-- Dependencies --
local BotMain = require('Core/main')
local EventConnections = require('Core/eventLoader')

-- Init (Bot) --
-- Connect Bot --
BotMain:Connect(function()
    print("------------------------------")
    print("Bot connected to discord api.")
end)
