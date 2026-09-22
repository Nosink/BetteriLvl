local name, ns = ...

SLASH_BETTERILVL1 = "/betterilvl"
SLASH_BETTERILVL2 = "/bilvl"

local function openSettings()
    if Settings and Settings.OpenToCategory and ns.settingsCategory then
        Settings.OpenToCategory(ns.settingsCategory:GetID())
    end
end

local function contains(args, options)
    for _, arg in pairs(args) do
        for _, option in pairs(options) do
            if arg == option then return true end
        end
    end
    return false
end

local function getArgs(message)
    local args = {}
    for argument in message:gmatch("%S+") do
        args[#args + 1] = argument
    end
    return args
end

SlashCmdList.BETTERILVL = function(message)
    message = (message or ""):match("^%s*(.-)%s*$"):lower()
    local args = getArgs(message)

    if #args == 0 or contains(args, { "config", "options", "settings" }) then
        return openSettings()
    else
        print("|cffffd200" .. name .. ":|r Unknown Command:", message)
    end
end
