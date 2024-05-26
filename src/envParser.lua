-- Core Dependencies --
local FS = require('@lune/fs')

--[=[
    The EnvParser class.
    @class EnvParser
--]=]
local EnvParser = {}

--[=[
    Trims whitespace from both ends of a string.
    @param s --> string -- The string to trim.
    @return string
--]=]
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

--[=[
    Parses an env file for Lua support.
    @param filePath --> string -- The file path to the env file.
    @return table -- A table containing the environment variables.
--]=]
function EnvParser.ParseEnv(filePath)
    local env = {}
    local readFile = FS.readFile(filePath)
    
    if not readFile then
        error("Could not open .env file.")
    end
    
    for line in readFile:gmatch("[^\r\n]+") do
        if line:sub(1, 1) ~= '#' and line:match("%S") then
            local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")

            if key and value then
                value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
                value = trim(value)
                key = trim(key)
                
                env[key] = value
            end
        end
    end
    
    return env
end

-- End --
return EnvParser
