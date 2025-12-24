
local function UpdatePlayeriLvl()
    if Settings.IsPlayeriLvlEnabled() or Settings.IsPlayerBorderEnabled() then
        ShowSlotiLvlOn(UnitHelper.Player)
    else
        HideSlotiLvlFrom(UnitHelper.Player)
    end
end

local function UpdatePlayerAverageiLvl()
    if Settings.IsPlayerAverageiLvlEnabled() then
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
