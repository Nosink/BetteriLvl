local name, ns = ...
local L = ns.L

SLASH_BETTERILVL1 = "/betterilvl"
SLASH_BETTERILVL2 = "/bilvl"

local function openSettings()
    if Settings and Settings.OpenToCategory and ns.settingsCategory then
        Settings.OpenToCategory(ns.settingsCategory:GetID())
    end
end

SlashCmdList.BETTERILVL = function(message)
    message = (message or ""):match("^%s*(.-)%s*$"):lower()

    if (message == "" or message == "config" or message == "options" or message == "settings") then
        return openSettings()
    else
        print(string.format("|c%s%s:|r %s |cff00ff00/betterilvl|r %s |cff00ff00/bilvl|r %s.",
            "ffffd200", name, L["COMMAND_USE"], L["COMMAND_OR"], L["COMMAND_DESCRIPTION"]))
    end
end
