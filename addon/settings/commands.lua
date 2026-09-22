local name, ns = ...

SLASH_BETTERILVL1 = "/betterilvl"
SLASH_BETTERILVL2 = "/bilvl"

local function openSettings()
    if Settings and Settings.OpenToCategory and ns.settingsCategory then
        Settings.OpenToCategory(ns.settingsCategory:GetID())
    end
end

SlashCmdList.BETTERILVL = function(msg)
    msg = (msg or ""):match("^%s*(.-)%s*$"):lower()

    if msg == "" or msg == "config" or msg == "options" or msg == "settings" then
        return openSettings()
    else
        print("|cffffd200" .. name  .. ":|r Unknown Command:", msg)
    end
end