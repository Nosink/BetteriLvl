
local _, ns = ...

local settings = ns.settings

local function UpdatePlayeriLvl()
    if settings.IsPlayeriLvlEnabled() or settings.IsPlayerBorderEnabled() then
        ShowSlotiLvlOn(UnitHelper.Player)
    else
        HideSlotiLvlFrom(UnitHelper.Player)
    end
end

local function UpdatePlayerAverageiLvl()
    if settings.IsPlayerAverageiLvlEnabled() then
        ShowAverageiLvlOf(UnitHelper.Player)
    else
        HideAverageiLvlFrom(UnitHelper.Player)
    end
end

local function HandleOnShowCharacterPanel()
    UpdatePlayeriLvl()
    UpdatePlayerAverageiLvl()
end

ns:RegisterEvent("ADDON_LOADED", HandleOnShowCharacterPanel)
ns:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", HandleOnShowCharacterPanel)