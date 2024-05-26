--[[
Loads the bot by "main.lua".
--]]

local function sleep(n)
    local t0 = os.clock()
    while os.clock() - t0 <= n do
        -- Busy wait
    end
end

-- Dependencies --
local EnvParser = require('envParser')
local env = EnvParser.ParseEnv('.env')
sleep(1)
local BotMain = require('Core/main').new(env.BOT_TOKEN)
local EventConnections = require('Core/eventLoader')

-- Init (Bot) --
-- Connect Bot --
BotMain:Connect(function()
    print("------------------------------")
    print("Bot connected to discord api.")
end)
