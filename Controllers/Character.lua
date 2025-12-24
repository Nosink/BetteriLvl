
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

hooksecurefunc(CharacterFrame, "Show", HandleOnShowCharacterPanel)

local BetteriLvlCharacterFrame = CreateFrame("Frame")

BetteriLvlCharacterFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
BetteriLvlCharacterFrame:SetScript("OnEvent", HandleOnShowCharacterPanel)
