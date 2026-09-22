local name, ns = ...

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
        print("|cffffd200" .. name .. ":|r Unknown Command:", message)
        print("|cffffd200" .. name .. ":|r Use |cff00ff00/betterilvl|r or |cff00ff00/bilvl|r to open the settings.")
    end
end
